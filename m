Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E134E27FD4F
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 13:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035086; cv=none; b=jarQ1oiHPjWSLAuMmUc4HAAmcOGAiMPr0sNoRzIbWNrXFjoH6mIDutJCWP4UDUPyAd7kCo7j+C8ERJjGXdGLDo12YaGaCnHdc9fTMdAJpLNvQBtuJiyTu8dZNJADMs2fKi56u1nP7/QNck0dYA76v4FMSMKIWySqH6yOdfr2f44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035086; c=relaxed/simple;
	bh=V+oEzF1bKShcTSoqMwhWy6ZOb1qxsQ+oVPVsE+5xUnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxYkMBG6/QhQH0bZo8hFomkr9ih4Zz45+jci1UKeVT3cVXrJb2McNebAQkuJEfIVjUFtvY82BFCM7PXuER1JdWNjd78bcvMhYcDwmAuAoUduAZ+JBBu852bw967MdMlmHDA+lSC3Ayq5f0RaYwtW03m871/O64M8SjPnTFZ9uRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5B6B68BEB; Tue, 14 Jul 2026 15:17:53 +0200 (CEST)
Date: Tue, 14 Jul 2026 15:17:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: aalbersh@kernel.org, pankaj.raghav@linux.dev, djwong@kernel.org,
	Zhang Yi <yi.zhang@huaweicloud.com>, gost.dev@samsung.com,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fiemap: add a nosync option
Message-ID: <20260714131753.GA31615@lst.de>
References: <20260714105314.413402-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714105314.413402-1-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 14, 2026 at 12:53:14PM +0200, Pankaj Raghav wrote:
> diff --git a/io/fiemap.c b/io/fiemap.c
> index b41f71bf..7aa8868d 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -36,6 +36,7 @@ fiemap_help(void)
>  " -a -- prints the attribute fork map instead of the data fork.\n"
>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
>  " -n -- query n extents.\n"
> +" -s -- do not use FIEMAP_FLAG_SYNC.\n"

The xfs_io manpage refers to the xfs_bmap man page for the argument,
and xfs_bmap already supports a -e option to skip the sync.  Maybe we
should match that for consistency?

Otherwise this looks good.
