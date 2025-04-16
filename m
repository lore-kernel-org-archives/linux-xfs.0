Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8BD2DFA31
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 04:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744779046; cv=none; b=fNOfBVmehkrslscH7o9bfmF2XJAb4rAKPcAGewdZs4UJMqau83uQy0G4uNSHKCqXMFlknYsWtoupKNwL+gJtwKDmO6YTaylZSPLqPUXTSW5/iZ/fRV/GQy9Pxq53dtMB2lOA29kRgyn3yiZxAvEnWnY5zQ1G3j9Q/eXRCiyGY0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744779046; c=relaxed/simple;
	bh=xyOjghhO7JA0wcETOMEyDjNPOTWYwaiAGijhY6PsZt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0FSaCcNCWagks3UgfB1J50xKjFv6wbdDJAm6oSca7I06Mf7st6YYp0R2oh1UyxKhtSLK1lZwOYa4aIbsY6fL1pp69rIceYSZ3+3yaZSkVUOBFZa2imv0f4L7DpmZJLnKe8JETnc6Cf+dJKps1BMPNW2W6xqxMD8130sMejxE9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlGglo8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlGglo8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6887FC4CEE2;
	Wed, 16 Apr 2025 04:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744779045;
	bh=xyOjghhO7JA0wcETOMEyDjNPOTWYwaiAGijhY6PsZt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IlGglo8z+DSsVEdKH1aK+Q9Zr0kBxqFPeOPiZWy71F2YkWLDQ8KLrfsUqVNSAkO+s
	 Rti2T87D20LscDgYjJbR4sFp2P0gcFshIRJDnrrL7s65BOqcorYFRFRNXTJEbsSsJb
	 lgZkcPRlWEbF53ficvloGlzMJZIap3Rehwf0vHCnmid22m0+jtYmYABKEoxZ0IIXd8
	 BfzhN3R64WB4bsGITDQ1Kty+uQrBkoSCQC96hi3/PzAHYtsHyY2aBun1ylgarGI3+L
	 iSCy2z3Ew5hiDDqFayVZUKGOUc1cCCLh09BwbIY1eyfDD26uWyb0Ne4IwF8GKciBwp
	 YNwG8znRkVMZg==
Date: Tue, 15 Apr 2025 21:50:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: fix blkid probe API violations causing weird output
Message-ID: <20250416045044.GA25700@frogsfrogsfrogs>
References: <20250416012837.GW25675@frogsfrogsfrogs>
 <Z_8zojbPUQ69-hH7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_8zojbPUQ69-hH7@infradead.org>

On Tue, Apr 15, 2025 at 09:35:46PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 15, 2025 at 06:28:37PM -0700, Darrick J. Wong wrote:
> > +	/* libblkid 2.38.1 lies and can return -EIO */
> 
> Can you expand this comment be less terse using the wording in the
> commit message?  Otherwise looks good:

Ok.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Did you also report the bug to util-linux so that it gets fixed there?

I'm not even sure how to categorize it -- the API docs all say things
like this:

 * Returns: 0 on success, 1 if nothing is detected or -1 on case of error.
 */
int blkid_do_fullprobe(blkid_probe pr)

But then you look at the probe functions that it calls:

static int probe_xfs(blkid_probe pr, const struct blkid_idmag *mag)
{
	struct xfs_super_block *xs;

	xs = blkid_probe_get_sb(pr, mag, struct xfs_super_block);
	if (!xs)
		return errno ? -errno : 1;

or:

static int probe_apfs(blkid_probe pr, const struct blkid_idmag *mag)
{
	struct apfs_super_block *sb;

	sb = blkid_probe_get_sb(pr, mag, struct apfs_super_block);
	if (!sb)
		return errno ? -errno : BLKID_PROBE_NONE;

So I guess it's just ... super broken?

--D
