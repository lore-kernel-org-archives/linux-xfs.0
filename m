Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61EEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbiATAWE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiATAWD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AE2C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:22:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5192961506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B050DC004E1;
        Thu, 20 Jan 2022 00:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638122;
        bh=5n4ZkWH+JI/IYrokl+kVljjTICrlfxtchkfbLiDcpaU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bKeTQBm0EQjgBKf2IuyfgQkLsoIkLfqOalFwCxRYYMZLeToim6VS8c45gvE94sOz3
         hutjwJEziSyWDModz+gmopWgej9TZPvTTdLm/POy8W8cx2q/DBanEfpgyE7PlE+1kX
         sOdwmDqLCDh+EbtslkzutnPZLmU/F+fbmB0w33vDA0o6oRIm3VwmjsaPm91U263bRm
         OMrr9SW18r0uVQXgMO53rEl5XsTCBGY2LtpU7caKgKV+EAjttQQjB87f/lFVyFClM2
         6N1ySLnQj0pEm1cUITFx2i2Qp5reXg4t1HZ4ibd8PvfifttG0t3HuTNXizquEjO8iS
         /Zsw1jwMVp2PA==
Subject: [PATCH 05/17] misc: add a crc32c self test to mkfs and repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:02 -0800
Message-ID: <164263812233.863810.8941848920301589525.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enhance mkfs and xfs_repair to run the crc32c self test when they start
up, and refuse to continue if the self test fails.   We don't want to
format a filesystem if the checksum algorithm produces incorrect
results, and we especially don't want repair to tear a filesystem apart
because it thinks the checksum is wrong.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/crc32cselftest.c      |    2 +-
 libfrog/crc32.c          |    2 +-
 libfrog/crc32cselftest.h |   21 ++++++++++++++-------
 man/man8/mkfs.xfs.8      |    4 ++++
 man/man8/xfs_repair.8    |    4 ++++
 mkfs/xfs_mkfs.c          |    8 ++++++++
 repair/init.c            |    5 +++++
 7 files changed, 37 insertions(+), 9 deletions(-)


diff --git a/io/crc32cselftest.c b/io/crc32cselftest.c
index f8f757f6..49eb5b6d 100644
--- a/io/crc32cselftest.c
+++ b/io/crc32cselftest.c
@@ -16,7 +16,7 @@ crc32cselftest_f(
 	int		argc,
 	char		**argv)
 {
-	return crc32c_test() != 0;
+	return crc32c_test(0) != 0;
 }
 
 static const cmdinfo_t	crc32cselftest_cmd = {
diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 6a273b71..2499615d 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -202,7 +202,7 @@ int main(int argc, char **argv)
 
 	printf("CRC_LE_BITS = %d\n", CRC_LE_BITS);
 
-	errors = crc32c_test();
+	errors = crc32c_test(0);
 
 	return errors != 0;
 }
diff --git a/libfrog/crc32cselftest.h b/libfrog/crc32cselftest.h
index 08284153..447a7f7d 100644
--- a/libfrog/crc32cselftest.h
+++ b/libfrog/crc32cselftest.h
@@ -661,18 +661,22 @@ static struct crc_test {
 	{0xb18a0319, 0x00000026, 0x000007db, 0x9dc0bb48},
 };
 
+/* Don't print anything to stdout. */
+#define CRC32CTEST_QUIET	(1U << 0)
+
 static int
-crc32c_test(void)
+crc32c_test(
+	unsigned int	flags)
 {
-	int i;
-	int errors = 0;
-	int bytes = 0;
-	struct timeval start, stop;
-	uint64_t usec;
+	int		i;
+	int		errors = 0;
+	int		bytes = 0;
+	struct timeval	start, stop;
+	uint64_t	usec;
 
 	/* keep static to prevent cache warming code from
 	 * getting eliminated by the compiler */
-	static uint32_t crc;
+	static uint32_t	crc;
 
 	/* pre-warm the cache */
 	for (i = 0; i < 100; i++) {
@@ -693,6 +697,9 @@ crc32c_test(void)
 	usec = stop.tv_usec - start.tv_usec +
 		1000000 * (stop.tv_sec - start.tv_sec);
 
+	if (flags & CRC32CTEST_QUIET)
+		return errors;
+
 	if (errors)
 		printf("crc32c: %d self tests failed\n", errors);
 	else {
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index a7f70285..880e949b 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -121,6 +121,10 @@ If the size of the block or sector is not specified, the default sizes
 .PP
 Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
+
+The correctness of the crc32c checksum implementation will be tested
+before formatting the filesystem.
+If the test fails, the format will abort.
 .SH OPTIONS
 Options may be specified either on the command line or in a configuration file.
 Not all command line options can be specified in configuration files; only the
diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index cc6a2be8..6625b47a 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -184,6 +184,10 @@ usual 0. This option cannot be used together with
 .B \-V
 Prints the version number and exits.
 .SS Checks Performed
+The correctness of the crc32c checksum implementation will be tested
+before examining the filesystem.
+If the test fails, the program will abort.
+
 Inconsistencies corrected include the following:
 .IP 1.
 Inode and inode blockmap (addressing) checks:
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 057b3b09..3a41e17f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -10,6 +10,7 @@
 #include "libxcmd.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/convert.h"
+#include "libfrog/crc32cselftest.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -4044,6 +4045,13 @@ main(
 			exit(0);
 	}
 
+	/* Make sure our checksum algorithm really works. */
+	if (crc32c_test(CRC32CTEST_QUIET) != 0) {
+		fprintf(stderr,
+ _("crc32c self-test failed, will not create a filesystem here.\n"));
+		return 1;
+	}
+
 	/*
 	 * All values have been validated, discard the old device layout.
 	 */
diff --git a/repair/init.c b/repair/init.c
index 55f226e9..3a320b4f 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -14,6 +14,7 @@
 #include "bmap.h"
 #include "incore.h"
 #include "prefetch.h"
+#include "libfrog/crc32cselftest.h"
 #include <sys/resource.h>
 
 static void
@@ -100,4 +101,8 @@ _("Unmount or use the dangerous (-d) option to repair a read-only mounted filesy
 	ts_create();
 	increase_rlimit();
 	pftrace_init();
+
+	if (crc32c_test(CRC32CTEST_QUIET) != 0)
+		do_error(
+ _("crc32c self-test failed, will not examine filesystem.\n"));
 }

