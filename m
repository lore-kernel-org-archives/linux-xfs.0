Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34641 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932605AbdKGBDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 20:03:48 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA713lZK030310
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA713l5f008673
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:47 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA713lwn018613
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:47 GMT
Subject: [PATCH 4/5] xfs: fix uninitialized return values in scrub code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 06 Nov 2017 17:03:46 -0800
Message-ID: <151001662619.26786.18307082892827501257.stgit@magnolia>
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix smatch complaints about uninitialized return codes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c    |    2 +-
 fs/xfs/scrub/parent.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index c8ca3fd..69e1efd 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -748,7 +748,7 @@ xfs_scrub_directory(
 	};
 	size_t				bufsize;
 	loff_t				oldpos;
-	int				error;
+	int				error = 0;
 
 	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
 		return -ENOENT;
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index cc2b8f6..63a2533 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -143,7 +143,7 @@ xfs_scrub_parent_validate(
 	struct xfs_inode		*dp = NULL;
 	xfs_nlink_t			expected_nlink;
 	xfs_nlink_t			nlink;
-	int				error;
+	int				error = 0;
 
 	*try_again = false;
 
@@ -258,7 +258,7 @@ xfs_scrub_parent(
 	xfs_ino_t			dnum;
 	bool				try_again;
 	int				tries = 0;
-	int				error;
+	int				error = 0;
 
 	/*
 	 * If we're a directory, check that the '..' link points up to

