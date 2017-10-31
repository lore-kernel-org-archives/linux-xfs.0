Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdJaHAd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 03:00:33 -0400
Date: Tue, 31 Oct 2017 15:00:27 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] xfs: test for umount hang caused by the pending
 dquota log item in AIL
Message-ID: <20171031070027.GI17339@eguan.usersys.redhat.com>
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
> +	_unmount_flakey >/dev/null 2>&1
> +	_cleanup_flakey > /dev/null 2>&1
> +}
> +
> +_get_xfs_scratch_sb_field()
> +{
> +	local field=$1
> +
> +	echo $(_scratch_xfs_db -r -c "sb 0" -c "print $field" | \
> +		awk -v field=$field '$0 ~ field {print $3}')
> +}
> +
> +# inject IO write error for the XFS filesystem except its log section
> +_make_xfs_scratch_flakey_table()
> +{
> +	local opt="0 1 1 error_writes"

More comments about this error_writes.

error_writes is only there after v4.10-rc1, we need to have a require
rule to test if current kernel supports error_writes or not, and _notrun
if not.

Thanks,
Eryu
