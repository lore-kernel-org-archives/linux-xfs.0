Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D3019B3D3;
	Tue, 13 Aug 2024 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560912; cv=none; b=U4oQy8Q9IHs/5oOW9QQ73B/jit9OWZaacNSgGMxOuf3ro0fCCO8d6T2N/L71BsAion9NA4hDc1QSDJyMeavS902HxIF4HDv9DRFfJsCGRonpzPYXP5QW8K/6BMA1Fewh0Q4Ffj22AZsyL/ACY8U0i5Ck9ktgeHm0FpepafY40ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560912; c=relaxed/simple;
	bh=QugT5F1A5+jC0D52eC830TmZ4sse5w1e23y/15AEU/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuL5ZjI/gcVUryGBHUJ5+F35eTCbGws47zLyy4N5JKKFHplFg1VVT64LWgvUvt9z0ZH+sGNSL8PHiUCFrU51j3UAN0lqfAfqdR0Q99YqFwSpBb5r2d7gNp8X2iaFbWmbO9X+Z3bbsi7li8Vyvqs8AZly8JhTlCslOBTzIlNEbRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 42D9C227A87; Tue, 13 Aug 2024 16:55:07 +0200 (CEST)
Date: Tue, 13 Aug 2024 16:55:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] add a new min_dio_alignment helper
Message-ID: <20240813145505.GB16082@lst.de>
References: <20240813073527.81072-1-hch@lst.de> <20240813073527.81072-3-hch@lst.de> <20240813144004.GD6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144004.GD6047@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 13, 2024 at 07:40:04AM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * No support for STATX_DIOALIGN and not a block device:
> > +	 * default to PAGE_SIZE.
> 
> Should we try DIOINFO here as a second to last gasp?

Using it is a good idea, and it should probably be second choice.
But I'll do that as a separate patch at the end end.

