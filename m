Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E1D3EBF08;
	Wed, 25 Mar 2026 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774455964; cv=none; b=eg5YB5pnu0XPBcyu/rXfWRQDgwlzajq6/cJNQ9NuMyJswlaMO3P7FAdKbsAe3MUR7LBGtNT6JooM4lOGYLFe9sMJremjx02CwoQjqQQb/EsjpSSUpDNjFUce5BrBY0uNE7E5LpHs53K5pepidhXMrr7Um78IaRCfbpsXuaLkt/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774455964; c=relaxed/simple;
	bh=D1i5YPn3nepsXs93Y3yzjR5xi7srB1NJEGzhg5tNUh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwkXVKQOKQvb+zwDV1QOfBdRDbhmGg31C+MTWTAcNarVZy0/QQURgogOB9Ec/bIcAqpixkbNyIz7cMQr5V2hPU9DpwEoWIE5ffEVCdbRP4NmP7qgs2O89Sw4tPLyGlFY27DQuA5GNqTxIp986iWffcZ6L3GA5HXlWIWsaXZrykA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H451FRpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H451FRpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ED5C4CEF7;
	Wed, 25 Mar 2026 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774455964;
	bh=D1i5YPn3nepsXs93Y3yzjR5xi7srB1NJEGzhg5tNUh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H451FRpvxj6W/wUJepeJeqwD2HaLpYiOjcnAFQFLYd1zrf0tNxBCMYib/8sbgTnDl
	 E9XUS9V2npYvDxkZZS6wzjIebTHBCFot6rljh7KiordjLkgymLg4Su5kHgItNO7aDw
	 Mq+00OcZ5O9/oSXtH8GJeoRn5w26Yi67/PA75L1n1aedt/eCRnhwN1P7eOTPTbzUHv
	 AhFtsLlxuOyxOpQkogHPmr6WejMj9icfWk7dvcHA5nuwykYzarrJPhz8yrZWyFU6uA
	 JFRvSYFRKLnZZh1kx0utkkrbkptYIooI1udWvhMIXFVpEr92XBC84YrjaLmUDESEKj
	 njVh1bSJYvbXw==
Date: Wed, 25 Mar 2026 09:26:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 07/25] iomap: introduce IOMAP_F_FSVERITY and teach
 writeback to handle fsverity
Message-ID: <20260325162603.GV6223@frogsfrogsfrogs>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-8-aalbersh@kernel.org>
 <20260325080021.GF952@lst.de>
 <std5dib2mf5nfd2gf3jbrhujvqr2tytczplopwfy4zrxrrmrgj@py7g4alrifbi>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <std5dib2mf5nfd2gf3jbrhujvqr2tytczplopwfy4zrxrrmrgj@py7g4alrifbi>

On Wed, Mar 25, 2026 at 01:38:07PM +0100, Andrey Albershteyn wrote:
> On 2026-03-25 09:00:21, Christoph Hellwig wrote:
> > > @@ -353,9 +353,16 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
> > >  {
> > >  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> > >  
> > > -	return srcmap->type != IOMAP_MAPPED ||
> > > -		(srcmap->flags & IOMAP_F_NEW) ||
> > > -		pos >= i_size_read(iter->inode);
> > > +	if (srcmap->type != IOMAP_MAPPED)
> > > +		return true;
> > > +
> > > +	if (srcmap->flags & IOMAP_F_NEW)
> > > +		return true;
> > > +
> > > +	if (srcmap->flags & IOMAP_F_FSVERITY)
> > > +		return false;
> > > +
> > > +	return pos >= i_size_read(iter->inode);
> > 
> > This might be a good time to document the various reasons for needing
> > zeroing.
> 
> something like this?
> 
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -344,9 +344,27 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
>  {
>         const struct iomap *srcmap = iomap_iter_srcmap(iter);
>  
> -       return srcmap->type != IOMAP_MAPPED ||
> -               (srcmap->flags & IOMAP_F_NEW) ||
> -               pos >= i_size_read(iter->inode);
> +       /*
> +        * If this block is not mapped, we don't have any backing blocks to read
> +        * yet

	/* If this block has not been written, there's nothing to read */

> +        */
> +       if (srcmap->type != IOMAP_MAPPED)
> +               return true;
> +
> +       /*
> +        * This block just got allocated and does not contain any meaningful data
> +        */

	/* Newly allocated blocks have not been written */

Otherwise looks good to me.

--D

> +       if (srcmap->flags & IOMAP_F_NEW)
> +               return true;
> +
> +       /*
> +        * fsverity metadata is stored past i_size, we need to read it instead of
> +        * zeroing
> +        */
> +       if (srcmap->flags & IOMAP_F_FSVERITY)
> +               return false;
> +
> +       return pos >= i_size_read(iter->inode);
>  }
> 
> > 
> > > +/*
> > > + * IO happens beyond inode EOF, fsverity metadata is stored there
> > > + */
> > > +#define IOMAP_F_FSVERITY	(1U << 10)
> > 
> > This comment feels a bit too sparse.  Here is my interpretation of what
> > this flag does:
> > 
> > /*
> >  * Indicates reads and writes of fsverity metadata.
> >  *
> >  * Fsverity metadata is stored after the regular file data and thus beyond
> >  * i_size.
> >  */
> 
> Thanks! I will update it
> 
> -- 
> - Andrey
> 
> 
