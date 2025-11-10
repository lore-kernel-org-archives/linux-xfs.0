Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A82652AF
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762812158; cv=none; b=Xl/ijdo+7hmDqTUPk9k7eqPJ90YACmE/RCxgsQaImCVd8JhNgV5U0FF3JyIkKeJRlCPvhIZDVLpGiFFe6M+M2MJq4iAqTwyBdyNMhed3vnihspjjILSJiPIqWR6Mk4JQ8ZyyY7Q5XW2zJmn2s6vthkBX51TnOKa9hNxKZHkOSaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762812158; c=relaxed/simple;
	bh=cRNbHUfExnEEJ0tF1zvmmPm68Hpg+4ITzVdArtOg9Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ocjs93Zu/Zk4l/9Gaj5yehgdTv2bRL6U0ZtmEbjyyQHZUjBL82Frjc6Pn0tdnM6TDNNMGpakjZY9eyQVXHKZ3cb9R/bw5cKzeAk83sbuf9/Pb2J15stnXoGSR0spdH97/Emx3J8UiJHlIRLH4/3t10s07oIcFQ4tAXC30SazNHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lLedqyaL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lLedqyaL"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3436cbb723fso2089907a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 14:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762812156; x=1763416956; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TETysHrOg5uEIq3OFEiOP5WeHwRydqyfloSGxw9yy9I=;
        b=lLedqyaLQ0HrgGGA3wQPY0L/H/8HIUjOOIAmOd6Zv+T+Dix4hUzlPxUvsvx7p0XYqy
         11pofpa2/6VBQJ4Mrn84ucm9qaWqCAM+rxHGeIm8j11YC73pl7rDT57QeZJKvDrhvSgP
         mjAYD58VXrRvPWJCrkAyt5n6DcgFWu2JOMRw6hS6YuZa8pmZepW3wr/mM9T8zXdokhb5
         vx7BXjkfMgoA/VyzIS9FvBwgCa9NvAosW6CLOFNPwHJtgQw6bdfoCGVALVDcgZrR/ol1
         PF+L7OO2W7pTd4pfvtU7930Jwj+V25fdJKKCwhWlSbfAehRfcdjGQfoqeoAXBXd5Lk8T
         mZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762812156; x=1763416956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TETysHrOg5uEIq3OFEiOP5WeHwRydqyfloSGxw9yy9I=;
        b=rptIAl9uWzpbC6WgO8VqYN38m7onWNtTS4pq4oeR3HtI7S+4LnmzBi1DqOWCpuf5e8
         HAFF7UBleCa7adRHCCPyJwl+QKoGjVChVeihtFKA/irDWYGrDqZZrPv2aLD1IiDeitPr
         0UUfGgSpb8oSbdl7HddQR8TnoaLNYq6uDykpz+dEDCv3g7lTCI7RYUg5zOSWDXZRrw5L
         E7OkOB+yBoOyIix3rKTs+WyqYWKPjQ9owJrfGfJynrpebiuAcZwYbKMbsgJiolMpt2kx
         E57QTualmHziPf5wrBl8iHpAOUus5jUUCg3bIjnGaizPXn56oP9bnsgP3/9vMq6gGJ7H
         me9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVOpK3SmUGPrads6tK/kDOWnAL4zgljn62kdQlLcz0HBXXyX0G53+cNkghpVokpJF+4hodUq7281RU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5P8fq1WkjggVa7fFpg03c9eUnwCj7lt1br0qmR15sddH8XuTt
	8579+1sthUcyuPrtMAXRVRSOTVA94ruviXoXQ8R20cgWCc8fPqVkDV74UucbvqjMJb2QFY4SoRI
	ko8wH
X-Gm-Gg: ASbGncucjXkLVUA8FK6z3FHgEF+zmy4ZBJ6MFecsIMR+PeE1VOq/rftGlgNeuttsBdi
	3ogqW1MGN+7rWdXqYl0EEjzkhArbnR63e1BenJU+F0eDHDyo7G5wTiKZfDdYNZd/Awep/6VPdwH
	bjfGvA3l886Mqkc0wy4vUvzHPSZBs42YuTRWc7lLWAfNfyIDi+qxIVPjjsPdMVb0O0z7kjGCjeX
	ZN6ZeqyglRRXhfigZgvNu+MdLjDkv0Oi0Ip6NMrVl1JFr004XllZaXU4Hg9Gjn3mMZhhjhUcZep
	9GWfy+hxjtJk4VqGDqhOWWw2RjuOb4Q7epHNQb+lIn6pbF2fQZ4S9O0GNIzuvy5Sp/vfvot5mSr
	ekQuhsThiRDFQHPT08F3RknKxwEAN5v6LUxyai1hnLRT7cCzu+yhPy59WwygUakwXIJRcgCQ4pT
	kedE7/gTleJ11g07zgtEqM3Ji1z6Yvc5L7OnUx0nMOUjzkqTm2dn3+Voj/44ZCm0krySkjVB2g
X-Google-Smtp-Source: AGHT+IFR8z9DnJBvdXwGEhypIzC3f1QmO1iA8elXy2Lh+piu6Xqwnps05L/wVYV01vg0pUTl4qDMHQ==
X-Received: by 2002:a17:90a:d403:b0:341:2150:4856 with SMTP id 98e67ed59e1d1-3436cbf299cmr13532473a91.17.1762812156071;
        Mon, 10 Nov 2025 14:02:36 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c31d86esm12407231a91.8.2025.11.10.14.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 14:02:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vIZy4-000000096ZX-2VVb;
	Tue, 11 Nov 2025 09:02:32 +1100
Date: Tue, 11 Nov 2025 09:02:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: fs-next-20251103 reclaim lockdep splat
Message-ID: <aRJg-LcA8RGeqOgQ@dread.disaster.area>
References: <aQux3yPwLFU42qof@casper.infradead.org>
 <aQu8B63pEAzGRAkj@dread.disaster.area>
 <aQySlxEJAHY5vVaC@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQySlxEJAHY5vVaC@bfoster>

On Thu, Nov 06, 2025 at 07:20:39AM -0500, Brian Foster wrote:
> On Thu, Nov 06, 2025 at 08:05:11AM +1100, Dave Chinner wrote:
> > On Wed, Nov 05, 2025 at 08:21:51PM +0000, Matthew Wilcox wrote:
> > > In trying to bisect the earlier reported transaction assertion failure,
> > > I hit this:
> > > 
> > > generic/476       run fstests generic/476 at 2025-11-05 20:16:46
....
> > As I said on #xfs: false positive on the inode lock.
> > 
> > Reclaim is running in GFP_KERNEL context, so it's allowed to lock
> > unreferenced inodes.
> > 
> > The inodes that the allocation context holds locked are referenced
> > inodes, so it cannot self-deadlock on the inode locks it holds
> > because reclaim does not access or lock referenced inodes.
> > 
> > That being said, looking at this patch:
> > 
> > https://lore.kernel.org/linux-xfs/20251003134642.604736-4-bfoster@redhat.com/
> > 
> > I think the allocation that iomap_fill_dirty_folios() should
> > probably be using mapping_gfp_constraint(mapping, GFP_KERNEL) rather
> > than a hard coded GFP_KERNEL allocation. This is deep in the
> > buffered write path and the xfs ILOCK is held when
> > iomap_fill_dirty_folios() and it does folio lookups in that
> > context.
> > 
> 
> There's an outstanding patch to nuke this allocation completely:
> 
> https://lore.kernel.org/linux-fsdevel/20251016190303.53881-2-bfoster@redhat.com/
> 
> This was also problematic for the ext4 on iomap WIP, so combined with
> the cleanup to use an iomap flag this seemed more elegant overall.

Ok, that looks like a good way to get rid of the allocation, so
you can add

Acked-by: Dave Chinner <dchinner@redhat.com>

to it.

> The patch series it's part of still needs work, but this one is just a
> standalone cleanup. If I can get some acks on it I'm happy to repost it
> separately to take this issue off the table..
> 
> > Huh - that kinda feels like a lock order violation. ILOCK is not
> > supposed to be held when we do page cache operations as the lock
> > order defined by writback operations is folio lookup -> folio lock
> > -> ILOCK.
> > 
> > So maybe this is a problem here, but not the one lockdep flagged...
> 
> Yeah.. but filemap_get_folios_dirty() is somewhat advisory. It is
> intended for use in this context, so only trylocks folios and those that
> it cannot lock, it just assumes are dirty||writeback and includes them
> in the batch for locking later (where later is defined as after the
> iomap callback returns where iomap typically does folio lookup/lock for
> buffered writes).

I guess I don't understand why this needs to be done under the
ilock. I've read the patches, and it doesn't explain to me why we
need to look up the pages under the ILOCK? The only constraint I see
is trimming the extent map to match the end of a full fbatch array,
but that doesn't seem like it can't be done by iomap itself.

Why do we need to do this dirty-folio batch lookup under the
ILOCK instead of as a loop in iomap_zero_range() that grabs a fbatch
for the unwritten mapping before calling iomap_zero_iter()
repeatedly until we either hit the end of the mapping or there are
no more dirty folios over the mapping?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
