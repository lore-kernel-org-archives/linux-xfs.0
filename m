Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBF72135B8
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 11:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736940067; cv=none; b=XxAkXJRB4sjdMAAz8f4gT+UKlQD1jDjyT448FyaZZqmtpqxg1Basd+K2vSFtyGkjJQ71oRY5QcashEnzO+zCVBStfEIMqjBJPif9c2G98cuAJdhcu+TTS39pOJdB3ypxs+9jLCAl5PuqQOkIb7xgfi7RWVu3AWKDlAcqGltCo6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736940067; c=relaxed/simple;
	bh=WNa/jfR6BK+OZnwQTI7l2ACfTdXZo+HPHrwo6JSCMZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOZNER28+LMMCjaiLb7apZH/VfAQ22uQy1HORdMt7R6yb3NNCYz9Gv1VczHs448whq0rNEhiOPnr9SoFKQbMSpfTiTOUha+88MnfBWugaXFL6YDbQNN3D8ZmHvN2G5E3DOz5p/bKDY7NEVG5nordLobMIOluttnBLJ4F3zV722g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XvlLr5f9; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XvlLr5f9"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2163dc5155fso120014425ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 03:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736940063; x=1737544863; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jVWuKlrBV2x5+y/k62DNDuCFR3QgDI8k3Jg4O3Y0trI=;
        b=XvlLr5f9rGHu0rQyhCICc2Kiu/W4U7/NZ1Ny2F3CVGzaPd7BXDPNQ/ljQWZlicJGKF
         jWTLfG5by9Vpn3SpAAOgigaSEHJKpVFKi3sWad/MsjKO2LkxYOO/l2ylJiq0UKrutCkX
         BCfp4qtJjArda7YhNMI8JVZZSB6ln00d7fW+smTzRp2n9RrGAGkQfCdzdMThh1De1zHF
         5ePHfik+VLDqJLOIInD5IDD1eHgGw+jmNa2tEhl5do3xV3OxX+mvOBl256sgFxg+2Iml
         y4IzTzzMintvuxpz0w+/+fdKwSN2asrJTmytTcWdFTBl8WMQ2c8k9qSsB7vHYZrD6m1C
         mS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736940063; x=1737544863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVWuKlrBV2x5+y/k62DNDuCFR3QgDI8k3Jg4O3Y0trI=;
        b=GVttVpIqOUzk/PmG/QsSayRhBMXNyLxyxMkNh2O3Dzy8whjYvuJCrGsfAw2BCFwaoy
         D1zxBx4SMuCvFqOP2N+Y/Ys5QLcIcVvhR3BOJW085bXUa4g7rIhXKZdjC/No4zMj4RaF
         Kr6e73/uQkDwUkL80+oQ+vYVd/v/lCl4+Q/S+nYzVdBbTzqZuE5UK6sY5bCoohvrbau3
         kOJtkgOsfyFAdf9zEsvROlc6WWEAaMrpLsoNNy3GzxiA1T0rQLIEfvfrSgut6LX1mkFz
         oIkBMQlamTYUngMbnuoT1Uhfi5l/d0IZ84b2mVno+qAGv6ln20BCOYnBRIoFFZokzUwg
         eqUg==
X-Forwarded-Encrypted: i=1; AJvYcCVh1sA4wIwcFh7sQ63hNK3Go2wOgAmLoUA3iivLJqx+goaf9AzNrf+xEYH5ulcqXOW8x7i/3qgcnV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuhZ+To2ZzfSjNpUJ8R8Qfdyary1zhsfbtknfecWm/KKjNX0Um
	3hGglQfHzNB0oPN3szAokgO8nHHSvaKTSguncBOxuWw2gTwWJ/sEVGWbqrWY3Po=
X-Gm-Gg: ASbGncs3gBZGZaPUh+v6zfrheC/bconeEPsHeTcaFPvgps0pTdSw4PgeEdupJBLBM/H
	X79Z3PBxJE/71LghUKFVc6dLvgSrhLcAdGCX4CmSRVgTNwHVP+d+Adbt/o/pkczjZM28pg0l7IQ
	rT2+JWSq7zF5FAeBL6Uk2PyTpniEJsSGQyZQ1T5DRnBYOk4eRAzkRiPoLjor8F67JgMaPAxZKEk
	fCq38nJEsLGqB68R+xKVZEFKoMVlzKLbdCVDZ1Tvn71j4hSCFqK1bEjuiGjmAoq4nLjkaXT8yLP
	c5gVpXgBLr6KQnYTtwojuw==
X-Google-Smtp-Source: AGHT+IG7ItAbf+cQiPO9JOWmNWrKrpX2b4HJkB/kl5GIIj07jFhdhz0wz+k+UDtii6KbCdAXxEzMTQ==
X-Received: by 2002:a17:902:f706:b0:216:69ca:773b with SMTP id d9443c01a7336-21a83f4b2bfmr431413885ad.5.1736940063268;
        Wed, 15 Jan 2025 03:21:03 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10f4d7sm79631525ad.10.2025.01.15.03.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 03:21:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tY1SG-000000069af-0Wfv;
	Wed, 15 Jan 2025 22:21:00 +1100
Date: Wed, 15 Jan 2025 22:21:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix buffer lookup vs release race
Message-ID: <Z4eaHPdwYgPYc217@dread.disaster.area>
References: <20250113042542.2051287-1-hch@lst.de>
 <20250113042542.2051287-3-hch@lst.de>
 <Z4V9wg8dbLXvq8hy@dread.disaster.area>
 <20250115053800.GA28704@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115053800.GA28704@lst.de>

On Wed, Jan 15, 2025 at 06:38:00AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 14, 2025 at 07:55:30AM +1100, Dave Chinner wrote:
> > The idea behind the initial cacheline layout is that it should stay
> > read-only as much as possible so that cache lookups can walk the
> > buffer without causing shared/exclusive cacheline contention with
> > existing buffer users.
> > 
> > This was really important back in the days when the cache used a
> > rb-tree (i.e. the rbnode pointers dominated lookup profiles), and
> > it's still likely important with the rhashtable on large caches.
> > 
> > i.e. Putting a spinlock in that first cache line will result in
> > lookups and shrinker walks having cacheline contention as the
> > shrinker needs exclusive access for the spin lock, whilst the lookup
> > walk needs shared access for the b_rhash_head, b_rhash_key and
> > b_length fields in _xfs_buf_obj_cmp() for lookless lookup
> > concurrency.
> 
> Hmm, this contradict the comment on top of xfs_buf, which explicitly
> wants the lock and count in the semaphore to stay in the first cache
> line.

The semaphore, yes, because locking the buffer is something the fast
path lookup does, and buffer locks are rarely contended.

Shrinkers, OTOH, work on the b_lru_ref count and use the b_lock spin
lock right up until the point that the buffer is going to be
reclaimed. These are not shared with the cache lines accessed by
lookups.

Indeed, it looks to me like the historic placing of the b_lru_ref on
the first cacheline is now incorrect, because it is no longer
modified during lookup - we moved that to the lookup callers a long
time ago.

i.e. shrinker reclaim shouldn't touch the first cacheline until it
is goign to reclaim the buffer.  A racing lookup at this point is
also very rare, so the fact it modifies the first cacheline of the
buffer is fine - it's going to need that exclusive to remove it from
the cache, anyway.

IOWs, the current separate largely keeps the lookup fast path and
shrinker reclaim operating on different cachelines in the same
buffer object, and hence they don't interfere with each other.

However, the change to to use the b_lock and a non-atomic hold count
means that every time a shrinker scans a buffer - even before
looking at the lru ref count - it will pull the first cache line
exclusive due to the unconditional spin lock attempt it now makes.

When we are under tight memory pressure, only the frequently
referenced buffers will stay in memory (hence lookup hits them), and
they will be scanned by reclaim just as frequently as they are
accessed by the filesystem to keep them referenced and on the LRUs...

> These, similar to the count that already is in the cacheline
> and the newly moved lock (which would still keep the semaphore partial
> layout) are modified for the uncontended lookup there.  Note that
> since the comment was written b_sema actually moved entirely into
> the first cache line, and this patch keeps it there, nicely aligning
> b_lru_ref on my x86_64 no-debug config.

The comment was written back in the days of the rbtree based index,
where all we could fit on the first cacheline was the rbnode, the
lookup critical fields (daddr, length, flags), the buffer data
offset (long gone) and the part of the
semaphore structure involved in locking the semaphore...

While the code may not exactly match the comment anymore, the
comment is actually still valid and correct and we should be fixing
the code to match the comment, not making the situation worse...

> Now I'm usually pretty bad about these cacheline micro-optimizations
> and I'm talking to the person who wrote that comment here, so that
> rationale might not make sense, but then the comment doesn't either.
> 
> I'm kinda tempted to just stick to the rationale there for now and then
> let someone smarter than me optimize the layout for the new world order.

I'd just leave b_lock where it is for now - if it is now going to be
contended between lookup and reclaim, we want it isolated to a
cacheline that minimises contention with other lookup related
data....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
