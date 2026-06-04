Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27E92882BE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780587358; cv=none; b=Je4M8XjlH/CUbbEsQ3T3+0YUxZ6D/5WKSGwrExo3soGJeKTn+ZPeTXPbZQAYy8efLcSWAzBk02O380mbn6zfJzKC9DvRYZQuheFTW4VpGD2aAvYu21b10Krb7QiywHdCzRYVQcmxqg2ovXrgU4sy7bWpkNohEcq+J81qGXMJeMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780587358; c=relaxed/simple;
	bh=GSMu/PeLer0uUnJrJ4b4Pvr9mAZpuAKEytPpfUldGA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sckF2aoMlnL3R1eRWjEsM0tRFb+w5AhalE1YbhApPDQSvd8D6CCgBVHTcYA5oRGaR2T2n23QV8fiAM08m1nt/AyUV6IXgtMXcrbsvFIWAHVr2JCDdpjay+k2GseEfyZfxlFTFJ2CdeycnJ/6581PQCVNunmEGtJ89NlZUQ6upF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Beehamc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Beehamc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7401F00893;
	Thu,  4 Jun 2026 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780587357;
	bh=5xj+oRR/o45PU2Of4azdD9MMXJZ//vPLqqG94DyqHWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Beehamc0yPfbzrtwwuZYnqhFYjU7TqurCb5EwP/+K751R0VBHkZHz8OGtI7eBZmCO
	 ceYCKM8sy/E44K6ugOEjWo2oO5+InA7SIes5TvlwxH3QD898nzzcTpDZI78JxhRYFd
	 s+89WpImcramdG0U+XlUgP1zEDlfGXCV0SixkGcWypFaHvpxePsCjJrCx6pkAss4mX
	 wwNK1rdzdpM5y0Xr+Nos+CfvvGFfTFiFIfqJG+aWAYXWjBlJ+Cqaa5J+xEBqdnGyS8
	 52tafv5iSEHfFI0ojmDlm4+/XKsMWO9yQxohzDm70NsHJiX5cDyujUwBo3f+G40a+z
	 3z5I8A2SCUegw==
Date: Thu, 4 Jun 2026 17:35:54 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 21/21] xfs_scrub: read verification isn't ok if it hit
 runtime errors
Message-ID: <aiGbSKv49TYLY3ek@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303495.2608728.18446230939962684059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303495.2608728.18446230939962684059.stgit@frogsfrogsfrogs>

On 2026-06-03 23:09:47, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex complains that a read-verify pool couldn't possibly be ok if
> someone set the runtime_error field to a nonzero value.  That's true, so
> fix the predicate.
> 
> Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> Fixes: 58fca77c2d2ae8 ("xfs_scrub: move failmap and other outputs into read_verify_pool")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
