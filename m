Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB0BC38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 22:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJYWWr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 18:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiJYWWr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 18:22:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A85F140F1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 15:22:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pb15so12199634pjb.5
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 15:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dEfzmkd/zmtDP9ZXFKwD+VSPCaZQ1HNMr5Q4mgwrHLU=;
        b=LK7elyLvAJJUoHXSpRjU034xmbQXdryXr2NBaxVOS6QGuZk44MHoY4rVpVa/OuHaa/
         EynQ4NIyOKRdVqw5KvL4nadhwIxiQ1GZCOcTA6g/0BhbDXI62W0ZeD4DyW5agWUrSKuX
         L5D6lb/Gals2Ilf0p8C4JQYdf+v/0gpOYN38M/UyAgILPLaB4tIzsUfNLuQaDXZF4O2d
         8dlIYbzGzLDdDBa360PLR29sGXxDVZqzwCOX+3sy68PecSf/q+PRRz+9UfbLBwzAeDkG
         rXmUpd85Df0EloFJdjyZ9VO40jKx3EDQ7TD5sxHCv2ys1xUtHruFoeEHndl2SbyyLEsg
         TQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dEfzmkd/zmtDP9ZXFKwD+VSPCaZQ1HNMr5Q4mgwrHLU=;
        b=ekK2kHY2SRCeB6RLr/+qb/h1Pe8VvworLj1SJKn+BbKqAShQ2sU/Tr4EV6yzvlka4S
         9F5hL0p/9TWg1jlJiNnibEGo2G2d8S+ewGdXhc1kMooDsT0K4j0wuB+jMKP1DDIZk5sN
         4HBeLNDO2MMpwHH0xN2JKMdfDSNqxtE7U+kXlLPWycRWHsxSLyAKc+NrI9tUwlnoy1+5
         Hryw5dUZ7UTwItfWZVnLe1nthPqpRM6+ty95NaFMXX/ocny+H3X0AAdj8LFWJUuzS9vV
         sq5AtEhdH2kLr2TsxbK2umPxogy52Ag8iGkjj6z497vQT7hqlNuSrifuoWUBz2FH5EgS
         Nlxg==
X-Gm-Message-State: ACrzQf39gjb+4MtLkiMAXZlCu+duQKSfprr+pi8zRzkjc7j6CKLvL0+m
        kySZZ/VUIH5LyHa6ZvjgX0vVa+ZM8Im+pw==
X-Google-Smtp-Source: AMsMyM4gJk5P/bBf8FsOBhbvGC4cdMhZLAqbLNvDvkgH3xwzu3VxFArlq1HYLkrzmDBRyJhDNUkVmg==
X-Received: by 2002:a17:903:1245:b0:178:9234:3768 with SMTP id u5-20020a170903124500b0017892343768mr40999257plh.146.1666736564974;
        Tue, 25 Oct 2022 15:22:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id e1-20020a17090a118100b00212daa6f41dsm74644pja.28.2022.10.25.15.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:22:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onSJk-006NoK-Oh; Wed, 26 Oct 2022 09:22:40 +1100
Date:   Wed, 26 Oct 2022 09:22:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: refactor all the EFI/EFD log item sizeof logic
Message-ID: <20221025222240.GH3600936@dread.disaster.area>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664718541.2688790.5847203715269286943.stgit@magnolia>
 <20221025220543.GG3600936@dread.disaster.area>
 <Y1heWlHlPLaxmDQe@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1heWlHlPLaxmDQe@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2022 at 03:08:26PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 26, 2022 at 09:05:43AM +1100, Dave Chinner wrote:
> > On Mon, Oct 24, 2022 at 02:33:05PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Refactor all the open-coded sizeof logic for EFI/EFD log item and log
> > > format structures into common helper functions whose names reflect the
> > > struct names.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_log_format.h |   48 ++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_extfree_item.c      |   69 ++++++++++++----------------------------
> > >  fs/xfs/xfs_extfree_item.h      |   16 +++++++++
> > >  fs/xfs/xfs_super.c             |   12 ++-----
> > >  4 files changed, 88 insertions(+), 57 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > > index 2f41fa8477c9..f13e0809dc63 100644
> > > --- a/fs/xfs/libxfs/xfs_log_format.h
> > > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > > @@ -616,6 +616,14 @@ typedef struct xfs_efi_log_format {
> > >  	xfs_extent_t		efi_extents[];	/* array of extents to free */
> > >  } xfs_efi_log_format_t;
> > >  
> > > +static inline size_t
> > > +xfs_efi_log_format_sizeof(
> > > +	unsigned int		nr)
> > > +{
> > > +	return sizeof(struct xfs_efi_log_format) +
> > > +			nr * sizeof(struct xfs_extent);
> > > +}
> > 
> > FWIW, I'm not really a fan of placing inline code in the on-disk
> > format definition headers because combining code and type
> > definitions eventually leads to dependency hell.
> > 
> > I'm going to say it's OK for these functions to be placed here
> > because they have no external dependencies and are directly related
> > to the on-disk structures, but I think we need to be careful about
> > how much code we include into this header as opposed to the type
> > specific header files (such as fs/xfs/xfs_extfree_item.h)...
> > 
> > > @@ -345,9 +318,8 @@ xfs_trans_get_efd(
> > >  	ASSERT(nextents > 0);
> > >  
> > >  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> > > -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> > > -				nextents * sizeof(struct xfs_extent),
> > > -				0);
> > > +		efdp = kmem_zalloc(xfs_efd_log_item_sizeof(nextents),
> > > +				GFP_KERNEL | __GFP_NOFAIL);
> > 
> > That looks like a broken kmem->kmalloc conversion. Did you mean to
> > convert this to allocation to use kzalloc() at the same time?
> 
> Oops, yeah.

FWIW, I just went back an looked at the efip allocation and you did
the same thing there, I just didn't notice it on the first pass....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
