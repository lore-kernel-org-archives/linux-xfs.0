Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698EB274672
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556802; cv=none; b=VG2OT+7fnQLmxOZ/rRIKvvGCPryk9UXQE9VmeNIbb4xGSz0VPIDPV88oBVGYhd8tcn2NxvQ2va2KgymQkIprsnhUCxducLUHKw2ZztXr+b11uzwYG73Na4Q3XJp8SnpM9WDZCqzbC53mdd7IyvKCAiSvvUxYYrvooIpyiqHXlaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556802; c=relaxed/simple;
	bh=HvCIgPWzyzhAE/2tcGeoGU6dnEKRsuphksCrN+bzjtc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JesVU6kmccdOO+eMkozc7z4QEXL0unIYApsKbJ3LOEPJStqvGmZQE8cT19apDJa3uezwZNFJmfP4ntKZjBR2Z6OURr1PnFIEy1sVphJrDbe2D5rdZQSJeFoSE0r/ZDS2WkaaAigFAUNTNo4QmmLEmf2kVMHsa10bczM5bLni1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpDk0na7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpDk0na7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4359AC4CEE3;
	Tue, 15 Jul 2025 05:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556802;
	bh=HvCIgPWzyzhAE/2tcGeoGU6dnEKRsuphksCrN+bzjtc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IpDk0na7jwVw/8ue3Vcw4lK/BZ1Dubx6zfCZtZqeS5VyiQJwmmUm9wR1jhz8whtwR
	 OPDwaQDjxi5AOI7TCZJ5WOzwpCNEeoLOb7vq5NpR7qaiC+psL/Vu038VaKEirT3BYi
	 idS3ogvc/ijSodaXjhjJXOuURSMzedMfdv8K50R/zA6/LlaqY9VJ5hrOSjL+9y/uqm
	 IuNy2Qy8ZaJC9n6oAd5NEkf/hCVCEoI4UY4S5gkj8RW4IwOTgZQvb3cygvs0UCGrOA
	 CVMGtMJYqrw0m2ND44Ra2RxVAnqN/5NAZ2Zl1JYMNPxh3f5E2uGdCS8b6XY+XukDGz
	 W06z3i9QU34Xg==
Date: Mon, 14 Jul 2025 22:20:01 -0700
Subject: [PATCH 1/1] xfs_scrub: remove EXPERIMENTAL warnings
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175255652766.1831318.18374702848127713840.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652747.1831318.4673191938278804524.stgit@frogsfrogsfrogs>
References: <175255652747.1831318.4673191938278804524.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

