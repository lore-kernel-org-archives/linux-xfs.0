Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B6F1B95B
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393343; cv=none; b=m/HwDQnhWVpGcE45+637CATp1LhsNi2zGMobcnAQRcHUR4ZR6B7sYbNN6+IzP7idNazrqBMfvTWCMydlVXQcS57fbHblbYn0QNeMOsyEU3UkxJhEhmK2b/3Ar4m41Zk82VpjFvDILsx4BDTB1ADnLKpxqq72AJtgPLUT7AYRQJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393343; c=relaxed/simple;
	bh=l7H1/4Ps/6NBgzktXcDeyCFsfIKOJst0T9kjlFw99Ws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+/bI2BI2uv4T/k12RhFwus3YywWOamQSTrlETgeHCW2pJW+pJxGwBSJOIx+TKUI5k15Vq4v4rI+b3fiFScocnVajI1Ti8D9brDfm1ykshPQcsqbaz2fsWGaIUWup/R3mqjf7xD98U5X++WErwYJfW3cMWnOs7PiFOoSpyC6RUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtTjaSiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtTjaSiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB52C4CEEB;
	Tue,  1 Jul 2025 18:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393342;
	bh=l7H1/4Ps/6NBgzktXcDeyCFsfIKOJst0T9kjlFw99Ws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FtTjaSiNH/HQrU05oJKHZR1XScLJLT8oJLzdxtnzGjgeTI7SUL9oPBPvcVP73U1j2
	 j2VPbPTqI6e3+qq4ClKMwaOriXnR8RgjniAyG4GGJSgtWvUm0lbBOC/MhJqYrY7oAH
	 PgsaCNZj9wPDPeam7vCoiP0w+S5W5lu+1swfhHH7a01qIAKSmyAr14hQTCTBdVndzh
	 IqIhyTyHuYgzotAu3zDnUr+9cr8EEIEimZMaeRFIID4Q5SGP31s2eLCdxUSAXNojqP
	 GgnQHtRObRVgo28bbWojvA3nCXhjwX70vE/zmMkYNSnOrjzlt6Puce7KVk4bEsd7+m
	 GWpWHQeQVwCig==
Date: Tue, 01 Jul 2025 11:09:02 -0700
Subject: [PATCH 1/1] xfs_scrub: remove EXPERIMENTAL warnings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <175139304146.916487.764787367428200733.stgit@frogsfrogsfrogs>
In-Reply-To: <175139304129.916487.5190678533940893960.stgit@frogsfrogsfrogs>
References: <175139304129.916487.5190678533940893960.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The kernel code for online fsck has been stable for a year, and there
haven't been any major changes to the program in quite some time, so
let's drop the experimental warnings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_scrub.8 |    6 ------
 scrub/xfs_scrub.c    |    3 ---
 2 files changed, 9 deletions(-)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 1ed4b176b6a35a..8b2a990831a2cc 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -13,12 +13,6 @@ .SH DESCRIPTION
 .B xfs_scrub
 attempts to check and repair all metadata in a mounted XFS filesystem.
 .PP
-.B WARNING!
-This program is
-.BR EXPERIMENTAL ","
-which means that its behavior and interface
-could change at any time!
-.PP
 .B xfs_scrub
 asks the kernel to scrub all metadata objects in the filesystem.
 Metadata records are scanned for obviously bad values and then
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 90897cc26cd71d..3dba972a7e8d2a 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -730,9 +730,6 @@ main(
 	hist_init(&ctx.datadev_hist);
 	hist_init(&ctx.rtdev_hist);
 
-	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
-	fflush(stdout);
-
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);

