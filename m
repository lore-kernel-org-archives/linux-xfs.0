Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08DFDDCD
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774418686; cv=none; b=Li6I0/SjmtgfSuj/iuOukWIxruhNGiycKMJ4gCHNqQeHW7R92c0rO/8ss1kNF508oD6655nKz6r3nPeSUdshmJ0clmw/efT1riny/1SjWxh6UJvu0qluow0/x16HdJe5oXhmheLzw9hyrUMtEgt/MATPR6mW2LmSSW0IQWZHgZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774418686; c=relaxed/simple;
	bh=VEgCA5oh0nPLoGUrusbjktg+wsPxnz7RiP/ilJthyUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hKv8fnd0NZ1wYCwxbyEgU8IEwOoPGEPOo/PoAG4inmRM5DsVktAu/vs5s4lpv+OVO6aWT8MD9o64b4QHJZ8oQVymyYwn4foOUoT2frVRzGsFkOdirIIHk514ddj3I1ZlrQGpt3PEs3HVGNMfM8E/nsYi8vd6Qa17vhPn2+dIxFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5538F68B05; Wed, 25 Mar 2026 07:04:40 +0100 (CET)
Date: Wed, 25 Mar 2026 07:04:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Message-ID: <20260325060440.GB31686@lst.de>
References: <20260320130256.35225-1-hans.holmberg@wdc.com> <20260323063641.GA24722@lst.de> <97982591-5909-470f-b453-a1d1397d4cbb@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97982591-5909-470f-b453-a1d1397d4cbb@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 23, 2026 at 10:32:43AM +0000, Hans Holmberg wrote:
> > Otherwise looks good.  Do we want a test to ensure this takes
> > effect?  And one that it doesn't do anything stupid on a hard
> > read-only file system?
> > 
> 
> Yep, I can add add a test that checks that:
> 
> 1) No gc is performed if the value is set 100 on a half-full
>    RO scratch fs with partially used zones
> 2) When the file system is remounted RW, gc does its thing.

Sounds great!

> Do do this, I'll need to add a dependency to mountstats in 
> xfstests though (checking gc status and rt available blocks),
> but that should be fine? 

Yeah, we depend on all kinds of procfs files, and mountstats have
been around from the start of the zoned allocator.

