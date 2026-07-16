Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D7B346E44;
	Thu, 16 Jul 2026 21:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784238443; cv=none; b=qK3s2R3VplYR+BAt3RP1fuTBCwU31wRbfK7ujt/ZL57zkMa3CB+EF3hl9Ssi9gQZlUEXjriG8C+vbA9b/eLdjqBpjP+9MNbfdjihJ8FSRj1VmG2Sfhdi51VpaT0wSuYdhwGKtYGgruZqPtRZ0QN8UrcE0TJYgE+cOjRemUmyqb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784238443; c=relaxed/simple;
	bh=DWhKi7C+BB+k+QsbdQCvFTRoYhaYlakhULC2G3Dv9Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odiDcoq4oh2GAl6mqWqiZNLZG8lyV3GQ1vfzFqE0Leameuf+2VwzECj5uaWglVuu3EQYwlpW56ymaqM10/4APw/UsN31sKD3Etiss4PUJI2hFTUJMgKp2uK440VS0JUmpmnTolc3+ToqqrC4H+YcwuA4nHg5505npcP5l7z1n94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfraN4+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfraN4+3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 83C5A1F00A3A;
	Thu, 16 Jul 2026 21:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784238441;
	bh=t479Evlyn6X+sGTZ+1ln5nHRNoIT2kSoFnTL7kjYTpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UfraN4+3jYkrRYXRzeMS1Y8Aao0zdEkZd5ekH83s2+goHzEqiybTLVpZf2fUVMiFg
	 YxeeMRCsqx+SLXXCtoGFQbemazn8kIBluzTtYRFRJRFaJQdBxhA2A9kWc8JsVtCwRX
	 UvK4DqgXDxd3HugqI4xCPlp7UfilUKeI2lgPmJK9L8uk28OhdXYt9UpselGfuRFfrj
	 GIyhHiolU35HzjFjxh/Ysq8Fc8VSoIYcThe0tRkFoP+u6E8PFvTz7BNAsrusIHKjB6
	 nYaWwlsmIpuTLqMUueK+pIVizMUGljXH45UAVV2bhfHtC8HuHndDwwqq8KiL5Nzr2X
	 bzXIj0QA+YEbA==
Date: Thu, 16 Jul 2026 14:47:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't livelock in scrub on a circular unlinked
 list
Message-ID: <20260716214720.GR7380@frogsfrogsfrogs>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
 <178416797487.2008054.2580454314921003800.stgit@frogsfrogsfrogs>
 <20260716082421.GH12330@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716082421.GH12330@lst.de>

On Thu, Jul 16, 2026 at 10:24:21AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 15, 2026 at 11:07:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM points out that online fsck can livelock if an unlinked inode list
> > contains a loop.  Use a bitmap to detect cycles.
> 
> Didn't we recently have some AI generated patch for the same thing?

Yes.

> Either way, this does actually look reasonable.  But also complex
> enough that I really want a test case that creates an image with
> such a corruption to test this case before we merge the kernel code
> as this is something that basically requires a maliciously crafted
> image, and we trade new otherwise untested code for a theoretical
> bug.

I'll try to work on that one today.

> > +static int
> > +xchk_iunlink_bucket(
> > +	struct xfs_scrub	*sc,
> > +	unsigned int		bucket,
> > +	xfs_agino_t		agino)
> 
> Maybe add a comment what this function tests?

/*
 * Walk the incore unlinked list for a particular AGI bucket to construct
 * the unlinked inode bitmap for later reconstruction of the unlinked list.
 * Returns 1 if we should keep checking, 0 to stop checking, or a negative
 * errno.
 */

> 
> > +{
> > +	struct xagino_bitmap	seen;
> > +	struct xfs_inode	*ip;
> > +	int			ret = 0;
> > +
> > +	xagino_bitmap_init(&seen);
> > +
> > +	while (agino != NULLAGINO) {
> > +		unsigned int	len = 1;
> > +
> > +		if (agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
> > +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> > +			goto bad;
> > +		}
> 
> Handle entries that should not be here, makes sense.
> 
> > +
> > +		if (xagino_bitmap_test(&seen, agino, &len)) {
> > +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> > +			goto bad;
> > +		}
> 
> Check that we don't have duplicates, makes sense.
> 
> > +		ip = xfs_iunlink_lookup(sc->sa.pag, agino);
> > +		if (!ip) {
> > +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> > +			goto bad;
> > +		}
> > +
> > +		if (!xfs_inode_on_unlinked_list(ip)) {
> > +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> > +			goto bad;
> > +		}
> 
> The that that the inode actually is on the unlinked list, makes
> sense.
> 
> >  	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
> > -		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
> > +		int		ret;
> >  
> > -		while (agino != NULLAGINO) {
> > -			if (agino % XFS_AGI_UNLINKED_BUCKETS != i) {
> > -				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> > -				return;
> > -			}
> 
> Ahh, and this is mostly existing code...
> 
> Maybe split the reactoring into a separate helper into a prep patch?

Ok will do.

--D
