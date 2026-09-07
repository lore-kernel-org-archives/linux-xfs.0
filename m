Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A05353A98;
	Mon,  7 Sep 2026 06:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762624; cv=none; b=hNtkCdTLX+Ii8R35yRCPmuLfadF8wouCq8hsg1BvIxB8Ri8kOXJRmEevrT/l+xDfc1abdk+qpAfgQFX92SwO8gxJKDBxnO9+E9JSbGO1sOX26T++UijXgBmFacJM71ls2kW8MHB0bM4+bHO5JMocK2r4bUWDckTUu8KzKj/Vrmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762624; c=relaxed/simple;
	bh=5Uu0PkU5kORhI54uU1+CWEd53uDS8YlCHr0bVejYxds=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ft37V70j+c0aKm04zZ+qoatIP3Bv7PTsG6sTTv6IuDCW0wYZMxrGrz2gEPH1oRN9EsH+qKnoWwIartgkir5iKte6oyMUhoeLqX6mjvRVUrmfRHjreodzThpHLAk55Gw4sGQszwlmzACwalBjCphteGPv+MAyZ4ibPL0W+zpqq6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0IMBx35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0IMBx35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03B31F00A3A;
	Mon,  7 Sep 2026 06:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762620;
	bh=75bRVupXM9z31/O5lSjqt5mAvB0xPwrehRbFIvRTE/w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=o0IMBx35YLk2B8kR1lqDv9cfntOtKvnjv+ZQ2569vFbZmAMOi3elCSbT4B6ChC2Qz
	 HxXgiCAuXfwexGP0XCY6X/23BOQPJYDLPCcvWYnkPj+I2FWGh8ybFDLEuqtPpyhIOS
	 XPnqcji+f/09c4asIm3DKAuTt8KscWp2eU8H8IHjUoxP9EjrSnc8LAM/ZTfxII+42F
	 /FHZQ5oqxK4GTddgh/M2uZ3BUxlxiPIpzx2ym2s260K0AiHjepjvJO0XVjmGPzCpqr
	 urdNg6vFYA7OikHtAGAe2n2mE4ts1kwRCMOMeXzdvoWdq2IreLNaytlYh1BIpt23yw
	 pX9OuqwyvYs0A==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v2 2/5] xfs: LLM-inspired bug fixes, part 6
Message-Id: <178876261936.15110.5700286241535016670.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:30:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 01 Sep 2026 22:41:37 -0700, Darrick J. Wong wrote:
> Here's a sixth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> v2: add RVBs, address some review comments
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
      commit: 022d5f5fce7f0b6125d404eb74044e6238aef369
[2/6] xfs: preserve owner on in-memory btree creation
      commit: 5287e56cba3be4a64bff9f73bce5964fda2590dc
[3/6] xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
      commit: f1930bc578095409c2dcfca6e4e898b24f0f0de6
[4/6] xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent
      commit: b71ae66863e4320a3b7313b53bb4d65f1718d58b
[5/6] xfs: don't modify file attributes or poke fsnotify for dry runs
      commit: 365fe37e10ea75840165f13322aa8481ea11dfef
[6/6] xfs: fix bnobt repair space reservation disposal failure
      commit: c83d1ef97ee3b0b92797d4b4932a3a813ba05b86

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

