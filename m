Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC839E162;
	Fri, 23 Jan 2026 05:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769147096; cv=none; b=PIRPe+mYdkw4x7YFTywL5PC3UUDjyCOsIZAi8ptC3ilhGUM7Xjh2sCALGwp4pnCGrJDL+ZNm0G0gTrsdRFeeaBO3RJM7tEdrZmu2Wz7oBMzQ6Q+4Gt79ENTBGwKquhvFdaayKaUDPK9mc3NHZ+k5WccOfw6f6QEGdSpbhNt1AUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769147096; c=relaxed/simple;
	bh=zS7jeGJQFM4MYFYI8vSRKlMYlDbn9kfbbd/8Xd5pZIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtIyeeX0MZuCZbPekuh8//izdRDr4r6yoYw28t8TLZko7MFKkRcwR64920zMgguW4mx1Eg7TFUFa8UKxcn71xGz2CKmUKMFPgYSRbN7eN0mgmMyyCV8yztpXg1Bo1GhNk8ZTJnLLdou5z/Vooq8IQor9vFw37klgBdd5oZp0f38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 169C0227AAE; Fri, 23 Jan 2026 06:44:49 +0100 (CET)
Date: Fri, 23 Jan 2026 06:44:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs
 helper from bio code
Message-ID: <20260123054448.GB24902@lst.de>
References: <20260119074425.4005867-1-hch@lst.de> <20260119074425.4005867-4-hch@lst.de> <20260122174703.GX5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122174703.GX5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 09:47:03AM -0800, Darrick J. Wong wrote:
> > -	struct page **pages = (struct page **)bv;
> 
> Huh.  We type-abuse an array of bio_vec's as an array of struct page
> pointers??
> 
> As a straight hoist the patch looks correct but I'm confused about this.

Yes.  This uses the larger space allocated for bio_vecs to first
place the pages at the end, and then filling in the bio_vecs from the
beginning.  I think the comments describe it pretty well, but if you
have ideas for enhancement, this might be a good time to update them.

