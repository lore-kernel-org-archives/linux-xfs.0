Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418710;
	b=ZQfmUD/IMjaxpsu0fH0TgM0fkjd0cCxzDkKLtQ+TY+0Dgooc7saUnqsrJEjnD5lxNcBH
	 14EOK67HRYlEZFRb0yxTRCiErGUOn1m89D4al4ZAgFsfN6zxRlM9HBqwWYiD/X5W1FVBQ
	 sAfLDSiyiMEJqrd2TcW6ZfvHhIv6d+MVmt36vinuYp28pHTk3YeRH4NahHuGaUcq726kd
	 oPmdwv+MHQwgqnuumQprka8rQ4722BL4lv7gDcfzzkp/joYOV882fWtZ6CDQUlIxOvPLx
	 GiyBEoMpXv0cdml+7+vVaOpYsxJ7X9hh6RAoc8cW+gggb+h22NJ1Cb3+/g5yvJvgH9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418710;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=Z4Wu2dz9YLmjzccxYguLjWW5op3tnOPEW1Q0uFoSP/c=;
	b=rVzbgO7VjIQBhLG047J1kAx6I9yyX6N1lZ7Q9KwkMgAsj5z86s9ichMRkJUjubdAUhkz
	 w+f7nWA278wVYjdWev7rzuPIvsXVfcQ5JQZ9q/e6BNaUCnw7LX0FVWfdWHeCj5i0wrK/C
	 fkbSLQuf9y8TTnwQ9X8t48P8k12aUFTy70CtP/xMmUt9ZwRnfdh2Myx6c6+LLcwzO3SZH
	 V2Pe6HBwmN5MVOhs/UaVDnt69dN59WI7C0PGWzuBjcCiCKGHOYyD4UF/nApNPh9bGbzLd
	 6sAF9aBr0fFd6Q9ac8Lpi0+3kZ0Zhm2AY1QZDb1V8ErSEIpyOJ3RPSIJ6caAi4JYrYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A27606A321;
	Wed, 11 Nov 2026 17:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86A27606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4360B68D1C; Wed, 11 Nov 2026 18:38:26 +0100 (CET)
Date: Wed, 11 Nov 2026 18:38:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/25] xfs: add support for reading with data checksums
Message-ID: <20261111173825.GC20167@lst.de>
References: <20261104085929.317544-1-hch@lst.de> <20261104085929.317544-17-hch@lst.de> <avRPwNoGozhWLdJz@quentin>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avRPwNoGozhWLdJz@quentin>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 12:31:52PM +0100, Pankaj Raghav (Samsung) wrote:
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index c30e688cfc9f..db834e5e60c1 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -601,7 +601,8 @@ xfs_get_iomap_read_ops(
> >  {
> >  	struct xfs_inode		*ip = XFS_I(mapping->host);
> >  
> > -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> > +	if (xfs_has_rtcsum(ip->i_mount) ||
> 
> Shouldn't this be xfs_is_rtcsum_inode(ip) instead of a per mount option?

Yes.

