Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA41A12AAD2
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423329; cv=none; b=THc3JKiU8zwQbanQUVsjKMN6/idY9paSOzqCXtrIP+Ls6VpUBsYYYsEBo6ku/iYQ6ky3T1hRzpSwBFqh/NLAnqUzvJUIfAnclSf62isbtcej7FWMkGILdbJqE+X5sxL6/ct5a4dH7t7sqgzHJ+vSfTYa5yyljpaU4LtOha5R2xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423329; c=relaxed/simple;
	bh=jcueFUfpffxGdQDgwub3MPg2R+UGsMQrWb8YGrpFgJE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nk+7VrQF+g/9BiO0lTbU/yH6r85JjgexQaG3yKBJIvKqUevJvGYCknwYcS05XXHYV6xVFBxf0hoKi/LHnnmpG6qgabEDgImR43eG5yt+wmtWNCr1iUtpjRyufPTj8PRd9oASfuN5Sf+bChECVJO5Z59hS67wHi9T3sq+8xghXiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQXTVr05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQXTVr05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426F4C433F1;
	Tue, 26 Mar 2024 03:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423329;
	bh=jcueFUfpffxGdQDgwub3MPg2R+UGsMQrWb8YGrpFgJE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UQXTVr054FsILp8f0OBKogGBlUJB4NQj9YeCD27A3+RVQ1wkNlpgUqoSO00iyeU6+
	 mbXuLCv3we5X0RFfSwOL21OQY6Ov2AJihLGFtwOIPDJZXmTyzl9Xv++nU3k2H8L+GU
	 tq+PtgTQte4KYPNCtklc+mEn7cyomc1bm1UVU+9llCny2fnghm8SnvjpZWnkLUVm/6
	 1D39GseBMW5eArufSWNulb8H2I5rCs3hXitmMz1Xh3UV1ZSfAgJNxzyCtkta3b/e+/
	 n/W5H16QgTO0DrHGDN8OEwK83NCc24rUhytsTvfHEIPUM0FpRfTOkQ2YnEBG+Q9+pu
	 0RxMFpTdwD2FA==
Date: Mon, 25 Mar 2024 20:22:08 -0700
Subject: [PATCH 5/5] xfs_io: add linux madvise advice codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142128632.2214086.17684623757351495391.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add all the Linux-specific madvise codes.  We're going to need
MADV_POPULATE_READ for a regression test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/madvise.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)


diff --git a/io/madvise.c b/io/madvise.c
index 6e9c5b121d72..ede233955ced 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -9,6 +9,7 @@
 #include <sys/mman.h>
 #include "init.h"
 #include "io.h"
+#include <asm/mman.h>
 
 static cmdinfo_t madvise_cmd;
 
@@ -26,6 +27,31 @@ madvise_help(void)
 " -r -- expect random page references (POSIX_MADV_RANDOM)\n"
 " -s -- expect sequential page references (POSIX_MADV_SEQUENTIAL)\n"
 " -w -- will need these pages (POSIX_MADV_WILLNEED) [*]\n"
+"\n"
+"The following Linux-specific advise values are available:\n"
+#ifdef MADV_COLLAPSE
+" -c -- try to collapse range into transparent hugepages (MADV_COLLAPSE)\n"
+#endif
+#ifdef MADV_COLD
+" -D -- deactivate the range (MADV_COLD)\n"
+#endif
+" -f -- free the range (MADV_FREE)\n"
+" -h -- disable transparent hugepages (MADV_NOHUGEPAGE)\n"
+" -H -- enable transparent hugepages (MADV_HUGEPAGE)\n"
+" -m -- mark the range mergeable (MADV_MERGEABLE)\n"
+" -M -- mark the range unmergeable (MADV_UNMERGEABLE)\n"
+" -o -- mark the range offline (MADV_SOFT_OFFLINE)\n"
+" -p -- punch a hole in the file (MADV_REMOVE)\n"
+" -P -- poison the page cache (MADV_HWPOISON)\n"
+#ifdef MADV_POPULATE_READ
+" -R -- prefault in the range for read (MADV_POPULATE_READ)\n"
+#endif
+#ifdef MADV_POPULATE_WRITE
+" -W -- prefault in the range for write (MADV_POPULATE_WRITE)\n"
+#endif
+#ifdef MADV_PAGEOUT
+" -X -- reclaim the range (MADV_PAGEOUT)\n"
+#endif
 " Notes:\n"
 "   NORMAL sets the default readahead setting on the file.\n"
 "   RANDOM sets the readahead setting on the file to zero.\n"
@@ -45,20 +71,69 @@ madvise_f(
 	int		advise = MADV_NORMAL, c;
 	size_t		blocksize, sectsize;
 
-	while ((c = getopt(argc, argv, "drsw")) != EOF) {
+	while ((c = getopt(argc, argv, "cdDfhHmMopPrRswWX")) != EOF) {
 		switch (c) {
+#ifdef MADV_COLLAPSE
+		case 'c':	/* collapse to thp */
+			advise = MADV_COLLAPSE;
+			break;
+#endif
 		case 'd':	/* Don't need these pages */
 			advise = MADV_DONTNEED;
 			break;
+#ifdef MADV_COLD
+		case 'D':	/* make more likely to be reclaimed */
+			advise = MADV_COLD;
+			break;
+#endif
+		case 'f':	/* page range out of memory */
+			advise = MADV_FREE;
+			break;
+		case 'h':	/* enable thp memory */
+			advise = MADV_HUGEPAGE;
+			break;
+		case 'H':	/* disable thp memory */
+			advise = MADV_NOHUGEPAGE;
+			break;
+		case 'm':	/* enable merging */
+			advise = MADV_MERGEABLE;
+			break;
+		case 'M':	/* disable merging */
+			advise = MADV_UNMERGEABLE;
+			break;
+		case 'o':	/* offline */
+			advise = MADV_SOFT_OFFLINE;
+			break;
+		case 'p':	/* punch hole */
+			advise = MADV_REMOVE;
+			break;
+		case 'P':	/* poison */
+			advise = MADV_HWPOISON;
+			break;
 		case 'r':	/* Expect random page references */
 			advise = MADV_RANDOM;
 			break;
+#ifdef MADV_POPULATE_READ
+		case 'R':	/* fault in pages for read */
+			advise = MADV_POPULATE_READ;
+			break;
+#endif
 		case 's':	/* Expect sequential page references */
 			advise = MADV_SEQUENTIAL;
 			break;
 		case 'w':	/* Will need these pages */
 			advise = MADV_WILLNEED;
 			break;
+#ifdef MADV_POPULATE_WRITE
+		case 'W':	/* fault in pages for write */
+			advise = MADV_POPULATE_WRITE;
+			break;
+#endif
+#ifdef MADV_PAGEOUT
+		case 'X':	/* reclaim memory */
+			advise = MADV_PAGEOUT;
+			break;
+#endif
 		default:
 			exitcode = 1;
 			return command_usage(&madvise_cmd);

