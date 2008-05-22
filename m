Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 17:14:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M0EPa4019889
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 17:14:27 -0700
Date: Thu, 22 May 2008 10:15:15 +1000
Subject: REVIEW: Forgot to remove d_add call when taking out
 drop_negative_children code
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080522001515.6F3A558C4C29@chook.melbourne.sgi.com>
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@oss.sgi.com

--- a/fs/xfs/linux-2.6/xfs_iops.c	2008-05-22 10:15:15.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_iops.c	2008-05-22 10:12:29.961204467 +1000
@@ -420,7 +420,11 @@ xfs_vn_ci_lookup(
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
 			return ERR_PTR(-error);
-		d_add(dentry, NULL);
+		/*
+		 * call d_add(dentry, NULL) here when d_drop_negative_children
+		 * is called in xfs_vn_mknod (ie. allow negative dentries
+		 * with CI filesystems).
+		 */
 		return NULL;
 	}
 
