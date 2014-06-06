Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 820077F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 16:03:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BC2E304032
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 14:03:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1IXOXW7fxKc4AxVv for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 14:03:05 -0700 (PDT)
Message-ID: <53922C8E.3050700@sandeen.net>
Date: Fri, 06 Jun 2014 16:03:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/3] xfs_fsr: ensure the line we read from leftofffile is
	null terminated
References: <53922B49.1050005@redhat.com>
In-Reply-To: <53922B49.1050005@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Ensure that the string we read from leftofffile is NULL
terminated; the buffer gets passed to strchr(), so
it's important that we ensure it ends with NULL.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3818f02..94d235c 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -554,6 +554,8 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 			fsrprintf(_("could not read %s, starting with %s\n"),
 				leftofffile, *fs->dev);
 		} else {
+			/* Ensure the buffer we read is null terminated */
+			buf[SMBUFSZ-1] = '\0';
 			for (fs = fsbase; fs < fsend; fs++) {
 				fsname = fs->dev;
 				if ((strncmp(buf,fsname,strlen(fsname)) == 0)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
