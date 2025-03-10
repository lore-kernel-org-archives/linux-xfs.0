Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776B118C011
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741603016; cv=none; b=J14oSU9eIHy0oLj95mQxXdeEIYKcz+9fQ9saUKtGOjEqnOuDFA9N2aaqlr4vWbVU8V67JEPea1+Bax1/1M4/09vFIOjhnQ0sIHDuVHalqFHsKrWV1d8sFIGjeEysjZhrhyLVb2vlzzuGYIL8EiFKcEm53ZWu7cl53lMgB83aqTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741603016; c=relaxed/simple;
	bh=sNqClxs83wLh/4vK51jP9yTC/ASRVudKSPzTYN2muUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgRnvDXddE5WkcgM3+3zNtn2H3jaBnep26Z3uBVBQ+dFCw8/NLhaZnxRWbPcuoxDh+zitkF18V/B+1FtPZuog26xp5+5izIrmlxsNO7jYBAlfntCYwTy/VCEHJghDoDOzDSJgjj6yqPCUFG3e/quY4xWB3SuZrMRAJj1nl52aT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B7F8368B05; Mon, 10 Mar 2025 11:36:42 +0100 (CET)
Date: Mon, 10 Mar 2025 11:36:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@redhat.com,
	bfoster@redhat.com, aalbersh@kernel.org, axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <20250310103642.GA4378@lst.de>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga> <WW-YcYkHs91Udy3MU9JoG8oirMMUKrs7XB4_rExNq8_azaAVtgdcf-7vtuKI23iITfyc832nCqSz_O7R41btrA==@protonmail.internalid> <20250303140547.GA16126@lst.de> <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z> <l07Q7sLKdafnmrmqBghsvH5o-E7m8nGRwAzBZHTeoEB6coPrxD8D1SvgJJ7HCs_vG6xUTJ9nMdxzEZ_EC90X0g==@protonmail.internalid> <20250304202059.GE2803749@frogsfrogsfrogs> <nausrxvwnnnk7g7ythgaslitvrfy5syeugvsjequ74zsd7gz2l@4bkgm5yrcjqh> <20250306170841.GA25819@lst.de> <20250306174012.GN2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306174012.GN2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 09:40:12AM -0800, Darrick J. Wong wrote:
> Eliminating the possibility of such messes is also why I avoided doing
> bugfixes and merge window prep whenever I could. ;)

Thats a good idea in general, but xfs took it a bit too far.  We really
should hae had major changes in linux-next for a ew weeks and not in the
last minute.

