Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA383AFD09;
	Mon, 20 Jul 2026 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538693; cv=none; b=WpqW7P+CTmiUUYalMfujuvT1TViJjekLU0qlc0bsM/gO05UtyZ/7uAkgb+lgH96yffWnAIA4shX/fymBSXo+IsM/jvYY9pXGaq/FSpZ6VNHzNRJeNt1p5lYdW9hGVuIrQtkYYdJfyoqLJhP58NmG1SsL7/9VAYTa2A9y3kEDfF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538693; c=relaxed/simple;
	bh=DbXfCmhHiqg6q74y0YMUhjNUS/rZK7b7LrEU4cwzjJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3QTMvv1Lhpqwdtd+IHA2/AjB04Wh8k8YvYgdg/EHKt2JBIGF2UW42MHbm8+rSbtRyAh6GUp4j/v8bLwp7D3JKs0JaoggjLsp50FTSuBcxPbcLOk7Cw7sNZgCkNq0J3fSHkqu2MwJZeLp4IcY7dwJk3uxLUUgTSGwgG9jWJORsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2077D68BEB; Mon, 20 Jul 2026 11:11:29 +0200 (CEST)
Date: Mon, 20 Jul 2026 11:11:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-ID: <20260720091128.GB24062@lst.de>
References: <20260623142109.1838702-1-hch@lst.de> <20260623142109.1838702-2-hch@lst.de> <al3j0GaQaeYj0Ih8@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al3j0GaQaeYj0Ih8@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 20, 2026 at 11:02:15AM +0200, Carlos Maiolino wrote:
> On Tue, Jun 23, 2026 at 04:21:06PM +0200, Christoph Hellwig wrote:
> > When using XFS with a main device on an SSD that stores metadata and a RT
> > device to store data on a HDD, we fail to take the I/O sizes for the RT
> > device into accounting, leading to up to 5% slower read performance when
> > using an SSD for metadata vs storing data and metadata on the HDD.
> > 
> > Fix this up by taking the RT settings into account.  Note that this
> > updates the BDI owned by the main device, and leaves those settings in
> > place even when the file system is unmounted.  This is a bit unexpected
> > but not different from manual tuning through sysfs (although that is only
> > possible for the ra_pages value).
> 
> Sorry a 'very late reply', but...
> On a second thought, wouldn't be wise to cache the original value in
> memory and restore it during unmount/filesystem shutdown?
> 
> I could send a patch to complement this one if you guys agree, otherwise
> just ignore me.

As mentioned this does seem like a valid option, there's tradeoff
both ways.  Although we'd also want a flag to avoid restoring them
if they were changed while mounted so it would get a bit more
complicated.  Happy to respin it for that if there is a general
preference.

