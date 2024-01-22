Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF559481A1
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 21:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705957847; cv=none; b=jvGuAN5/pGBXK8oZ7n+A3L+j8lG+FAMsS7EOWcgIKsfnpyg3Fol7x7E5cBTb6s90HtEEeebIVsKzoJhHA1yR9RLuSl4RmzC5MxmfISGXOImjcaRR54lEZAs9BKuV3hrZMYZMeywk81j+QkAgHGrJ6wR8rUlD6XzaMp9IhMiBjV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705957847; c=relaxed/simple;
	bh=vC3WjR9eiS3egzgWXjR16FSJB5yh0XKkwNKSY9P0SSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLAfAI4SuAtWs8CnJIOpjdm4KMuAFNyxQ7gkvv0IvUrSez/wAjrIXaYHvYwePGJwnsB8mSRJeJiAr+b+nOO8Kfm3gFyyeBOCSZvWKscAFbP98dtrFfONjBsQrnlQznwzB56vzHBfKteIeW+ps0VuNtVuvyrCWwn93ArMfvh+xng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dpcHB/0w; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dpcHB/0w"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d7431e702dso9645095ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 13:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705957845; x=1706562645; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gbck5AucTZaxjbWeuuYe5wNSP+bnbEh0aXTJXBNZvyM=;
        b=dpcHB/0wqEUxrfgmCvadVWp5SBnqt8mXYECbjhNPESN6ZyPOGzqrmw3Za/ovUVYbGo
         ZQuJN+hDUt7kC1udMvtUm5AfYODoCDOQOXWiSLBaIE2QE/6BgPaeMEtOip4ATOsywdmB
         u8G0liSTl6F+CAX082YTmYuM5V86xeTMO9AQTJRvv85dQzocwJeSmQ7jPxJmLGDb4HFm
         Z/ITcRRLGCOBlyZxL8hBAFLH/MkTW8aMHvRPsswY0m6Ml0ri7zOkRd7mZI1BERIO7fnU
         feUtfkISMugCJnDimJuuVdT29XR/X5zv48Yf/heT5Xu1iW1mHOGOUHqoJFjBhNF2rx8q
         1hVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705957845; x=1706562645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbck5AucTZaxjbWeuuYe5wNSP+bnbEh0aXTJXBNZvyM=;
        b=VKcSMapn8BP/gGAuz677rwkFoabdxLXAwFKtelP/jO1SDx92AGSpUi1S7HqI+iP82v
         pgUDTGuiOUbE+HJUx32AYSW93aEkHXK40qFzdBAbsGspnkKf/Dtx9sSuKBdbnB1mn2Rz
         +k5iJaZiUGPWahHvhNDg/tQCa8pvVTBf7BY+SYowiPZ6CHWRw7AGLOMKAx05lkOnFB/r
         pgeFHbTyeU4tkrXVSc92l8dVCoAQyfItCqwqe1C0mzTLXOSupSngS0iCIIPPhK+bL4Z+
         GcBq1WYrdJneHA+KUM3b5vu6w1bU2vx0jPvg/lCJ2gUHGvyuwmlKvaTrIS/7UQmUYbVx
         ICsw==
X-Gm-Message-State: AOJu0Yy84c3gbsNFEg4dr0o8aGiDd9WFw3Z98NZSDNC0f2EyoGa9M9K3
	wyh9f6xiQqFSAl23LAt2ZNMgrt13MUA6GguaxSadC5G2CxTccvYpDTG85uxW8YU=
X-Google-Smtp-Source: AGHT+IHUu3jLG0QUgF7pUGQTAj/j46q0ifGLwypCNt/gsq+Kex4/+H6n2AOh5+p3Xnl4HX8Pfgsp5w==
X-Received: by 2002:a17:903:1c4:b0:1d7:2d68:cee8 with SMTP id e4-20020a17090301c400b001d72d68cee8mr2356123plh.45.1705957845195;
        Mon, 22 Jan 2024 13:10:45 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id i10-20020a17090320ca00b001d737d51411sm3636211plb.227.2024.01.22.13.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 13:10:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rS1Z2-00Dvph-2d;
	Tue, 23 Jan 2024 08:10:40 +1100
Date: Tue, 23 Jan 2024 08:10:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: use folios in the buffer cache
Message-ID: <Za7Z0CS696T9npwg@dread.disaster.area>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-3-david@fromorbit.com>
 <20240119012624.GQ674499@frogsfrogsfrogs>
 <Za4NkMYRhYrVnb1l@infradead.org>
 <Za5aANHuptzLrS6Z@dread.disaster.area>
 <Za5rQnj6NPqTE+CN@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za5rQnj6NPqTE+CN@infradead.org>

On Mon, Jan 22, 2024 at 05:18:58AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 22, 2024 at 11:05:20PM +1100, Dave Chinner wrote:
> > I haven't looked at what using vmalloc means for packing the buffer
> > into a bio - we currently use bio_add_page(), so does that mean we
> > have to use some variant of virt_to_page() to break the vmalloc
> > region up into it's backing pages to feed them to the bio? Or is
> > there some helper that I'm unaware of that does it all for us
> > magically?
> 
> We have a kmem_to_page helper for chuking any kind of kernel virtual
> address space into pages.  xfs_rw_bdev in fs/xfs/xfs_bio_io.c uses
> that for a bio, we should probably hav an async version of that
> and maybe move it to the block layer instead of duplicating the
> logic in various places.

Yeah, OK, as I expected. I'd forgotten that we already play that
game with xfs_rw_bdev(). I think we can trivially factor out an
async version and call that from the xfs_buf.c code fo vmalloc()d
ranges, so I think I'll work towards that and actually remove the
bio packing loop from xfs_buf.c altogether.

> > Yeah, that's kind of where I'm going with this. Large folios already
> > turn off unmapped buffers, and I'd really like to get rid of that
> > page straddling mess that unmapped buffers require in the buffer
> > item dirty region tracking. That means we have to get rid of
> > unmapped buffers....
> 
> I actually have an old series to kill unmapped buffers and use
> vmalloc, but decided I'd need use folios for the fast path instead
> of paying the vmalloc overhead.  I can dust it off and you can decide
> if you want to pick up parts of it.

I wouldn't worry about it too much - the rest of it is pretty
straight forward once we know inode cluster buffers are working
correctly with single large folios and we always fall back to
vmalloc().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
