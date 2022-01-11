Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A99C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbiAKVuo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37312 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245518AbiAKVuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10496B81D57;
        Tue, 11 Jan 2022 21:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B121BC36AE3;
        Tue, 11 Jan 2022 21:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937841;
        bh=xoQqAE1wPQG96TIrahEbkQ7eV72i1Zk2u6dt+bCkF8s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fHK0BoO9vlnr783wkJPIrC9OPxh77/WbQU9rOuUHT1sln4MP00hD73qO2ADj1SLrS
         qu7DIjGbAOuYno2oAOmuO6Ko13YC7aQkcj3N3BXwveMftJq0UoUwrGlcGnpUyrIEAe
         Yt0VWqddermcYxY1UeV4VPVQLFJ+dmItIsdG5xRwyincRo+q92cqnigM9T+m3Pwjn6
         obZpByDoG2qPfMCHjrLj9Kbr9FqRyXW+2wPCq7Wdoi3gWKPixkVwaPAgJsyttT7fc7
         qT0kLq+QpPASjDmlhragepRitAmtUtKTRS33FZ+79hAUpyIRol9ZYiNJLDlLz2Uuxx
         gvQp0ylOuVL7Q==
Subject: [PATCH 6/8] fsx: add support for XFS_IOC_ALLOCSP
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:41 -0800
Message-ID: <164193784141.3008286.16249748010203337264.stgit@magnolia>
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add support for this old ioctl before we remove it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsx.c |  110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 108 insertions(+), 2 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 12c2cc33..520e53a2 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -111,6 +111,7 @@ enum {
 	OP_CLONE_RANGE,
 	OP_DEDUPE_RANGE,
 	OP_COPY_RANGE,
+	OP_ALLOCSP,
 	OP_MAX_FULL,
 
 	/* integrity operations */
@@ -165,6 +166,7 @@ int	randomoplen = 1;		/* -O flag disables it */
 int	seed = 1;			/* -S flag */
 int     mapped_writes = 1;              /* -W flag disables */
 int     fallocate_calls = 1;            /* -F flag disables */
+int     allocsp_calls = 1;		/* -F flag disables */
 int     keep_size_calls = 1;            /* -K flag disables */
 int     punch_hole_calls = 1;           /* -H flag disables */
 int     zero_range_calls = 1;           /* -z flag disables */
@@ -268,6 +270,7 @@ static const char *op_names[] = {
 	[OP_DEDUPE_RANGE] = "dedupe_range",
 	[OP_COPY_RANGE] = "copy_range",
 	[OP_FSYNC] = "fsync",
+	[OP_ALLOCSP] = "allocsp",
 };
 
 static const char *op_name(int operation)
@@ -410,6 +413,15 @@ logdump(void)
 			if (overlap)
 				prt("\t******WWWW");
 			break;
+		case OP_ALLOCSP:
+			down = lp->args[1] < lp->args[2];
+			prt("ALLOCSP  %s\tfrom 0x%x to 0x%x",
+			    down ? "DOWN" : "UP", lp->args[2], lp->args[1]);
+			overlap = badoff >= lp->args[1 + !down] &&
+				  badoff < lp->args[1 + !!down];
+			if (overlap)
+				prt("\t******NNNN");
+			break;
 		case OP_FALLOCATE:
 			/* 0: offset 1: length 2: where alloced */
 			prt("FALLOC   0x%x thru 0x%x\t(0x%x bytes) ",
@@ -1695,6 +1707,51 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 }
 #endif
 
+#ifdef XFS_IOC_ALLOCSP
+/* allocsp is an old Irix ioctl that either truncates or does extending preallocaiton */
+void
+do_allocsp(unsigned new_size)
+{
+	struct xfs_flock64	fl;
+
+	if (new_size > biggest) {
+		biggest = new_size;
+		if (!quiet && testcalls > simulatedopcount)
+			prt("allocsping to largest ever: 0x%x\n", new_size);
+	}
+
+	log4(OP_ALLOCSP, 0, new_size, FL_NONE);
+
+	if (new_size > file_size)
+		memset(good_buf + file_size, '\0', new_size - file_size);
+	file_size = new_size;
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		      new_size <= monitorend)))
+		prt("%lld allocsp\tat 0x%x\n", testcalls, new_size);
+
+	fl.l_whence = SEEK_SET;
+	fl.l_start = new_size;
+	fl.l_len = 0;
+
+	if (ioctl(fd, XFS_IOC_ALLOCSP, &fl) == -1) {
+	        prt("allocsp: 0x%x\n", new_size);
+		prterr("do_allocsp: allocsp");
+		report_failure(161);
+	}
+}
+#else
+void
+do_allocsp(unsigned new_isize)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -2040,6 +2097,8 @@ test(void)
 		if (fallocate_calls && size && keep_size_calls)
 			keep_size = random() % 2;
 		break;
+	case OP_ALLOCSP:
+		break;
 	case OP_ZERO_RANGE:
 		if (zero_range_calls && size && keep_size_calls)
 			keep_size = random() % 2;
@@ -2066,6 +2125,12 @@ test(void)
 		if (!mapped_writes)
 			op = OP_WRITE;
 		break;
+	case OP_ALLOCSP:
+		if (!allocsp_calls) {
+			log4(OP_FALLOCATE, 0, size, FL_SKIPPED);
+			goto out;
+		}
+		break;
 	case OP_FALLOCATE:
 		if (!fallocate_calls) {
 			log4(OP_FALLOCATE, offset, size, FL_SKIPPED);
@@ -2141,6 +2206,10 @@ test(void)
 		dotruncate(size);
 		break;
 
+	case OP_ALLOCSP:
+		do_allocsp(size);
+		break;
+
 	case OP_FALLOCATE:
 		TRIM_OFF_LEN(offset, size, maxfilelen);
 		do_preallocate(offset, size, keep_size);
@@ -2270,8 +2339,8 @@ usage(void)
 "	-U: Use the IO_URING system calls, -U excludes -A\n"
  #endif
 "	-D startingop: debug output starting at specified operation\n"
-#ifdef HAVE_LINUX_FALLOC_H
-"	-F: Do not use fallocate (preallocation) calls\n"
+#if defined(HAVE_LINUX_FALLOC_H) || defined(XFS_IOC_ALLOCSP)
+"	-F: Do not use fallocate (preallocation) or XFS_IOC_ALLOCSP calls\n"
 #endif
 #ifdef FALLOC_FL_PUNCH_HOLE
 "	-H: Do not use punch hole calls\n"
@@ -2587,6 +2656,41 @@ __test_fallocate(int mode, const char *mode_str)
 #endif
 }
 
+int
+test_allocsp()
+{
+#ifdef XFS_IOC_ALLOCSP
+	struct xfs_flock64	fl;
+	int			ret = 0;
+
+	if (lite)
+		return 0;
+
+	fl.l_whence = SEEK_SET;
+	fl.l_start = 1;
+	fl.l_len = 0;
+
+	ret = ioctl(fd, XFS_IOC_ALLOCSP, &fl);
+	if (ret == -1 && (errno == ENOTTY || errno == EOPNOTSUPP)) {
+		if (!quiet)
+			fprintf(stderr,
+				"main: filesystem does not support "
+				"XFS_IOC_ALLOCSP, disabling!\n");
+		return 0;
+	}
+
+	ret = ftruncate(fd, file_size);
+	if (ret) {
+		warn("main: ftruncate");
+		exit(132);
+	}
+
+	return 1;
+#else
+	return 0;
+#endif
+}
+
 static struct option longopts[] = {
 	{"replay-ops", required_argument, 0, 256},
 	{"record-ops", optional_argument, 0, 255},
@@ -2972,6 +3076,8 @@ main(int argc, char **argv)
 
 	if (fallocate_calls)
 		fallocate_calls = test_fallocate(0);
+	if (allocsp_calls)
+		allocsp_calls = test_allocsp(0);
 	if (keep_size_calls)
 		keep_size_calls = test_fallocate(FALLOC_FL_KEEP_SIZE);
 	if (punch_hole_calls)

