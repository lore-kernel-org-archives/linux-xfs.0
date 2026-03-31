Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E6331E827;
	Tue, 31 Mar 2026 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970119; cv=none; b=JRl/Vh/0KIJPelmebkfsEMOQBSCNmXJqsekiPx957/7YLRHgx1uUA8/m8jxMr76TcRkWDw4jUycJkdJbryRZzhRgEKatOYXvgVUh4chN3PsethpI0G7eY3o+afaZdUqlqoU22S/z6ibiCOkDEGoYaUiquvfxTOltbOXYavg+1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970119; c=relaxed/simple;
	bh=C40MvJNbHnJgp4MtXAN5jZBO57OTtNq9RRtINpyL8xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVkwcDg7F65JhBe5PeCxHhEN1hZVtYEkNKNxJgq60ApjDtv/hapmZ+ThUb+TCKTdrCvASm1XlJsuwLVZEroq3uaH4PYcHzzO1TAzzTefm3CO5W99GQ/mVQEoLJY1Y7k9/eo+x0OcS3AegdF5CCaYMo+0iVs3umhjWnLFRxlhURQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8B32668AFE; Tue, 31 Mar 2026 17:15:14 +0200 (CEST)
Date: Tue, 31 Mar 2026 17:15:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	hans.holmberg@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260331151514.GA7927@lst.de>
References: <20260330130029.3902654-1-hch@lst.de> <26debf2c-7b0c-49bc-b2e6-fc9eb3d8bde0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26debf2c-7b0c-49bc-b2e6-fc9eb3d8bde0@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 31, 2026 at 07:00:39PM +0900, Damien Le Moal wrote:
> Hmmm. I think you should delete odd numbered files only since they are going to
> be written at the end of a zone. Otherwise, you make the zone empty, and it will
> thus not be considered as open.

Yes, but due to the unevent number I did reproduce the bug even
with this version.  I tried your loop and this overshoots the open
zone limit even more without the fix, so I'll switch to that.

