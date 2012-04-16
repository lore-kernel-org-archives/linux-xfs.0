Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GGTSef228396 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 11:29:28 -0500
Date: Mon, 16 Apr 2012 11:31:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfstests: Introduce test case 285 to check
	statfs(2) will not cause ASSERT(XFS_IS_QUOTA_RUNNING(mp)) failed.
Message-ID: <20120416163112.GC2924@sgi.com>
References: <4F87ED3D.5060105@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F87ED3D.5060105@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hey Jeff,

On Fri, Apr 13, 2012 at 05:09:17PM +0800, Jeff Liu wrote:
> Call statfs(2) against a project directory cause ASSERT(XFS_IS_QUOTA_RUNNING(mp)) at xfs_qm_dqget() failed pre-vanilla kernel-3.4
> if the "pquota" or "prjquota" mount option was not enabled on the underlying partition.  This test case can help checking it.
> 
> [15002.359375] XFS: Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4362

I'd have expected to see an xfs_qm_dqget related stack trace here.  Are you
sure that this is the one you intended to include?

Thanks,
	Ben


> [15002.359416] ------------[ cut here ]------------
> [15002.359508] kernel BUG at fs/xfs/xfs_message.c:101!
> [15002.359594] invalid opcode: 0000 [#1] SMP 
> [15002.359683] Modules linked in: xfs(O) cryptd aes_i586 aes_generic binfmt_misc ...
> [15002.361578] 
> [15002.361614] Pid: 4886, comm: seek_test Tainted: G           O 3.2.0-rc1-00306-g7f80850 #6 LENOVO 7661D43/7661D43
> [15002.361807] EIP: 0060:[<f94f9d2c>] EFLAGS: 00210246 CPU: 1
> [15002.361976] EIP is at assfail+0x47/0x57 [xfs]
> [15002.362055] EAX: 0000005c EBX: e90d4400 ECX: 00000000 EDX: 000000b6
> [15002.362162] ESI: 00000000 EDI: f39ed800 EBP: f39d7e40 ESP: f39d7e2c
> [15002.362269]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [15002.362366] Process seek_test (pid: 4886, ti=f39d6000 task=db5cd960 task.ti=f39d6000)
> [15002.362452] Stack:
> [15002.362452]  00000000 f95b705a f95bb47d f95ba4f4 0000110a f39d7ee4 f952a5b5 00000000
> [15002.362452]  f39d7ed0 f39d7ed4 f39d7eb0 f39d7e94 00000000 00000000 f39d7eb0 f95662ad
> [15002.362452]  00000000 00000000 00000000 f950910e e90d4438 00000001 00000000 00000000
> [15002.362452] Call Trace:
> [15002.362452]  [<f952a5b5>] xfs_bmapi_read+0x65/0x5fb [xfs]
> [15002.362452]  [<f95662ad>] ? xfs_iext_bno_to_ext+0x10b/0x231 [xfs]
> [15002.362452]  [<f950910e>] ? kmem_alloc+0x4c/0x102 [xfs]
> [15002.362452]  [<f952b808>] ? xfs_getbmapx_fix_eof_hole+0x210/0x269 [xfs]
> [15002.362452]  [<f94f7a3b>] xfs_find_desired_extent+0x37e/0x5ac [xfs]
> [15002.362452]  [<f94e6e70>] xfs_file_llseek+0xe9/0x1d8 [xfs]
> [15002.362452]  [<c1213670>] ? fsnotify_modify+0xa9/0xbf
> [15002.362452]  [<f94e6d87>] ? i_size_read+0x8f/0x8f [xfs]
> [15002.362452]  [<c1213330>] vfs_llseek+0x76/0x8a
> [15002.362452]  [<c1213ebf>] sys_lseek+0x78/0xc7
> [15002.362452]  [<c1814814>] syscall_call+0x7/0xb
> [15002.362452] Code: 10 89 54 24 0c 89 44 24 08 c7 44 24 04 5a 70 5b f9 c7 04 24 00 00 00 00 e8 ad fc ff ff 83 05 305 ...
> [15002.362452] EIP: [<f94f9d2c>] assfail+0x47/0x57 [xfs] SS:ESP 0068:f39d7e2c
> [15002.466588] ---[ end trace ce044edd5a2cbfa7 ]---
> 
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  285     |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  285.out |    2 +
>  group   |    1 +
>  3 files changed, 78 insertions(+), 0 deletions(-)
>  create mode 100755 285
>  create mode 100644 285.out
> 
> diff --git a/285 b/285
> new file mode 100755
> index 0000000..9084fbb
> --- /dev/null
> +++ b/285
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# FS QA Test No. 285
> +#
> +# This test verify statfs(2) against a project directory will not cause
> +# ASSERT(XFS_IS_QUOTA_RUNNING(mp)) at xfs_qm_dqget() failed if the project
> +# quota option was not enabled on the underlying partition.  It was failed
> +# pre-vanilla kernel 3.4.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2012 Oracle Liu Jie.  All Rights Reserved.
> +#
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
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  021101301  USA
> +# ---------------------------------------------------------------------
> +#
> +# creator
> +owner=jeff.liu@oracle.com
> +
> +seq=`basename $0`
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
> +	umount $SCRATCH_MNT 2>/dev/null
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +. ./common.quota
> +
> +echo "Silence is golden."
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_xfs_quota
> +_require_scratch
> +
> +proj_dir="${SCRATCH_MNT}/test_project"
> +test_file="${proj_dir}/test_file"
> +
> +_scratch_mkfs_xfs			>/dev/null 2>&1
> +_qmount
> +
> +mkdir $proj_dir
> +touch $test_file
> +
> +$XFS_QUOTA_PROG -x -c "project -s -p ${proj_dir} 2012" $SCRATCH_DEV \
> +					>/dev/null 2>&1
> +du -sh $proj_dir			>/dev/null 2>&1
> +
> +# Clean up
> +rm -rf $proj_dir
> +_scratch_unmount
> +
> +status=0
> +exit
> diff --git a/285.out b/285.out
> new file mode 100644
> index 0000000..18b5787
> --- /dev/null
> +++ b/285.out
> @@ -0,0 +1,2 @@
> +QA output created by 285
> +Silence is golden.
> diff --git a/group b/group
> index 104ed35..51ee3fd 100644
> --- a/group
> +++ b/group
> @@ -403,3 +403,4 @@ deprecated
>  282 dump ioctl auto quick
>  283 dump ioctl auto quick
>  284 auto
> +285 auto quick quota
> -- 
> 1.7.9
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
