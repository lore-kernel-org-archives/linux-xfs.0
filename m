Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DF53B894B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308677; cv=none; b=iWkay8jFf7TdPKuNLRQ+vyLCBDhsId4VRgU75LtPQume5xE94ZCCAHQDWEkD50h3kFYTAMh2S3WEt6lTu3/oHrJgeBIj9+jY0uhDi5O9JQMUGPYMkF9UALQ8Bw5l0ZaCbJvyW8XhtlU0f7dMLOx0wLXxuWRJb6pYw2bq7fKArlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308677; c=relaxed/simple;
	bh=ahtuzU+60SjduV4jsiJ2LmX0gmGaWAatvZ2az0ku/MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/TSmSVJlsLNLEGvzczus8U8YopaLVoDrNyYow1aLPSHgeSXDGeH9QcUQ3liXCZWJeSWDPuOUaA32KgIlypf/Ewszv8d95N+EWBgybc2oPG9fJivOG/mKaeRFRk/QVaiXtvN7c8tA87MyA0lsQ/Uzhcdmfo7ZlyNXN4mL1aexsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C860B68C4E; Wed, 24 Jun 2026 15:44:27 +0200 (CEST)
Date: Wed, 24 Jun 2026 15:44:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: improve the xfs_buf_ioend_fail calling
 convention
Message-ID: <20260624134427.GC5649@lst.de>
References: <20260622073035.1370904-1-hch@lst.de> <20260622073035.1370904-4-hch@lst.de> <ajkxAU-VxjRrHVS0@nidhogg.toxiclabs.cc> <20260624074206.GA12969@lst.de> <ajuUlgquKt7puvOz@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajuUlgquKt7puvOz@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 10:26:26AM +0200, Carlos Maiolino wrote:
> On Wed, Jun 24, 2026 at 09:42:06AM +0200, Christoph Hellwig wrote:
> > On Mon, Jun 22, 2026 at 02:59:05PM +0200, Carlos Maiolino wrote:
> > > On Mon, Jun 22, 2026 at 09:30:02AM +0200, Christoph Hellwig wrote:
> > > > Move setting the ASYNC flag into xfs_buf_ioend_fail_async, assert that
> > > 				  Is this a typo? I can't find this
> > > 				  definition anywhere and the code also
> > > 				  moves this into xfs_buf_ioend_fail(),
> > > 				  not into a _async variation.
> > 
> > Yeah, this could use a little update.
> > 
> > 
> 
> If you'll be re-sending the whole series again, feel free to add

Sure, I'll look into it tomorrow.

