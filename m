Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726B0C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 01:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiDAB3D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 21:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiDAB3D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 21:29:03 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2786D1E017A
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 18:27:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F17F5534270;
        Fri,  1 Apr 2022 12:27:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1na64G-00CIqg-4i; Fri, 01 Apr 2022 12:27:12 +1100
Date:   Fri, 1 Apr 2022 12:27:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
Message-ID: <20220401012712.GJ1544202@dread.disaster.area>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
 <87sfr1nxj7.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220329062340.GY1544202@dread.disaster.area>
 <20220330034333.GG27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330034333.GG27690@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=624654f2
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=Svv7V-RX2cpxqv_diF8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 08:43:33PM -0700, Darrick J. Wong wrote:
> But then the second question is: what's the maximum height of a dabtree
> that indexes an xattr structure?  I don't think there's any maximum
> limit within XFS on the number of attrs you can set on a file, is there?

Nope. But the attr btree is a different beast to the dirv2
structure - it's a hashed index btree with the xattr records in the
leaf, it's not an index of a fixed max size external data structure.

> At least until you hit the iext_max_count check.  I think the VFS
> institutes its own limit of 64k for the llistxattr buffer, but that's
> about all I can think of.


> I suppose right now the xattr structure can't grow larger than 2^(16+21)
> blocks in size, which is 2^49 bytes, but that's a mix of attr leaves and
> dabtree blocks, unlike directories, right?

Yes. ALso remote xattr blocks, which aren't stored in the dabtree
at all, but are indexed by the attr fork BMBT address space.

So I think for XFS_DA_NODE_MAXDEPTH = 5, the xattr tree with a 4kB
block size (minimum allowed, IIRC), we can index approximately
(500^4) individual xattrs in the btree index (assuming 4 levels of
index and 1 level of leaf nodes containing xattrs).

My math calculates that to be about 62.5 billion xattrs before we
run out of index space in a 5 level tree with a 4kB block size.
Hence I suspect we'll run out of attr fork extents even on a 32 bit
extent count before we run out of xattr index space.

Also, 62.5 billion xattrs is more links than we can have to a single
inode (4billion), so we're not going to exhaust the xattr index
space just with parent pointers...

> > immediately how many blocks can be in the XFS_DIR2_LEAF_SPACE
> > segement....
> > 
> > We also know the maximum number of individual directory blocks in
> > the 32GB segment (fixed at 32GB / dir block size), so the free space
> > array is also a fixed size at (32GB / dir block size / free space
> > entries per block).
> > 
> > It's easy to just use (96GB / block size) and that will catch most
> > corruptions with no risk of a false positive detection, but we could
> > quite easily refine this to something like:
> > 
> > data	(32GB +				
> > leaf	 btree blocks(XFS_DA_NODE_MAXDEPTH) +
> > freesp	 (32GB / free space records per block))
> > frags					/ filesystem block size
> 
> I think we ought to do a more careful study of XFS_DA_NODE_MAXDEPTH,

*nod*

ISTR that Chandan had already done some of this when he
characterised the attr fork btree behaviour w.r.t. suitabililty for
large numbers of parent pointers before starting this extent count
work.

> but
> it could become more involved than we think.  In the interest of keeping
> this series moving, can we start with a new verifier check that
> (di_nextents < that formula from above) and then refine that based on
> whatever improvements we may or may not come up with for
> XFS_DA_NODE_MAXDEPTH?

Yup, that sounds like a good plan.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
