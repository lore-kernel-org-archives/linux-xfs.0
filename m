Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACA9C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 04:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiKXEka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 23:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKXEk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 23:40:29 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD88140CC
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 20:40:28 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x66so632900pfx.3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 20:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsOa0b+azLzNRVkrkvK6vY9yhXL+G3D3wDIO/6iFfIk=;
        b=7804fENegoVbn1ttL3eyHEUjus9u8URf+0qLz5J7sdlCfKPnaDK8W0E8CzK8SkiTdS
         e+A9iZXzcZZzP7s3WkC/SQwEuwtFPXJoyGzkasGiNxP9DQMJosVbhagsfuCakM2luVTM
         xc6+8ZWzmrafm39ERzrc9XIAJDURUzu1jhfh4YMuK3TE+pSd9h9jV73PrdwHP57nSmQP
         w2hKceNiSXq7dtJpivbmMXC8PJopjNxFfLU1NE5J/50dJTGEgZSrkOZKbJWWhwOe9yhh
         e0W+Ok02xLbck3Q00/iJPpK1ecVpD4k4hRCbpk3B+mdXa0fl1oABAvSeaiow+9pKZOck
         qwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PsOa0b+azLzNRVkrkvK6vY9yhXL+G3D3wDIO/6iFfIk=;
        b=bGz2dfXyHoskoKHfN6XIz+IKqD8hBSrOP46Ez8gSmSlcwUQSj4QRPzOy/cSdxDoL7p
         TyVFhnjFB+X6j1RWJE6gjHxPAAQwMwiITZVIpgYb9ugiXcEnDhx22rJQ4LSKIR2PNJ4s
         2wOJIbuOhOjlqKCQfdUNZAVTE/vPK8vMqRM1Mz2MeXi9WOw6FPMzQqdsqn2s1VU4ExzM
         OG+q57zLi51nqqrUFJWQGFuhBrgvsTtPXniF0sqwIepSVrUknBzZV0wUbm8jEP3jj+tH
         opXwfeEy4mQHHncBVfzAgAhtAp8zzX+JvF32rm3QKX3FXvR3YhO90CPqVaVFWlUoCTsq
         NeRA==
X-Gm-Message-State: ANoB5plKXVfW4oFu/5P9pGX1CEWW30gpNApbviFotvyz9xJ4+0OF0ueK
        P1sj+I03hz/ovAsx0+Hn2jDOH87I6Qk2+w==
X-Google-Smtp-Source: AA0mqf4jkETbSSHAwAtV6zmWYIYZYfm8gyQ/si8mlT0w6cyFMOjWylA0CC6/z5v/B1xlUI5cDWEYKg==
X-Received: by 2002:aa7:810e:0:b0:56b:f23a:7854 with SMTP id b14-20020aa7810e000000b0056bf23a7854mr16746462pfi.66.1669264827438;
        Wed, 23 Nov 2022 20:40:27 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id w62-20020a627b41000000b0056b6c7a17c6sm117385pfc.12.2022.11.23.20.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 20:40:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oy42B-000KaT-90; Thu, 24 Nov 2022 15:40:23 +1100
Date:   Thu, 24 Nov 2022 15:40:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: moar weird metadata corruptions, this time on arm64
Message-ID: <20221124044023.GU3600936@dread.disaster.area>
References: <Y3wUwvcxijj0oqBl@magnolia>
 <20221122015806.GQ3600936@dread.disaster.area>
 <Y3579xWtwQEdBFw6@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3579xWtwQEdBFw6@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 23, 2022 at 12:00:55PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 22, 2022 at 12:58:06PM +1100, Dave Chinner wrote:
> > On Mon, Nov 21, 2022 at 04:16:02PM -0800, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > I've been running near-continuous integration testing of online fsck,
> > > and I've noticed that once a day, one of the ARM VMs will fail the test
> > > with out of order records in the data fork.
.....
> In the latest run, I got this trace data:
> 
> ino 0x600a754 nr 0x5 offset 0x304 nextoff 0x31e
> ino 0x600a754 func xfs_bmapi_reserve_delalloc line 4152 data fork:
>     ino 0x600a754 nr 0x0 nr_real 0x0 offset 0x7 blockcount 0xe startblock 0xc12867 state 0
>     ino 0x600a754 nr 0x1 nr_real 0x1 offset 0x78 blockcount 0xc8 startblock 0xc70d25 state 1
>     ino 0x600a754 nr 0x2 nr_real 0x2 offset 0x150 blockcount 0x16 startblock 0xc70dfd state 1
>     ino 0x600a754 nr 0x3 nr_real 0x3 offset 0x2a5 blockcount 0x5f startblock 0xc9f218 state 1
>     ino 0x600a754 nr 0x4 nr_real 0x4 offset 0x318 blockcount 0x6 startblock 0xffffffffe0007 state 0
>     ino 0x600a754 nr 0x5 nr_real 0x4 offset 0x304 blockcount 0x14 startblock 0xc9f277 state 0
>     ino 0x600a754 nr 0x6 nr_real 0x5 offset 0xaf8 blockcount 0x1a startblock 0xd17aa3 state 0
>     ino 0x600a754 nr 0x7 nr_real 0x6 offset 0x12f7 blockcount 0x40 startblock 0xcca511 state 1
>     ino 0x600a754 nr 0x8 nr_real 0x7 offset 0x307c blockcount 0x3 startblock 0xc70ded state 0
>     ino 0x600a754 nr 0x9 nr_real 0x8 offset 0x307f blockcount 0x1 startblock 0xc70df0 state 1
> 
> Here we again see that a delalloc extent was inserted into the wrong
> position in the iext leaf, same as last time.  The extra trace data I
> collected are as follows:
> 
> ino 0x600a754 fork 0 oldoff 0x318 oldlen 0x6 oldprealloc 0x0 isize 0x307e14c
>     ino 0x600a754 oldgotoff 0xaf8 oldgotstart 0xd17aa3 oldgotcount 0x1a oldgotstate 0
>     ino 0x600a754 freshgotoff 0xe0e46156d65cb freshgotstart 0xd178b5 freshgotcount 0x1a freshgotstate 0
>     ino 0x600a754 nowgotoff 0x318 nowgotstart 0xffffffffe0007 nowgotcount 0x6 nowgotstate 0
>     ino 0x600a754 oldicurpos 4 oldleafnr 9 oldleaf 0xfffffc012d8f4680
>     ino 0x600a754 newicurpos 4 newleafnr 10 newleaf 0xfffffc012304d800

.....

> Line 5 is a copy of @icur at the beginning fo the call, and line 6 is
> the contents of @icur after the xfs_bmap_add_extent_hole_delay call.
> Notice that the cursor positions are the same, but the leaf pointers are
> different.  I suspect that leaf ~d8f4680 has been freed, and this is the
> reason why freshgot is totally garbage. 

That implies that a extent tree modification is being made whilst
the delalloc function is holding the ILOCK_EXCL. Either rwsems on
ARM are broken (entirely possible given the subtle memory ordering
of the slow paths has caused this sort of problem on x64-64 multiple
times in the past), or something else isn't holding the ILOCK_EXCL
while modifying the iext tree.

> I wonder if the leaf pointers
> being different is the result of an iext btree splitting into 2 objects
> and then being recombined into one?

That implies multiple operations occurred - the single leaf won't
split until it is full - that's when we add the 15th record to the
tree. We're nowhere near that. And it won't attempt a rebalance that
may merge the the two leaf nodes until a remove occurs and the
number of entries in that leaf drops to half full (7 entries) and
the combined total is less that a full leaf.

Further, this is the left-most leaf, so any split will allocate a
new right sibling and move the entries right in to the new node. If
either the new right or the left node then rebalance, they will
always merge to the left-most leaf and free the right leaf. IOWs,
a grow-split-shrink-merge on the left most leaf in the tree will not
change the address of that left-most leaf - the right leave will get
allocated then freed...

So I'm not sure that even a grow-split-shrink-merge has occurred
concurrently here.....

Oh.... inserting into the root block of the tree results in
xfs_iext_realloc_root() being called, and krealloc() is called to
grow the root leaf block. that points cur->leaf at the newly
reallocated chunk of memory.

Ok, so the change in cursor is to be expected. There's nothing wrong
with the cursor, or that we have a reallocated the root leaf.

That leaves something not holding the right lock when inserting
a new extent,, or rwsems are broken on ARM.

> I augmented the xfs_iext_* functions to check the ILOCK state in all
> functions that are passed an xfs_inode.  None of them tripped across the
> entire fstests cloud run last night, so there's no obvious problem
> there.  The buffered write path takes ILOCK_EXCL and keeps it right up
> to where the debug splat happens, so there's no locking problem there.
> 
> So I started looking for things that could shift the extent count by one.
> Looking for semi-adjacent records, I noticed this:
> 
> nr 0x1 nr_real 0x1 offset 0x78 blockcount 0xc8 startblock 0xc70d25 state 1
> nr 0x2 nr_real 0x2 offset 0x150 blockcount 0x16 startblock 0xc70dfd state 1
> 
> 0xc70d25+0xc8 == 0xc70ded, so this could be the result of someone
> punching 0x10 blocks.
> 
> ino 0x600a754 nr 0x3 nr_real 0x3 offset 0x2a5 blockcount 0x5f startblock 0xc9f218 state 1
> ino 0x600a754 nr 0x5 nr_real 0x4 offset 0x304 blockcount 0x14 startblock 0xc9f277 state 0
> 
> The incorrect delalloc reservation notwithstanding, these two records
> are logically and physically adjacent, with the only difference being
> that one is unwritten and the other is not.  Someone could have
> converted an unwritten extent to written, possibly as a result of a
> post-write conversion?
> 
> ino 0x600a754 nr 0x8 nr_real 0x7 offset 0x307c blockcount 0x3 startblock 0xc70ded state 0
> ino 0x600a754 nr 0x9 nr_real 0x8 offset 0x307f blockcount 0x1 startblock 0xc70df0 state 1
> 
> The 0xc70ded here is familiar -- I wonder if this got mapped here as a
> result of an FIEXCHANGE'd with offset 0x140?  Extent 9 is adjacent with
> extent 8, except for the state difference.  Hmm.  I guess I better go
> check the FIEXCHANGE code...

And there's no such thing a FIEXCHANGE in the upstream current code
base, so that would be a good place to look for shenanigans.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
