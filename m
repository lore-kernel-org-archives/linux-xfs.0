Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AA5C07545
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 05:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjJYFON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 01:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjJYFOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 01:14:12 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E718812A
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 22:14:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c9e06f058bso3822235ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 22:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1698210849; x=1698815649; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=abjZV2BedOMB4n+9PKJCTggt3iGle5q+1EgjR3w4u28=;
        b=xXuDxZpgb3oqQGxd53Hu+QOT9bGskR6RXUmK+DcsrlC8xYiup2Q3SFx2VNoE9bcWrC
         /Yk2otGE0+0cRvA1/+Qw/OL6mtb5y6bdMBeogUaq6Gr3BQdqF+vQErDmaXNXSZ5vSH6f
         t7jBS4weDvpGezilyefbcmqJfH0kg8gq3otbsRpqSrrCboAXt4ChxMYb+saRd9MB/ZZN
         XSS13kvzBMc9DNgGL4kYJCmDHkospaQY5c4BTiooQLywegfnMnItdEWuG8jP4CLO/oF4
         7bF7Yr7PE0gUoUPkQ8hm+BErZaXmIWblq8M2fodz38nANr6UCqVYH9veks4rOh1Qx1FX
         DcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698210849; x=1698815649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abjZV2BedOMB4n+9PKJCTggt3iGle5q+1EgjR3w4u28=;
        b=NaHqKuQ2VbVqLHpplKZkt1Wbi29w/my/Nfo1M3HhXZl6VOjJqPSkHexq9UiZNTdZNT
         6paKqouSbdde3QxwgzhMI3yAAm5BP4ieO+C97mwWbGxyVzniSRLMi/zwhUp4wvNI8Kx5
         bE74VGnsd8NiwNz91Fw40wbWteFbxefYWWGjnfi1Tpw6y+Rjjv9DPAO1buxDRCjdG73q
         KeB5uM3C6EmbdKkBUzIAqCl+aooYYafFBKq81HF7hzlOM8mXXYnTJNrZRluhogYCwS44
         Cjay6xLTVeh7Giv24s9IWAIZnlJjYeowSldk3Loqk9jO9W17Cqnr/YZohhLbAX1G4Bwj
         kh3A==
X-Gm-Message-State: AOJu0YxiAMznWv87LAwp1/IegDCwrdKGi6FSCkZslvyxVGf1avqCT2VJ
        3NUOjWVjoKW9B4JFRjA+7gwNjA==
X-Google-Smtp-Source: AGHT+IGXjNeKm1+PhBqU6co7e2JJ52xwPjOviIf/UhUyEgdGZyIZCfKIpYYxATizcZpESs1/ZTqAjA==
X-Received: by 2002:a17:902:dacc:b0:1c9:dac0:fbc2 with SMTP id q12-20020a170902dacc00b001c9dac0fbc2mr23036392plx.13.1698210849278;
        Tue, 24 Oct 2023 22:14:09 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::4:161b])
        by smtp.gmail.com with ESMTPSA id l12-20020a170902f68c00b001bdeb6bdfbasm8200220plg.241.2023.10.24.22.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 22:14:08 -0700 (PDT)
Date:   Tue, 24 Oct 2023 22:14:07 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] xfs: fix internal error from AGFL exhaustion
Message-ID: <ZTikH67goprXtn1+@telecaster>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <ZTibBf0ef5PMcJiH@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTibBf0ef5PMcJiH@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 03:35:17PM +1100, Dave Chinner wrote:
> On Tue, Oct 24, 2023 at 04:37:33PM -0700, Omar Sandoval wrote:
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
> 
> Good find, Omar!
> 
> For completeness, what's the rest of the trace? We've recently
> changed how extent freeing path works w.r.t. busy extents so I'm
> curious as to what the path into this code is.

This one is from my fpunch reproducer, but there were two call traces we
actually saw in production. One from writeback:

xfs_corruption_error+0x90/0xa0
xfs_btree_insert+0x1b1/0x1d0
xfs_alloc_fixup_trees+0x28e/0x450
xfs_alloc_ag_vextent_size+0x4e0/0x780
xfs_alloc_ag_vextent+0x11c/0x140
xfs_alloc_fix_freelist+0x3f2/0x510
xfs_alloc_vextent+0x254/0x490
xfs_bmap_btalloc+0x301/0x6e0
xfs_bmapi_allocate+0x206/0x2d0
xfs_bmapi_convert_delalloc+0x2b9/0x450
xfs_map_blocks+0x1cc/0x470
iomap_do_writepage+0x22b/0x860
write_cache_pages+0x1ae/0x4c0
iomap_writepages+0x1c/0x40
xfs_vm_writepages+0x6b/0xa0
do_writepages+0x6f/0x1d0
__writeback_single_inode+0x39/0x2b0
writeback_sb_inodes+0x277/0x510
__writeback_inodes_wb+0x6e/0xe0
wb_writeback+0xda/0x250
wb_workfn+0x1f4/0x430
process_one_work+0x12c/0x490
worker_thread+0x143/0x3e0
kthread+0xa3/0xd0
ret_from_fork+0x1f/0x30

And one from inodegc:

xfs_corruption_error+0x90/0xa0
xfs_btree_insert+0x1b1/0x1d0
xfs_alloc_fixup_trees+0x28e/0x450
xfs_alloc_ag_vextent_size+0x4e0/0x780
xfs_alloc_ag_vextent+0x11c/0x140
xfs_alloc_fix_freelist+0x3f2/0x510
__xfs_free_extent+0xde/0x1f0
xfs_trans_free_extent+0x54/0xd0
xfs_extent_free_finish_item+0x69/0xa0
xfs_defer_finish_noroll+0x163/0x510
xfs_defer_finish+0x10/0x70
xfs_itruncate_extents_flags+0x13a/0x250
xfs_inactive_truncate+0xac/0xe0
xfs_inactive+0x14f/0x160
xfs_inodegc_worker+0x81/0x100
process_one_work+0x12c/0x490
worker_thread+0x143/0x3e0
kthread+0xa3/0xd0
ret_from_fork+0x1f/0x30

These are both from 5.19.

> > (It's guaranteed that
> > none of the internal nodes need to be split because they were just
> > split.)
> 
> Hmmm. That doesn't sound right - btrees don't work that way.
> 
> We don't know what path the tree split along in the previous insert
> operation  - a split only guarantees the next insert along that same
> path won't split if the insert hits one of the two leaf blocks from
> the split.  Insert into a different leaf can still split interior
> nodes all the way back up the tree the point where it intersects
> with the previous full height split path.
> 
> e.g. if the previous full height split was down the left side of the
> tree and the next insert is in the right half of the tree, the right
> half can split on insert all the way up to the level below the old
> root.

You're right, I was only thinking about the 2->3 level case. My
assumption is only true in that case.

> > Fix it by adding an extra block of slack in the freelist for the
> > potential leaf split in each of the bnobt and cntbt.
> 
> Hmmm. yeah - example given is 2->3 level split, hence only need to
> handle a single level leaf split before path intersection occurs.
> Yup, adding an extra block will make the exact problem being seen go
> away.
> 
> Ok, what's the general solution? 4-level, 5-level or larger trees?
> 
> Worst split after a full split is up to the level below the old root
> block. the root block was split, so it won't need a split again, so
> only it's children could split again. OK, so that's (height - 1)
> needed for a max split to refill the AGFL after a full height split
> occurred.
> 
> Hence it looks like the minimum AGFL space for any given
> allocation/free operation needs to be:
> 
> 	(full height split reservation) + (AGFL refill split height)
> 
> which is:
> 
> 	= (new height) + (new height - 2)
> 	= 2 * new height - 2
> 	= 2 * (current height + 1) - 2
> 	= 2 * current height
> 
> Ok, so we essentially have to double the AGFL minimum size to handle
> the generic case of AGFL refill splitting free space trees after a
> transaction that has exhausted it's AGFL reservation.
> 
> Now, did I get that right?

That sounds right, but I'll have to think about it more after some sleep
:)

Assuming that is correct, your LE search suggestion sounds kind of nice
rather than such a drastic change to the AGFL size.

> The rmapbt case will need this change, too, because rmapbt blocks
> are allocated from the free list and so an rmapbt update can exhaust
> the free list completely, too.

Ah, I missed where the rmapbt is updated since it was slightly removed
from the xfs_alloc_fixup_trees() code path I was looking at.

Thanks for the quick review!

Omar
