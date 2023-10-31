Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8F9C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 22:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjJaWAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 18:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjJaWAA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 18:00:00 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BA1EA
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 14:59:57 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc68c1fac2so11201155ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 14:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698789597; x=1699394397; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BNuszjs+HhhaGf+TwpCiKiWrKOCUPZMcfM+/dKOhj5Q=;
        b=TngKXeC4B5+6nI2vhC7B3Rcg1XBH03h3MfuxDYykV6BMpeXDoGdS9p0/8uLSj7vyNh
         AlOUU7lV3fMN92KQIhx3xUIQ+mqwpzCupGDCrwInApvGh7VuphtR6mI1a3lDROZ2MFi3
         Ojis3XdYjJzzJlfNE6CQ4wqpoviwFGJRrdc6kF/iJlE9AyRiy8k1rDTLIjisMyJtkZQ2
         WtZ1cz5jgt2uFJWykaqHtX867V1G5RYAi/XFz3xGk1ay6lfmVei1L0vAUbSLsOHKxkgE
         qPg3yjqu7ehT9hCRa3GykzRcGXcAnTJZhLm9sZ3HfqcWMqPt0zv0IpTysNftelWBYZaL
         guFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698789597; x=1699394397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNuszjs+HhhaGf+TwpCiKiWrKOCUPZMcfM+/dKOhj5Q=;
        b=g8MGChzO+apTW36dnE141xigLLwF3rTJwehKK1C8METJ7laVZqvWANbAQ/qGFqmCeo
         uYAGULATUHlkT8prCu2+tS5idqfsyqq/JiFWN+Is0fwM1b62FtcAxrw5dzGETF0ldSrv
         fh0H2OYNh/BeTgeU1D+0EYiBUefxn9on41z27HWa+4OmD5zefERS3UDpfO1gtnW2fCtz
         /lItGhtUleZe8mJlRbzvoeA1CBefNdowR/JzPiaW9OOXrjN5L2hISbmpqxrmVwFuhtvt
         VKBrAQ6m64CJJClMIka3vz/O+IftoDh+oTVdhs1lS8+3Y3tYRrAo8Dhhtu50TJTDOgts
         JCzw==
X-Gm-Message-State: AOJu0Yw+TLSjBcdEmsHan0RhjZq3jZpKzceO+hs1QLNaMl/lsbyUrGsu
        vVWpV4y1cBmVaGH+nHrx8GfbcQ==
X-Google-Smtp-Source: AGHT+IE3vaiTbLiF6/V7sNPdvfS3STQxwrfJjFHF6hrLdrv7KiXFbajCoUznjIEpsGxpjBAU8WoSXQ==
X-Received: by 2002:a17:902:d306:b0:1c9:fdf0:f69 with SMTP id b6-20020a170902d30600b001c9fdf00f69mr12490784plc.63.1698789597088;
        Tue, 31 Oct 2023 14:59:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id jk6-20020a170903330600b001c61901ed2esm43547plb.219.2023.10.31.14.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 14:59:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qxwm9-006WxX-2m;
        Wed, 01 Nov 2023 08:59:53 +1100
Date:   Wed, 1 Nov 2023 08:59:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2] xfs: fix internal error from AGFL exhaustion
Message-ID: <ZUF42edjN9VDc9SO@dread.disaster.area>
References: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
 <20231031212400.GA1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031212400.GA1205143@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2023 at 02:24:00PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 30, 2023 at 02:00:02PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > We've been seeing XFS errors like the following:
> > 
> > XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
> > ...
> > Call Trace:
> >  xfs_corruption_error+0x94/0xa0
> >  xfs_btree_insert+0x221/0x280
> >  xfs_alloc_fixup_trees+0x104/0x3e0
> >  xfs_alloc_ag_vextent_size+0x667/0x820
> >  xfs_alloc_fix_freelist+0x5d9/0x750
> >  xfs_free_extent_fix_freelist+0x65/0xa0
> >  __xfs_free_extent+0x57/0x180
> > ...
> > 
> > This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
> > xfs_btree_insrec() fails.
> > 
> > After converting this into a panic and dissecting the core dump, I found
> > that xfs_btree_insrec() is failing because it's trying to split a leaf
> > node in the cntbt when the AG free list is empty. In particular, it's
> > failing to get a block from the AGFL _while trying to refill the AGFL_.
> > 
> > If a single operation splits every level of the bnobt and the cntbt (and
> > the rmapbt if it is enabled) at once, the free list will be empty. Then,
> > when the next operation tries to refill the free list, it allocates
> > space. If the allocation does not use a full extent, it will need to
> > insert records for the remaining space in the bnobt and cntbt. And if
> > those new records go in full leaves, the leaves (and potentially more
> > nodes up to the old root) need to be split.
> > 
> > Fix it by accounting for the additional splits that may be required to
> > refill the free list in the calculation for the minimum free list size.
> > 
> > P.S. As far as I can tell, this bug has existed for a long time -- maybe
> > back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
> > ...") in April 1994! It requires a very unlucky sequence of events, and
> > in fact we didn't hit it until a particular sparse mmap workload updated
> > from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
> > exposed by some other change in allocation or writeback patterns. It's
> > also much less likely to be hit with the rmapbt enabled, since that
> > increases the minimum free list size and is unlikely to split at the
> > same time as the bnobt and cntbt.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> > Changes since v1 [1]:
> > 
> > - Updated calculation to account for internal nodes that may also need
> >   to be split.
> > - Updated comments and commit message accordingly.
> > 
> > 1: https://lore.kernel.org/linux-xfs/ZTrSiwF7OAq0hJHn@dread.disaster.area/T/
> > 
> >  fs/xfs/libxfs/xfs_alloc.c | 25 ++++++++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 3069194527dd..3949c6ad0cce 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2275,16 +2275,35 @@ xfs_alloc_min_freelist(
> >  
> >  	ASSERT(mp->m_alloc_maxlevels > 0);
> >  
> > +	/*
> > +	 * For a btree shorter than the maximum height, the worst case is that
> > +	 * every level gets split and a new level is added, then while inserting
> > +	 * another entry to refill the AGFL, every level under the old root gets
> > +	 * split again. This is:
> > +	 *
> > +	 *   (current height + 1) + (current height - 1)
> 
> Could you make this comment define this relationship more explicitly?
> 
> 	 *   (full height split reservation) + (AGFL refill split height)
> 	 *   (current height + 1) + (current height - 1)
> 
> With that added,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Yup, with that comment change I'm happy with it, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
