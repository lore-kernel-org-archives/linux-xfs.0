Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CB9C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 13:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C183207FF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 13:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d44Usw75"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgLANNT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLANNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 08:13:19 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8C0C0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 05:12:39 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id e5so1206397pjt.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 05:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sGOi7C5S4BExAcyJuUCB1Hj7At2fZjOhjs23vWYO3Mk=;
        b=d44Usw75FBhbyEbXXzJqZdG46+WbhHlrjjHL0CiSMmZWUPHJhCqaN7XjD31kEoQ+U1
         hxNNXZ9Cz7oG7c5HmSwJMUtubvk8tHgRNjb2OAI+lGD/QAAKHLLm3GN67z1Y7fniKvWD
         Ku9TtdQB0xrVgGrljl+0wEEx0ooxZv/ztjRuCHvEYTjbvlQIurYWxdvWgBN4QY/jVSSc
         npEOUXRr/0jFnNVDdz4lkwsH9QnCmaZaavFIAHQdNnOFsmgOLuMGQouSftTidVseJZ+s
         o9WQRqpYx9W5w2OAt0WO+czfYPWpu5GS8/g0XK7Y/E6mNVG3Y0GeUIOLxqa8oLO62sZS
         eC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sGOi7C5S4BExAcyJuUCB1Hj7At2fZjOhjs23vWYO3Mk=;
        b=CR7SH5V3CptW1LlFSnWi4B120vfdbTTXv9rjvy8Dm8/3y3mN4u6if941S2c85z67Vf
         Gi0A1grhtQhaoUluyA3Ockvd0h8plHOG7SQx3UadYvCVdieD3ahP5zyb5UdGNJAGNiQL
         cXnZIq4045KGbDtcRfsAw5v+Z4VItT0hVBWWNenTtmO8h92UeNrlV/t2R1N+ku5UME4w
         ctoFs10bfVMwB7B+kTbpp0PnKpcWc4Aip8/L2y3xgsmuRjO7i9xrTuq40BPkv16aB2xY
         w58FLaufVB2PROSs4PZKcBol6r/MZTwC8jIQ7EeQ3XJnGODcinEABJ1vbeJ8j0/oT/TU
         P2XQ==
X-Gm-Message-State: AOAM530wMEMW8U8KQZ27XfKpPy3FVo/WJG08xoLYPFyghO6RAEQont6u
        5WpSE8N2Tnwrt3AqR0B9CAci2hfdgr8=
X-Google-Smtp-Source: ABdhPJzFMDzE6WgXyJY6NZzwQ/3u5br9kRNKjD0KNJRxSIiutJhqsWmzBErqzJEFlGYnjqzFJ+5t+w==
X-Received: by 2002:a17:90a:7e8e:: with SMTP id j14mr2554574pjl.60.1606828358476;
        Tue, 01 Dec 2020 05:12:38 -0800 (PST)
Received: from garuda.localnet ([122.171.217.238])
        by smtp.gmail.com with ESMTPSA id e31sm2557134pgb.16.2020.12.01.05.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 05:12:37 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: Maximum height of rmapbt when reflink feature is enabled
Date:   Tue, 01 Dec 2020 18:42:34 +0530
Message-ID: <7691390.z3D37GG2ZM@garuda>
In-Reply-To: <20201130215114.GH2842436@dread.disaster.area>
References: <3275346.ciGmp8L3Sz@garuda> <20201130215114.GH2842436@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 01 Dec 2020 08:51:14 +1100, Dave Chinner  wrote:
> On Mon, Nov 30, 2020 at 02:35:21PM +0530, Chandan Babu R wrote:
> > The comment in xfs_rmapbt_compute_maxlevels() mentions that with
> > reflink enabled, XFS will run out of AG blocks before reaching maximum
> > levels of XFS_BTREE_MAXLEVELS (i.e. 9).  This is easy to prove for 4k
> > block size case:
> > 
> > Considering theoretical limits, maximum height of rmapbt can be,
> > max btree height = Log_(min_recs)(total recs)
> > max_rmapbt_height = Log_45(2^64) = 12.
> 
> I think the use of mirecs here is wrong. We can continue to fill
> both leaves and nodes above minrecs once we get to maximal height.
> When a leaf/node is full, it will attempt to shift records left and
> right to sibling nodes before trying to split. Hence a split only
> occurs when all three nodes are completely full.
> 
> Hence we'll end up with a much higher average population of leaves
> and nodes than the minimum when we are at maximum height, especially
> at the upper levels of the btree near the root.
> 
> i.e. we won't try to split the root ever until the root is at
> maximum capacity, and we won't try to split the next level down
> (before we get to a root split) until at least 3 adjacent nodes
> are at max capacity, and so on. Hence at higher levels, the tree is
> always going to tend towards max capacity nodes, not min capacity.
> That changes these calculations quite a lot...
> 
> > Detailed calculation:
> > nr-levels = 1; nr-leaf-blks = 2^64 / 84 = 2e17;
> > nr-levels = 2; nr-blks = 2e17 / 45 = 5e15;
> > nr-levels = 3; nr-blks = 5e15 / 45 = 1e14;
> > nr-levels = 4; nr-blks = 1e14 / 45 = 2e12;
> > nr-levels = 5; nr-blks = 2e12 / 45 = 5e10;
> > nr-levels = 6; nr-blks = 5e10 / 45 = 1e9;
> > nr-levels = 7; nr-blks = 1e9 / 45 = 3e7;
> > nr-levels = 8; nr-blks = 3e7 / 45 = 6e5;
> > nr-levels = 9; nr-blks = 6e5 / 45 = 1e4;
> > nr-levels = 10; nr-blks = 1e4 / 45 = 3e2;
> > nr-levels = 11; nr-blks = 3e2 / 45 = 6;
> > nr-levels = 12; nr-blks = 1;
> > 
> > Total number of blocks = 2e17
> >
> > Here, 84 is the minimum number of leaf records and 45 is the minimum
> > number of node records in the rmapbt when using 4k block size. 2^64 is
> > the maximum possible rmapbt records
> > (i.e. max_rmap_entries_per_disk_block (2^32) * max_nr_agblocks
> > (2^32)).
> >
> > i.e. theoretically rmapbt height can go upto 12.
> 
> Yes, but if the rmapbt contains 2^64 records, how many physical disk
> blocks does it consume itself? Worst case that's 2^64 / 45, so
> somewhere between 2^58 and 2^59 blocks of storage required for
> indexing all those reocrds with a 4kB block size?
> 
> Yet we only have 2^28 4kB blocks in an AG, and the limit of a
> rmapbt is actually what can physically fit in an AG, yes?
> 
> So, regardless of what the theoretical record capacity of a worse
> case rmapbt record fill might be, it hits physical record storage
> limits long before that. i.e. the limit on the btree height is
> physical storage, not theoretical record indexing capability.
> 
> In which case, let us [incorrectly, see later] assume we have a
> handful of maximally shared single data blocks and the rest of the
> 1TB AG is rmapbt. i.e.  the maximum depth of the rmapbt is
> determined by how much physical space it can consume, which is very
> close to 2^32 blocks for 1kB filesystems.
> 
> Let's work from max capacity, so 2^32 * 21 is the max record holding
> capacity of the per-ag rmapbt.  Hence the worst case index height
> requirement for the rmapbt is indexing ~2^37 records.
> 
> nr-levels = 1; nr-leaf-blks = 2^32 * 21 / 21 = 4e9
> nr-levels = 2; nr-blks = 4e9 / 21 = 2e8;
> nr-levels = 3; nr-blks = 2e8 / 21 = 9e6;
> nr-levels = 4; nr-blks = 9e6/ 21 = 4e5;
> nr-levels = 5; nr-blks = 4e5 / 21 = 2e4;
> nr-levels = 6; nr-blks = 2e4 / 21 = 1e3;
> nr-levels = 7; nr-blks = 1e3 / 21 = 50
> nr-levels = 8; nr-blks = 50 / 21 = 3;
> nr-levels = 9; nr-blks = 3 / 21 = 1;
> nr-levels = 10; nr-blks = 1;
> 
> So we *just* tick over into a 10 level rmapbt here in this worse
> case where the rmapbt takes *all* of the AG space.  In comparison,
> min capacity lower nodes, max capacity higher nodes:
> 
> nr-levels = 1; nr-leaf-blks = 2^32 * 11 / 11 = 4e9
> nr-levels = 2; nr-blks = 4e9 / 11 = 4e8;
> nr-levels = 3; nr-blks = 4e8 / 11 = 4e7;
> nr-levels = 4; nr-blks = 4e7/ 11 = 3e6;
> nr-levels = 5; nr-blks = 3e6 / 21 = 2e5;
> nr-levels = 6; nr-blks = 2e5 / 21 = 7e3;
> nr-levels = 7; nr-blks = 7e3 / 21 = 348;
> nr-levels = 8; nr-blks = 348 / 21 = 16;
> nr-levels = 9; nr-blks = 16 / 21 = 1;
> nr-levels = 10; nr-blks = 1;
> 
> Same, it's a 10 level tree.
> 
> > But as the comment in xfs_rmapbt_compute_maxlevels() suggests, we will
> > run out of per-ag blocks trying to build an rmapbt of height
> > XFS_BTREE_MAXLEVELS (i.e. 9).
> > 
> > Since number of nodes grows as a geometric series,
> > nr_nodes (roughly) = (45^9 - 1) / (45 - 1) = 10e12
> > 
> > i.e. 10e12 blocks > max ag blocks (2^32 == 4e9)
> > 
> > However, with 1k block size we are not close to consuming all of 2^32
> > AG blocks as shown by the below calculations,
> > 
> >  - rmapbt with maximum of 9 levels will have roughly (11^9 - 1) / (11 -
> >    1) = 2e8 blocks.
> 
> 2.35e8, which is a quarter of the max AG space, assuming minimum
> capacity nodes. Assuming max capacity nodes, we're at
> 3.9e10 blocks, which is almost 40x the number of blocks in the AG...
> 
> >    - 11 is the minimum number of recs in a non-leaf node with 1k block size.
> >    - Also, Total number of records (roughly) = (nr_leaves * 11) = 11^8 * 11
> >      = 2e9 (this value will be used later).
> >  
> >  - refcountbt
> >    - Maximum number of records theoretically = maximum number of blocks
> >      in an AG = 2^32
> 
> The logic here is flawed - you're assuming exclusive use of the AG
> to hold *both* rmapbt records and shared data extents. Every block
> used for an rmap record cannot have a refcount record pointing at
> it because per-ag metadata cannot be shared.
> 
> >    - Total (leaves and non-leaf nodes) blocks required to hold 2^32 records
> >      Leaf min recs = 20;  Node min recs = 60 (with 1k as the block size).
> >      - Detailed calculation:
> >  	    nr-levels = 1; nr-leaf-blks = 2^32 / 20 = 2e8;
> >  	    nr-levels = 2; nr-blks = 2e8 / 60 = 4e6
> >  	    nr-levels = 3; nr-blks = 4e6 / 60 = 6e4
> >  	    nr-levels = 4; nr-blks = 6e4 / 60 = 1.0e3
> >  	    nr-levels = 5; nr-blks = 1.0e3 / 60 = 2e1
> >  	    nr-levels = 6; nr-blks = 1
> >  
> >      - Total block count = 2e8
> 
> So, if we assume that 20% of the AG space is refcount btree records
> like this, then the rmapbt only consumes 80% of the AG, then the
> rmap btree is much closer to the 9 level limit, especially if
> we consider we'll tend towards max capacity nodes as we fill the
> tree, not min capacity nodes.
> 
> But the reality is that we could have a single refcount record with
> 2^32 references, and that requires 2^32 rmapbt records. So if we are
> talking about really high extent refcount situations, the worst case
> is a handful of single blocks with billions of references. IOWs, the
> refcountbt is a single block with ~2^5 entries in it, each which
> track 2^32 references. Now we require 2^37 rmapbt records, and we've
> overflowed the maximum physical storage capacity of the AG for
> rmapbt blocks.

Thanks for the detailed explanation.

> 
> >  - Bmbt (assuming all the rmapbt records have the same inode as owner)
> >    - Total (leaves and non-leaf nodes) blocks required to hold 2e9 records
> >      Leaf min recs = 29;  Node min recs = 29 (with 1k as the block size).
> >      (2e9 is the maximum rmapbt records with rmapbt height 9 and 1k block size).
> >        nr-levels = 1; nr-leaf-blks = 2e9 / 29 = 7e7
> >        nr-levels = 2; nr-blks = 7e7 / 29 = 2e6
> >        nr-levels = 3; nr-blks = 2e6 / 29 = 8e4
> >        nr-levels = 4; nr-blks = 8e4 / 29 = 3e3
> >        nr-levels = 5; nr-blks = 3e3 / 29 = 1e2
> >        nr-levels = 6; nr-blks = 1e2 / 29 = 3
> >        nr-levels = 7; nr-blks = 1
> >  
> >    - Total block count = 7e7
> >  
> >  Total blocks used across rmapbt, refcountbt and bmbt = 2e8 + 2e8 + 7e7 = 5e8.
> 
> BMBT blocks are not bound to an AG the way refcount and rmapbt
> records are. They can be anywhere in the filesystem, so they play no
> part in calculations like these.
> 
> > Since 5e8 < 4e9(i.e. 2^32), we have not run out of blocks trying
> > to build a rmapbt with XFS_BTREE_MAXLEVELS (i.e 9) levels.
> > 
> > Please let me know if my understanding is incorrect.
> 
> The worst case theory is largely sound, but theory != reality.
> 
> The actual reality of someone with billions of refcount entries to a
> a handful of single extents in a single AG is using a 1kB block size
> is likely to be so rare that we shouldn't consider it a critical
> design point.
> 
> That is, if the values cover the default 4kB block size just fine,
> then we should not penalise every common configuration just to
> handle an extreme case in an extremely rare corner case for a
> non-default configuration.

Ok.

> 
> > I have come across a "log reservation" calculation issue when
> > increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for
> > extending data fork extent count to 48 bits.
> 
> What is that issue?

Sorry, I should have described it when sending the original mail.

Increasing the value of XFS_BTREE_MAXLEVELS to 10 caused the value of
mp->m_rmap_maxlevels to be set to 10 when reflink feature is enabled. This in
turn increased "min log size" calculations and hence a modified kernel (one
with XFS_BTREE_MAXLEVELS set to 10) will fail to mount a filesystem which was
created by mkfs.xfs which used 9 as the value for XFS_BTREE_MAXLEVELS for its
"min log size" calculations.

Of course, this problem is no longer valid because ...

> 
> The BMBT modifications should not care about XFS_BTREE_MAXLEVELS as
> a limit, we use the calculated mp->m_bm_maxlevels[] variables for
> BMBT height. These are bound by the maximum number of extents the
> tree can index, not the depth of btrees allowed within an AG.
> Changing the size of the BMBT tree should not affect the per-ag
> btrees in any way, nor the log reservations required to manipulate
> the per-ag btrees...

Ah, I didn't realize that XFS_BTREE_MAXLEVELS was applicable only to per-AG
btrees. As mentioned in your response to Darrick, memory for "struct
xfs_btree_cur" should be allocated based on the maximum height of the btree
that the code is about to traverse.

Thanks once again for providing an insight into this.

-- 
chandan



