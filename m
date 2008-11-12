Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:58:10 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9w3Ig001058
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:58:03 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D3B4154A881
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:58:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 4Wf89EtkFaAJvHOF for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:58:03 -0800 (PST)
Date: Wed, 12 Nov 2008 04:57:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix buffer overflow in lstat64.c
Message-ID: <20081112095702.GA2496@infradead.org>
References: <490F7A7F.9010102@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490F7A7F.9010102@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Nov 03, 2008 at 04:26:07PM -0600, Eric Sandeen wrote:
> lstat64.c was putting an 11-byte string into a 10-byte buffer.

What about somthing like this instead?


Index: xfs-cmds/xfstests/src/lstat64.c
===================================================================
--- xfs-cmds.orig/xfstests/src/lstat64.c	2008-11-12 10:55:16.000000000 +0100
+++ xfs-cmds/xfstests/src/lstat64.c	2008-11-12 10:55:50.000000000 +0100
@@ -57,7 +57,6 @@ int
 main(int argc, char **argv)
 {
 	struct stat64	sbuf;
-	char		mode[10];
 	int		i, c;
 	int		terse_flag = 0;
 
@@ -78,6 +77,7 @@ main(int argc, char **argv)
 	time(&timebuf);
 
 	for (i = optind; i < argc; i++) {
+		char *mode = "----------";
 
 		if( lstat64(argv[i], &sbuf) < 0) {
 			perror(argv[i]);
@@ -92,7 +92,6 @@ main(int argc, char **argv)
 			printf("  Size: %-10llu", (unsigned long long)sbuf.st_size);
 		}
 
-		strcpy(mode,"----------");
 		if (sbuf.st_mode & (S_IEXEC>>6))
 			mode[9] = 'x';
 		if (sbuf.st_mode & (S_IWRITE>>6))
