Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CA007F37
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 12:07:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B09B8F8068
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 10:07:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Y2jhAE2RjfgNkZh5 for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 10:07:46 -0700 (PDT)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0B52F6052411
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 12:07:45 -0500 (CDT)
Message-ID: <52388C61.1000001@sandeen.net>
Date: Tue, 17 Sep 2013 12:07:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: initialize filetype for lost+found creation
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
To: xfs-oss <xfs@oss.sgi.com>

If we create lost+found make sure it's got the proper filetype.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(sorry, untested, not sure how to force creation when I can't use
xfs_db to craft a filesystem that needs lost+found)

diff --git a/repair/phase6.c b/repair/phase6.c
index a4ad7a3..946cb6d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -904,6 +904,8 @@ mk_orphanage(xfs_mount_t *mp)
 
 	xname.name = (unsigned char *)ORPHANAGE;
 	xname.len = strlen(ORPHANAGE);
+	xname.type = XFS_DIR3_FT_DIR;
+
 	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
 		return ino;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
