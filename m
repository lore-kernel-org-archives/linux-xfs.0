Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQIZiMm004146 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 12:35:50 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 597D11113C07
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 10:35:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 8AtgpsX0xPwS5Utw for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2008 10:35:43 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 9FCDAAC6272
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 12:35:43 -0600 (CST)
Message-ID: <492D96FF.4030605@sandeen.net>
Date: Wed, 26 Nov 2008 12:35:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH, RFC] - xfsprogs: pad ustat struct for mount check to avoid
	corruption
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Linux kernels (at least up until 2.6.27) are lacking compat sys_ustat
handlers on some platforms (notably PPC) so that if called from 32 bits
on a 64-bit kernel, the kernel will copy out too much (32 bytes onto a
20-byte structure):

[root@xero xfstests]# xfs_logprint /dev/loop0
xfs_logprint:
*** stack smashing detected ***: xfs_logprint terminated
Aborted

This will be fixed upstream, but for the benefit of older kernels we
may want to guard against this by padding the structure we pass into
the syscall.   We don't care about the values anyway, just the return
value.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfsprogs/libxfs/linux.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/linux.c
+++ xfs-cmds/xfsprogs/libxfs/linux.c
@@ -49,7 +49,8 @@ static int max_block_alignment;
 int
 platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 {
-	struct ustat	ust;
+	/* Pad ust; pre-2.6.28 linux copies out too much in 32bit compat mode */
+	struct ustat	ust[2];
 	struct stat64	st;
 
 	if (!s) {
@@ -60,7 +61,7 @@ platform_check_ismounted(char *name, cha
 		s = &st;
 	}
 
-	if (ustat(s->st_rdev, &ust) >= 0) {
+	if (ustat(s->st_rdev, ust) >= 0) {
 		if (verbose)
 			fprintf(stderr,
 				_("%s: %s contains a mounted filesystem\n"),


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
