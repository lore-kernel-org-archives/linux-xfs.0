Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BD317F94
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 15:13:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 452228F8035
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 13:13:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PIwAcT9Z1NDfOEaV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 13:13:33 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id D69AFA202A
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 20:13:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t6NKDW0i013911
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 16:13:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 1/2] xfs: return committed status from xfs_trans_roll()
Date: Thu, 23 Jul 2015 16:13:29 -0400
Message-Id: <1437682410-51778-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1437682410-51778-1-git-send-email-bfoster@redhat.com>
References: <1437682410-51778-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Some callers need to make error handling decisions based on whether the
current transaction successfully committed or not. Rename
xfs_trans_roll(), add a new parameter and provide a wrapper to preserve
existing callers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.c | 15 +++++++++++++--
 fs/xfs/xfs_trans.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 0582a27..a0ab1da 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1019,9 +1019,10 @@ xfs_trans_cancel(
  * chunk we've been working on and get a new transaction to continue.
  */
 int
-xfs_trans_roll(
+__xfs_trans_roll(
 	struct xfs_trans	**tpp,
-	struct xfs_inode	*dp)
+	struct xfs_inode	*dp,
+	int			*committed)
 {
 	struct xfs_trans	*trans;
 	struct xfs_trans_res	tres;
@@ -1052,6 +1053,7 @@ xfs_trans_roll(
 	if (error)
 		return error;
 
+	*committed = 1;
 	trans = *tpp;
 
 	/*
@@ -1074,3 +1076,12 @@ xfs_trans_roll(
 		xfs_trans_ijoin(trans, dp, 0);
 	return 0;
 }
+
+int
+xfs_trans_roll(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*dp)
+{
+	int			committed = 0;
+	return __xfs_trans_roll(tpp, dp, &committed);
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3b21b4e..518ae5c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -226,6 +226,7 @@ void		xfs_trans_log_efd_extent(xfs_trans_t *,
 					 xfs_fsblock_t,
 					 xfs_extlen_t);
 int		xfs_trans_commit(struct xfs_trans *);
+int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
