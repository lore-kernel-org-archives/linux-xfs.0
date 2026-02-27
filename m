Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D0D407568;
	Fri, 27 Feb 2026 13:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772200357; cv=none; b=VTWtNnD+KQNWlHj5PCwzhGlg6e9chbGbcZBD865vSagGeTGrKX9vTyS5lTpL44ApDV8ZV2ktPY3s0+GEdSjxX5NgLg9wriouI9f26h5PLFMKKH8j0D2C84f+WlJh7T+n3jVQsdFdvVruhbCs73R1exB7JrONVne3Mn0VOO9LkjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772200357; c=relaxed/simple;
	bh=ubxolrZAJzpAc67IrFsJm10tC/6/fBLHWP7mx/sXgls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXjdbFlhRXzH8bSUPStfYHcTT3XqAqhs4zG6rvU5iF0ATZUDvf3TJ483OeYFMC7anclrrJZit7WLgnj6nrsPg9FWfzowxAakYfSBfL0Y/yd46OChMTYDJ5tV7urAiDL2yIcJBfH2jVbzCDqGrcfag18ASLezmk8OBKg6meoPCkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E29C68B05; Fri, 27 Feb 2026 14:52:34 +0100 (CET)
Date: Fri, 27 Feb 2026 14:52:33 +0100
From: hch <hch@lst.de>
To: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Cc: "djwong@kernel.org" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cem@kernel.org" <cem@kernel.org>
Subject: Re: [PATCH] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <20260227135233.GA20671@lst.de>
References: <20260227030105.822728-2-wilfred.opensource@gmail.com> <20260227040619.GI13853@frogsfrogsfrogs> <dbda17987ff33a132da82b8635ac2a5c6ae01c78.camel@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dbda17987ff33a132da82b8635ac2a5c6ae01c78.camel@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 27, 2026 at 05:16:39AM +0000, Wilfred Mallawa wrote:
> > > -	__u32 rg_reserved[27];	/* o: zero */
> > > +	__u32 rg_reserved0;	/* o: preserve alignment */
> > > +	__u64 rg_writepointer;  /* o: write pointer sector for
> > > zoned */
> > 
> > Hrm.  It's not possible to advance the write pointer less than a
> > single
> > xfs fsblock, right? 
> 
> I believe so, perhaps Christoph could chime in?

It's not possible.

> 
> > zoned rt requires rt groups, so that means the
> > write pointer within a rtgroup has to be a xfs_rgblock_t (32bit)
> > value,
> > so shouldn't this be a __u32 field?
> 
> I figured since this is currently returning a basic block offset
> (similar to a zone report from a zoned device), it *could* exceed a
> U32_MAX for larger zones (?). Does it seem more appropriate to return
> the xfs fsblock offset here instead?

No, the count of blocks in a zone is a xfs_rgblock_t, which is a
uint32_t.  So all group/zone relative addressing can and should use
32-bit types.

