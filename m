Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0C2F2D
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 06:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736403165; cv=none; b=W0ouHdCd4hUjKJt70ytBmmoyd3BZ4n/TkeqXpiFOI4YeyMMtkNEdnMb8fMF/LXdVUwQbjY9glD7KWi4G5o68Sbd96uTYuQkDAm/sRPTBT1gcz+NsJ1NhbC0zqOt/7dailnymSGCT68YJ7GpVwJKnyRSlMEt2Cq9FLBNgfta8KoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736403165; c=relaxed/simple;
	bh=vtFERVkTMa4rUiy+c8SSugVChatXkxLtPwxjWi1sKww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVtoL2r5jlA7ICXt4MjZBkV/1Fr2EuK1EYqhA01+Ib7Ke4wAQrv8yQZUdMQwgRD+SH/Cq92lYtf18TZ5T4VgvUZlmFB5hsX+mgerUhVyCM1Zzg8DtTL3nJAyr30HFTnLePy8U5sumkQ285eBmMFbr+H1oKUwQWoepDL48yVpil8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DE7F668BFE; Thu,  9 Jan 2025 07:12:38 +0100 (CET)
Date: Thu, 9 Jan 2025 07:12:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <20250109061238.GA16687@lst.de>
References: <20241229133350.1192387-1-aalbersh@kernel.org> <20250106154212.GA27933@lst.de> <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw> <20250107165057.GA371@lst.de> <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 08, 2025 at 10:20:59AM +0100, Andrey Albershteyn wrote:
> > Maybe we can used it for $HANDWAVE is not a good idea. 
> 
> > Hash based verification works poorly for mutable files, so we'd
> > rather have a really good argument for that.
> 
> hmm, why? Not sure I have an understanding of this

You need a consistent point in time to verify with your hash to have
a meaning.  How do you define that point for a mutable file?
