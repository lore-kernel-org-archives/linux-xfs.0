Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4763C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 01:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjCABWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 20:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCABWW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 20:22:22 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C130B31
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 17:21:44 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p6so6848604pga.0
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 17:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozgc3uc5odOQTH16uLiq78gE11HZlDPiCeNDefyyOA0=;
        b=cvMCxGkM6/u8cHHKDPfug1+cYBCl+VFjoKRsZFAsQ0DfgRphLCCT6MN61IDF+5310d
         BEgtVjPKRC78m0C4M1QnRtlTd7c+NixwIoPYmnMOKFBuDVyMRt591D3Gfq/BzpioszXY
         H3174HBs0Ol+77y7BPQtgbbqp57gnUfKLq/By+dZy4y7fzOcJLK/3tL+uy+mnrYogTal
         mJuJb44cSEyZAgJtmeej32tTOddemzEjHQmMVzzxuFPuL0nuqxIYlqPML4AzLOZfSDBb
         3XwU9BkRTyywMesE/L0PErrV+OgVLD+bNNjPkvGQFlSe9Dd1ydqsgjYZnGuU8ScjQCfd
         xJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozgc3uc5odOQTH16uLiq78gE11HZlDPiCeNDefyyOA0=;
        b=SFk/8oyKkjRYU3V/yqjgZZIRSLWCwWCbgdsuJocsjE0hq2XtIddOILZRZ3OvSMuJ2O
         PONcs601y9A1jB3Af19WpWV9BcReA2sWn4MY973Dw2Q5CjSpBzZpDa4EqxPI7X64B3W4
         EpJx4wxOLIadHek0NwAGB7/NW13mczV+8lwHDDvgnR1wuPV/TnDe7ywLOU5LOUcmnkQD
         0/25sy0J/pykuqPzbDVEegV3qlJfWMglMEpTiv1fAMkHL/Nb/wZgyn3kn6HbbxDGPMN8
         8kMig9eAQxynMf849jSv6d8/m8EeeM5YHkiouPW4d6iV03kyoiMkf4jXE1G75vKhXuG0
         nkzw==
X-Gm-Message-State: AO0yUKWrdC2GFDjOqgNo0jHLRbb6UfQi9HpOKDCgm1BSxhUUnc6/V7Pp
        h8uIOnBlxZuh57wVtS3Nn7Sa+Nwabp7vgeF4
X-Google-Smtp-Source: AK7set8ltEj0zK59oOj0GRb1Gt9P/W9ids9uTBIwDRHGixxSSJKlknJVklesEmbBzeIPm+/MEXImuw==
X-Received: by 2002:aa7:99c8:0:b0:5a8:d97d:c346 with SMTP id v8-20020aa799c8000000b005a8d97dc346mr4541864pfi.12.1677633687793;
        Tue, 28 Feb 2023 17:21:27 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id r24-20020a62e418000000b00571f66721aesm6610068pfh.42.2023.02.28.17.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 17:21:27 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pXB9o-003L8J-6l; Wed, 01 Mar 2023 12:21:24 +1100
Date:   Wed, 1 Mar 2023 12:21:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one-block in xfs_discard_folio()
Message-ID: <20230301012124.GF360264@dread.disaster.area>
References: <20230301001706.1315973-1-david@fromorbit.com>
 <Y/6ghfyWXLuCefkn@magnolia>
 <20230301010417.GE360264@dread.disaster.area>
 <Y/6liVjtv0ssl8og@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/6liVjtv0ssl8og@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 28, 2023 at 05:08:25PM -0800, Darrick J. Wong wrote:
> On Wed, Mar 01, 2023 at 12:04:17PM +1100, Dave Chinner wrote:
> > On Tue, Feb 28, 2023 at 04:47:01PM -0800, Darrick J. Wong wrote:
> > > On Wed, Mar 01, 2023 at 11:17:06AM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > The recent writeback corruption fixes changed the code in
> > > > xfs_discard_folio() to calculate a byte range to for punching
> > > > delalloc extents. A mistake was made in using round_up(pos) for the
> > > > end offset, because when pos points at the first byte of a block, it
> > > > does not get rounded up to point to the end byte of the block. hence
> > > > the punch range is short, and this leads to unexpected behaviour in
> > > > certain cases in xfs_bmap_punch_delalloc_range.
> > > > 
> > > > e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
> > > > there is no previous extent and it rounds up the punch to the end of
> > > > the delalloc extent it found at offset 0, not the end of the range
> > > > given to xfs_bmap_punch_delalloc_range().
> > > > 
> > > > Fix this by handling the zero block offset case correctly.
> > > > 
> > > > Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
> > > > Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> > > > Found-by: Brian Foster <bfoster@redhat.com>
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_aops.c | 14 ++++++++++++--
> > > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > > index 41734202796f..429f63cfd7d4 100644
> > > > --- a/fs/xfs/xfs_aops.c
> > > > +++ b/fs/xfs/xfs_aops.c
> > > > @@ -466,6 +466,7 @@ xfs_discard_folio(
> > > >  {
> > > >  	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
> > > >  	struct xfs_mount	*mp = ip->i_mount;
> > > > +	xfs_off_t		end_off;
> > > >  	int			error;
> > > >  
> > > >  	if (xfs_is_shutdown(mp))
> > > > @@ -475,8 +476,17 @@ xfs_discard_folio(
> > > >  		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
> > > >  			folio, ip->i_ino, pos);
> > > >  
> > > > -	error = xfs_bmap_punch_delalloc_range(ip, pos,
> > > > -			round_up(pos, folio_size(folio)));
> > > > +	/*
> > > > +	 * Need to be careful with the case where the pos passed in points to
> > > > +	 * the first byte of the folio - rounding up won't change the value,
> > > > +	 * but in all cases here we need to end offset to point to the start
> > > > +	 * of the next folio.
> > > > +	 */
> > > > +	if (pos == folio_pos(folio))
> > > > +		end_off = pos + folio_size(folio);
> > > > +	else
> > > > +		end_off = round_up(pos, folio_size(folio));
> > > 
> > > Can this construct be simplified to:
> > > 
> > > 	end_off = round_up(pos + 1, folio_size(folio));
> > 
> > I thought about that first, but I really, really dislike sprinkling
> > magic "+ 1" corrections into the code to address non-obvious
> > unexplained off-by-one problems.
> > 
> > 
> > > If pos is the first byte of the folio, it'll round end_off to the start
> > > of the next folio.  If pos is (somehow) the last byte of the folio, the
> > > first argument to round_up is already the first byte of the next folio,
> > > and rounding won't change it.
> > 
> > Yup, and that's exactly the problem I had with doing this - it
> > relies on the implicit behaviour that by moving last byte of a block
> > to the first byte of the next block, round_up() won't change the end
> > offset.  i.e. the correct functioning of the code is just as
> > non-obvious with a magic "+ 1" as the incorrect functioning was
> > without it.
> > 
> > Look at it this way: I didn't realise it was wrong when I wrote the
> > code, and I couldn't find the bug round_up() introduced when reading
> > the code even after the problem had been bisected to this exact
> > change. The code I wrote is bad, and adding a magic "+ 1" to fix the
> > bug doesn't make the code any better.
> > 
> > Given this is a slow path, so I see no point in optimising the code
> > for efficiency. IMO, clarity of the logic and calculation being made
> > is far more important - obviously correct logic is better than
> > relying on the effect of a magic "+ 1" on some other function to
> > acheive the same thing....
> 
> <nod> Just making sure I wasn't missing something.
> 
> By the way, was this reported to the list?

The original report is here:

https://bugzilla.kernel.org/show_bug.cgi?id=217030 

And in discussion of the initial fix I sent out, Brian found the
off-by-one here:

https://lore.kernel.org/linux-xfs/Y+vOfaxIWX1c%2Fyy9@bfoster/

I still plan to fix up the patchset that removes ->discard_folio and
retain pages dirty in memory after writeback mapping failures, but I
figured getting the bug fix out was more important...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
