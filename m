Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965B822B8AB
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 13:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762349330; cv=none; b=DZf0Mwx5XZzeH+nHPx7ZDN+6AAa666aSGWuUauI0futrkrhrg4Rxa51Am/m216GhvI61cJ25EylZNaC804GnznXKruOhJxp7Wu1JDhUuDe5Xf16QAnfJextVO3q/KAKkPeMvh+EX9i4bLLjBofzLcMlNYm9OZb2e9HYlouqMKqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762349330; c=relaxed/simple;
	bh=LPhO+f6K6Al3I8G6Xb2ky2OPzd6ZUHLWFyZ+bnjX3Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fh3k/EIyNjPY36IuPXW6G+mizKn5ypQiBNp/4yeDDRkmcbdcepgG0I+65kOpnzq4ttRVw6Ct8ypwqSjwL3htWdWqHlWBycyPBpLcbSoGPhmmiaaSxMb3eYJrktrQwlCMQMaOBWet2sHGkFJAHH8acQ6zXdt3cSBg2XME1hfOJJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1879C227AAA; Wed,  5 Nov 2025 14:28:46 +0100 (CET)
Date: Wed, 5 Nov 2025 14:28:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: improve the calling convention for the
 xlog_write helpers
Message-ID: <20251105132845.GA20168@lst.de>
References: <20251030144946.1372887-1-hch@lst.de> <20251030144946.1372887-8-hch@lst.de> <20251101032632.GV3356773@frogsfrogsfrogs> <20251103104658.GB9158@lst.de> <20251104234009.GQ196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251104234009.GQ196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 04, 2025 at 03:40:09PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 03, 2025 at 11:46:58AM +0100, Christoph Hellwig wrote:
> > On Fri, Oct 31, 2025 at 08:26:32PM -0700, Darrick J. Wong wrote:
> > > > $ size fs/xfs/xfs_log.o*
> > > >    text	   data	    bss	    dec	    hex	filename
> > > >   26330	   1292	      8	  27630	   6bee	fs/xfs/xfs_log.o
> > > >   26158	   1292	      8	  27458	   6b42	fs/xfs/xfs_log.o.old
> > > 
> > > Um... assuming xfs_log.o is the post-patch object file, this shows the
> > > text size going up by 172 bytes, right?
> > 
> > That one does.  I was pretty sure it was the other way around, so І
> > re-run this with the current tree:
> > 
> > $ size fs/xfs/xfs_log.o*
> >    text	   data	    bss	    dec	    hex	filename
> >   29300	   1730	    176	  31206	   79e6	fs/xfs/xfs_log.o
> >   29160	   1730	    176	  31066	   795a	fs/xfs/xfs_log.o.old
> > 
> > but yes, this grows the text size somewhat unexpectedly.
> > 
> > I still like the new code, but I guess this now counts as a pessimization :(
> 
> "Cleaning up the method signatures is worth 140 bytes" :)

Hopefuly.  I have to say I really much, much prefer the new calling
conventions.  But I'm also confused that it increased code size, as
usually this kind of struct packing for deep call chains reduces code
size.

