Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1CD2144CC
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741015457; cv=none; b=A4XvUQqcQHET5eYZuYEKOFcuD8EWdcQ/Vfs40IueL/RvH5M/2O0xqdQ7s/LOmSkBZsWcbOL1mlaOq86b9odqV1p+O3e+xTGhZX5mpteRI0Pxx/ITq6zVCqLgKZak3W8/B/kilrGuncKm5uum2SqyRUAYLSUKPupvPwDGE5PhTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741015457; c=relaxed/simple;
	bh=wghbk7MYhGhfqYqrtvB58y5ayjkmvHdv3/mIkYhOsCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RvuS7Ii45n1HQ4uMAp2pC/arBg9V6AIeAo0rfJqg8dR8DH+gizXQLMPh8S1umwJBaVmRaaVwQiafW9/3gRq76SKvlr4P5Gk+/2lDxhmbDxQ32pfALZ3jdqK3IHXmLAZkkB0tNMkEZG5pB70pRWmjbwPv1KbEQNvQSnOysAvAkSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4586B68CFE; Mon,  3 Mar 2025 16:24:09 +0100 (CET)
Date: Mon, 3 Mar 2025 16:24:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	david@fromorbit.com, djwong@kernel.org, sandeen@redhat.com,
	bfoster@redhat.com, aalbersh@kernel.org, axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <20250303152408.GA18006@lst.de>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga> <WW-YcYkHs91Udy3MU9JoG8oirMMUKrs7XB4_rExNq8_azaAVtgdcf-7vtuKI23iITfyc832nCqSz_O7R41btrA==@protonmail.internalid> <20250303140547.GA16126@lst.de> <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 03, 2025 at 04:00:39PM +0100, Carlos Maiolino wrote:
> This is pretty much aligned with my intentions, I haven't looked close yet how
> other subsystems deals with it, but by a few releases now, I keep a
> xfs-fixes-$ver branch which I collect patches for the current version, so adding
> a new branch for the next merge window is what I aimed to do with
> xfs-6.15-merge.
> 
> The question for me now lies exactly on how to synchronize both. You partially
> answered my question, although merging the current into next sounds weird to me.

for-next really is the convention for what goes into linux-next.
For dma-mapping I kept a separate for-linus instead of merging the
current one into for-next which also works, but you still might have
to merge them occasionally.

> 
> If I merge current into next, and send Linus a PR for each (let's say for -rc7
> and in sequence for the next merge window), Linus will receive two PRs with
> possibly the same patches, and yet, on the merge window PR, there will also be a
> merge commit from -current, is this what you're describing?

Yes, but only if you really need the merge because the code for the
next merge window requires it to base new patches onto it.  If the
merge is a no-op you don't need to merge, and if it is not required
for code added Linus prefers to to the merge himself, possible with
a little bit of guidance.
