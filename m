Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13891D50F
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705647837; cv=none; b=RBXnOuLvXbQZ71E86R/9/SMATQJjKcgt0dWc4/RTUi9vHaY6ulUmu2bVRkR4Nbrb8zi243hdwKz9FomU63yG3uCIHvPcIImCtwXQzMzOIMNbdvZ9mKVotA9TZpnhaepsKNXvI/Wv+VRwlyZnmMD5VE8ZKzN5J8MhBZdqoUU1gI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705647837; c=relaxed/simple;
	bh=GTxbW1SL3JK2YAurPq5xcsLPZ5gXrwIQUJEtjtQG+Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjDAJ83EpLkW3IVzNLkwj+CoRHRB5drhBGGSSVAY+JCIZRWr/nspU+H5LnRFJGUur7h4ZELfmNZgpalVOXddW8QwoMOinn3QVdDBKozwWV3iTx1Mbhh6ApjE+LGZ1EB3VJXIJ0WYti4QsBYmzm9G2dF5B14nqGM2HChljRGtH2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eV3kmnSo; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eV3kmnSo"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6dc20b4595bso315880a34.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 23:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705647835; x=1706252635; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X8Arh70fDu03R+d/hJeo95Gy62+3eiFjD0bJ2gIwqPM=;
        b=eV3kmnSorKWmDAAfis2Zj46CD2XpDD+SkhGueWah1QDwXJg8T3HmdsvqHWGqYqXQ8X
         /bxFaC2snOVtp3TU6LEbLc0jiZCvi+dsgKYC32bCRqcVUkmyd+AGkhdp71L7BSJdKWEw
         tLpcvPmaVj/JHJK9A/3ZIY72El7m26LFtFEUDuTlYMl+cRpX5C+7QS6MJcf7WAaBjS3w
         wuzr0ptFFZFIFhcbX8vZ5oyL6cxOT7RiD/5SfQRsTgnzB5A5sYD1O34FUNhqDFoUbhnD
         L4CgEVxMtPbZn+gRAqgif2QJcAef0laX1PqWTsEIpLqv9oa45oWxz9ZLx2LZDgUmd9Cj
         6WWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705647835; x=1706252635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8Arh70fDu03R+d/hJeo95Gy62+3eiFjD0bJ2gIwqPM=;
        b=deq9Gov5D/WpiGA67yXGFeFpXqGgFS1qbNPFSMhAQ991av8YQ9OFZdPHMf5YWECDVm
         KJ7WhI1OmE8bHqcNkuP+wbI9fYw8PbssFKWkQ/STdl5ch0ppfLhfhoHZuuvPUJhs4Vux
         CGROv7SPBaN/hQUUazBmGPoYRXFDQGArK63kQBlQT54PYRyuEPLlnuDOoPYlIMS3tnPw
         AgUFu7D/9V2mJ7okwjmueZ7Nl1llbFiqg9e5jGO3KiVHWRvcd/JvAncEGl2NSLd4Yykh
         asIFRJ1NzVePpwQ9YEW1SAkVIcu3v4OCsKYzqxRWVwteG6xsr4DBKqTSuOkyR4Ls8cie
         yVSA==
X-Gm-Message-State: AOJu0YzhRrmkiq8WmSoZYi4NB3I7ZBsgNDiDRFmJKtfXW5HY130mcpzz
	G06kQp85giHPrOxUfzU8r8dYLf1c/KxG0M71cCczNev3czCx4XRGqH5tXkLkht0=
X-Google-Smtp-Source: AGHT+IGuHSygKsIPmCDnm1lLQ8LYQFBOogvEUeCXCoi5rvnUk3bTNh1cG6MUoT1bMmn9V+T6HwBtfA==
X-Received: by 2002:a05:6359:45a9:b0:176:25b:64f5 with SMTP id no41-20020a05635945a900b00176025b64f5mr2689090rwb.26.1705647834866;
        Thu, 18 Jan 2024 23:03:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id q16-20020a056a00085000b006d9aa04574csm4338227pfk.52.2024.01.18.23.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 23:03:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rQius-00CMBs-2K;
	Fri, 19 Jan 2024 18:03:50 +1100
Date: Fri, 19 Jan 2024 18:03:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: use folios in the buffer cache
Message-ID: <Zaoe1jbUR5a0voiO@dread.disaster.area>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-3-david@fromorbit.com>
 <20240119012624.GQ674499@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240119012624.GQ674499@frogsfrogsfrogs>

On Thu, Jan 18, 2024 at 05:26:24PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 19, 2024 at 09:19:40AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Convert the use of struct pages to struct folio everywhere. This
> > is just direct API conversion, no actual logic of code changes
> > should result.
> > 
> > Note: this conversion currently assumes only single page folios are
> > allocated, and because some of the MM interfaces we use take
> > pointers to arrays of struct pages, the address of single page
> > folios and struct pages are the same. e.g alloc_pages_bulk_array(),
> > vm_map_ram(), etc.
> > 
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> > @@ -387,9 +387,9 @@ xfs_buf_alloc_pages(
> >  	for (;;) {
> >  		long	last = filled;
> >  
> > -		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
> > -						bp->b_pages);
> > -		if (filled == bp->b_page_count) {
> > +		filled = alloc_pages_bulk_array(gfp_mask, bp->b_folio_count,
> > +						(struct page **)bp->b_folios);
> 
> Ugh, pointer casting.  I suppose here is where we might want an
> alloc_folio_bulk_array that might give us successively smaller
> large-folios until b_page_count is satisfied?  (Maybe that's in the next
> patch?)

No, I explicitly chose not to do that because then converting buffer
offset to memory address becomes excitingly complex. With fixed size
folios, it's just simple math. With variable, unknown sized objects,
we either have to store the size of each object with the pointer,
or walk each object grabbing the size to determine what folio in the
buffer corresponds to a specific offset.

And it's now the slow path, so I don't really care to optimise it
that much.

> I guess you'd also need a large-folio capable vm_map_ram.  Both of
> these things sound reasonable, particularly if somebody wants to write
> us a new buffer cache for ext2rs and support large block sizes.

Maybe so, but we do not require them and I don't really have the
time or desire to try to implement something like that. And, really
what benefit do small multipage folios bring us if we still have to
vmap them?

> Assuming that one of the goals here is (say) to be able to mount a 16k
> blocksize filesystem and try to get 16k folios for the buffer cache?

The goal is that we optimistically use large folios where-ever we
have metadata buffers that are larger than a single page, regardless
of the filesystem block size.

Right now on a 4kB block size filesystem that means inode cluster
buffers (16kB for 512 byte inodes), user xattr buffers larger than a
single page, and directory blocks if the filesytsem is configure
with "-n size=X" and X is 8kB or larger.

On filesystems with block sizes larger than 4kB, it will try to use
large folios for everything but the sector sized AG headers.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
