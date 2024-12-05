Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455D049627
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 23:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733442536; cv=none; b=bxi+19hsvbxt2xhALCrzNyXXxs1rb+hi19BTuKkizbT6jLM8UzSx1ysL7omg1i+zUzLGmgzozKyo/RSXnsPwR7uynUTwNCSsJPA22JRChzccghpxkNGz17A+TWYsxjeFNHmRNc/qwZzc+GDrxmutsrzN0k2cyDCqxkFyJH2FArI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733442536; c=relaxed/simple;
	bh=uqz6ivQ/2LyumpX9NNCPcod+YMiz19Q1MG3CTwn+rmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYcqRy6TtxeXAC0GXqiz1RveLZdYI9ahcgifnxqqX+Qxsudarv7TK6Q7UCsDnkkgzCWM1QGyeBV0roBBfHVUuMhCkT0hwUHtW/Tbepp1TcYM9rn4znrOuxqitEL4SFJGU3/b2UyDVx0liLtxs7qEXMR7n3cJPVtIFFSsNcMdNxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kMVcF/cd; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kMVcF/cd"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7e6d04f74faso1079594a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Dec 2024 15:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733442532; x=1734047332; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wp6M/ObLqy+1tkOR01UeM6+9P+LWvNmp8Od0Uqs1xZc=;
        b=kMVcF/cd3g11TjsDU79FEsye6DC96x0VcSgcSrP4jRMsEdJtsQO53+5JB9AOcl7ygE
         11k2n5k1nHTlGoBitIZcX9XdF+w/WczoxTU+9JcI5lEgL2K89lbEYh6umwT9AxvET7rU
         oRUaNN5p1tTL1eBumfNPRNc9sVRk0suhF+DG1Z66pXAUPVFu9n+N7KjLwSXvA1jOZKki
         CMuo6RbnR4FOzqk9jfOsM9iGSdDWarP8FBR1MgEyfGPaCncXc7A4hMOc0+K1AnAUAx3P
         RZSoInCWS4J8Zs12Zb5WIl8dqRU5LmB5dlsMCkOsnWbmsiUX/jO4ZZN1NOvW2mfNolAO
         wxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733442532; x=1734047332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wp6M/ObLqy+1tkOR01UeM6+9P+LWvNmp8Od0Uqs1xZc=;
        b=Sg32UarEfc2/ZkI7JIBFzcrGYcGaecBIoWxiZ8kMKWCPLF+tGOPuFVRf2Cscq0I6rm
         3lRjLfaSbKtSyTvZ2a9J1hjt17bav+fqgU5sR2UllUZQgPmb5xpFxAxTDfk8WYj0I4Zc
         EAqn7N/fMKN0SJNC2sYHwY+3mKryKgQB3JD4mSwbBc8gR/ldCq6+wyKxh5yCwPmJ9462
         bRjAgMvADcMSq9fzXSWAkSVCaV/1rpRswwlbepNCaRxVkI1Em3nuS/iKgI8waLcmBO5k
         AmMdM1vlbZKVY+/z7p1aZ0e0Np0ay8jDElAfNokXwvZL3sVITUlSTynUNn4cZGbnDDjY
         ghzw==
X-Forwarded-Encrypted: i=1; AJvYcCVUH+RmUyIuiHF5m3dEgPi9oZTwU9P6qS61AoA5dPEhqHfCKedg2SWMnr2X+0CMtFuz/mw7MlceblY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP918c6jaT4MTnKVEZHLFIo3+BpenMhlQh8eZBWwnunJfAbg2U
	DmTBZMm3IjYD8c6HJHLZR5pM+cGWPg0UVA3q0ZoGT+b+QXtn4iGDNnjLFO8ozeg+wzDrpveGR+g
	X
X-Gm-Gg: ASbGncty/dtJDY8bpcJvXsbJ+wuQBBA0MLePMV7m+8jXp3XLvcStSdEGagCxNiE6grD
	ddvSJvc6b7bPdeprwy6pU1T70M8hWcALqQv9FrJrNz1Y5p9F2ScZNgPa3UR0WtWVzX4bOKZmTDH
	8fXJojoIZ9fhYD7tPvtU6XESPAgqXKDgJhEwKhWlrPklMvGcif61YDC4yMdUk6xPcTu0B2Q08Q1
	c0LVbB8U1Ah0069CsONZsj9dF9H7ssEOmQ3GR1VY3DwfLrtj1Tcj8VjT/U5nsZtAFyWA/lvk+9P
	E/Kw2q+P9PKn5RBryhpMlmA=
X-Google-Smtp-Source: AGHT+IGIGj5SnYCFPesKUm0foOJsHTZQ70hdnjfdPmpvBxSjq6dR3HnM650p3aAphKdS24ug934vVw==
X-Received: by 2002:a17:90b:3f8b:b0:2ea:8aac:6ac1 with SMTP id 98e67ed59e1d1-2ef68e2a9c7mr1831164a91.15.1733442532547;
        Thu, 05 Dec 2024 15:48:52 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef27078b03sm4196890a91.38.2024.12.05.15.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 15:48:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tJLaS-000000078y9-1kqe;
	Fri, 06 Dec 2024 10:48:48 +1100
Date: Fri, 6 Dec 2024 10:48:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: alexjlzheng@tencent.com, cem@kernel.org, chandanbabu@kernel.org,
	dchinner@redhat.com, djwong@kernel.org, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RESEND PATCH v2] xfs: fix the entry condition of exact EOF
 block allocation optimization
Message-ID: <Z1I74KeyZRv2pBBT@dread.disaster.area>
References: <Z09stGvgxKV91XfX@dread.disaster.area>
 <20241205121802.1232223-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205121802.1232223-1-alexjlzheng@tencent.com>

On Thu, Dec 05, 2024 at 08:18:02PM +0800, Jinliang Zheng wrote:
> On Wed, 4 Dec 2024 07:40:20 +1100, Dave Chinner wrote:
> > On Sat, Nov 31, 2024 at 07:11:32PM +0800, Jinliang Zheng wrote:
> > > When we call create(), lseek() and write() sequentially, offset != 0
> > > cannot be used as a judgment condition for whether the file already
> > > has extents.
> > > 
> > > Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
> > > it is not necessary to use exact EOF block allocation.
> > > 
> > > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > > ---
> > > Changelog:
> > > - V2: Fix the entry condition
> > > - V1: https://lore.kernel.org/linux-xfs/ZyFJm7xg7Msd6eVr@dread.disaster.area/T/#t
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 36dd08d13293..c1e5372b6b2e 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -3531,12 +3531,14 @@ xfs_bmap_btalloc_at_eof(
> > >  	int			error;
> > >  
> > >  	/*
> > > -	 * If there are already extents in the file, try an exact EOF block
> > > -	 * allocation to extend the file as a contiguous extent. If that fails,
> > > -	 * or it's the first allocation in a file, just try for a stripe aligned
> > > -	 * allocation.
> > > +	 * If there are already extents in the file, and xfs_bmap_adjacent() has
> > > +	 * given a better blkno, try an exact EOF block allocation to extend the
> > > +	 * file as a contiguous extent. If that fails, or it's the first
> > > +	 * allocation in a file, just try for a stripe aligned allocation.
> > >  	 */
> > > -	if (ap->offset) {
> > > +	if (ap->prev.br_startoff != NULLFILEOFF &&
> > > +	     !isnullstartblock(ap->prev.br_startblock) &&
> > > +	     xfs_bmap_adjacent_valid(ap, ap->blkno, ap->prev.br_startblock)) {
> > 
> > There's no need for calling xfs_bmap_adjacent_valid() here -
> > we know that ap->blkno is valid because the
> > bounds checking has already been done by xfs_bmap_adjacent().
> 
> I'm sorry that I didn't express it clearly, what I meant here is: if we want
> to extend the file as a contiguous extent, then ap->blkno must be a better
> choice given by xfs_bmap_adjacent() than other default values.

Yes, but xfs_bmap_adjacent_valid() does not tell us that.

> /*
>  * If allocating at eof, and there's a previous real block,
>  * try to use its last block as our starting point.
>  */
> if (ap->eof && ap->prev.br_startoff != NULLFILEOFF &&
>     !isnullstartblock(ap->prev.br_startblock) &&
>     xfs_bmap_adjacent_valid(ap,
> 		ap->prev.br_startblock + ap->prev.br_blockcount,
> 		ap->prev.br_startblock)) {
> 	ap->blkno = ap->prev.br_startblock + ap->prev.br_blockcount; <--- better A

For people reading along: This sets the allocation target to the
end of the previous physical extent.

> 	/*
> 	 * Adjust for the gap between prevp and us.
> 	 */
> 	adjust = ap->offset -
> 		(ap->prev.br_startoff + ap->prev.br_blockcount);
> 	if (adjust && xfs_bmap_adjacent_valid(ap, ap->blkno + adjust,
> 			ap->prev.br_startblock))
> 		ap->blkno += adjust;                                 <--- better B

And this adjusts for the file offset of the new EOF allocation
being a distance beyond the previous extent. i.e.

file offset:	0	EOF	    ap->offset
layout:		+--prev--+-----hole-----+--new EOF allocation--+

After allocation:
file offset:	0	oEOF	      offset		      EOF
layout:		+--prev--+-----hole-----+--new EOF allocation--+
physical:	+--used--+-----free-----+-------used-----------+

And now when the write to fill the file offset hole (e.g. because of
racing concurrent extending AIO+DIO writes being issued out of
order), we end up with this non-EOF NEAR allocation being set up
over the hole in the file:

file offset:	0      ap->offset      			      EOF
layout:		+--prev--+-----hole-----+--------next----------+
                       ap->blkno

And the NEAR allocation will find the exact free space we left to
fill that hole, resulting in a file that looks like this:

file offset:	0					      EOF
layout:		+----------------------------------------------+
physical:	+----------------------------------------------+

i.e. a single contiguous extent.

> 	return true;

And it's important to note that xfs_bmap_adjacent returns true if
it selects a new target for exact allocation.

> }
> 
> Only when we reach 'better A' or 'better B' of xfs_bmap_adjacent() above, it
> is worth trying to use xfs_alloc_vextent_EXACT_bno(). Otherwise, NEAR is
> more suitable than EXACT.

Well, yes, that is exactly what the code was -trying- to do.
It was using ap->offset as a proxy for "there is a previous extent"
rather than an explicit check for "do we need exact allocation"

As you've rightly pointed out - this code is not correct in all
situations, nor optimal for all situations.

What I've been trying to point out to you is that your solution is
not optimal, either. 

> Therefore, we need xfs_bmap_adjacent() to determine whether xfs_bmap_adjacent()
> has indeed modified ap->blkno.

It already does, but we ignore it. If we want use exact allocation
only when we are doing EOF allocation:

Perhaps:

-	xfs_bmap_adjacent(ap);
+	if (!xfs_bmap_adjacent(ap))
+		ap->eof = false;

And then in xfs_bmap_btalloc_at_eof() all we need is

-	if (ap->offset) {
+	if (ap->eof) {

i.e. we only do exact allocation at EOF when xfs_bmap_adjacent has
set a target we want exact allocation for.

(note: don't confuse ap->eof and ap->aeof)

> > Actually, for another patch, the bounds checking in
> > xfs_bmap_adjacent_valid() is incorrect. What happens if the last AG
> > is a runt? i.e. it open codes xfs_verify_fsbno() and gets it wrong.
> 
> For general scenarios, I agree.

This *is* a general scenario. Every single extending allocation goes
through this path.

> But here, the parameters x and y of xfs_bmap_adjacent_valid() are both derived
> from ap->prev. Is it possible that it exceeds mp->m_sb.sb_agcount or
> mp->m_sb.sb_agblocks?

I think you missed the significance of the gap (file offset)
adjustment.

Write a couple of TB beyond EOF and see what happens. Then allocate
a file in the last AG that is a runt, and try to write a distance
beyond EOF that will land the target blkno between the size of
the runt AG and mp->m_sb.sb_agcount....

Hint: runt AG length < AGBNO(ap->blkno) < mp->m_sb.sb_agcount.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
