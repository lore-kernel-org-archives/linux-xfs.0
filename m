Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64301FF1AE
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765906297; cv=none; b=Cvi1dziqK/ODuDt7Mm67UCnjEWW+kvwuFRiPf3Tz3vilQt3hsk9wnZCRYJSTzqxJbYpXitYdbWITOjPSRMpSK2Qgiw6IXL49uLGYxKV3z+JJhPKfVoLNNt+IudIV4VNJDFT5qOSnod8iWfu7sLodbGrg5i+JLjAm59BdW23fpDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765906297; c=relaxed/simple;
	bh=BPauXPiImvahaaUEY80SOXLLUZYXxiUdJFU/+OrhkfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLxYtcN3S1RYy4ZX/mKFY7g7cDNL4bEmxZIjdziQQBCjcNvOJb8GueeuzVxOzn0mFSw1UsmgX6O5mJkn38FgPKmo3qG++U1nzLFfYVlGiYg/0ptO9bE9sTnh02vmTTAAUjlmqoIst7bHH6VDb2m5isD4k0XzOPuMpgd0KbjUZ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C642227A87; Tue, 16 Dec 2025 18:31:30 +0100 (CET)
Date: Tue, 16 Dec 2025 18:31:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	bfoster@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <20251216173129.GA14116@lst.de>
References: <P_OCd7pNcLvRe038VeBLKmIi6KSgitIcPVyjn56Ucs9A34-ckTtKbjGP08W5TLKsAjB8PriOequE0_FNUOny-Q==@protonmail.internalid> <20251215060654.478876-1-hch@lst.de> <ffgi6wyu52fnaprwf3yh55zu7w54jnzeujfqhojpevntzfd4an@bpjnajccspt2> <5Jo2Clb8CI-sXH9HcivM7ax5k7r_sSb5fXgPjIiDorMYb_ZPsX3AUGt5g3YOaaTH1rFgjRwXz_FjIVfkIe2ViQ==@protonmail.internalid> <20251216080618.GA3453@lst.de> <tbzmh2fl7vchasnqvosujidfttyftmkhmdt5odmzscdbj2x6qo@ln7n6m5aw7k3> <20251216155431.GP7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216155431.GP7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 16, 2025 at 07:54:31AM -0800, Darrick J. Wong wrote:
> The original version is correct.  If you have 4k fsblocks and a
> zerorange request for 8GB - 2 bytes starting at 4097, you'll have to
> actually zero 4097-8191 and 8589930496 - 8589934591.  (Almost) one block
> each, at each end.
> 
> That said, "one block at each end" conveys that adquately in modern day
> English usage and people think I'm old fashioned even for uttering the
> first version. ;)
> 
> (Old fashioned being 1960s :P)

You're the only native speaker, so I'll defer to you.  A little
old-school is always good anyway.

