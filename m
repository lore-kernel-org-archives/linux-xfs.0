Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 22:37:29 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B5bN5V029237
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:37:23 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] Export xfs_attr_set_int_trans
Date: Fri, 11 Jul 2008 15:38:14 +1000
Message-Id: <1215754695-6958-1-git-send-email-xaiki@sgi.com>
In-Reply-To: <1215675545-2707-5-git-send-email-xaiki@sgi.com>
References: <1215675545-2707-5-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

make xfs_attr_set_int_trans non static so we can use it outside of xfs_attr.c
(Needed to use it in vnodeops.c, for create+EA)

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_attr.c |    2 +-
 fs/xfs/xfs_attr.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 8e9598d..24ba91d 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -241,7 +241,7 @@ xfs_attr_calc_size(
  * we can't commit it either as we don't know if the caller is
  * done with it.
  */
-STATIC int
+int
 xfs_attr_set_int_trans(
 	xfs_trans_t	**tpp,
 	xfs_inode_t	*dp,
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index f99395c..32e80f9 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -161,6 +161,9 @@ struct xfs_da_args;
 int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
 int xfs_attr_inactive(struct xfs_inode *dp);
 
+int xfs_attr_set_int_trans(struct xfs_trans **, struct xfs_inode *, 
+			   struct xfs_name *, char *, int, int);
+
 int xfs_attr_shortform_getvalue(struct xfs_da_args *);
 int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int *, int);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-- 
1.5.6.2
