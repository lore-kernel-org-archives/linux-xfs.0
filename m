Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5361E4AF;
	Fri, 19 Jun 2026 04:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781845025; cv=none; b=EHG0zFyPXUf2yOHSIFiGIA+IXilk2jZnmanS9zwnZR+movJ7DkFRujOQspNAt3eFe6DlUecwpEqviQcRTUi2OdFs3n7OkgGKMKQFOvXTFZHZd13XF1vjnQ/QIc4+36qBWcvlP+xqDsUBVnyJ1q207IGirv16yZ8BqiCIwW5ClZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781845025; c=relaxed/simple;
	bh=LRjcQfszsIpjPUS2nfRKnGhGzIGqREtMvLolD629Z04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMvNFqTpie1Lv0X79UCK0hO9/bN33CgGT0OTywMi8awP1b8cLO/ggrTyvghFAekv8kbbVyefnI59OL+cgRStBXnfhqt87u2UCmOf9YthH3jdqQGw/8Fj2eJrN3vesU2crHAGHTHubOV8K41IJ++ySa1Bp7ct7sAK7ea/Z9pKyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B2C568AFE; Fri, 19 Jun 2026 06:57:01 +0200 (CEST)
Date: Fri, 19 Jun 2026 06:57:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/078: disable all concurrency scaling
Message-ID: <20260619045700.GA24871@lst.de>
References: <20260618134834.237647-1-hch@lst.de> <20260618134834.237647-2-hch@lst.de> <997e50d2-83d8-4b41-9c2a-749e5c85bf4b@sandeen.net> <325bdef5-487e-49d7-90d4-3418e2ae7799@sandeen.net> <ajSgfekizOMFT0SB@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajSgfekizOMFT0SB@shinmob>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 19, 2026 at 10:55:21AM +0900, Shin'ichiro Kawasaki wrote:
> On Jun 18, 2026 / 09:23, Eric Sandeen wrote:
> > On 6/18/26 8:54 AM, Eric Sandeen wrote:
> > > On 6/18/26 8:48 AM, Christoph Hellwig wrote:
> > >> Disable concurrency scaling to avoid mismatching output on systems with
> > >> a large CPU count.
> > >>
> > >> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > I think this papers over what I still feel is a problem in mkfs.xfs
> > > behavior, but that's a different issue and making tests pass is good, so:
> > > 
> > > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Er, hang on - let me retract that. Lukas sent a series to address
> > this problem too, right, and one of the things he added in his series
> > is a helper to determine whether the concurrency options even exist,
> > so that this can continue to run on older xfsprogs, which seems like
> > a good idea, no?
> > 
> > https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?h=for-next&id=7f162f5bcf50fc32c7e3b432e7ff189571a3151f
> > 
> > which added _scratch_mkfs_xfs_supports_concurrency()
> 
> I agree, I think we can add the change below on top of this patch.
> Regardless of the change, I confirmed that this patch avoids the failure
> that I reported. Thanks!

Thanks, I'll add that.

