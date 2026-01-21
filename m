Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECC1407560;
	Wed, 21 Jan 2026 06:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977655; cv=none; b=gYTLSW3/se3ApZ0MKQyPg4hgTIIIHYdGpg7ZX4Jr06y+GpXLMMjvftCepneMOwHIrJn8guz8PPg22UBdunG23BY5G0qaqpDygVtuaas7VeYHMeNoOcsghvfQdrQ+2eVYL/Q/0WB2YzHI6O7yCxIFdF4TTgag687/nZ7ec91uAzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977655; c=relaxed/simple;
	bh=yFkUkGg491UWGrRY4Wb7QJvThY2Jll/D1DzMFSm+lWA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVPucGIcNz6+XDughljFQ9LhrvXb+01MBEhyrhZz5ylpwsMsoVX28O9btSCH90Rfr0bPV7pSjM+18rwLpdbJPZ30tlio45bYEbWNUf5851N7QKFVK0MdWH9aWdhJ1vTMDrCXI/8yA0lFvCS7FAS4UBnU3Q85qO+rsPuy2FdgbI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6WBTMZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6WBTMZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B3BC116D0;
	Wed, 21 Jan 2026 06:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977655;
	bh=yFkUkGg491UWGrRY4Wb7QJvThY2Jll/D1DzMFSm+lWA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W6WBTMZxcjWw4pnmm/xagYFOZ/RKIx4C47XsccyaYuJsxCGTSpvP+Q10hqDRan9BH
	 CF9zA6ezV8k/yJ+oLouxfX8isN3yzevROIbnwyN5AWXZZquoBA/yTisP9ZQiJ8yN7E
	 3oZEUSoi2o1c6IVzt3i4b7rw4jlQosjiLh/p8fpa3ojt7eAfhaJ5QNET+UTF2tm1Ju
	 zno8jywo9U81IaptYo40J6Jii4jP8ARNCRoLtNAyviZXD5d6TOb0zzOpH1PeCPDPSM
	 lkUBRNFvU+PxQHuj25/4HMwUTHK6wtIPDkL4Xje6pxpg3idRSt7iNCToi7U3GbU2ZB
	 9LpivYQ2nRX3A==
Date: Tue, 20 Jan 2026 22:40:54 -0800
Subject: [PATCH 3/4] xfs: check return value of xchk_scrub_create_subord
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: r772577952@gmail.com, stable@vger.kernel.org, r772577952@gmail.com,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176897723608.207608.5078916310150765504.stgit@frogsfrogsfrogs>
In-Reply-To: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this function to return NULL instead of a mangled ENOMEM, then fix
the callers to actually check for a null pointer and return ENOMEM.
Most of the corrections here are for code merged between 6.2 and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: 1a5f6e08d4e379 ("xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    3 +++
 fs/xfs/scrub/repair.c |    3 +++
 fs/xfs/scrub/scrub.c  |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7bfa37c99480f0..257aefd33d04ff 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1395,6 +1395,9 @@ xchk_metadata_inode_subtype(
 	int			error;
 
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	xchk_scrub_free_subord(sub);
 	return error;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index efd5a7ccdf624a..4d45d39e67f11e 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1136,6 +1136,9 @@ xrep_metadata_inode_subtype(
 	 * setup/teardown routines.
 	 */
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	if (error)
 		goto out;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3c3b0d25006ff4..c312f0a672e65f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -634,7 +634,7 @@ xchk_scrub_create_subord(
 
 	sub = kzalloc(sizeof(*sub), XCHK_GFP_FLAGS);
 	if (!sub)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	sub->old_smtype = sc->sm->sm_type;
 	sub->old_smflags = sc->sm->sm_flags;

