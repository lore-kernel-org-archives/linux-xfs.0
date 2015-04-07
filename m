Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96EB17F6A
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 08:58:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5DC98304039
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 06:58:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xXstM2E4cGKD5pR2 for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 06:58:07 -0700 (PDT)
Message-ID: <5523E26E.8010700@sandeen.net>
Date: Tue, 07 Apr 2015 08:58:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_db: disallow sb UUID write on v5 filesystems
References: <5522A0DB.2010309@redhat.com>
In-Reply-To: <5522A0DB.2010309@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, "F. Stoyan" <fstoyan@swapon.de>

Do not allow xfs_db (or the xfs_admin frontend) to change the UUID
of a V5 filesystem; this will cause UUID mismatches across the
filesystem, and we currently have no mechanism to update them all.
Changing only the superblock UUID makes all other metadata look
invalid, and xfs_repair reacts by junking everything.

Addresses-Debian-Bug: 782012
Reported-by: F. Stoyan <fstoyan@swapon.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2, fix up comment whitespace :/
(and add brian's review for dave's convenience)

diff --git a/db/sb.c b/db/sb.c
index 6cb665d..f31f4a2 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -363,6 +363,18 @@ uuid_f(
 			return 0;
 		}
 
+		/*
+		 * For now, changing the UUID of V5 superblock filesystems is
+		 * not supported; we do not have the infrastructure to fix all
+		 * other metadata when a new superblock UUID is generated.
+		 */
+		if (xfs_sb_version_hascrc(&mp->m_sb) &&
+		    strcasecmp(argv[1], "rewrite")) {
+			dbprintf(_("%s: only 'rewrite' supported on V5 fs\n"),
+				progname);
+			return 0;
+		}
+
 		if (!strcasecmp(argv[1], "generate")) {
 			platform_uuid_generate(&uu);
 		} else if (!strcasecmp(argv[1], "nil")) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
