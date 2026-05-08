Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29622759C;
	Fri,  8 May 2026 08:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778227933; cv=none; b=ia7Nc0HnFF5kv4QECu9+Xy53zUnwGmI9lCjgOqyE4BzPnSFvILUPVUwOJxz3RW5/qQlmQOYhdtrTbLzz5KtYUi3Oi/9aOW2RaIMPMCttcAS2RzAeQI04KDukC3tykWVJCLXhj1CqaUC1g4H0jnl9ndCv/xlUnPV/wwe7kf/fbdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778227933; c=relaxed/simple;
	bh=OJRMt2tYOgvhkjjDt2AWOGD/eZEwihXaHy8mSL/WQlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFzgH+xQgTQV/2Xsb0b8uLagIDaAkIhEToTAYNsbHcPhGyz4vW7GQ7Fi6fnlrOabm3F36OF1sKyrt1Je9btCZRFvsWOzPneXQUEVp/D/floaxaLklk0fDpYBwZu5EK9uhSG9WV4G0yfhx+8D8bwHLAV0HbkrS4Lh51kd/DMyD0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B6C0A68BFE; Fri,  8 May 2026 10:12:09 +0200 (CEST)
Date: Fri, 8 May 2026 10:12:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: pass a minsize argument to
 bio_iov_iter_bounce
Message-ID: <20260508081209.GB19748@lst.de>
References: <20260507050153.1298375-1-hch@lst.de> <20260507050153.1298375-2-hch@lst.de> <7a24ulsyoczubsjc2y4rkv7tkgqzpo7ehkkljdytyo6tzqdw24@avwve4kr7tzy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a24ulsyoczubsjc2y4rkv7tkgqzpo7ehkkljdytyo6tzqdw24@avwve4kr7tzy>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 07, 2026 at 01:36:11PM +0200, Pankaj Raghav (Samsung) wrote:
> On Thu, May 07, 2026 at 07:01:47AM +0200, Christoph Hellwig wrote:
> > When bouncing for block size > PAGE_SIZE file systems that require
> > file system block size alignment (e.g. zoned XFS), the bio needs to
> > be big enough to fit an entire block.
> 
> Not related to the patch but I am wondering why we don't need this for
> non-zoned bs > PS configurations.

Because they only require sector size alignment for both read and
writes.  So I guess we could actually hit it with a large sector size
and not just fs block size.
