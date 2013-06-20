Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36C797F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 12:25:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 262D1304039
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 10:25:08 -0700 (PDT)
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id D7SA3XVxf4cJkbMV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 20 Jun 2013 10:25:06 -0700 (PDT)
Received: by mail-qa0-f46.google.com with SMTP id ih17so1276128qab.12
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 10:25:05 -0700 (PDT)
Message-ID: <51C33AE6.3050409@gmail.com>
Date: Thu, 20 Jun 2013 13:24:54 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 59/60] xfs: Add xfs_log_rlimit.c
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-60-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-60-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/19/2013 12:51 AM, Dave Chinner wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Add source files for xfs_log_rlimit.c The new file is used for log
> size calculations and validation shared with userspace.
> 
> [dchinner: xfs_log_calc_max_attrsetm_res() does not modify the
> tr_attrsetm reservation, just calculates the maximum. ]
> 
> [dchinner: rework loop in xfs_log_get_max_trans_res() ]
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile         |    1 +
>  fs/xfs/xfs_log_format.h |    8 ++-
>  fs/xfs/xfs_log_rlimit.c |  145 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 153 insertions(+), 1 deletion(-)
>  create mode 100644 fs/xfs/xfs_log_rlimit.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index c5c38a9..22691eb 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -81,6 +81,7 @@ xfs-y				+= xfs_alloc.o \
>  				   xfs_inode_fork.o \
>  				   xfs_inode_buf.o \
>  				   xfs_log_recover.o \
> +				   xfs_log_rlimit.o \
>  				   xfs_sb.o \
>  				   xfs_symlink_remote.o \
>  				   xfs_trans_resv.o
> diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
> index 37a7ff9..8f46b6a 100644
> --- a/fs/xfs/xfs_log_format.h
> +++ b/fs/xfs/xfs_log_format.h
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
> + * Copyright (c) 2013 Jie Liu.
>   * All Rights Reserved.
>   *
>   * This program is free software; you can redistribute it and/or
> @@ -19,6 +20,7 @@
>  #define __XFS_LOG_FORMAT_H__
>  
>  struct xfs_mount;
> +struct xfs_trans_res;
>  
>  typedef __uint32_t xlog_tid_t;
>  
> @@ -41,6 +43,9 @@ typedef __uint32_t xlog_tid_t;
>  
>  #define XLOG_HEADER_SIZE	512
>  
> +/* Minimum number of transactions that must fit in the log (defined by mkfs) */
> +#define XFS_MIN_LOG_FACTOR	3
> +
>  #define XLOG_REC_SHIFT(log) \
>  	BTOBB(1 << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
>  	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
> @@ -125,7 +130,6 @@ typedef struct xlog_op_header {
>  	__u16	   oh_res2;	/* 32 bit align			:  2 b */
>  } xlog_op_header_t;
>  
> -
>  /* valid values for h_fmt */
>  #define XLOG_FMT_UNKNOWN  0
>  #define XLOG_FMT_LINUX_LE 1
> @@ -178,5 +182,7 @@ typedef struct xfs_log_iovec {
>  } xfs_log_iovec_t;
>  
>  int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
> +int	xfs_log_calc_minimum_size(struct xfs_mount *);
> +
>  
>  #endif /* __XFS_LOG_FORMAT_H__ */
> diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
> new file mode 100644
> index 0000000..e3f4b4e
> --- /dev/null
> +++ b/fs/xfs/xfs_log_rlimit.c
> @@ -0,0 +1,145 @@
> +/*
> + * Copyright (c) 2013 Jie Liu.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_log.h"
> +#include "xfs_trans.h"
> +#include "xfs_ag.h"
> +#include "xfs_sb.h"
> +#include "xfs_mount.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_inode.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr_leaf.h"
> +
> +/*
> + * Calculate the maximum length in bytes that would be required for a local
> + * attribute value as large attributes out of line are not logged.
> + */
> +STATIC int
> +xfs_log_calc_max_attrsetm_res(
> +	struct xfs_mount	*mp)
> +{
> +	int			size;
> +	int			nblks;
> +
> +	size = xfs_attr_leaf_entsize_local_max(mp->m_sb.sb_blocksize) -
> +	       MAXNAMELEN - 1;
> +	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> +	nblks += XFS_B_TO_FSB(mp, size);
> +	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> +
> +	return  M_RES(mp)->tr_attrsetm.tr_logres +
> +		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> +}
> +
> +/*
> + * Iterate over the log space reservation table to figure out and return
> + * the maximum one in terms of the pre-calculated values which were done
> + * at mount time.
> + */
> +STATIC void
> +xfs_log_get_max_trans_res(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_res	*max_resp)
> +{
> +	struct xfs_trans_res	*resp;
> +	struct xfs_trans_res	*end_resp;
> +	int			log_space = 0;
> +	int			attr_space;
> +
> +	attr_space = xfs_log_calc_max_attrsetm_res(mp);
> +
> +	resp = (struct xfs_trans_res *)M_RES(mp);
> +	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
> +	for (; resp < end_resp; resp++) {
> +		int		tmp = resp->tr_logcount > 1 ?
> +				      resp->tr_logres * resp->tr_logcount :
> +				      resp->tr_logres;
> +		if (log_space < tmp) {
> +			log_space = tmp;
> +			*max_resp = *resp;		/* struct copy */
> +		}
> +	}
> +
> +	if (attr_space > log_space) {
> +		*max_resp = M_RES(mp)->tr_attrsetm;	/* struct copy */
> +		max_resp->tr_logres = attr_space;
> +	}
> +}
> +
> +/*
> + * Calculate the minimum valid log size for the given superblock configuration.
> + * Used to calculate the minimum log size at mkfs time, and to determine if
> + * the log is large enough or not at mount time. Returns the minimum size in
> + * filesystem block size units.
> + */
> +int
> +xfs_log_calc_minimum_size(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_trans_res	tres = {0};
> +	int			max_logres;
> +	int			min_logblks = 0;
> +	int			lsunit = 0;
> +
> +	xfs_log_get_max_trans_res(mp, &tres);
> +
> +	max_logres = xfs_log_calc_unit_res(mp, tres.tr_logres);
> +	if (tres.tr_logcount > 1)
> +		max_logres *= tres.tr_logcount;
> +
> +	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
> +		lsunit = BTOBB(mp->m_sb.sb_logsunit);
> +
> +	/*
> +	 * Two factors should be taken into account for calculating the minimum
> +	 * log space.
> +	 * 1) The fundamental limitation is that no single transaction can be
> +	 *    larger than half size of the log.
> +	 *
> +	 *    From mkfs.xfs, this is considered by the XFS_MIN_LOG_FACTOR
> +	 *    define, which is set to 3. That means we can definitely fit
> +	 *    maximally sized 2 transactions in the log. We'll use this same
> +	 *    value here.
> +	 *
> +	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
> +	 *    for the reservation because there are two log writes that can
> +	 *    require padding - the transaction data and the commit record which
> +	 *    are written separately and both can require padding to the LSU.
> +	 *    Consider that we can have an active CIL reservation holding 2*LSU,
> +	 *    but the CIL is not over a push threshold, in this case, if we
> +	 *    don't have enough log space for at one new transaction, which
> +	 *    includes another 2*LSU in the reservation, we will run into dead
> +	 *    loop situation in log space grant procedure. i.e.
> +	 *    xlog_grant_head_wait().
> +	 *
> +	 *    Hence the log size needs to be able to contain two maximally sized
> +	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
> +	 *
> +	 * Also, the log size should be a multiple of the log stripe unit, round
> +	 * it up to lsunit boundary if lsunit is specified.
> +	 */
> +	if (lsunit)
> +		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
> +	else
> +		min_logblks = BTOBB(max_logres);
> +	min_logblks *= XFS_MIN_LOG_FACTOR;
> +	return XFS_BB_TO_FSB(mp, min_logblks);
> +}
> 

OK, my overall patch for this patch series is after my closing and may 
be wrong.  I applied Dave's patchset over a yet-newer git kernel and 
may have gotten burned a little bit.  It may not even be helpful, as 
xfs/297 gets a new assert on a non-CRC 512b-block filesystem, as 
opposed to grinding to a halt.  [xfs/297 still passes for filesystems 
that have a 4k block size.]

The point of this reply is to call on Jeff Liu and ask this:  Do you 
have a more recent and accurate fix to this code than what I tried to 
remember?  Or did the fix not work on platforms other than 32-bit x86?

Thanks!

Michael

>From f2a4759c5ed2011daed14b3b44f5eee2e317dbf6 Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Thu, 20 Jun 2013 03:40:30 -0400
Subject: [PATCH] Residual fixes for 2013-06-19 XFS 3.11 patchset

This patch represents fixing a merge conflict between the functions
xfs_inactive_symlink() and xfs_inactive_symlink_rmt() from a patch
that `git am` did not take cleanly.  Sysadmin hack.  Please check.

This patch also uses an int cast to make the build not fail
with an undefined reference to _udivdi3.  This issue is somewhat
documented near the roundup() function in include/linux/kernel.h
as applying to gcc-3.3, but it also seems to apply to gcc-4.8.1.
It is a Jeff Liu fix that might have gotten lost in the mix.
Reconstructed from memory.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 fs/xfs/xfs_inode_ops.c  | 2 +-
 fs/xfs/xfs_log_rlimit.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_ops.c b/fs/xfs/xfs_inode_ops.c
index c551a8a..6cfab9f 100644
--- a/fs/xfs/xfs_inode_ops.c
+++ b/fs/xfs/xfs_inode_ops.c
@@ -1496,7 +1496,7 @@ xfs_inactive(
 		 * Zero length symlinks _can_ exist.
 		 */
 		if (ip->i_d.di_size > XFS_IFORK_DSIZE(ip)) {
-			error = xfs_inactive_symlink_rmt(ip, &tp);
+			error = xfs_inactive_symlink(ip, &tp);
 			if (error)
 				goto out_cancel;
 		} else if (ip->i_df.if_bytes > 0) {
diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index e3f4b4e..003ea89 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -137,7 +137,7 @@ xfs_log_calc_minimum_size(
 	 * it up to lsunit boundary if lsunit is specified.
 	 */
 	if (lsunit)
-		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
+		min_logblks = roundup((int)BTOBB(max_logres), lsunit) + 2 * lsunit;
 	else
 		min_logblks = BTOBB(max_logres);
 	min_logblks *= XFS_MIN_LOG_FACTOR;
-- 
1.8.3

root@plbearer:/var/lib/xfstests# MKFS_OPTIONS='-b log=9' ./check -xfs xfs/297
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 plbearer 3.10.0-rc6+
MKFS_OPTIONS  -- -f -b log=9 /dev/sdb6
MOUNT_OPTIONS -- /dev/sdb6 /mnt/xfstests-scratch

xfs/297 216s ...[ 2262.188646] XFS: Assertion failed: BTOBB(need_bytes) < log->l_logBBsize, file: fs/xfs/xfs_log.c, line: 1498
[ 2262.189898] ------------[ cut here ]------------
[ 2262.190017] kernel BUG at fs/xfs/xfs_message.c:108!
[ 2262.190017] invalid opcode: 0000 [#1]
[ 2262.190017] CPU: 0 PID: 11388 Comm: mkdir Not tainted 3.10.0-rc6+ #5
[ 2262.190017] Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
[ 2262.190017] task: eebe8000 ti: d91fa000 task.ti: d91fa000
[ 2262.190017] EIP: 0060:[<c11b3454>] EFLAGS: 00010282 CPU: 0
[ 2262.190017] EIP is at assfail+0x2b/0x2d
[ 2262.190017] EAX: 0000005f EBX: d961e600 ECX: 000002e1 EDX: eebe84a0
[ 2262.190017] ESI: 00000dcb EDI: 00000000 EBP: d91fbe0c ESP: d91fbdf8
[ 2262.190017]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 2262.190017] CR0: 8005003b CR2: b768a2f0 CR3: 2a4de000 CR4: 000007d0
[ 2262.190017] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2262.190017] DR6: ffff0ff0 DR7: 00000400
[ 2262.190017] Stack:
[ 2262.190017]  00000000 c16f3f10 c16fbcd4 c16e9391 000005da d91fbe28 c12006bd 00000069
[ 2262.190017]  000111b8 00000069 00000003 000111b8 d91fbe60 c12022bc 00000069 00000001
[ 2262.190017]  00000009 eaba0bb0 d91fbe60 c11b496d 00000001 d961e600 00000000 df116e88
[ 2262.190017] Call Trace:
[ 2262.190017]  [<c12006bd>] xlog_grant_push_ail+0x4e/0xf2
[ 2262.190017]  [<c12022bc>] xfs_log_reserve+0xc8/0x290
[ 2262.190017]  [<c11b496d>] ? xfs_mod_incore_sb+0x46/0x4f
[ 2262.190017]  [<c11b9741>] xfs_trans_reserve+0x295/0x2a3
[ 2262.190017]  [<c11a8bcf>] xfs_create+0x151/0x57f
[ 2262.190017]  [<c10e5788>] ? kern_path_create+0x8b/0x118
[ 2262.190017]  [<c11b1146>] xfs_vn_mknod+0x94/0x15f
[ 2262.190017]  [<c11b122d>] ? xfs_vn_create+0x1c/0x1c
[ 2262.190017]  [<c11b124a>] xfs_vn_mkdir+0x1d/0x1f
[ 2262.190017]  [<c10e5be4>] vfs_mkdir+0x75/0x10c
[ 2262.190017]  [<c10e2618>] ? putname+0x23/0x32
[ 2262.190017]  [<c10e5cd6>] SyS_mkdirat+0x5b/0xab
[ 2262.190017]  [<c10e5d4c>] SyS_mkdir+0x26/0x28
[ 2262.190017]  [<c156f710>] syscall_call+0x7/0xb
[ 2262.190017] Code: 55 89 e5 83 ec 14 3e 8d 74 26 00 89 4c 24 10 89 54 24 0c 89 44 24 08 c7 44 24 04 10 3f 6f c1 c7 04 24 00 00 00 00 e8 ad fd ff ff <0f> 0b 55 89 e5 83 ec 14 3e 8d 74 26 00 c7 44 24 10 01 00 00 00
[ 2262.190017] EIP: [<c11b3454>] assfail+0x2b/0x2d SS:ESP 0068:d91fbdf8
[ 2262.236310] ---[ end trace fb9dc01903f0ec11 ]---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
