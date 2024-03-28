Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C4612E1EE;
	Thu, 28 Mar 2024 14:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711637808; cv=none; b=FCrHDcf6wufLwhuAQqfPmAiEHbmnB/PJzYfBhWRGKk13pAcJMKWXShnc5tiX28TO4FzdYAln11Z4eymeqcz+12Ju76GeTMLkfKkFX5r46Tvip/TUn7B+9ZceaKQgUTgRZzLfOBKAJJBiYqHdiO5rDR4cyeN1WX5/odHNQbserEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711637808; c=relaxed/simple;
	bh=Nknw4o5oZvTORM4ukyGTrR1Dv2WKkn1lzdc63kKE8mE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCkwnI2NoUNtCstbUEF3Ytv/LSNhuhbco1ggNEk8sPNbjXqtqNOKtPdTzXNWxyADJ5Od9LjPU4WImnehFobK0+BYGBuh3k/Hrkv8I0/vzAU9GG7OYBjHZ9PqMaoO/XRWODfTamDrdg+D0shOYveScvbl6sICK9auEbTFzOyvyZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A21968B05; Thu, 28 Mar 2024 15:56:41 +0100 (CET)
Date: Thu, 28 Mar 2024 15:56:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: don't run tests that require v4 file systems when
 not supported
Message-ID: <20240328145641.GA29197@lst.de>
References: <20240328121749.15274-1-hch@lst.de> <20240328135905.fw27fzpixofpp4v7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328135905.fw27fzpixofpp4v7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 09:59:05PM +0800, Zorro Lang wrote:
> On Thu, Mar 28, 2024 at 01:17:49PM +0100, Christoph Hellwig wrote:
> > Add a _require_xfs_nocrc helper that checks that we can mkfs and mount
> > a crc=0 file systems before running tests that rely on it to avoid failures
> > on kernels with CONFIG_XFS_SUPPORT_V4 disabled.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> This change makes sense to me, thanks for this update.
> By searching "crc=0" in tests/xfs, I got x/096, x/078 and x/300 which
> are not in this patch. Is there any reason about why they don't need it?

xfs/078 only forces crc=0 for block size <= 1024 bytes.  Would be
kinds sad to disable it just to work around this case.

xfs/096 requires an obsolete mkfs without input validation, but
I guess adding the doesn't hurt

xfs/300 needs the check, it doesn't run on my test setup because it
requires selinux.

