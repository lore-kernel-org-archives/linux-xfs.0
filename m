Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E3B2D8385;
	Fri, 25 Sep 2026 04:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309588; cv=none; b=OvxS3o1WzjWxsXXw78Calby6Ns4GIWddpdRmPKbgPy1eg7N+GWxn4zVs+aHx3I3ucaULNOXeBGp+JGSZZh9M9opknyboNs4JzL0R6uQtOWwWJ08qhytEVAGOraLFzkqEaYa6KVj3X93Ybx+/sK35Aa4Vu5+CUKK199MnnMtID80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309588; c=relaxed/simple;
	bh=B8TgmeQr/27UK5TazgtgMS7stMt327Ap83i77sjW2Vk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSUEfjFRkEo55xmm2LiMctZGoRSXIUkbkY09dYCEgSlecjkJ3khSKHiSGA0pV0P5YffIqlOM1ZdCt8fXt0WW/c1IAuiFk8t7XhfP2G3hJPAjtITku9pnZG4TRC9TCn7d4TwsF2482TlrmKnDtVSfp483vR36KNhczE6FQfWID7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZxxl1I8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZxxl1I8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5BE9D1F000FF;
	Fri, 25 Sep 2026 04:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309587;
	bh=Q1vbrRXXHcC+gOJfac+DZt0CK4AQKh4AVeDwKjQpVW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jZxxl1I8h5aCXjhA1WLrKGlL1mYSwNvQuPTS9bUCP9YmphAcM6Q756s3JyotPBXMv
	 bbZpImTZN2t4+wPoGwhBMtz4m+uSlHfqJSDaq2ayiA23evW6NTxIbJGtewvRGM8v6A
	 xu03XNCtj595D+tLNgEcvYTZyQCL0DsJ+Th0SvxXa3vh4sPu0ONdzFStRFScEZ/GJD
	 lztKrZmC6DgvWekrqXL3lhTqycVCrs8k/c+KHcaA0gZjRXBPrSs4pQElpVyd+hcaBL
	 wrkG5TQBO0yCEGgfWRdEoQXTe1SY4ZxfkLs7VcLwna330SpraB9dnCU59NH3dl2Pln
	 RWOA8J84aIemQ==
Date: Thu, 24 Sep 2026 21:13:06 -0700
Subject: [PATCH 10/12] xfs: jump out of xchk_bmap_check_rmap if fatal signals
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932261.3344850.16757175231565950517.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we never check for fatal signals inside the loop
that checks file fork mappings against the rmapbt.  This can lead to
lengthy delays in responding to a ^C, so add some bailout checks.

Cc: <stable@vger.kernel.org> # v4.17
Fixes: 5e777b62b0bcb6 ("xfs: bmap scrubber should do rmap xref with bmap for sparse files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/bmap.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 4f3c7f681bd921..428be9ecdcd4d4 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -626,6 +626,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != I_INO(sc->ip))
@@ -657,6 +661,9 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);

