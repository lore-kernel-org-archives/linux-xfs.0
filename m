Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD00C7EE23
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 22:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCAWMd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Mar 2023 17:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCAWMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2023 17:12:32 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFD84DBC1
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 14:12:31 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id d10so8646044pgt.12
        for <linux-xfs@vger.kernel.org>; Wed, 01 Mar 2023 14:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K0Vxn8eJt09MmhxDC3gfG0HTVvypAiAJrQz7ec8UgmY=;
        b=b0ZwQOm2U/atixaww1yC09FP+SSgQyx7BHm+VFbpah5SMlk99QYgNgL9j7IMNecwBz
         iKvYt6gqGHDgY7eYNWxfh2qA7qYFZ1zsgamqHIqiqqa+QS6z27V7fLmFFBS73sL/5/Hh
         lWVBXRIllbNhHTp0DdfBsW2aNlitXlO81XHY5I1oEg2uxodZBwMqV2O2mzgWgh3nRYOb
         b7vi2G+tgjtAM8oBJ1LweirSjj3V57H4F0EAHgaOn3/iJwM6wwDB4M+W5ss42/Cd0PbE
         m/KoL54vEnnOZBVzm5N+tEuBhJvg3XNPWwkhn0trUTJPrzl7SRwFPXdYCPQBj4lYhVQU
         EX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0Vxn8eJt09MmhxDC3gfG0HTVvypAiAJrQz7ec8UgmY=;
        b=I8T/SQ7lQ9RSTdrvtvsH4fhS6+iLJ577/kql7zprkUGurOU4W6vqZ+lL+yr34wFZmx
         A/f6YMSieyAyXromoXpHW0n8uJec0932q/mWHAluCDIFYjjoGSvMLYuQfpiRQFmGV+te
         TTHqUoBqqKs7z1/S3qFgsQrcAiquuYL2rLH7geykKAKpk/ogU+Urr2lUoBeHtZD0ciqf
         oz/WHj0R57appY0SLV6xAMzgsCeZw0/RwpG6s+2Xjh2fsHTAiWdP+T5UX4CKb2OxBTNu
         KJsLQicvRZCX1nbQYeyrPkE9gBlFxg5qdNnk3nHpFES/whNexmSdANjZzMqrBLJ+FnEI
         a3rw==
X-Gm-Message-State: AO0yUKVGb/j5cpItr+oUzPam9Z3INTSKFEoa6wwkY2w8SkFWrggw5gz4
        DGtbEiiSM2voyAhcavrlnSs6gHsdlbllDycE
X-Google-Smtp-Source: AK7set/MzOQ+dC11nBHsHUNfAFj9vxFaQt77oYaLb+vVxE+ADeUFR8hyflf+hbhkrbXH6uF7VGS38w==
X-Received: by 2002:a62:6dc1:0:b0:578:ac9f:79a9 with SMTP id i184-20020a626dc1000000b00578ac9f79a9mr6233335pfc.15.1677708750752;
        Wed, 01 Mar 2023 14:12:30 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id s11-20020aa7828b000000b0059435689e36sm8611468pfm.170.2023.03.01.14.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 14:12:30 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pXUgV-003gUu-FN; Thu, 02 Mar 2023 09:12:27 +1100
Date:   Thu, 2 Mar 2023 09:12:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andreas =?iso-8859-1?Q?Gr=FCnbacher?= 
        <andreas.gruenbacher@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one-block in xfs_discard_folio()
Message-ID: <20230301221227.GH360264@dread.disaster.area>
References: <20230301001706.1315973-1-david@fromorbit.com>
 <Y/6ghfyWXLuCefkn@magnolia>
 <20230301010417.GE360264@dread.disaster.area>
 <CAHpGcMKA7Qy+DA0-JVU=YyOSQi4eeGN8GGFCo_edCVVBNV_v+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHpGcMKA7Qy+DA0-JVU=YyOSQi4eeGN8GGFCo_edCVVBNV_v+g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 01, 2023 at 02:41:53PM +0100, Andreas Grünbacher wrote:
> Am Mi., 1. März 2023 um 02:07 Uhr schrieb Dave Chinner <david@fromorbit.com>:
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
> > > >     struct xfs_inode        *ip = XFS_I(folio->mapping->host);
> > > >     struct xfs_mount        *mp = ip->i_mount;
> > > > +   xfs_off_t               end_off;
> > > >     int                     error;
> > > >
> > > >     if (xfs_is_shutdown(mp))
> > > > @@ -475,8 +476,17 @@ xfs_discard_folio(
> > > >             "page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
> > > >                     folio, ip->i_ino, pos);
> > > >
> > > > -   error = xfs_bmap_punch_delalloc_range(ip, pos,
> > > > -                   round_up(pos, folio_size(folio)));
> > > > +   /*
> > > > +    * Need to be careful with the case where the pos passed in points to
> > > > +    * the first byte of the folio - rounding up won't change the value,
> > > > +    * but in all cases here we need to end offset to point to the start
> > > > +    * of the next folio.
> > > > +    */
> > > > +   if (pos == folio_pos(folio))
> > > > +           end_off = pos + folio_size(folio);
> > > > +   else
> > > > +           end_off = round_up(pos, folio_size(folio));
> > >
> > > Can this construct be simplified to:
> > >
> > >       end_off = round_up(pos + 1, folio_size(folio));
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
> 
> Hmm. On the other hand, it's not immediately obvious that the if
> statement only does an addition with rounding; it might as well do
> something more complex.

I don't really understand what you are trying to say here.

> Darrick's version avoids making things more
> complicated than they need to be.

At the expense having magic "+ 1"s in the code. Those always lead to
confusion and future off-by-one bugs.

Following the fundamental principle of obvious correctness: If we
are adding a "+ 1" to fix a bug, then the original code was bad and
needs to be reworked to remove the possibility of future, difficult
to detect off-by-one mistakes in the code.

> Other ways of doing the same thing would be:
> 
> end_off = round_down(pos, folio_size(folio)) + folio_size(folio);
> end_off = folio_pos(folio) + folio_size(folio);

That last one is the best suggestion I've heard, because the end
offset is always the first byte of the next folio. That's an
explicit, unambiguous encoding of the exact requirement we need to
fulfil. It does not require rounding, magic "+ 1" values to be
added, etc.

Thanks, Andreas, I'll change it to that.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
