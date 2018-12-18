Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48998 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbeLRTC6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 14:02:58 -0500
Subject: [PATCH 1/2] xfs: handle bad flags in xfs_recover_inode_owner_change
References: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3898cc3a-be06-a29e-07f6-9daf52cb7545@sandeen.net>
Date: Tue, 18 Dec 2018 13:02:56 -0600
MIME-Version: 1.0
In-Reply-To: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Today, xfs_recover_inode_owner_change() indicates that if XFS_ILOG_DOWNER
is set, XFS_ILOG_DBROOT must be as well, via an assert.  However, this 
could fail to be true due to fuzzing or corruption, so we really
should handle it gracefully rather than calling ASSERT() and crashing,
or blowing past it on a non-debug build and BUGging later.

Return -EFSCORRUPTED and fail the log replay if we find this
inconsistent state.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1fc9e9042e0e..56148a3083b8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2964,7 +2964,10 @@ xfs_recover_inode_owner_change(
 	}
 
 	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
-		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
+		if (!(in_f->ilf_fields & XFS_ILOG_DBROOT)) {
+			error = -EFSCORRUPTED;
+			goto out_free_ip;
+		}
 		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
 					      ip->i_ino, buffer_list);
 		if (error)
@@ -2972,7 +2975,10 @@ xfs_recover_inode_owner_change(
 	}
 
 	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
-		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
+		if (!(in_f->ilf_fields & XFS_ILOG_ABROOT)) {
+			error = -EFSCORRUPTED;
+			goto out_free_ip;
+		}
 		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
 					      ip->i_ino, buffer_list);
 		if (error)
