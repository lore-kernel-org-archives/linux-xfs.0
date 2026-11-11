Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418678;
	b=O3zqboZhZKEPNVUyFDvHHUzO9c3hBpz8jl0zJbR5PKZBMh1NVSGXZzkZme8YzV+EZVR9
	 DIZtn3iUaGeULCSSZ+nvbSnKNVbLfhUS7pXzctbYGFjw5KrCAauPpp50yFgxXixpv3g9N
	 LrevEhEjfRWK3+4kBnh4Jf+/kSbLkSBApLIAfTy1za5S1Y5ChVInMiLaBeW30b3bee1d6
	 oFjXFX0ky9wKymjsgo9vgEGlhAMOCUjiGv4K1oDsLrZE+6nCuk88Xe/pdps8GlOHjUvqc
	 CzwMOL/h14EZEK/EfoEjYBDPkXBwZzKRRQJ087p0zuFy8fp0CD1SjWqnRqGeSx1nENw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418678;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=bBjc37grNCQlSs8ezsdfvA0r1VBGXIBHMVBTdzmA/NU=;
	b=T0cByePSuySoL51Lh1CcPRCmaD59fCdVRXbrCUXN4fMVZ1osq//fqgmOYKVgSutvofLV
	 ILxMzfD4dPSZxUC+y9/4MleZcvZuKeuI0gSavbu+OWhRnSNrQjuQl+QwSdEL1ky4F0xXa
	 bWUQHjG0Oo/5quhlTKdm8b/4ARQPYnSI9HlcIYd8xDTUTK5wOqtbrs7SA07fxh77+a+qk
	 fkItoweTizhTzniCF0aK0gR3MirPEW0xdLXqVaDp0IzxVQ+boc6H+kBhAgKtwFo1gNwbv
	 rRwWUhBwNv1ZjtoegAakBnuyaWlyqeh8+WTair1Swp762TsoChPZ4QLU6djtGS4HDkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6BD606A326;
	Wed, 11 Nov 2026 17:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A6BD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2156868D17; Wed, 11 Nov 2026 18:37:53 +0100 (CET)
Date: Wed, 11 Nov 2026 18:37:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Wilfred Mallawa <wilfred.opensource@gmail.com>
Subject: Re: [PATCH 03/25] xfs: always call xfs_update_stable_writes in
 xfs_ioctl_setattr_xflags
Message-ID: <20261111173752.GA20167@lst.de>
References: <20261104085929.317544-1-hch@lst.de> <20261104085929.317544-4-hch@lst.de> <avRM1f0Lhw-Y1uxf@quentin>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avRM1f0Lhw-Y1uxf@quentin>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 12:11:51PM +0100, Pankaj Raghav (Samsung) wrote:
> On Wed, Nov 04, 2026 at 09:57:07AM +0100, Christoph Hellwig wrote:
> > Currently xfs_update_stable_writes() is never called when the RT flag is
> > flipped because xfs_ioctl_setattr_xflags() updates ip->i_diflags before
> > comparing the rtflag variable to XFS_IS_REALTIME_INODE(ip), and thus
> > the stable flag can be set incorretly when flipping the realtime bit
> > on an existing file.
> > 
> > Fix this by unconditionally calling xfs_update_stable_writes for regular
> > files.
> > 
> > Fixes: d528a6c1d4b6 ("xfs: data checksums require stable writes")
> 
> Shouldn't this patch be folded in to the stable writes patches?

Not really, this is a fix for patches already in mainline.  Carlos
has queued this one up already, so it will be gone from the next
round.

