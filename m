Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 14:16:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3NLG0kG010042
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 14:16:01 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB8CD15C522A
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 14:16:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id DuYj4Of3UWlmb1XR for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 14:16:42 -0700 (PDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3NLGfh4018822
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 17:16:41 -0400
Message-ID: <480FA737.5030001@sandeen.net>
Date: Wed, 23 Apr 2008 16:16:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] convert xfs to use ERR_CAST
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>
Cc: David Howells <dhowells@redhat.com>

Looks like somehow xfs got missed in the conversion that
took place in e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f,
"Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p) <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f>"

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

ndex: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
@@ -167,7 +167,7 @@ xfs_fs_fh_to_dentry(struct super_block *
 	if (!inode)
 		return NULL;
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	result = d_alloc_anon(inode);
 	if (!result) {
 		iput(inode);
@@ -198,7 +198,7 @@ xfs_fs_fh_to_parent(struct super_block *
 	if (!inode)
 		return NULL;
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	result = d_alloc_anon(inode);
 	if (!result) {
 		iput(inode);
