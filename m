Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B53242D70
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 06:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760594797; cv=none; b=N6FvjSQIzCmWSvv1B9mSZyGakaKtdp3Lpge8gn+GUEwVdpEQ7rI1pF6uJj/4jQ0aWNTXOZf5y4hKQCV1LxljHQPr07UuRn71mXI26OvlAXhf46qOw2md6JmoJB4PcIRdcy5Z/ScovPyeJ6RBZjCqk45M95vC2+EcRaLsQo09Y2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760594797; c=relaxed/simple;
	bh=B+44oiFX/heSf8oEVhW14cmJgu1ayhaiNt2K3oLW8yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=te4UdKaYjGf6EOdds8nz/TTwTkmduQvUuHGyNnU1LNlTWLPMy/rzCLXH+DVTP0nPPKqZ7EZpMUWa8xdkmpJnEqbTq5RcfJkxFawzwJHsRLNhZoTuwvt4YP42arpEWzPJ2U8uJszI18CiAk+aTu/5LzoTBz0OPvaOxhjSYd+waYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BEB7F227A88; Thu, 16 Oct 2025 08:06:29 +0200 (CEST)
Date: Thu, 16 Oct 2025 08:06:29 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: hch <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: cache open zone in inode->i_private
Message-ID: <20251016060629.GA31451@lst.de>
References: <20251015063034.61067-1-hch@lst.de> <8e5066f2-4e03-4769-bb78-5f87d94759e3@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e5066f2-4e03-4769-bb78-5f87d94759e3@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 16, 2025 at 05:17:31AM +0000, Hans Holmberg wrote:
> > +	 * reused for GC in the meantime.  Skip it in that case.
> > +	 */
> > +	rcu_read_lock();
> > +	oz = VFS_I(ip)->i_private;
> > +	if (oz && (oz->oz_is_gc || !atomic_inc_not_zero(&oz->oz_ref)))
> > +		oz = NULL;
> 
> We still won't steal any open zones for gc(except at mount time), so
> the keep the assert and comment below in stead?

True.  When writing this I thought that a zone pointed to could be
reused as the GC zone, and it could.  But the open zone would not
have the oz_is_gc set in that case, but instead we're protected by
it being marked as full inside the oz still.

I'll bring back the old assert and will write extensive comments
explaining all this for v2.

