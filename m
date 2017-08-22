Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35088 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbdHVVW7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 17:22:59 -0400
Subject: [PATCH 4/3] xfs_quota: remove dodgy init_cvtnum
References: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <72d932f4-5ae1-29b1-e4de-d4740913e901@sandeen.net>
Date: Tue, 22 Aug 2017 16:22:58 -0500
MIME-Version: 1.0
In-Reply-To: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

init_cvtnum() in quota is a lie; it sets blocksize to
4096 and sector size to 512 unconditionally.

Now that cvtnum can cope with unset block and/or sectors,
just pass in zeros, meaning that we can't specify limits
in terms of block or sector count.

Now that we're not using the "fake" sizes, remove them
from the extractb() args as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/edit.c b/quota/edit.c
index 8418e85..aa8c14e 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -222,8 +222,6 @@ extractb(
 	char		*string,
 	const char	*prefix,
 	int		length,
-	uint		blocksize,
-	uint		sectorsize,
 	uint64_t	*value)
 {
 	long long	v;
@@ -231,7 +229,7 @@ extractb(
 
 	if (strncmp(string, prefix, length) == 0) {
 		s = string + length + 1;
-		v = cvtnum(blocksize, sectorsize, s);
+		v = cvtnum(0, 0, s);
 		if (v == -1LL) {
 			fprintf(stderr,
 				_("%s: Error: could not parse size %s.\n"),
@@ -272,9 +270,8 @@ limit_f(
 	char		*name;
 	uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
 	int		c, type = 0, mask = 0, flags = 0;
-	uint		bsize, ssize, endoptions;
+	uint		endoptions;
 
-	init_cvtnum(&bsize, &ssize);
 	bsoft = bhard = isoft = ihard = rtbsoft = rtbhard = 0;
 	while ((c = getopt(argc, argv, "dgpu")) != EOF) {
 		switch (c) {
@@ -315,17 +312,17 @@ limit_f(
 	 */
 	while (argc > optind + endoptions - 1) {
 		char *s = argv[optind++];
-		if (extractb(s, "bsoft=", 5, bsize, ssize, &bsoft))
+		if (extractb(s, "bsoft=", 5, &bsoft))
 			mask |= FS_DQ_BSOFT;
-		else if (extractb(s, "bhard=", 5, bsize, ssize, &bhard))
+		else if (extractb(s, "bhard=", 5, &bhard))
 			mask |= FS_DQ_BHARD;
 		else if (extracti(s, "isoft=", 5, &isoft))
 			mask |= FS_DQ_ISOFT;
 		else if (extracti(s, "ihard=", 5, &ihard))
 			mask |= FS_DQ_IHARD;
-		else if (extractb(s, "rtbsoft=", 7, bsize, ssize, &rtbsoft))
+		else if (extractb(s, "rtbsoft=", 7, &rtbsoft))
 			mask |= FS_DQ_RTBSOFT;
-		else if (extractb(s, "rtbhard=", 7, bsize, ssize, &rtbhard))
+		else if (extractb(s, "rtbhard=", 7, &rtbhard))
 			mask |= FS_DQ_RTBHARD;
 		else {
 			exitcode = 1;
diff --git a/quota/init.c b/quota/init.c
index d45dc4c..eb2b9ca 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -51,15 +51,6 @@ usage(void)
 	exit(1);
 }
 
-void
-init_cvtnum(
-	unsigned int	*blocksize,
-	unsigned int	*sectsize)
-{
-	*blocksize = 4096;
-	*sectsize = 512;
-}
-
 static void
 init_commands(void)
 {
diff --git a/quota/init.h b/quota/init.h
index 6879855..10b4d68 100644
--- a/quota/init.h
+++ b/quota/init.h
@@ -29,5 +29,3 @@ extern void	quot_init(void);
 extern void	quota_init(void);
 extern void	report_init(void);
 extern void	state_init(void);
-
-extern void init_cvtnum(unsigned int *, unsigned int *);
