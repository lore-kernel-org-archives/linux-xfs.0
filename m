Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A990E238C08
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660570; cv=none; b=Khh3O5vgUc17X/7XiyP6H7iPSGTcYEv5Sc2RGPTIse+lkZJ8ewjXwBS1y+k6pqSa/rqxVDcTH/nm+lWfZ4T+dHLHK6/XIvom6FeU843Vgljzo7ViF/h08309wJTcuMj5s8z8hwJsCElhtksk6ch7ZpVykqnXsL4VfNUBZbYH7/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660570; c=relaxed/simple;
	bh=pB9jFzw2END/bZbh5jNUhIylQvuGLFIgnm2WsBC5r+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArK8DuTamvIKvBos4JS3y4uZ7DgVpjMP+NMMi6ERfOHVHViJ15MMCoIbqlp1PERlHRhc6KHpTP4oaw3/RQ2DkP6F9mxDWimNWXlDfkM1eb4Cayg4FGQ/jg9ElYOtxFLtiwSeAky1StXycvC+AAJ2V5sIexA+Z8mw1NaNTUz9B0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D067768AA6; Tue,  2 Dec 2025 08:29:25 +0100 (CET)
Date: Tue, 2 Dec 2025 08:29:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: logprint cleanups, part1
Message-ID: <20251202072925.GD18046@lst.de>
References: <20251128063007.1495036-1-hch@lst.de> <4zapkmkqg7no4x4bi2lfocjf6amj7sohn57x5ir72odcuo6ojk@miznyqz3vmkq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4zapkmkqg7no4x4bi2lfocjf6amj7sohn57x5ir72odcuo6ojk@miznyqz3vmkq>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 08:03:24PM +0100, Andrey Albershteyn wrote:
> > I have similar patches for the rest of logprint (which isn't quite
> > as bad), as well as ideas and prototypes for some more substantial
> > work.  As this will be a lot of patches I'll try to split them into
> > batches.
> > 
> > 
> 
> this one looks good for me, with a few nits I found, I can fix them
> while applying, let me know if that's good

If that's fine for you go ahead, otherwise I'd be happy to resend.

