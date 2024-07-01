Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84A510F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719795079; cv=none; b=ehRl/UCJBbLs/tDVhO1Mpe8YxvPT5eqjTRsjVHdQvLg64N9j6pAIGTwbogKvFj7RPJ7LpJcjKFT86pIN3jm3G5CsU+4o8Di78E+prvShsgAKpKJOuvIBnCKEQeGVweP6ISJA+ctPlFxF5dMl6rNTgXxZZwix/EDmgo5j0ZDmJts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719795079; c=relaxed/simple;
	bh=hr9gdzshpFzQmPvL3ZRAUjLw+TmTlbHROzGD/vC5ciI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDeuUPCVw/z9cZG3OJPcwrZD/qvQ3dZRYMhHfQcFv/8COqZlwXPq8PoViGTKSpg+QwYAifcWOPNVX7wfd1ksyuNYqgF2WlTQQnTgWwmtNIgIieHulOGROIHB/QUaX/pyKp1YBuYYB4pw7gJ7L8Fh7RRsCCGG0Dv/t4CM1d0BnRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RdOfQywN; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RdOfQywN"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-701fb69e406so900777a34.3
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 17:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719795077; x=1720399877; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BRy9gpTqjPsDTNmbbMNYv903/wEg0NdHPwtiMwt6OR4=;
        b=RdOfQywNWLM3IDMLN/Pn2D3qgf7QTv51iPV+SCwJlXDFerFX/Ngtgu3D4J4jU8IaGf
         HQeumdjGt56H/TqJaU3Qaf5hIWgHEFkAk2Tir/jje7sYzoOi0VaivEEfuc86/F6ClKUO
         pnvk9/8c0CJiVHEYDWxrbCBu8PVgclW0Gc5O5kKj1hcGR57Go7GKckCN0lfmguAWmzeV
         cDRoBfg3BOSL7e52BbAvPxhm9HPB8Bx/aIoMXmpK2cFLUtqrBIKAe+vJbjJwFdNuNSKN
         xonezYuvkYMc4MRzdnlMuDNhgwwjjeO+5neNSTjH7mdGU+L17GSzXLEE962ypRBlQiA2
         xIrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719795077; x=1720399877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BRy9gpTqjPsDTNmbbMNYv903/wEg0NdHPwtiMwt6OR4=;
        b=dumSSq1E0ttE9XyMNpie2SP/EBYb6GsZcfJjqtywEkxu/J0bt/DroNUM+EACUKjlMX
         L08P5Xhz4pXqHlVD4iCr9Y8sTqsawYFchUeOOWhCSVL3DaMx76ibzICnvne11/4cGQQF
         VeimVMEvn1PEuGW1lwsEbh/2xk+HaQrC98F8PoCi5rAkAzdQUwlc0H8TqNl3aoBzqXYW
         AWGF4XU7ApWj/7E1w0OjDja3fKOtr96wRfswaJUs2aOtpsqdyi5KTUytmyHkkpZRE3HH
         oziHbn84pdaU41I/DReJdgHbNBgs9BmviS5ioujLYWJq76r30yDeOb7/fACZgf3XQKGX
         7poQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4Qh1+KnTIA7pPRzpIG48yYT5ioglkmHQpOffSaQOzLGTzVF4kJlhXES+D3W+Af/fCGA0yRsODz8CpDYmqyWHNxYZT4jiTPHo4
X-Gm-Message-State: AOJu0YwLXlMB9JZ1blA76eoOWsolOptwfEbF6fmwLKb5wyHsAOAJJzxj
	vJDq1Yw1bEPJOunIY/3NMZrDzb+LYkbyuItoD7Tli8SaYoNz2xaTPxG/I9M1Lr0=
X-Google-Smtp-Source: AGHT+IHwf+hkdxjvEUS1SSgOqiQynwxq7WtMiWRzYfBDFBW3X2YyYuAHnU7Wo8v0yTr7hdPVqncAKA==
X-Received: by 2002:a05:6870:1584:b0:259:8463:43a6 with SMTP id 586e51a60fabf-25db35870cdmr2243202fac.34.1719795076526;
        Sun, 30 Jun 2024 17:51:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70801f584b2sm5220058b3a.43.2024.06.30.17.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 17:51:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO5GD-00HLeT-0g;
	Mon, 01 Jul 2024 10:51:13 +1000
Date: Mon, 1 Jul 2024 10:51:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: alexjlzheng@gmail.com
Cc: chandan.babu@oracle.com, djwong@kernel.org, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: Re: [PATCH v3 2/2] xfs: make xfs_log_iovec independent from
 xfs_log_vec and free it early
Message-ID: <ZoH9gVVlwMkQO1dm@dread.disaster.area>
References: <20240626044909.15060-1-alexjlzheng@tencent.com>
 <20240626044909.15060-3-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626044909.15060-3-alexjlzheng@tencent.com>

On Wed, Jun 26, 2024 at 12:49:09PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> When the contents of the xfs_log_vec/xfs_log_iovec combination are
> written to iclog, xfs_log_iovec loses its meaning in continuing to exist
> in memory, because iclog already has a copy of its contents. We only
> need to keep xfs_log_vec that takes up very little memory to find the
> xfs_log_item that needs to be added to AIL after we flush the iclog into
> the disk log space.
> 
> Because xfs_log_iovec dominates most of the memory in the
> xfs_log_vec/xfs_log_iovec combination, retaining xfs_log_iovec until
> iclog is flushed into the disk log space and releasing together with
> xfs_log_vec is a significant waste of memory.

Have you measured this? Please provide numbers and the workload that
generates them, because when I did this combined structure the
numbers and performance measured came out decisively on the side of
"almost no difference in memory usage, major performance cost to
doing a second allocation"...

Here's the logic - the iovec array is largely "free" with the larger
data allocation.

------

Look at how the heap is structured - it is in power of 2 slab sizes:

$ grep kmalloc /proc/slabinfo |tail -13
kmalloc-8k           949    976   8192    4    8 : tunables    0    0    0 : slabdata    244    244      0
kmalloc-4k          1706   1768   4096    8    8 : tunables    0    0    0 : slabdata    221    221      0
kmalloc-2k          3252   3312   2048   16    8 : tunables    0    0    0 : slabdata    207    207      0
kmalloc-1k         76110  96192   1024   32    8 : tunables    0    0    0 : slabdata   3006   3006      0
kmalloc-512        71753  98656    512   32    4 : tunables    0    0    0 : slabdata   3083   3083      0
kmalloc-256        71006  71520    256   32    2 : tunables    0    0    0 : slabdata   2235   2235      0
kmalloc-192        10304  10458    192   42    2 : tunables    0    0    0 : slabdata    249    249      0
kmalloc-128         8889   9280    128   32    1 : tunables    0    0    0 : slabdata    290    290      0
kmalloc-96         13583  13902     96   42    1 : tunables    0    0    0 : slabdata    331    331      0
kmalloc-64         63116  64640     64   64    1 : tunables    0    0    0 : slabdata   1010   1010      0
kmalloc-32        552726 582272     32  128    1 : tunables    0    0    0 : slabdata   4549   4549      0
kmalloc-16        444768 445440     16  256    1 : tunables    0    0    0 : slabdata   1740   1740      0
kmalloc-8          18178  18432      8  512    1 : tunables    0    0    0 : slabdata     36     36      0

IOws, if we do a 260 byte allocation, we get the same sized memory
chunk as a 512 byte allocation as they come from the same slab
cache.

If we now look at structure sizes - the common ones are buffers
and inodes so we'll look at then.

For an inode, we typically log something like this for an extent
allocation (or free) on mostly contiguous inode (say less than 10
extents)

vec 1:	inode log format item
vec 2:	inode core
vec 3:	inode data fork

Each of these vectors has a 12 byte log op header built into them,
and some padding to round them out to 8 byte alignment.

vec 1:	inode log format item:	12 + 56 + 4 (pad)
vec 2:	inode core:		12 + 176 + 4 (pad)
vec 3:	inode data fork:	12 + 16 (minimum) + 4 (pad)
				12 + 336 (maximum for 512 byte inode)

If we are just logging the inode core, we are allocating
12 + 56 + 4 + 12 + 176 + 4 = 264 bytes.

It should be obvious now that this must be allocated from the 512
byte slab, and that means we have another 248 bytes of unused space
in that allocated region we can actually use -for free-.

IOWs, the fact that we add 32 bytes for the 2 iovecs for to index
this inode log item doesn't matter at all - it's free space on the
heap. Indeed, it's not until the inode data fork gets to a couple of
hundred bytes in length that we overflow the 512 byte slab and have
to use the 1kB slab. Again, we get the iovec array space for free.

If we are logging the entire inode with the data fork, then the
size of the data being logged is 264 + 12 + 336 + 4 = 616 bytes.
This is well over the 512 byte slab, so we are always going to be
allocating from the 1kB slab. We get the iovec array for free the
moment we go over the 512 byte threshold again.

IOWs, all the separation of the iovec array does is slightly change
the data/attr fork size thresholds where we go from using the 512
byte slab to the 1kB slab.

A similar pattern holds out for the buffer log items.  The minimum
it will be is:

vec 1:	buf log format item
vec 2:	single 128 byte chunk

This requires 12 + 40B + 4 + 12 + 128B + 4 = 200 bytes. For two
vectors, we need 32 bytes for the iovec array, so a total of 232
bytes is needed, and this will fit in a 256 byte slab with or
without the iovec array attached.

The same situation occurs are we increase the number of logged
regions or the size of the logged regions - in almost all cases we
get the iovec array for free because we log 128 byte regions out of
buffers and they will put us into the next largest size slab
regardless of the memory used by the iovec array.

Hence we should almost always get the space for the iovec array for
free from the slab allocator, and separating it out doesn't actually
reduce slab cache memory usage. If anything, it increases it,
because now we are allocating the iovec array out of small slabs and
so instead of it being "free" the memory usage is now accounted to
smaller slabs...

-----

Hence before we go any further with this patch set, I'd like to see
see numbers that quantify how much extra memory the embedded iovec
array is actually costing us. And from that, an explanation of why
the above "iovec array space should be cost-free" logic isn't
working as intended....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
