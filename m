Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714154;
	b=V8Qbf2CquvU7PbxO1G+WZj0W6bjHVOWVGIFI4C+yxcws7Wjzf78DdEMywVDbu3Z+PzB4
	 N0e9oiuQkPj+ju+XOQadFIAmGgIa7fGRhUHYzVAd9RqZ2zy95ORe6fMlOWXWb/SHdgf0c
	 SMUgxYviLWx6zsmk7yTfLb6uowCumx0IHIzACYwDwngx8JTND6sYa8pcvCT7u2wff/82h
	 USgWq4Cb0X6cUI2EE16d4yMlMfdzIycCaGWBO7aWDx7AQuAxyJ18zqrpHankkERQY5Djt
	 1pU4PYW1X41P8ab1In8I7mVA2fzB41IUJog1mBBzmfcy+OCdW1bxuFJKWXpV54KJbPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714154;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WItMxEwlKSu/SJYeWI0DJrrYDzS66umVb0Kzn+bDJXM=;
	b=Vr58pJsiwpHdCXxF3YCNi6opNdBsoinJYsmPnf7LDceIbhF33svlFzk+nx/VpPqB6+HC
	 agSNimz7nVu8PiNAJXqpzufA2tI/IqQhg1Mj41Jd8hSDZr5wO5CDq8eEXAdJzvKOtfuLk
	 y2iU33beb2A6k9WtZC0wjGlGzR/k6ZvnM37EH7118Bv1Q11E92F1HV7Keqn7B5l5/Cz10
	 52aEY5Fg6qbvvUB2y0U0mx3YxjWQkkTPERKmm+QBgtQjPMyL9HG7sNcYImPEt469YrKjk
	 eOO5/vzYGmcZiGBU5zTjledoB2e/M/GdyNz1eUeu/1vGZorlnisWHPpbAEjhEuVWFeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwGHVL8A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F19C606A327;
	Tue,  3 Nov 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwGHVL8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3FE1F00919;
	Tue,  3 Nov 2026 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714153;
	bh=WItMxEwlKSu/SJYeWI0DJrrYDzS66umVb0Kzn+bDJXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WwGHVL8ATkldVixTCR3s9E2FXQRJEfjI8e4Oy9GJSvvJSU8doNTrl2M0FAWbP5Pfa
	 hmzmh93/u0WjcVsBzXc6rIdcfHy/bBuh6vFhXQ1POq77Sl5oykpVuX7Ia0HnSQ07c9
	 LGPz8voMVFlTbNCMeIFzvZ9KcEnED3pRcnA3T+FvtliNWMgN73ipnGkUEMF1c+XxCK
	 1mQYLSGXf7rn3en+iL7Y8lqjiOsy9Hwp1NQSeUhECNbbWd0h7fcz3/bp4nqOWFcSqO
	 wC7tRVgyGXvWy6pphGz3r5vnOUIOIkBORHKbgAT2Num4Tll7vfTb3hsQSyyu2CoIb2
	 E8xGUNkkKND2w==
Date: Tue, 3 Nov 2026 14:55:48 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 05/15] xfs: handle fsverity I/O in write/read path
Message-ID: <aunQUzz7AV-qvys-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-6-aalbersh@kernel.org>
 <aumrai1iWxj97svo@infradead.org>
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
In-Reply-To: <aumrai1iWxj97svo@infradead.org>

On 2026-11-03 01:37:46, Christoph Hellwig wrote:
> On Mon, Nov 02, 2026 at 03:41:35PM +0100, Andrey Albershteyn wrote:
> > @@ -41,6 +41,7 @@
> >  #include "xfs_inode_util.h"
> >  #include "xfs_rtgroup.h"
> >  #include "xfs_zone_alloc.h"
> > +#include "xfs_verity.h"
> 
> I think the Sashiko comment that this breaks the build until
> xfs_fsverifty.h is added is spot on.  Easiest is probably to just add
> the header in this patch already.
> 
> >  	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
> >  
> > +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> > +		iomap_flags |= IOMAP_F_FSVERITY;
> > +
> >  	/*
> >  	 * COW fork blocks can overlap data fork blocks even if the blocks
> >  	 * aren't shared.  COW I/O always takes precedent, so we must always
> > @@ -265,7 +270,8 @@ xfs_map_blocks(
> >  	    isnullstartblock(imap.br_startblock))
> >  		goto allocate_blocks;
> >  
> > -	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
> > +	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags,
> > +			  XFS_WPC(wpc)->data_seq);
> 
> Is there a reason to not just move the IOMAP_F_FSVERITY handling
> into xfs_bmbt_to_iomap?  It would break if single extent is shared
> between data and verity data, but we already leave a large enough hole
> that this could never happen, right?

I think it can be moved to xfs_bmbt_to_iomap(), but we will need an
offset there. The one extent case could happen if file size is
exactly 64k and we got continuous phys space allocation with merkle
tree (then the extents will be merged).

> 
> If we need to protect agaist that explicitly passing the offset might
> still be better, although it would be a bit ugly.
> 
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  
> >  	xfs_iomap_set_anon_write(ip, &wpc->iomap, offset,
> > -			XFS_FSB_TO_B(mp, count_fsb));
> > +			XFS_FSB_TO_B(mp, count_fsb), iomap_flags);
> 
> Same for xfs_iomap_set_anon_write, although we already do have the
> offset here in either case.
> 
> > +static int
> > +xfs_iomap_writepages(
> > +	struct xfs_inode		*ip,
> > +	struct iomap_writepage_ctx	*ctx)
> > +{
> > +	/*
> > +	 * Writeback does not work for folios past EOF, let it know that
> > +	 * I/O happens for fsverity metadata and this restriction need
> > +	 * to be skipped
> > +	 */
> > +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> > +		ctx->iomap.flags |= IOMAP_F_FSVERITY;
> 
> Sashiko complained about this, but I also really don't understand
> how setting ctx->iomap.flags before we even get a mapping to start
> with make much sense.  This should be set together with filling the
> iomap either way.

The problem here is that when we found a dirty folio to writeback,
and we know it's beyond EOF, how to find out that's it's fsverity
folio. We don't have any fsverity metadata attach to an inode yet as
we are in the process of creating it.

This is not a nice workaround here, but I use stale iomap.flags
here. So, every next folio in that iomap has the stale flags from a
previous one, which has fsverity set. This should be fine as the
only folios written, at this point, are fsverity metadata.

Here I set it for the first folio in the iomap, to get it started.
Otherwise, writeback will just will not continue on folios post EOF.

This could be probably done by elevating "verity in construction"
into inode_state_flags *shrug*

> 
> > +#include "xfs_verity.h"
> > +#include <linux/fsverity.h>
> >  
> >  #define XFS_ALLOC_ALIGN(mp, off) \
> >  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> > @@ -883,6 +885,9 @@ xfs_direct_write_iomap_begin(
> >  	if (flags & IOMAP_ATOMIC)
> >  		iomap_flags |= IOMAP_F_ATOMIC_BIO;
> >  
> > +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> > +		iomap_flags |= IOMAP_F_FSVERITY;
> > +
> >  	/*
> >  	 * COW writes may allocate delalloc space or convert unwritten COW
> >  	 * extents, so we need to make sure to take the lock exclusively here.
> > @@ -1023,7 +1028,8 @@ xfs_direct_write_iomap_begin(
> >  	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
> >  	if (imap.br_startblock != HOLESTARTBLOCK) {
> >  		seq = xfs_iomap_inode_sequence(ip, 0);
> > -		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
> > +		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags,
> > +				iomap_flags & IOMAP_F_FSVERITY, seq);
> 
> Does passing on the other iomap_flags hurt here?  Filtering out a
> specific one looks pretty odd.
> 

I suppose it's fine, the buffered-io path won't have anything except
fsverity, and direct-io can set IOMAP_F_DIRTY/IOMAP_F_ATOMIC_BIO
which is probably not desired for source cow extent. I will test it

-- 
- Andrey
