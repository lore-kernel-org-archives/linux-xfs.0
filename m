Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AADB3955C7
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786382203; cv=none; b=QmyCnh+dNd59WJkceXwkP6B4figjFeaB8438PJ5CDg+R7ELW1uS74zNcPXGh2QptDp1ekEFMsrciLBzMPrOCeCa6PfPFwz94LPetarGLkcJXVxxc6cnJebJhg0VkKouXpR/ojV3K3U6EBW5ICF3WGiOpJd/zq6fWRw9A7Oe2OE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786382203; c=relaxed/simple;
	bh=nuQnChr0FcJg75P97i1nyKedjF46lp/fYyhO+OrbMLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEt00YGgUoNFEgjQ7g6USs36NqPELfAX7jbB6ukRL9tObXycpDMCNyjTxrzrQ2oqWVeEbfPGimvoXoEc+F2FZvutDQ5Gqv6f8lRKe/amtGV2/B5hRtEjyYxobk/hS1gZ2IP2l7u1anlQ/zD+yTCxhjOuukAPR/J6Y4LjYXIlEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A4D0968B05; Mon, 10 Aug 2026 19:16:34 +0200 (CEST)
Date: Mon, 10 Aug 2026 19:16:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
Message-ID: <20260810171632.GA26992@lst.de>
References: <20260810153759.466417-1-hch@lst.de> <20260810153759.466417-4-hch@lst.de> <ann7HKGV6GgnzDQT@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ann7HKGV6GgnzDQT@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 10, 2026 at 06:25:47PM +0200, Andrey Albershteyn wrote:
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index c80f05507373..9506cd8d15e6 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -634,11 +634,10 @@ xfs_zoned_map_blocks(
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  
> >  	wpc->iomap.type = IOMAP_MAPPED;
> > -	wpc->iomap.flags = IOMAP_F_DIRTY;
> >  	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
> >  	wpc->iomap.offset = offset;
> >  	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
> > -	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
> > +	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
> 
> Does it make sense to set IOMAP_F_DIRTY here? I haven't found how it
> could be used

Well, by the protocol of the flag we should set it as the update
requires a transaction to be persisted.  But you are right in the
sense that nothing actually looks at it for zoned right now.

