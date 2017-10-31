Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751798AbdJaGqV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 02:46:21 -0400
Date: Tue, 31 Oct 2017 14:46:17 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] xfs: test for umount hang caused by the pending
 dquota log item in AIL
Message-ID: <20171031064617.GH17339@eguan.usersys.redhat.com>
References: <1509003472-24191-1-git-send-email-houtao1@huawei.com>
 <1509003472-24191-2-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509003472-24191-2-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

On Thu, Oct 26, 2017 at 03:37:52PM +0800, Hou Tao wrote:
> When the first writeback and the retried writeback of dquota buffer get
> the same IO error, XFS will let xfsaild to restart the writeback and
> xfs_qm_dqflush_done() will not be invoked. xfsaild will try to re-push
> the quota log item in AIL, the push will return early everytime after
> checking xfs_dqflock_nowait(), and xfsaild will try to push it again.
> 
> IOWs, AIL will never be empty, and the umount process will wait for the
> drain of AIL, so the umount process hangs.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Sorry for the late review. Is there a specific patch or patchset fixed
this bug? I tested on v4.14-rc2 kernel and for-next branch on Darrick's
tree, test survivied multiple runs on both kernels.

> ---
>  tests/xfs/999     | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |   2 +
>  tests/xfs/group   |   1 +
>  3 files changed, 172 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 0000000..4b89899
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,169 @@
> +#! /bin/bash
> +# FS QA Test No. 999
> +#
> +# Test for XFS umount hang problem caused by the unceasing push
> +# of dquot log item in AIL. Because xfs_qm_dqflush_done() will
> +# not be invoked, so each time xfsaild initiates the push,
> +# the push will return early after checking xfs_dqflock_nowait().
> +#
> +# xfs_qm_dqflush_done() should be invoked by xfs_buf_do_callbacks().
> +# However after the first write and the retried write of dquota buffer
> +# get the same IO error, XFS will let xfsaild to restart the write and
> +# xfs_buf_do_callbacks() will not be inovked.
> +#
> +# This test emulates the write error by using dm-flakey. The log
> +# area of the XFS filesystem is excluded from the range covered by
> +# dm-flakey, so the XFS will not be shutdown prematurely.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Huawei Technologies Co., Ltd. All Rights Reserved.
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	sysctl -w fs.xfs.xfssyncd_centisecs=3000 >/dev/null 2>&1

Save the original value in a variable before test and restore it in
_cleanup.

> +	_unmount_flakey >/dev/null 2>&1
> +	_cleanup_flakey > /dev/null 2>&1
> +}
> +
> +_get_xfs_scratch_sb_field()

Please name local functions without the leading underscore, usually
that's for common helpers :)

> +{
> +	local field=$1
> +
> +	echo $(_scratch_xfs_db -r -c "sb 0" -c "print $field" | \
> +		awk -v field=$field '$0 ~ field {print $3}')
> +}

Seems we can make this helper a common function in common/xfs, so other
tests could take use of it too. Right now I only see xfs/098 could be a
potential user.

> +
> +# inject IO write error for the XFS filesystem except its log section
> +_make_xfs_scratch_flakey_table()
> +{
> +	local opt="0 1 1 error_writes"
> +	local dev=${SCRATCH_DEV}
> +	local dev_sz=$(blockdev --getsz $dev)
> +
> +	if [ "${USE_EXTERNAL}" = "yes" -a ! -z "$SCRATCH_LOGDEV" ]; then
> +		echo "0 ${dev_sz} flakey $dev 0 ${opt}"
> +		return
> +	fi
> +
> +	local blk_sz=$(_get_xfs_scratch_sb_field blocksize)
> +	local log_ofs=$(_get_xfs_scratch_sb_field logstart)
> +	local log_sz=$(_get_xfs_scratch_sb_field logblocks)
> +	local table=""
> +	local ofs=0
> +	local sz
> +
> +	let "log_ofs *= blk_sz / 512"
> +	let "log_sz *= blk_sz / 512"
> +
> +	if [ "$ofs" -lt "${log_ofs}" ]; then
> +		let "sz = log_ofs - ofs"
> +		table="$ofs $sz flakey $dev $ofs ${opt}"
> +	fi
> +
> +	table="$table\n${log_ofs} ${log_sz} linear $dev ${log_ofs}"
> +
> +	let "ofs = log_ofs + log_sz"
> +	if [ "$ofs" -lt "${dev_sz}" ]; then
> +		let "sz = dev_sz - ofs"
> +		table="$table\n$ofs $sz flakey $dev $ofs ${opt}"
> +	fi
> +
> +	echo -e $table
> +}

Not sure if it's worth converting this into a common helper too. I'm
fine with it being a local function too, I guess it's not a commonly
used function anyway.

> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/dmflakey
> +. ./common/xfs

No need to source common/xfs in individual test case, common/rc will do
it based on $FSTYP

> +. ./common/quota
> +
> +_supported_fs xfs
> +_supported_os Linux
> +
> +# due to the injection of write IO error, the fs will be inconsistent
> +_require_scratch_nocheck
> +_require_dm_target linear
> +_require_dm_target flakey
> +_require_user
> +_require_xfs_quota
> +_require_freeze
> +
> +rm -f $seqres.full
> +
> +echo "Silence is golden"
> +
> +_scratch_mkfs_xfs >/dev/null 2>&1

_scratch_mkfs should be fine, better to dump the mkfs output to
$seqres.full for debug purpose.

> +
> +_init_flakey
> +
> +# no error will be injected
> +FLAKEY_TABLE="0 $(blockdev --getsz $SCRATCH_DEV) linear $SCRATCH_DEV 0"
> +_load_flakey_table $FLAKEY_ALLOW_WRITES

It looks like to me that this FLAKEY_TABLE and _load_flakey_table are
not necessary, the default FLAKEY_TABLE won't drop or error any writes
too.

> +$DMSETUP_PROG info >> $seqres.full
> +$DMSETUP_PROG table >> $seqres.full
> +
> +# shorten the time waiting for the push of ail items
> +sysctl -w fs.xfs.xfssyncd_centisecs=100 >/dev/null 2>&1
> +
> +_qmount_option "usrquota"
> +_mount_flakey
> +
> +# We need to set the quota limitation twice, and inject the write error
> +# after the second setting. If we try to inject the write error after
> +# the first setting, the initialization of the dquota buffer will get
> +# IO error and also be retried, and during the umount process the
> +# write will be ended, and xfs_qm_dqflush_done() will be inovked, and
> +# the umount will exit normally.
> +$XFS_QUOTA_PROG -x -c "limit -u isoft=500 fsgqa" $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c "report -ih" $SCRATCH_MNT >> $seqres.full
> +
> +# ensure the initialization of the dquota buffer is done
> +xfs_freeze -f $SCRATCH_MNT
> +xfs_freeze -u $SCRATCH_MNT
> +
> +$XFS_QUOTA_PROG -x -c "limit -u isoft=400 fsgqa" $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c "report -ih" $SCRATCH_MNT >> $seqres.full
> +
> +# inject write IO error
> +FLAKEY_TABLE=$(_make_xfs_scratch_flakey_table)
> +_load_flakey_table $FLAKEY_ALLOW_WRITES

Set FLAKEY_TABLE_DROP here and call _load_flakey_table with
$FLAKEY_DROP_WRITES

> +$DMSETUP_PROG info >> $seqres.full
> +$DMSETUP_PROG table >> $seqres.full
> +
> +sync
> +# wait for the push of the dquota log item in AIL and
> +# the completion of the retried write of dquota buffer
> +sleep 2
> +
> +_unmount_flakey
> +
> +_cleanup_flakey
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 0000000..3b276ca
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b439842..d11cbfd 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -431,3 +431,4 @@
>  431 auto quick dangerous
>  432 auto quick dir metadata
>  433 auto quick attr
> +999 quota dangerous

Should be in 'auto' and 'quick' group too?

Thanks,
Eryu

> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
