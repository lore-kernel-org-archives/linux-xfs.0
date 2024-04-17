Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F66171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390066; cv=none; b=VQWBAvWGPmlC2ojDSe5cSjVT5jN23/1ycw4kBjODcsHEoMylfBfbMxgq/I+3g+f4b2wA5ctQnUC1f+FFBsmo1Ls8ufMWYuC+jkWAksFNrlHipgUuPDRrlqY1/VFsH1HDZ4T5ltTt0PUBxaS6+3Ij5YooTaxROZM0CS6DNn0NmjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390066; c=relaxed/simple;
	bh=N0pRjMUyIA/8gxE9ykqJDfyfZTz8akEPJ2W1Ve6awDo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=psyzKSkMNSTh6lhOBc6u5ULUY9ksy1GGF2A5i0aQEvPAPd5ZkgkGJkaVpBWOD7FN/oM2DASuZvzmiElezRuIibdQp5lUvdQ6kNy12P24AI0U7PAfM9Ifg0aF2OKl0/FJTvrMmy3TTLhbtojpvbQx4BBJCqOd2M3gQG+Dz5R/p3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmeY5aII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmeY5aII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8D5C072AA;
	Wed, 17 Apr 2024 21:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390065;
	bh=N0pRjMUyIA/8gxE9ykqJDfyfZTz8akEPJ2W1Ve6awDo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JmeY5aIIOhUZ4nSj/vglOfI9n+gzfKAAlIB5oOs8LU1no4Zi1nJlHZK7G8dTvdIji
	 n3j6VdCoYh3XtoNlNmyrmepAJ1Yij1lGrdBRvIHiQCrm4IjX7ZVjB31ECMb7Z1nenK
	 ghxiPghGf1AO1+KoSbufjQwreikqdz4oPj7+OFeROXQOD77Q9Zz1gBHmpBd3WMsLHN
	 2EMdE812/qalw3xfe954DifCxzKQQeFEzz58CrIi4lEyLvxBDUmIzwuD4MELHOrkM1
	 5vrYz52pRZnFXl7wBAxPRbE+sRmoCUdL+SXBmXDo7YFUEyiy8P3B1xPqqm6FSwcn7G
	 KpfFxMqELQTSA==
Date: Wed, 17 Apr 2024 14:41:05 -0700
Subject: [PATCH 5/5] xfs_io: add linux madvise advice codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338844053.1855783.9752629961635955337.stgit@frogsfrogsfrogs>
In-Reply-To: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
References: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/madvise.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)


diff --git a/io/madvise.c b/io/madvise.c
index 6e9c5b121..ede233955 100644
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

