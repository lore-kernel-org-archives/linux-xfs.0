Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 04:10:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37BAbrL014563
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 04:10:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EA9094E5B1
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 04:11:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 5jfVdlAWyows7W0s for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 04:11:14 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m379vjF3011838
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 11:57:45 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m379vjjh011836
	for xfs@oss.sgi.com; Mon, 7 Apr 2008 11:57:45 +0200
Date: Mon, 7 Apr 2008 11:57:45 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't validate symlink target component length
Message-ID: <20080407095745.GA11772@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This validtion is not posix conform and no other Linux filesystem does
it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-07 09:33:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-07 09:34:25.000000000 +0200
@@ -3105,31 +3105,6 @@ xfs_symlink(
 	pathlen = strlen(target_path);
 	if (pathlen >= MAXPATHLEN)      /* total string too long */
 		return XFS_ERROR(ENAMETOOLONG);
-	if (pathlen >= MAXNAMELEN) {    /* is any component too long? */
-		int len, total;
-		char *path;
-
-		for (total = 0, path = target_path; total < pathlen;) {
-			/*
-			 * Skip any slashes.
-			 */
-			while(*path == '/') {
-				total++;
-				path++;
-			}
-
-			/*
-			 * Count up to the next slash or end of path.
-			 * Error out if the component is bigger than MAXNAMELEN.
-			 */
-			for(len = 0; *path != '/' && total < pathlen;total++, path++) {
-				if (++len >= MAXNAMELEN) {
-					error = ENAMETOOLONG;
-					return error;
-				}
-			}
-		}
-	}
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
