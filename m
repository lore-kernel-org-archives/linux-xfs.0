Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F9744C51D
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 11:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387199; cv=none; b=meabyIyEWJAk/C4ALDTtcr5CYKfhjBeooxSj7kevQYujhVJyJ7IhO1SO0uxD6sR4n6OCo58hVu5FQllBV/pfXh8NJ6npFuyYipewtTP6+k73khGKihWhMYfzCVa2k0sgNLgCY8pIyqDW5SgU1Kkk1y6C+aEyW5Q6JD14JH8KriA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387199; c=relaxed/simple;
	bh=zPbo450vcdGk3lJ0WO66x0cUun1k9tRqWGGw3mEZoqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQaeOJsUThU2oIrCTn3nP+YY9wPKyJwQWc3KbszQCZxk8WuHSZ0gQe2KSGUs0kaymxsKmu+8D33FSGkCTKWd2tkkWhnHTjEheoyQdF7ET8lM3Djr3sxMJnGgFPLnZ1yKKeZfCUT//G7PmoZbEhbiwgQWP1atANKKo9BXWWkOdlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9B1768BFE; Mon, 14 Sep 2026 13:59:44 +0200 (CEST)
Date: Mon, 14 Sep 2026 13:59:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Carpenter <error27@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: fix racy open zone caching
Message-ID: <20260914115944.GA23565@lst.de>
References: <aqfgjXJ8yANKjlwa@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqfgjXJ8yANKjlwa@stanley.mountain>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 14, 2026 at 02:54:53PM +0300, Dan Carpenter wrote:
> 	fs/xfs/xfs_zone_alloc.c:823 xfs_get_cached_zone()
> 	error: we previously assumed 'oz' could be null (see line 813)

The warning is correct.  I actually ran into it this weekend while
running benchmarks and sent a fix just a few minutes ago...

>     809          */
>     810         if (oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
>     811                 spin_lock(&ip->i_flags_lock);
>     812                 oz = VFS_I(ip)->i_private;
>     813                 if (oz && oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
>                             ^^
> imagine oz is NULL
> 
>     814                         VFS_I(ip)->i_private = NULL;
>     815                         spin_unlock(&ip->i_flags_lock);
>     816                         xfs_open_zone_put(oz);
>     817                         oz = NULL;
>     818                         goto out_unlock;
>     819                 }
>     820                 spin_unlock(&ip->i_flags_lock);
>     821         }
>     822 
> --> 823         if (!atomic_inc_not_zero(&oz->oz_ref))
>                                           ^^
> then this will crash
> 
>     824                 oz = NULL;
>     825 out_unlock:
>     826         rcu_read_unlock();
>     827         return oz;
>     828 }
> 
> This email is a free service from the Smatch-CI project [smatch.sf.net].
> 
> regards,
> dan carpenter
---end quoted text---
