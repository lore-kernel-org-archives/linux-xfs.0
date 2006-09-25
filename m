Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Sep 2006 01:42:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8P8fwaG015907
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 01:41:59 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFB0F45CB2D
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 01:41:18 -0700 (PDT)
Received: from agami.com ([192.168.168.146])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8P8fHQ2005885
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 01:41:17 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8P8fCKA003759
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 01:41:12 -0700
Message-ID: <45179573.3020007@agami.com>
Date: Mon, 25 Sep 2006 14:08:11 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Data type overflow in xfs_trans_unreserve_and_mod_sb
References: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg>
In-Reply-To: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg>
Content-Type: multipart/mixed;
 boundary="------------040408080302030208020808"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>

This is a multi-part message in MIME format.
--------------040408080302030208020808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi David,
           As part of fixing xfs_reserve_blocks issue, you might want to 
fix an issue in xfs_trans_unreserve_and_mod_sb as well. Since, I am on 
much older version, my patch is not applicable on newer trees. However, 
the patch is attached for your reference.

The problem is as below:

Superblock modifications required during transaction are stored in delta 
fields in transaction. These fields are applied to the superblock when 
transaction commits.

The in-core superblock changes are done in 
xfs_trans_unreserve_and_mod_sb. It calls xfs_mod_incore_sb_batch 
function to apply the changes. This function tries to apply the deltas 
and if it fails for any reason, it backs out all the changes. One 
typical modification done is like that:

         case XFS_SBS_DBLOCKS:
                 lcounter = (long long)mp->m_sb.sb_dblocks;
                 lcounter += delta;
                 if (lcounter < 0) {
                         ASSERT(0);
                         return (XFS_ERROR(EINVAL));
                 }
                 mp->m_sb.sb_dblocks = lcounter;
                 return (0);

So, when it returns EINVAL, the second part of the code backs out the 
changes made to superblock. However, the worst part is that 
xfs_trans_unreserve_and_mod_sb does not return any error value. The 
transaction appears to be committed peacefully without returning the 
error. You don't notice this unless you do I/O on the filesystem. Later, 
it hits some sort of in-memory corruption or other errors.

We hit this issue in our testing we tried to grow the filesystem from 
from 100GB to 10000GB. This is beyond the interger (31 bits) limit and, 
hence, for dblocks and fdblocks,  xfs_mod_sb struct does not pass in 
correct data.




--------------040408080302030208020808
Content-Type: text/x-patch;
 name="xfs-sb-mod-growfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs-sb-mod-growfs.patch"

diff -urNp -X kernel-2.6.7-dontdiff kernel-2.6.7-orig/fs/xfs/xfs_mount.c kernel-2.6.7-modif/fs/xfs/xfs_mount.c
--- kernel-2.6.7-orig/fs/xfs/xfs_mount.c
+++ kernel-2.6.7-modif/fs/xfs/xfs_mount.c
@@ -1286,7 +1286,7 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
  */
 STATIC int
 xfs_mod_incore_sb_unlocked(xfs_mount_t *mp, xfs_sb_field_t field,
-			int delta, int rsvd)
+			long delta, int rsvd)
 {
 	int		scounter;	/* short counter for 32 bit fields */
 	long long	lcounter;	/* long counter for 64 bit fields */
diff -urNp -X kernel-2.6.7-dontdiff kernel-2.6.7-orig/fs/xfs/xfs_mount.h kernel-2.6.7-modif/fs/xfs/xfs_mount.h
--- kernel-2.6.7-orig/fs/xfs/xfs_mount.h
+++ kernel-2.6.7-modif/fs/xfs/xfs_mount.h
@@ -551,10 +551,11 @@ static inline xfs_agblock_t XFS_DADDR_TO
 
 /*
  * This structure is for use by the xfs_mod_incore_sb_batch() routine.
+ * xfs_growfs can specify a few fields which are more than int limit
  */
 typedef struct xfs_mod_sb {
 	xfs_sb_field_t	msb_field;	/* Field to modify, see below */
-	int		msb_delta;	/* Change to make to specified field */
+	long		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
 #define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock), PINOD)
diff -urNp -X kernel-2.6.7-dontdiff kernel-2.6.7-orig/fs/xfs/xfs_trans.c kernel-2.6.7-modif/fs/xfs/xfs_trans.c
--- kernel-2.6.7-orig/fs/xfs/xfs_trans.c
+++ kernel-2.6.7-modif/fs/xfs/xfs_trans.c
@@ -590,62 +590,62 @@ xfs_trans_unreserve_and_mod_sb(
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		if (tp->t_icount_delta != 0) {
 			msbp->msb_field = XFS_SBS_ICOUNT;
-			msbp->msb_delta = (int)tp->t_icount_delta;
+			msbp->msb_delta = tp->t_icount_delta;
 			msbp++;
 		}
 		if (tp->t_ifree_delta != 0) {
 			msbp->msb_field = XFS_SBS_IFREE;
-			msbp->msb_delta = (int)tp->t_ifree_delta;
+			msbp->msb_delta = tp->t_ifree_delta;
 			msbp++;
 		}
 		if (tp->t_fdblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_FDBLOCKS;
-			msbp->msb_delta = (int)tp->t_fdblocks_delta;
+			msbp->msb_delta = tp->t_fdblocks_delta;
 			msbp++;
 		}
 		if (tp->t_frextents_delta != 0) {
 			msbp->msb_field = XFS_SBS_FREXTENTS;
-			msbp->msb_delta = (int)tp->t_frextents_delta;
+			msbp->msb_delta = tp->t_frextents_delta;
 			msbp++;
 		}
 		if (tp->t_dblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_DBLOCKS;
-			msbp->msb_delta = (int)tp->t_dblocks_delta;
+			msbp->msb_delta = tp->t_dblocks_delta;
 			msbp++;
 		}
 		if (tp->t_agcount_delta != 0) {
 			msbp->msb_field = XFS_SBS_AGCOUNT;
-			msbp->msb_delta = (int)tp->t_agcount_delta;
+			msbp->msb_delta = tp->t_agcount_delta;
 			msbp++;
 		}
 		if (tp->t_imaxpct_delta != 0) {
 			msbp->msb_field = XFS_SBS_IMAX_PCT;
-			msbp->msb_delta = (int)tp->t_imaxpct_delta;
+			msbp->msb_delta = tp->t_imaxpct_delta;
 			msbp++;
 		}
 		if (tp->t_rextsize_delta != 0) {
 			msbp->msb_field = XFS_SBS_REXTSIZE;
-			msbp->msb_delta = (int)tp->t_rextsize_delta;
+			msbp->msb_delta = tp->t_rextsize_delta;
 			msbp++;
 		}
 		if (tp->t_rbmblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_RBMBLOCKS;
-			msbp->msb_delta = (int)tp->t_rbmblocks_delta;
+			msbp->msb_delta = tp->t_rbmblocks_delta;
 			msbp++;
 		}
 		if (tp->t_rblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_RBLOCKS;
-			msbp->msb_delta = (int)tp->t_rblocks_delta;
+			msbp->msb_delta = tp->t_rblocks_delta;
 			msbp++;
 		}
 		if (tp->t_rextents_delta != 0) {
 			msbp->msb_field = XFS_SBS_REXTENTS;
-			msbp->msb_delta = (int)tp->t_rextents_delta;
+			msbp->msb_delta = tp->t_rextents_delta;
 			msbp++;
 		}
 		if (tp->t_rextslog_delta != 0) {
 			msbp->msb_field = XFS_SBS_REXTSLOG;
-			msbp->msb_delta = (int)tp->t_rextslog_delta;
+			msbp->msb_delta = tp->t_rextslog_delta;
 			msbp++;
 		}
 	}

--------------040408080302030208020808--
