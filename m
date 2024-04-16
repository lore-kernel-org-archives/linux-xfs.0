Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FBE185E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229193; cv=none; b=H83Lh/cOie+ZIQ5GmedOyRPM6/et1NgCWQSDlf1wQvVu1j7GqyKP6c2SEO4r8TfDnOuxgzdPCSUoNpBFlqaeUKKfaPrAI8znVfrRitHY19+V38sZB7laGWsPPCUxgey8vohvFz6wrcat9X79jGJ+Mg6R/k+s44BDHsseQrpxx3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229193; c=relaxed/simple;
	bh=ULRUhFiuY27iWFwpZ19CynW7sUZgqRX1GO+VxKW0IjA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcM0X/FWWNLEILRNPOwBXEPFJpoE65s2HbAovcGcpZEjKxCvAcNyJw9/3Uk9Cy7MEJBlY7DQZXSkl96+dXO/G5OzdOCaLqWZjdJ1kZ1fVXWRlnYoEyr6bo1MxKgmQNfhVEb1XUcofLMZGsXNoACra3psdeEAPRMyZg/VwtJf/2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Of6NRs3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Of6NRs3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4133C2BD11;
	Tue, 16 Apr 2024 00:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229192;
	bh=ULRUhFiuY27iWFwpZ19CynW7sUZgqRX1GO+VxKW0IjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Of6NRs3pmTrmlv8igSczPHKmpZFZ7cZCGENTHoEaxPfR0NdghFQTk1F5uNR9O5zC/
	 /kW47xsykbqz0BRhZprs0XDTfTVHPQBLa/PO90p5YaLJM//ewbHxrqDXE+NSMV58Yj
	 tusvdeIRiZDy661wHe5KNAeA16IaC57WRcLfHT8LqqFoJYEzoqA0o0BRqu6HURNbVD
	 3z+W0S6LOzhVFkprYu7ryoQlSgWArLcDuH0BvT6TK+Bv+BWIMVIdJmyVjQd/wzNVKV
	 X4objTr3JPav9P0KrInB86TC9JJXDM9iF++h0cnVLXNNJHF6v7u7SNdS9cJ8DqHYAt
	 RA5D57emMkgbw==
Date: Mon, 15 Apr 2024 17:59:52 -0700
Subject: [PATCH 5/5] xfs_io: add linux madvise advice codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, cmaiolino@redhat.com,
 linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322881873.210882.13529720668713675414.stgit@frogsfrogsfrogs>
In-Reply-To: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
References: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
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

