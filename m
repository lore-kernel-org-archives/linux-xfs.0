Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C46C64EC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 01:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCABIa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 20:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCABI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 20:08:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F6730B09
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 17:08:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E996EB80ED2
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 01:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86F2C433EF;
        Wed,  1 Mar 2023 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677632905;
        bh=a0FDQ4gfMhIE9ed0Cnya/pOW78s/aR8QqJj8tbQr3Nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lm6jVU2aHcjkgDFo0M/v15CJ6xQbHWn+wp+YVOAf5Pjm2wwZ7LedQNqvQONGbOuvu
         OZoBRz6HQwEtOPg/z7YDD9Wx2Ispy3az/LLDPYV7IVkvlkAAbUKVQr+9YXjfLUhwGC
         8MaTwcrg5QvkDjA8bNL7taPciSi0goSh6GVnFpf2/Ng9sLfPqHKkY0sam4xccl8AgU
         vwywsHyli6n1K89TJx4bJ21KBCaHyUZ5wicPoDcpbOpuXAuRyuqxH8Jyxh8IDiq0yh
         9gKTy7sdhiew0m3EowvMhXIH8JedfBfoBzpV7Vba+Ktz65D2HiGrJLVRC5eQLPNpKn
         NFkiiICA95c4A==
Date:   Tue, 28 Feb 2023 17:08:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one-block in xfs_discard_folio()
Message-ID: <Y/6liVjtv0ssl8og@magnolia>
References: <20230301001706.1315973-1-david@fromorbit.com>
 <Y/6ghfyWXLuCefkn@magnolia>
 <20230301010417.GE360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301010417.GE360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 01, 2023 at 12:04:17PM +1100, Dave Chinner wrote:
> On Tue, Feb 28, 2023 at 04:47:01PM -0800, Darrick J. Wong wrote:
> > On Wed, Mar 01, 2023 at 11:17:06AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The recent writeback corruption fixes changed the code in
> > > xfs_discard_folio() to calculate a byte range to for punching
> > > delalloc extents. A mistake was made in using round_up(pos) for the
> > > end offset, because when pos points at the first byte of a block, it
> > > does not get rounded up to point to the end byte of the block. hence
> > > the punch range is short, and this leads to unexpected behaviour in
> > > certain cases in xfs_bmap_punch_delalloc_range.
> > > 
> > > e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
> > > there is no previous extent and it rounds up the punch to the end of
> > > the delalloc extent it found at offset 0, not the end of the range
> > > given to xfs_bmap_punch_delalloc_range().
> > > 
> > > Fix this by handling the zero block offset case correctly.
> > > 
> > > Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
> > > Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> > > Found-by: Brian Foster <bfoster@redhat.com>
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_aops.c | 14 ++++++++++++--
> > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > index 41734202796f..429f63cfd7d4 100644
> > > --- a/fs/xfs/xfs_aops.c
> > > +++ b/fs/xfs/xfs_aops.c
> > > @@ -466,6 +466,7 @@ xfs_discard_folio(
> > >  {
> > >  	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
> > >  	struct xfs_mount	*mp = ip->i_mount;
> > > +	xfs_off_t		end_off;
> > >  	int			error;
> > >  
> > >  	if (xfs_is_shutdown(mp))
> > > @@ -475,8 +476,17 @@ xfs_discard_folio(
> > >  		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
> > >  			folio, ip->i_ino, pos);
> > >  
> > > -	error = xfs_bmap_punch_delalloc_range(ip, pos,
> > > -			round_up(pos, folio_size(folio)));
> > > +	/*
> > > +	 * Need to be careful with the case where the pos passed in points to
> > > +	 * the first byte of the folio - rounding up won't change the value,
> > > +	 * but in all cases here we need to end offset to point to the start
> > > +	 * of the next folio.
> > > +	 */
> > > +	if (pos == folio_pos(folio))
> > > +		end_off = pos + folio_size(folio);
> > > +	else
> > > +		end_off = round_up(pos, folio_size(folio));
> > 
> > Can this construct be simplified to:
> > 
> > 	end_off = round_up(pos + 1, folio_size(folio));
> 
> I thought about that first, but I really, really dislike sprinkling
> magic "+ 1" corrections into the code to address non-obvious
> unexplained off-by-one problems.
> 
> 
> > If pos is the first byte of the folio, it'll round end_off to the start
> > of the next folio.  If pos is (somehow) the last byte of the folio, the
> > first argument to round_up is already the first byte of the next folio,
> > and rounding won't change it.
> 
> Yup, and that's exactly the problem I had with doing this - it
> relies on the implicit behaviour that by moving last byte of a block
> to the first byte of the next block, round_up() won't change the end
> offset.  i.e. the correct functioning of the code is just as
> non-obvious with a magic "+ 1" as the incorrect functioning was
> without it.
> 
> Look at it this way: I didn't realise it was wrong when I wrote the
> code, and I couldn't find the bug round_up() introduced when reading
> the code even after the problem had been bisected to this exact
> change. The code I wrote is bad, and adding a magic "+ 1" to fix the
> bug doesn't make the code any better.
> 
> Given this is a slow path, so I see no point in optimising the code
> for efficiency. IMO, clarity of the logic and calculation being made
> is far more important - obviously correct logic is better than
> relying on the effect of a magic "+ 1" on some other function to
> acheive the same thing....

<nod> Just making sure I wasn't missing something.

By the way, was this reported to the list?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
