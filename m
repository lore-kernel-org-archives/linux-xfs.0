Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B603C871B;
	Mon, 20 Jul 2026 07:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784534294; cv=none; b=OhF/fOdGgCLwzpJqkO3ZXk+2hfiwua2gVZkxWhbXh22rnyxgi+YHH1Q6RqSiyhq+KwzPhSV1juJTtyR+bIwxJHwrSNbHgGt/+iGdmooOw8J4ZeY4EUhtcRtaBqawYirgVhpurZ9VAYDSoGmd7TvfpVICwWiD6pP7D09eqA1D5uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784534294; c=relaxed/simple;
	bh=z2pV5+m7oywp5F57tdzfLtRpSn1K0sQzxY2FXhn1+5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLwo9x/p5BcHTseXI7k6vwtOQFLzi0PP6IBtNJK5We9QmWfBfl2KPgVNyn6ms+8xWmx1UT3Omt1tLCma6qCVobhbFBSC1jOiLNPvgWbXuPSgNz5gZZivM1Xy2KiAYWwPF99Wv93tDOKJ6U092lOm9GHoL/gfPKOKAuO/dbh5bOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D8E968BEB; Mon, 20 Jul 2026 09:58:02 +0200 (CEST)
Date: Mon, 20 Jul 2026 09:58:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Oliver Sang <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs]  9b64ca202f:
 fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec 24.1% regression
Message-ID: <20260720075801.GA18087@lst.de>
References: <202607161601.867c143e-lkp@intel.com> <20260717064807.GA23992@lst.de> <alyHzqUcyw4+EIPp@xsang-OptiPlex-9020>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alyHzqUcyw4+EIPp@xsang-OptiPlex-9020>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 19, 2026 at 04:16:14PM +0800, Oliver Sang wrote:
> hi, Christoph Hellwig,
> 
> On Fri, Jul 17, 2026 at 08:48:07AM +0200, Christoph Hellwig wrote:
> > On Thu, Jul 16, 2026 at 09:13:19PM +0800, kernel test robot wrote:
> > > 
> > > 
> > > Hello,
> > > 
> > > kernel test robot noticed a 24.1% regression of fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec on:
> > > 
> > 
> > This looks really odd.  While the patch adds a bit more computation,
> > that is very cheap shifting and masking.  
> 
> in order to avoid the false positive, we rebuilt the kernel and rerun tests
> on both 9b64ca202f and its parent. though the data has some differences with
> last time, the regression trend is still similar - 21.8% regression this time.
> 
> 
> > So the only theory I have here
> > is that this somehow affects the inode data layout.  Can you re-run this
> > with the patch below applied on top of commit
> > 9b64ca202f364a6bf8e19bdd20953bc2d776c67f ?
> 
> yeah, but applying your patch upon 9b64ca202f, we saw the regression recovered.
> 
> from average data, it now becomes even little better than the parent of
> 9b64ca202f, i.e. caffb4252c, but since the data is not very stable - 4% stddev
> for caffb4252c and 6% stddev for bd79e961ea, we cannot call +3.1% a valid
> improvement according to our bot's rules.

Already, so this must be something about cache line sharing.  I'll try to get
hold of a big enough test box to see if I can reproduce this, in the worst
case we'll have to just add back the padding for now.
