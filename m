Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C0A5187FE;
	Tue, 22 Sep 2026 06:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790059987; cv=none; b=FopcPcey94PNme5f7Gddi555ToUS3Ejw0Hc4d9YyRWVdhcAc/0y2N1eJgNNks4y8awK0NdwAqRsLps35TB8M8MPVmHRC/loUmSUR8JB7fwdO4SReuhqLMdHq2Hw1xAtZ+IB9snKzvzKNjtbf+VfRcBU8/eKAW66WNM9S7aVb3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790059987; c=relaxed/simple;
	bh=+StIT6EmGrgPOrAtmIXXZDr9d13WH9BJM/SnlK5qcrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nch2/L3TlhFyhCJJ046T5TfWOOhTZbybS7BcPRENwZu6V5hXaWqbEMhzbqswoK2a35I94/Gil6/EOwRGYVrbR8V52Je96k1484CISKhZsdxpo8KMo4XO3OQ0qgX/W556TGuJI+XH2yLwALKKBwLhpWbAtDpMob6WHPjpgvjjloA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1PfaDTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1PfaDTj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E8171F000FF;
	Tue, 22 Sep 2026 06:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790059986;
	bh=ZLptsZejgtdfGTR8FErIULNWvg92OFalqesM1cag7fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c1PfaDTjCMOZoQY30xMWav7XcyB9vxRovQHy9AQhYJK0L4qU0rWia+RUk32pvlk80
	 She3GUMc/9h8qNkTa0CEMyANhSSOLismqRDapZUCTsX2bMdHXhbspqZhGi0W3lNs4J
	 HwpXBZ/hRtaHVudmq8+AeU/VwcfDFUNOxxPYli9BEsnAN9nsAqfIXhGCUUeoYf0EPQ
	 +wYnFjAAexezaoTl7Jlz1SLt9ouLvobPsc4IZnDYddsKwRtDIw7F4pkUQBZDAChnB5
	 JwX63Xgn1Lvk1oiDeLvrHf73cozffgTiQllAuloGJeCZjsvM2q0PC2n1JVahgIsBlT
	 O11ZyyibbNfyg==
Date: Mon, 21 Sep 2026 23:53:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/14] xfs: fix maximum atomic cow length computation
Message-ID: <20260922065305.GT6283@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120721.181988.7950955477687457877.stgit@frogsfrogsfrogs>
 <arIQUbrLZNVv10Mo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIQUbrLZNVv10Mo@infradead.org>

On Mon, Sep 21, 2026 at 10:21:21PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:17:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM says rounddown_pow_of_two acts funny if you pass it 0, so we need
> > to catch this possibility because maybe the filesystem doesn't support
> > software atomic writes at all.
> 
> Can this happen?  Shouldn't the xfs_can_sw_atomic_write() above guard
> against this?

Hmm.  Yes it can.  I think I'll drop this one.

--D
