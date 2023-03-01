Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD660C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 01:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCABEW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 20:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCABEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 20:04:22 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1374423C6F
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 17:04:21 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c10so6308020pfv.13
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 17:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/g1/R8BEx896JtE2tdAOLWvCVS/vBGvjfdAfx/XcepE=;
        b=ra2oOiSlbRCzq7cECLn2fm+lE91Bb3UPpETuSmbCYAYmbAcMBHYFVciLynorsm2dcE
         RUtO2bybENwoN6QnrKxe8Lhn7hAvSGUJi/hiwr0MOmzX7o0RfTRCJxd7e6S4R2y31D0b
         2WrQHKAovMsw24aALde8HByjoTf1WDPlJgLQsRW1s/ypMR6ndETcp0jA8YQFvKC6pkJ3
         1YJK6FVOldb0pqXojmXSyblxDyr4jxTxj1gd/MSSPzxJYBt0S/s/4GOoXtIDPrDQ6o+v
         lH0tKTXPOJ+7rzVvEToJr39cJ8SNlc6NtDVSQGfH/KGZf1iu40fykdBjx0Dd0YR3uwc0
         Z5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/g1/R8BEx896JtE2tdAOLWvCVS/vBGvjfdAfx/XcepE=;
        b=NqJivTDz9QXfbbJnd71kyAl4oxHUhvzlFmHeSO6QEXjWKiY42upFTbOew503GPidYm
         yT/UsfDagNIJD7rMkL/s28D95O3ehtoq8nX1W0vSztVbbfHylytuehBhEMk7urFIa6co
         r9mLBcZAh1nhAoy2b/MUjHA8KnbYZMVR4jgvSvbKrPZjn+dwmPQaKEhX8+aVYxBHjpqI
         0awzJa7kxO8g8zVOXrkPMh5XD3xqEeaO/NyTKNWACwfNLDvVAtwoR5ul63qn2tlE7t1/
         mPHDlEMCr6nPoBDSaq1SIOqWYU6GBCfcQye/Zvv/dsGVDTAjUEPEgmclMyzEeUSN4rWU
         aV+Q==
X-Gm-Message-State: AO0yUKW2Wv5qcHTN4YiTf2esbloq40IBXY3zrKULynWPZodAhBqbeVd7
        lfzWplr43FDyEWu/gfk0YwmcKmTP6ADmmcG1
X-Google-Smtp-Source: AK7set8qnCKJmGvF1Xxdd5tBXn16EEXqDqEnjnD6TiDDbkS6mJbVXm1Q7efbK2Gh6a8Kk89S30ZCNA==
X-Received: by 2002:a05:6a00:24d5:b0:5a8:cc39:fc58 with SMTP id d21-20020a056a0024d500b005a8cc39fc58mr16706767pfv.6.1677632660452;
        Tue, 28 Feb 2023 17:04:20 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id q25-20020a62ae19000000b005a84ef49c63sm6574866pff.214.2023.02.28.17.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 17:04:19 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pXAtF-003KxZ-4K; Wed, 01 Mar 2023 12:04:17 +1100
Date:   Wed, 1 Mar 2023 12:04:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one-block in xfs_discard_folio()
Message-ID: <20230301010417.GE360264@dread.disaster.area>
References: <20230301001706.1315973-1-david@fromorbit.com>
 <Y/6ghfyWXLuCefkn@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/6ghfyWXLuCefkn@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 28, 2023 at 04:47:01PM -0800, Darrick J. Wong wrote:
> On Wed, Mar 01, 2023 at 11:17:06AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The recent writeback corruption fixes changed the code in
> > xfs_discard_folio() to calculate a byte range to for punching
> > delalloc extents. A mistake was made in using round_up(pos) for the
> > end offset, because when pos points at the first byte of a block, it
> > does not get rounded up to point to the end byte of the block. hence
> > the punch range is short, and this leads to unexpected behaviour in
> > certain cases in xfs_bmap_punch_delalloc_range.
> > 
> > e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
> > there is no previous extent and it rounds up the punch to the end of
> > the delalloc extent it found at offset 0, not the end of the range
> > given to xfs_bmap_punch_delalloc_range().
> > 
> > Fix this by handling the zero block offset case correctly.
> > 
> > Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
> > Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> > Found-by: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 41734202796f..429f63cfd7d4 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -466,6 +466,7 @@ xfs_discard_folio(
> >  {
> >  	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_off_t		end_off;
> >  	int			error;
> >  
> >  	if (xfs_is_shutdown(mp))
> > @@ -475,8 +476,17 @@ xfs_discard_folio(
> >  		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
> >  			folio, ip->i_ino, pos);
> >  
> > -	error = xfs_bmap_punch_delalloc_range(ip, pos,
> > -			round_up(pos, folio_size(folio)));
> > +	/*
> > +	 * Need to be careful with the case where the pos passed in points to
> > +	 * the first byte of the folio - rounding up won't change the value,
> > +	 * but in all cases here we need to end offset to point to the start
> > +	 * of the next folio.
> > +	 */
> > +	if (pos == folio_pos(folio))
> > +		end_off = pos + folio_size(folio);
> > +	else
> > +		end_off = round_up(pos, folio_size(folio));
> 
> Can this construct be simplified to:
> 
> 	end_off = round_up(pos + 1, folio_size(folio));

I thought about that first, but I really, really dislike sprinkling
magic "+ 1" corrections into the code to address non-obvious
unexplained off-by-one problems.


> If pos is the first byte of the folio, it'll round end_off to the start
> of the next folio.  If pos is (somehow) the last byte of the folio, the
> first argument to round_up is already the first byte of the next folio,
> and rounding won't change it.

Yup, and that's exactly the problem I had with doing this - it
relies on the implicit behaviour that by moving last byte of a block
to the first byte of the next block, round_up() won't change the end
offset.  i.e. the correct functioning of the code is just as
non-obvious with a magic "+ 1" as the incorrect functioning was
without it.

Look at it this way: I didn't realise it was wrong when I wrote the
code, and I couldn't find the bug round_up() introduced when reading
the code even after the problem had been bisected to this exact
change. The code I wrote is bad, and adding a magic "+ 1" to fix the
bug doesn't make the code any better.

Given this is a slow path, so I see no point in optimising the code
for efficiency. IMO, clarity of the logic and calculation being made
is far more important - obviously correct logic is better than
relying on the effect of a magic "+ 1" on some other function to
acheive the same thing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
