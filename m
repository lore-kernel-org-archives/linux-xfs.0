Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2869D1862C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797468; cv=none; b=AuRuLOeydljEjzyry1Nungd3xK75qC2ITJahm79pXKPy98ktTaQdher8ok2r3NeMp5KjLtTPU26Mnur/9kIQv4gvXAcqMx1w4R3VfH735j50zGpOBaQ9x6CsvQkywJ8ZwdqnBDI2YD/kvsFv0MJTZJeQH16rr+SkYGASEsOO/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797468; c=relaxed/simple;
	bh=jcueFUfpffxGdQDgwub3MPg2R+UGsMQrWb8YGrpFgJE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kPja2CuRTr6teswd7EkD58TzijbiVAvAQGd7mjRFduSRr43U/yddOYyER6QVG3UDJ8pY92mzZZy2MHOck0UlCUBoGYAqylJpKkyaTD+hhL6uP9N2b2X/kxNeZkdOyA4Gbo8QNdIA06egKEQKW4rLyJjRquYzZlcQla+Vu/ad8us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0eNYDez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0eNYDez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2811C433F1;
	Mon, 18 Mar 2024 21:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710797467;
	bh=jcueFUfpffxGdQDgwub3MPg2R+UGsMQrWb8YGrpFgJE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g0eNYDezR2PRhsHX1AuXOYIV10b9xwCYfCSCGp1FSC1Pksld08+28hJ8nVh0hDETW
	 34u/Z2xapXOC43SWtQbtbQngvX1xiJlExi2aOQPFVmpv2b1a6BI6E6baBez2X+B6Br
	 pPM7/I8Go7lwvRTtYFNtmH0awuH6FOUjYZ7tzgNkdH72bnDrN6phdgPaQs8EEgkqte
	 /kiHhniiPmC82xWCmI8wCIQwP9ER9/WgqNT15lmYLE3OrEZmoFjezeKJszdGllL+uv
	 lRzRqpSYF8XT5NpzWeb78Wsent8ln52m2+JAAFEqMiwxszK+rUDIVSHOJVDT5j1W2V
	 eyDG1wlfzbZ+A==
Date: Mon, 18 Mar 2024 14:31:07 -0700
Subject: [PATCH 4/4] xfs_io: add linux madvise advice codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171079733032.3790235.1241181436907477385.stgit@frogsfrogsfrogs>
In-Reply-To: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
References: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
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

