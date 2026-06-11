Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C7A403B16;
	Thu, 11 Jun 2026 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781185125; cv=none; b=j+PLXEVYCey1cPc0spqb+GzwLWXFiBiF0rpBth7kiLzaqjkCa31iN+91ka99vm0t5vK7mZjOc4zbyBVodqPcXRPh3k3t6Kc0K+27Qxk1DmP6w1VyevLZzGtxEGrRZTWILek6R7D64uVytBn3nA4IYcXA7IulXnG9d7UjLpa1xmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781185125; c=relaxed/simple;
	bh=dCGsq+sGn8+AXkFppkC4Oy35WP7J0fWClIUetfnvcCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuNag17+yxwlfkDEeCeFy54QVLIowz6NZTqtUTgY9YMN3LN6z6wXhZ6mOt1ANcqpqfFCNG+JgGBsvmou8A6kLomAqZhOf35XquEjUI8izltaLBlgIrSieH2xbZUYRN19icCnBrRWRoE/L11kxpJPSvYKTclC3sxXKsnvx6VhWLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CCAF668C4E; Thu, 11 Jun 2026 15:38:33 +0200 (CEST)
Date: Thu, 11 Jun 2026 15:38:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	brauner@kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] iomap: enforce DIO alignment check in iomap
Message-ID: <20260611133833.GA14645@lst.de>
References: <20260610145218.141369-1-cem@kernel.org> <20260611055744.GA18538@lst.de> <aiqBvF93P4NjfaDR@nidhogg.toxiclabs.cc> <aiqwy5DfHI79KXuZ@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiqwy5DfHI79KXuZ@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 11, 2026 at 06:57:47AM -0600, Keith Busch wrote:
> It's entirely possible a device supports byte aligned addresses. The
> block layer just doesn't let a driver report that. So either it really
> was successful because you found a bug that skips the alignment checks,
> or your device silently corrupted your payload.
> 
> Anyway, my earlier suggestion should work. Ming thinks it may go to far,
> though, in not taking the optimization when it was possible. So here's
> an alternative suggestion that should get things working as expected:

The fix below looks like it is addressing a real bug.  I'm not sure if
Carlos is hitting it, but we were missing the alignment checks for
single-bvec fast path bios so far indeed.

