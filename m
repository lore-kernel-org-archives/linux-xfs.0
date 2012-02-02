Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1212bh9021557 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 19:02:37 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id mcSp1QDK15DM3hor (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 17:02:36 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1Rsl4N-00075f-CW
	for xfs@oss.sgi.com; Wed, 01 Feb 2012 17:02:35 -0800
Message-ID: <33246061.post@talk.nabble.com>
Date: Wed, 1 Feb 2012 17:02:35 -0800 (PST)
From: kdasu <kdasu.kdev@gmail.com>
Subject: Inode lockdep problem observed on 2.6.37.6 xfs with RT subvolume
MIME-Version: 1.0
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
To: xfs@oss.sgi.com


Need some help understanding the state of xfs with rt subvolume
support on 2.6.37.

When using xfs rt subvolume on a harddisk partition with kernel
2.6.37.6,and normal r/w/delete file operations  causes deadlock
like hangs .  Failure  symptoms are lockups and mount failure on reboot.

On further investigation it was found that one of the changes could be
the cause.
The same tests seem to pass with xfs in 2.6.31 kernel.

xfs: simplify xfs_trans_iget  : 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=aa72a5cf00001d0b952c7c755be404b9118ceb2e
aa72a5cf00001d0b952c7c755be404b9118ceb2e 

Reverting the change and forward porting to the xfs_trans_iget() seems to
get rid of the deadlock and mount issues .

Below is the change

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 linux-2.6.37/fs/xfs/xfs_trans_inode.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/linux-2.6.37/fs/xfs/xfs_trans_inode.c
b/linux-2.6.37/fs/xfs/xfs_trans_inode.c
index ccb3453..c2861d5 100644
--- a/stblinux-2.6.37/fs/xfs/xfs_trans_inode.c
+++ b/stblinux-2.6.37/fs/xfs/xfs_trans_inode.c
@@ -56,6 +56,27 @@ xfs_trans_iget(
        xfs_inode_t     **ipp)
 {
        int                     error;
+       xfs_inode_t     *ip = NULL;
+       xfs_perag_t     *pag = NULL;
+
+       /*
+       * If we find the inode in core with this transaction
+       * pointer in its i_transp field, then we know we already
+       * have it locked.
+       */
+       if(tp != NULL) {
+               pag = xfs_perag_get(mp,  XFS_INO_TO_AGNO(mp, ino));
+               read_lock(&pag->pag_ici_lock);
+               ip = radix_tree_lookup(&pag->pag_ici_root,
XFS_INO_TO_AGNO(mp, ino));
+               read_unlock(&pag->pag_ici_lock);
+               xfs_perag_put(pag);
+       }
+
+       /* the returned inode must match the transaction */
+       if (ip && (ip->i_transp == tp)) {
+               *ipp = ip;
+               return 0;
+       }

        error = xfs_iget(mp, tp, ino, flags, lock_flags, ipp);
        if (!error && tp) {

--
1.7.6

I have also attached the xfs_logprint text output when the mount fails.
http://old.nabble.com/file/p33246061/xfslog-2.6.37.6-mount-fail.txt
xfslog-2.6.37.6-mount-fail.txt 


Regards
Kamal
-- 
View this message in context: http://old.nabble.com/Inode-lockdep-problem-observed-on-2.6.37.6-xfs-with-RT-subvolume-tp33246061p33246061.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
