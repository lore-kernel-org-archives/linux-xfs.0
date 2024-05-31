Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291C2EAE7
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 20:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186343; cv=none; b=Dl5vD9Oz4hxMUIa+XD4Dw7xa2ketmVFhLyX0ANUHhe1y3CyqSXoR7yCwTOPBWPL4YYcmYCWDsGFPchq5yFGbRgly9OaDmP2VJTQDAd6lXKwLF21Adf6jSf4yPxauXdqugX/vflnkEkR2XsBGZSEN1R3KmnkOoGB4FDw44KIqcaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186343; c=relaxed/simple;
	bh=/knBw9H3uc3B/e4jwbgLbaBhOoVi80G4Za91a+o4tHE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=f1rbODBcHRz0g5miD2DiNH6nKQYp8zwECbZgTDbHtjaGr/6s/dQDbvdRMSG7GKzllMkwqGobFOBsPG2Ssoz0q5exdrEBYcP/X31ScJOgjvjC1gxA8fYzodoQ8DQpuZ4uId34rFpm9DkmbLpc6oZkXltdxEX9wrzyKfLT0myx218=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lsbjd8yv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lsbjd8yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ACEC116B1;
	Fri, 31 May 2024 20:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717186342;
	bh=/knBw9H3uc3B/e4jwbgLbaBhOoVi80G4Za91a+o4tHE=;
	h=Date:From:To:Cc:Subject:From;
	b=Lsbjd8yvPxbjri0p5sxndJprusWljjAk3hOvrZZW2WJnsDTKqdlNAXOMQK4Xyw+sP
	 XFSL5SPem+1POK8sVTiQ9nJwCTZGz+V9G9oqaf8Sq43EVw/rr69yiEM02Zv7fWMutA
	 mTgRuKKC+nFx7V1aSIHH2UbgA5ZyDuQrB6ETyE9ppLPhHemjHapG64FtXycDUpwvw/
	 GnBQX8Ez29/2NU30+rTwOcuse2omP6V9cMb15SxRhYSRWcMSeG+rDmjH6btaOe+cFe
	 IfAtQrSHGtlL31S6/s4sGso6h8E+Te+XnBbmAghHKhjSvzyDj/+6e5wv2PouYu1sx5
	 D1GOm7eTYeIJw==
Date: Fri, 31 May 2024 13:12:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_io: fix gcc complaints about potentially uninitialized
 variables
Message-ID: <20240531201222.GS52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

When I turned on UBSAN on the userspace build with gcc 12.2, I get this:

bulkstat.c: In function ‘bulkstat_single_f’:
bulkstat.c:316:24: error: ‘ino’ may be used uninitialized [-Werror=maybe-uninitialized]
  316 |                 ret = -xfrog_bulkstat_single(&xfd, ino, flags, &bulkstat);
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bulkstat.c:293:41: note: ‘ino’ was declared here
  293 |                 uint64_t                ino;
      |                                         ^~~

I /think/ this is a failure of the gcc static checker to notice that sm
will always be set to the last element of the tags[] array if it didn't
set ino, but this code could be more explicit about deciding to
fallback to strtoul.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/bulkstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/bulkstat.c b/io/bulkstat.c
index 829f6a025153..f312c6d55f47 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -301,7 +301,7 @@ bulkstat_single_f(
 
 	for (i = optind; i < argc; i++) {
 		struct single_map	*sm = tags;
-		uint64_t		ino;
+		uint64_t		ino = NULLFSINO;
 		unsigned int		flags = 0;
 
 		/* Try to look up our tag... */
@@ -314,7 +314,7 @@ bulkstat_single_f(
 		}
 
 		/* ...or else it's an inode number. */
-		if (sm->tag == NULL) {
+		if (ino == NULLFSINO) {
 			errno = 0;
 			ino = strtoull(argv[i], NULL, 10);
 			if (errno) {
