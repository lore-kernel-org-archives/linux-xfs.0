Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1165247ECDE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780581585; cv=none; b=dUqXOrIdC61NZDH5C/ExWJJbPCkLlIAKP+PMYed9fMm5OW8qoh8nfRPFuV9NfNHwa+deTLUhj1ds/Y8T4SujLOoEK+/Pt5xOae7ym5ZRw6SkzsQdElgb6nARs8+ewT/mmyKz+s6TobWlaH4QIgtLRTVSOtnG4PxXBf+Fa8AoSVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780581585; c=relaxed/simple;
	bh=epcMrEmMjekHrP5wj/Qw9Pga2T0TC0tRnQUvsi3O/X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZ7Sm7ZV455rd6cZIbnXE8UiCFnImQljbkuAKeig0jLyOoIfNU2w1CLDcjcxSWbY6FMC5GS2a/FHmDDxmKx9SDJsaHgqOegeKdXOMbIZpFeOWd72HWS2KM+wfz6Hgc5uncEE/EKEGtrQBo1WgmcFQv//zVp7CD4XBffVDK82eU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=is3ee5St; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="is3ee5St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD271F00893;
	Thu,  4 Jun 2026 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780581583;
	bh=zrAnCSLB+O4gj00Wcf1ovkoCDKhDJWe65/qtd2aoMgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=is3ee5StXsXt4cqtT2fql/+jOzOIPbUTDFnhAMvTTL7TNfLgCylf3tjpawD3Jlfl6
	 h/eifstBmOaPtYngI0740a5S+7g2AtBdPvp/x5YVfuFsMHPfm4Tgt+yotGTLxfhUFA
	 yetNYW3+TrnvzKv+ll7U+WMO3yVlS3y2LCfFRRLRLZDwg94+87vyy0CIFD+ruAUE8o
	 qXyGBqcaTQXlYLNqvXme/RhBbp4o9gD+2uFll5lHtZFReWqa0wVtEUHlA5+/aB22m1
	 7m95Y/y0zRNkMWFqjek0YY3qA5p6nnQmG7ww+L/d1nxAUK/RZbCiLbmQ/pfmvg9oML
	 q6ybRyz2/ehSA==
Date: Thu, 4 Jun 2026 15:59:40 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 12/21] xfs_scrub: fix nonsense advice after a scrub finds
 errors
Message-ID: <aiGEtwsZlPzFwbnA@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303328.2608728.18278071862274653584.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303328.2608728.18278071862274653584.stgit@frogsfrogsfrogs>

On 2026-06-03 23:07:27, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a user ran xfs_scrub -p (aka optimization-only mode) and it found
> errors, we advise the user to run without -n.  That's silly, because
> they didn't run with -n, they ran with -p.  Fix the messaging here.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 84e248f3e83f36 ("xfs_scrub: add an optimization-only mode")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
