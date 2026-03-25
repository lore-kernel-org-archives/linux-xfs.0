Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3193644A1;
	Wed, 25 Mar 2026 08:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425929; cv=none; b=qkfgN9CEOAM3u2MMm/S1hhPoApMwFCz3CQhdX2srafSdyfGbv6GIq1dHRiLSPgM4Ymdqu/BXChfpA+FwoBe4Ndwv31mq1LlZw8/lxKzkMIfiuriH87KRjGmBeKK4yIXqBMdrNKwFsen4v/9D3CCvLx3G4ZDcOJHtjREL6ep9hdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425929; c=relaxed/simple;
	bh=+19C0e82RyTBkkeFT9u8iv2756DNPQteV+mA0Dh+pEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGkyi7ZeRtoC9R341ao9mBLBjOiTVrHhPdauPJpNBlDRkI+DOKlT7LaU0qY8r99OI24SX/WjX5N6+QMIVVNdBfFBzFNelGlwdy5474guK/scJ11ZhQjLeltjkkZzEafID9yKNprzw3q9mU0r3F7TCSrTYR6coUyrG1bUMO4wKkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A106768D07; Wed, 25 Mar 2026 09:05:25 +0100 (CET)
Date: Wed, 25 Mar 2026 09:05:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 11/25] iomap: introduce iomap_fsverity_write() for
 writing fsverity metadata
Message-ID: <20260325080525.GH952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-12-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-12-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 19, 2026 at 06:01:58PM +0100, Andrey Albershteyn wrote:
> This is just a wrapper around iomap_file_buffered_write() to create
> necessary iterator over metadata.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

