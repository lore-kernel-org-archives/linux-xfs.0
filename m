Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B63E2C08C4
	for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 11:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753962188; cv=none; b=by4lJQxwJ0QUH3xMLdZwTysAK7LIqQP0z3gCaMZN8S2Rz5TUvlZeavQwjZ4O5kjnOipBbsncpZC+UFUqVfKlIoXmLje+xyZbY3aeUHpdpRpIzWOxBo3ZMCUqgjufVGHExiKJfOHH03sR4GMcg6l1Uf7Xz7AMm96AG9zjDLjBxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753962188; c=relaxed/simple;
	bh=lPPR+xOELWOjgNYZPLA2fZ8JUQ13Q6IiXHiwQiLDycc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ATWALSVzGPJiOmgJeLdHNqNg7pBpZzDv8fen6k+l3bDRVEImh078wb1nB2hmCwSByR7XXQzXG3aHjTISHYP0M5rqOuHEdrWnd91NIORPsLlt0+CK+C6gjDJpXKPEbc/uBfJIMFMALiwCbsm3uSJGmAoPtR5dvD702DBqMaZVNWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KCTbntd6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCTbntd6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753962185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fo+NPNjMxlQ2cBw7t4Z+XizD1fhqWsIHl9ucwxzn9EA=;
	b=KCTbntd6qVXhfwzyzX2k7JNYnNUDA4GNy5gF53bWvMc+DFOJMfN4tIjgFkJc8f3EiRvmTW
	lRwPRznFd9xjiszJ6C9UHLfSq3KnJLGojzgmfWsZpEM3TyHU73rHU1R7NE5vGnaSPNBVU5
	S66pdtbjqWuFC9UFOKDww2COGorVPIA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-Z06lGBFHP8mnNgahGQRb3g-1; Thu, 31 Jul 2025 07:43:00 -0400
X-MC-Unique: Z06lGBFHP8mnNgahGQRb3g-1
X-Mimecast-MFC-AGG-ID: Z06lGBFHP8mnNgahGQRb3g_1753962177
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-af911f05997so30961266b.3
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 04:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753962177; x=1754566977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fo+NPNjMxlQ2cBw7t4Z+XizD1fhqWsIHl9ucwxzn9EA=;
        b=kAIK+MY3p4UrtIX9G1sqMRmCkpVjqK2tgnoZbi9YUtitS9nkLfB8odN5Ffl3DNmk7q
         fKNIuNBbszvAcfrMp7mDw5nyPOjCLU0UEyFc+a2atx0AOJIoUEynFksbvMB8ZMLG+luZ
         KrcnvTe7MytatxZQ9kV33SKLOzRLIgW2+fz2bzSqizAOZCeG37s+ds9+DlqXQXNFL/9i
         v9RLuGibBXrw2467DATcztWU75IipX2eXracwGcvR6DtfF3A0do7s3kCyV7q9bZEEbKo
         DNRDPya0P6L5Lf+8bLmfajvRu6leRFyXPb8Vb5bUC5DLmOGdH8HLe0uISHvX4rynvVKU
         NEcw==
X-Forwarded-Encrypted: i=1; AJvYcCWb1pyCwf+Iw0Yb+NeoNSHKdlYzntzbp4/lIm8K2AhIRblVuI5b+hHVObUU4yTpuNfp0e0prxlOJCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZwuhtFmBmYxrb5bwv1KHskKW2bV/IXjxAuam/kxtygvml0EpN
	jP8t/UwpNjDSCqBmWOn57tqYzXqNCoZJCvqaAcRpjI66prBdq2qIoumpvpGNr6+EN4mK8mGIq9w
	144FOVU1NGgG787NjCSjS0nJUehDd7V9zn8cfKPxsZ6CSw0LEPPybj7aiAUUk
X-Gm-Gg: ASbGncu91t+xIvyXYcovBhruqIdr7F/masgg1R0ep8i9J2aQDoLie4Tq9Mx+nk0HklS
	pfrGHrXtlJQmF3LYkIQcjHv5+0jWfTrTcPMBb8jd9RCaFO0rkbDHfBcqnWHBKsH4IoPO7k5uxby
	fuX+d2sps91bJjnZ3W46gz7WK3u7buzXXRY2wi0iU3KhHHiA6OFkGFhKxYPRRZbMtDxDvX+2Bza
	aClfEhL3YjOTxi7G3+FtqEVSpjZrRFR6iH/tyfq9+UEY+uAOIkHynfRNIc7v5Yjjs/6kmc34sf5
	aJ35LPD7EeE6caJT8xK9mAly1AZVmzkcThqEhjwpMgU56QJoEDH8JYBVi7c=
X-Received: by 2002:a17:907:3da5:b0:ae3:cd73:efde with SMTP id a640c23a62f3a-af8fd9b8cd8mr840014766b.44.1753962176761;
        Thu, 31 Jul 2025 04:42:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE67P8ng9AVSUESMcuBOxJ0x4LQSgKEPKDtRaQgthvJXLuQrA842cvO1Io0AFJoyaHMXBrfDA==
X-Received: by 2002:a17:907:3da5:b0:ae3:cd73:efde with SMTP id a640c23a62f3a-af8fd9b8cd8mr840012166b.44.1753962176183;
        Thu, 31 Jul 2025 04:42:56 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a078a11sm98404766b.7.2025.07.31.04.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 04:42:55 -0700 (PDT)
Date: Thu, 31 Jul 2025 13:42:54 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, david@fromorbit.com, ebiggers@kernel.org, hch@lst.de, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 20/29] xfs: disable preallocations for fsverity
 Merkle tree writes
Message-ID: <hnpu2acy45q3v3k4sj3p3yazfqfpihh3rnvrdyh6ljgmkod6cz@poli3ifoi6my>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-20-9e5443af0e34@kernel.org>
 <20250729222736.GK2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729222736.GK2672049@frogsfrogsfrogs>

On 2025-07-29 15:27:36, Darrick J. Wong wrote:
> On Mon, Jul 28, 2025 at 10:30:24PM +0200, Andrey Albershteyn wrote:
> > While writing Merkle tree, file is read-only and there's no further
> > writes except Merkle tree building. The file is truncated beforehand to
> > remove any preallocated extents.
> > 
> > The Merkle tree is the only data XFS will write. As we don't want XFS to
> > truncate file after we done writing, let's also skip truncation on
> > fsverity files. Therefore, we also need to disable preallocations while
> > writing merkle tree as we don't want any unused extents past the tree.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/xfs/xfs_iomap.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index ff05e6b1b0bb..00ec1a738b39 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -32,6 +32,8 @@
> >  #include "xfs_rtbitmap.h"
> >  #include "xfs_icache.h"
> >  #include "xfs_zone_alloc.h"
> > +#include "xfs_fsverity.h"
> > +#include <linux/fsverity.h>
> 
> What do these includes pull in for the iflags tests below?

Probably need to be removed, thanks for noting

> 
> >  #define XFS_ALLOC_ALIGN(mp, off) \
> >  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> > @@ -1849,7 +1851,9 @@ xfs_buffered_write_iomap_begin(
> >  		 * Determine the initial size of the preallocation.
> >  		 * We clean up any extra preallocation when the file is closed.
> >  		 */
> > -		if (xfs_has_allocsize(mp))
> > +		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> > +			prealloc_blocks = 0;
> > +		else if (xfs_has_allocsize(mp))
> >  			prealloc_blocks = mp->m_allocsize_blocks;
> >  		else if (allocfork == XFS_DATA_FORK)
> >  			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
> > @@ -1976,6 +1980,13 @@ xfs_buffered_write_iomap_end(
> >  	if (flags & IOMAP_FAULT)
> >  		return 0;
> >  
> > +	/*
> > +	 * While writing Merkle tree to disk we would not have any other
> > +	 * delayed allocations
> > +	 */
> > +	if (xfs_iflags_test(XFS_I(inode), XFS_VERITY_CONSTRUCTION))
> > +		return 0;
> 
> I assume XFS_VERITY_CONSTRUCTION doesn't get set until after we've
> locked the inode, flushed the dirty pagecache, and truncated the file to
> EOF?  In which case I guess this is ok -- we're never going to have new
> delalloc reservations,

yes, this is my thinking here

> and verity data can't be straddling the EOF
> folio, no matter how large it is.  Right?

Not sure, what you mean here. In page cache merkle tree is stored
at (1 << 53) offset, and there's check for file overlapping this in
patch 22 xfs_fsverity_begin_enable().

-- 
- Andrey

