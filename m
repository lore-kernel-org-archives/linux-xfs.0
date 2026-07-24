Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EEC3A9628;
	Fri, 24 Jul 2026 13:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898799; cv=none; b=ZoeXV7WpzMs332O23aDorBjncg7UtM20gYcQJYNBRM7Fz1+2ADmeRQ72MmHSyVcs2+0PW5GCXksJFLfFqcD7eFnWBk8SR9ydzfqf11IZBOzVi1GJQMvGAMkX0CRb1S7q6/HOftOtgw1zJ8pi08Bn2KnqzMYidYTyBpdczKc+u8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898799; c=relaxed/simple;
	bh=B2EJbs3TJ5XbxxR+DLc0pnnDadUKwE4zezEBIo5PGwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbucjbDV2eeJHpPWV6AGnJ0ut0NPX14jKx+iHCRUnqU+wHxGRDykyLhxqFGbd0UqDWN1GmRPKAl3hZ1n6uLruvJsbMF9fgEKPnAAffPfkVkE+8xwZ+r4Ljx5tXbS5WLrMRPwl2/JFKL7WO/q+V12ohXm6GFjTNHhzbDuscFR1gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5216C68AFE; Fri, 24 Jul 2026 15:13:10 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:13:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 05/23] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <20260724131309.GA27878@lst.de>
References: <20260721184346.416657-1-aalbersh@kernel.org> <20260721184346.416657-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-6-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 21, 2026 at 08:40:42PM +0200, Andrey Albershteyn wrote:
> The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> flush whole folio on every digest (which is 128 for 4k). Open code folio
> mapping and flushing to copy all digests at once.

What is the point of this?  flush_dcache_folio is a no-op on sane
architectures, and this should not be a performance path, so
avoiding all the kmap logic does seem benefitial.  Or at least only
opencode it for !highmem to avoid the worst part.

