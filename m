Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7C4EEAA71
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 21:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjINVsc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 17:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjINVsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 17:48:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD13F270A
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 14:48:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1c3d8fb23d9so12291805ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 14:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694728107; x=1695332907; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=exwyWVoL3wXucbXDFVqg0jgJTS9sr68133tcmZU+/T0=;
        b=KXIA6uGxgb1SczEoyhsXCdn8dH7uOYe3I0Wxht9WeS4dwQ0KcaVnpm7xG0Z+7pFtyH
         AI7O5kb42MuLUlvrWmtc0ifnE426uFMd0EQVf8qqDS0beEOivUc/1/6ZFm+qavf+h/Ko
         TDrpu1jdG7Ex3PR759Q7M4gEq5vgG6FxOvlOTve2FSxm9wg0acCNfUPrs8IvDSsni+u5
         ngm6h3iZRUer5WJ/I24FVJkPuwV+Ipllc3FolmRzJe02SoyFwSuaqr6BfwWQtAFq+gbK
         /98CJ3D6BFTY5Oy7qUE5nEvr8cer3stWriGBIDCZaBWZJzBVPMBDatG2YefHclWYrV/R
         GkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694728107; x=1695332907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exwyWVoL3wXucbXDFVqg0jgJTS9sr68133tcmZU+/T0=;
        b=SJw+krSCaUdrWTKKTqja2QVpa0Npm8k3e0E1UUltxyYXtJOoGK/Mt2IZHN+PnxWZec
         zU6ssLjE3F80EFis2np3ZjklAzW1D6QrNDsfprbzE3Ot+PNxaRZnI2iU/syiwzUBHvuO
         GKeHUQjlBg+DueWq/cqG6943Sj17wyuR5HBuaHHQr3Hdo0JAOhvopkaDX+oyJO1tGq6e
         isD/mqZtEBEt1GGgI55jDcJ/y6TgyiMGrzjEP65L0usZ9oGGFJu8DztgfXGeDcQbooHI
         PIx/sf6j/Kn63xJsDwjzDTo/lggJXYdjG9njOb+uLHaNiKE17mztIDeyMTgEnL8o9iU8
         oiTg==
X-Gm-Message-State: AOJu0YzpDGaUyMsPBaXl21a30mtm6GRYD+TWd8jFLVzKbochxNiboq3v
        UdijcFJMj/rcpvS9mnpFvd5BZw==
X-Google-Smtp-Source: AGHT+IHj7BWF7ZTgjqBBejk8Rdbi8hjwAeD5w01p60NhJYz3ltxFn53uEBjpDv97pVrmB7Oo94tDRw==
X-Received: by 2002:a17:902:f812:b0:1c4:1538:85fc with SMTP id ix18-20020a170902f81200b001c4153885fcmr2180541plb.51.1694728107260;
        Thu, 14 Sep 2023 14:48:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902694600b001b801044466sm2031354plt.114.2023.09.14.14.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 14:48:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qguCG-000mUN-0h;
        Fri, 15 Sep 2023 07:48:24 +1000
Date:   Fri, 15 Sep 2023 07:48:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 1/6] xfs: cache last bitmap block in realtime allocator
Message-ID: <ZQN/qNgZJZdWdxQx@dread.disaster.area>
References: <cover.1693950248.git.osandov@osandov.com>
 <317bb892b0afe4d3355ab78eb7132f174e44d7f7.1693950248.git.osandov@osandov.com>
 <ZPqYU79pTYYZFmf9@dread.disaster.area>
 <20230908152827.GX28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908152827.GX28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 08, 2023 at 08:28:27AM -0700, Darrick J. Wong wrote:
> On Fri, Sep 08, 2023 at 01:43:15PM +1000, Dave Chinner wrote:
> > On Tue, Sep 05, 2023 at 02:51:52PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > Profiling a workload on a highly fragmented realtime device showed a ton
> > > of CPU cycles being spent in xfs_trans_read_buf() called by
> > > xfs_rtbuf_get(). Further tracing showed that much of that was repeated
> > > calls to xfs_rtbuf_get() for the same block of the realtime bitmap.
> > > These come from xfs_rtallocate_extent_block(): as it walks through
> > > ranges of free bits in the bitmap, each call to xfs_rtcheck_range() and
> > > xfs_rtfind_{forw,back}() gets the same bitmap block. If the bitmap block
> > > is very fragmented, then this is _a lot_ of buffer lookups.
> > > 
> > > The realtime allocator already passes around a cache of the last used
> > > realtime summary block to avoid repeated reads (the parameters rbpp and
> > > rsb). We can do the same for the realtime bitmap.
> > > 
> > > This replaces rbpp and rsb with a struct xfs_rtbuf_cache, which caches
> > > the most recently used block for both the realtime bitmap and summary.
> > > xfs_rtbuf_get() now handles the caching instead of the callers, which
> > > requires plumbing xfs_rtbuf_cache to more functions but also makes sure
> > > we don't miss anything.
> > > 
> > > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_rtbitmap.c | 179 ++++++++++++++++++-----------------
> > >  fs/xfs/xfs_rtalloc.c         | 119 +++++++++++------------
> > >  fs/xfs/xfs_rtalloc.h         |  30 ++++--
> > >  3 files changed, 170 insertions(+), 158 deletions(-)
> > 
> > ....
> > 
> > > diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> > > index 62c7ad79cbb6..72f4261bb101 100644
> > > --- a/fs/xfs/xfs_rtalloc.h
> > > +++ b/fs/xfs/xfs_rtalloc.h
> > > @@ -101,29 +101,40 @@ xfs_growfs_rt(
> > >  /*
> > >   * From xfs_rtbitmap.c
> > >   */
> > > +struct xfs_rtbuf_cache {
> > > +	struct xfs_buf *bbuf;	/* bitmap block buffer */
> > > +	xfs_fileoff_t bblock;	/* bitmap block number */
> > > +	struct xfs_buf *sbuf;	/* summary block buffer */
> > > +	xfs_fileoff_t sblock;	/* summary block number */
> > 
> > I don't think the block numbers are file offsets? Most of the code
> > passes the bitmap and summary block numbers around as a
> > xfs_fsblock_t...
> 
> They're fed into xfs_bmapi_read as the xfs_fileoff_t parameter.
> 
> I have a whole series cleaning up all of the units abuse in the rt code
> part of the realtime modernization patchdeluge:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=clean-up-realtime-units
> 
> Here's the specific patch that cleans up this one part:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=realtime-groups&id=b344bd4bd655576f8bda193b0e33f471a6295b05
....

> Could someone (Omar?) take a look at my other rt cleanups too?  I'd very
> much like to get them merged out of my dev tree.

Can you post the series to the list? That makes it much easier to
comment on them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
