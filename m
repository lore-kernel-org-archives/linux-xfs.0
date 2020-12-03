Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED22FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 960AB22285
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbgLCV41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:56:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731794AbgLCV41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 16:56:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LtGL0009432;
        Thu, 3 Dec 2020 21:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4j1NUz8P113BjVpOxBhy8TNASwseqDhwQkQMyUaByNM=;
 b=UXsgmdfOSTmC6oQQoUx4i2OA0HtFQVa6/f+s3dPzI95IaH7QD5V17dgNwapCmftnYvbh
 V0rlQNCZ9mRTS3oI6C9DjaDQXumCkf/QfvatAnVW5NCMqS0NreSBfoyl8Ai4LC9+mFOK
 LT35i5/O+Y/CyrtUcR1E8kDsCZUwmkMhnmmM6cDTUtevu6r53FkD7n8llpiUFAEvu9CV
 IYhFk6LItpIB2zxGuf4ePAyMWO8YXy+XDp6mtYBkqd/7hdZ2JQKL6pS8J0w651lWvkMf
 53kHhbSlJ7LERBYny52bEbv3GOwO2xiaGYBzULwFudiKaTsdnYBhvACUwJ88Jev/st6d yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egm0ckb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 21:55:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LeXF0128845;
        Thu, 3 Dec 2020 21:55:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540awvd32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 21:55:41 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3Ltew9005825;
        Thu, 3 Dec 2020 21:55:40 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 13:55:40 -0800
Date:   Thu, 3 Dec 2020 13:55:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Maximum height of rmapbt when reflink feature is enabled
Message-ID: <20201203215539.GC106271@magnolia>
References: <3275346.ciGmp8L3Sz@garuda>
 <20201130215114.GH2842436@dread.disaster.area>
 <7691390.z3D37GG2ZM@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7691390.z3D37GG2ZM@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 06:42:34PM +0530, Chandan Babu R wrote:
> On Tue, 01 Dec 2020 08:51:14 +1100, Dave Chinner  wrote:
> > On Mon, Nov 30, 2020 at 02:35:21PM +0530, Chandan Babu R wrote:
> > > The comment in xfs_rmapbt_compute_maxlevels() mentions that with
> > > reflink enabled, XFS will run out of AG blocks before reaching maximum
> > > levels of XFS_BTREE_MAXLEVELS (i.e. 9).  This is easy to prove for 4k
> > > block size case:
> > > 
> > > Considering theoretical limits, maximum height of rmapbt can be,
> > > max btree height = Log_(min_recs)(total recs)
> > > max_rmapbt_height = Log_45(2^64) = 12.
> > 
> > I think the use of mirecs here is wrong. We can continue to fill
> > both leaves and nodes above minrecs once we get to maximal height.
> > When a leaf/node is full, it will attempt to shift records left and
> > right to sibling nodes before trying to split. Hence a split only
> > occurs when all three nodes are completely full.
> > 
> > Hence we'll end up with a much higher average population of leaves
> > and nodes than the minimum when we are at maximum height, especially
> > at the upper levels of the btree near the root.
> > 
> > i.e. we won't try to split the root ever until the root is at
> > maximum capacity, and we won't try to split the next level down
> > (before we get to a root split) until at least 3 adjacent nodes
> > are at max capacity, and so on. Hence at higher levels, the tree is
> > always going to tend towards max capacity nodes, not min capacity.
> > That changes these calculations quite a lot...
> > 
> > > Detailed calculation:
> > > nr-levels = 1; nr-leaf-blks = 2^64 / 84 = 2e17;
> > > nr-levels = 2; nr-blks = 2e17 / 45 = 5e15;
> > > nr-levels = 3; nr-blks = 5e15 / 45 = 1e14;
> > > nr-levels = 4; nr-blks = 1e14 / 45 = 2e12;
> > > nr-levels = 5; nr-blks = 2e12 / 45 = 5e10;
> > > nr-levels = 6; nr-blks = 5e10 / 45 = 1e9;
> > > nr-levels = 7; nr-blks = 1e9 / 45 = 3e7;
> > > nr-levels = 8; nr-blks = 3e7 / 45 = 6e5;
> > > nr-levels = 9; nr-blks = 6e5 / 45 = 1e4;
> > > nr-levels = 10; nr-blks = 1e4 / 45 = 3e2;
> > > nr-levels = 11; nr-blks = 3e2 / 45 = 6;
> > > nr-levels = 12; nr-blks = 1;
> > > 
> > > Total number of blocks = 2e17
> > >
> > > Here, 84 is the minimum number of leaf records and 45 is the minimum
> > > number of node records in the rmapbt when using 4k block size. 2^64 is
> > > the maximum possible rmapbt records
> > > (i.e. max_rmap_entries_per_disk_block (2^32) * max_nr_agblocks
> > > (2^32)).
> > >
> > > i.e. theoretically rmapbt height can go upto 12.
> > 
> > Yes, but if the rmapbt contains 2^64 records, how many physical disk
> > blocks does it consume itself? Worst case that's 2^64 / 45, so
> > somewhere between 2^58 and 2^59 blocks of storage required for
> > indexing all those reocrds with a 4kB block size?
> > 
> > Yet we only have 2^28 4kB blocks in an AG, and the limit of a
> > rmapbt is actually what can physically fit in an AG, yes?
> > 
> > So, regardless of what the theoretical record capacity of a worse
> > case rmapbt record fill might be, it hits physical record storage
> > limits long before that. i.e. the limit on the btree height is
> > physical storage, not theoretical record indexing capability.
> > 
> > In which case, let us [incorrectly, see later] assume we have a
> > handful of maximally shared single data blocks and the rest of the
> > 1TB AG is rmapbt. i.e.  the maximum depth of the rmapbt is
> > determined by how much physical space it can consume, which is very
> > close to 2^32 blocks for 1kB filesystems.
> > 
> > Let's work from max capacity, so 2^32 * 21 is the max record holding
> > capacity of the per-ag rmapbt.  Hence the worst case index height
> > requirement for the rmapbt is indexing ~2^37 records.
> > 
> > nr-levels = 1; nr-leaf-blks = 2^32 * 21 / 21 = 4e9
> > nr-levels = 2; nr-blks = 4e9 / 21 = 2e8;
> > nr-levels = 3; nr-blks = 2e8 / 21 = 9e6;
> > nr-levels = 4; nr-blks = 9e6/ 21 = 4e5;
> > nr-levels = 5; nr-blks = 4e5 / 21 = 2e4;
> > nr-levels = 6; nr-blks = 2e4 / 21 = 1e3;
> > nr-levels = 7; nr-blks = 1e3 / 21 = 50
> > nr-levels = 8; nr-blks = 50 / 21 = 3;
> > nr-levels = 9; nr-blks = 3 / 21 = 1;
> > nr-levels = 10; nr-blks = 1;
> > 
> > So we *just* tick over into a 10 level rmapbt here in this worse
> > case where the rmapbt takes *all* of the AG space.  In comparison,
> > min capacity lower nodes, max capacity higher nodes:
> > 
> > nr-levels = 1; nr-leaf-blks = 2^32 * 11 / 11 = 4e9
> > nr-levels = 2; nr-blks = 4e9 / 11 = 4e8;
> > nr-levels = 3; nr-blks = 4e8 / 11 = 4e7;
> > nr-levels = 4; nr-blks = 4e7/ 11 = 3e6;
> > nr-levels = 5; nr-blks = 3e6 / 21 = 2e5;
> > nr-levels = 6; nr-blks = 2e5 / 21 = 7e3;
> > nr-levels = 7; nr-blks = 7e3 / 21 = 348;
> > nr-levels = 8; nr-blks = 348 / 21 = 16;
> > nr-levels = 9; nr-blks = 16 / 21 = 1;
> > nr-levels = 10; nr-blks = 1;
> > 
> > Same, it's a 10 level tree.
> > 
> > > But as the comment in xfs_rmapbt_compute_maxlevels() suggests, we will
> > > run out of per-ag blocks trying to build an rmapbt of height
> > > XFS_BTREE_MAXLEVELS (i.e. 9).
> > > 
> > > Since number of nodes grows as a geometric series,
> > > nr_nodes (roughly) = (45^9 - 1) / (45 - 1) = 10e12
> > > 
> > > i.e. 10e12 blocks > max ag blocks (2^32 == 4e9)
> > > 
> > > However, with 1k block size we are not close to consuming all of 2^32
> > > AG blocks as shown by the below calculations,
> > > 
> > >  - rmapbt with maximum of 9 levels will have roughly (11^9 - 1) / (11 -
> > >    1) = 2e8 blocks.
> > 
> > 2.35e8, which is a quarter of the max AG space, assuming minimum
> > capacity nodes. Assuming max capacity nodes, we're at
> > 3.9e10 blocks, which is almost 40x the number of blocks in the AG...
> > 
> > >    - 11 is the minimum number of recs in a non-leaf node with 1k block size.
> > >    - Also, Total number of records (roughly) = (nr_leaves * 11) = 11^8 * 11
> > >      = 2e9 (this value will be used later).
> > >  
> > >  - refcountbt
> > >    - Maximum number of records theoretically = maximum number of blocks
> > >      in an AG = 2^32
> > 
> > The logic here is flawed - you're assuming exclusive use of the AG
> > to hold *both* rmapbt records and shared data extents. Every block
> > used for an rmap record cannot have a refcount record pointing at
> > it because per-ag metadata cannot be shared.
> > 
> > >    - Total (leaves and non-leaf nodes) blocks required to hold 2^32 records
> > >      Leaf min recs = 20;  Node min recs = 60 (with 1k as the block size).
> > >      - Detailed calculation:
> > >  	    nr-levels = 1; nr-leaf-blks = 2^32 / 20 = 2e8;
> > >  	    nr-levels = 2; nr-blks = 2e8 / 60 = 4e6
> > >  	    nr-levels = 3; nr-blks = 4e6 / 60 = 6e4
> > >  	    nr-levels = 4; nr-blks = 6e4 / 60 = 1.0e3
> > >  	    nr-levels = 5; nr-blks = 1.0e3 / 60 = 2e1
> > >  	    nr-levels = 6; nr-blks = 1
> > >  
> > >      - Total block count = 2e8
> > 
> > So, if we assume that 20% of the AG space is refcount btree records
> > like this, then the rmapbt only consumes 80% of the AG, then the
> > rmap btree is much closer to the 9 level limit, especially if
> > we consider we'll tend towards max capacity nodes as we fill the
> > tree, not min capacity nodes.
> > 
> > But the reality is that we could have a single refcount record with
> > 2^32 references, and that requires 2^32 rmapbt records. So if we are
> > talking about really high extent refcount situations, the worst case
> > is a handful of single blocks with billions of references. IOWs, the
> > refcountbt is a single block with ~2^5 entries in it, each which
> > track 2^32 references. Now we require 2^37 rmapbt records, and we've
> > overflowed the maximum physical storage capacity of the AG for
> > rmapbt blocks.
> 
> Thanks for the detailed explanation.
> 
> > 
> > >  - Bmbt (assuming all the rmapbt records have the same inode as owner)
> > >    - Total (leaves and non-leaf nodes) blocks required to hold 2e9 records
> > >      Leaf min recs = 29;  Node min recs = 29 (with 1k as the block size).
> > >      (2e9 is the maximum rmapbt records with rmapbt height 9 and 1k block size).
> > >        nr-levels = 1; nr-leaf-blks = 2e9 / 29 = 7e7
> > >        nr-levels = 2; nr-blks = 7e7 / 29 = 2e6
> > >        nr-levels = 3; nr-blks = 2e6 / 29 = 8e4
> > >        nr-levels = 4; nr-blks = 8e4 / 29 = 3e3
> > >        nr-levels = 5; nr-blks = 3e3 / 29 = 1e2
> > >        nr-levels = 6; nr-blks = 1e2 / 29 = 3
> > >        nr-levels = 7; nr-blks = 1
> > >  
> > >    - Total block count = 7e7
> > >  
> > >  Total blocks used across rmapbt, refcountbt and bmbt = 2e8 + 2e8 + 7e7 = 5e8.
> > 
> > BMBT blocks are not bound to an AG the way refcount and rmapbt
> > records are. They can be anywhere in the filesystem, so they play no
> > part in calculations like these.
> > 
> > > Since 5e8 < 4e9(i.e. 2^32), we have not run out of blocks trying
> > > to build a rmapbt with XFS_BTREE_MAXLEVELS (i.e 9) levels.
> > > 
> > > Please let me know if my understanding is incorrect.
> > 
> > The worst case theory is largely sound, but theory != reality.
> > 
> > The actual reality of someone with billions of refcount entries to a
> > a handful of single extents in a single AG is using a 1kB block size
> > is likely to be so rare that we shouldn't consider it a critical
> > design point.
> > 
> > That is, if the values cover the default 4kB block size just fine,
> > then we should not penalise every common configuration just to
> > handle an extreme case in an extremely rare corner case for a
> > non-default configuration.
> 
> Ok.
> 
> > 
> > > I have come across a "log reservation" calculation issue when
> > > increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for
> > > extending data fork extent count to 48 bits.
> > 
> > What is that issue?
> 
> Sorry, I should have described it when sending the original mail.
> 
> Increasing the value of XFS_BTREE_MAXLEVELS to 10 caused the value of
> mp->m_rmap_maxlevels to be set to 10 when reflink feature is enabled. This in
> turn increased "min log size" calculations and hence a modified kernel (one
> with XFS_BTREE_MAXLEVELS set to 10) will fail to mount a filesystem which was
> created by mkfs.xfs which used 9 as the value for XFS_BTREE_MAXLEVELS for its
> "min log size" calculations.
> 
> Of course, this problem is no longer valid because ...

I disagree -- m_rmap_maxlevels should be set to the maximal height of an
rmap btree.  On a reflink filesystem we (theoretically) can create
enough rmappings to make the rmapbt consume more than every block in the
AG.  (In practice the reflink remap code will cut you off long before we
run out of space so this is unlikely unless every block is individually
mapped into files and are shared, or every extent is shared hundreds of
millions of times.

Therefore, the (asymptotic upper bound) on m_rmap_maxlevels for a
reflink+rmap filesystem ought to be the maximal height assuming the
rmapbt consumes every block in the AG.

We're probably stuck with xfs_rmapadd_space_res returning a value no
smaller than 9, though, because it affects the minimum log size and thus
affects the ondisk format. :(

> > 
> > The BMBT modifications should not care about XFS_BTREE_MAXLEVELS as
> > a limit, we use the calculated mp->m_bm_maxlevels[] variables for
> > BMBT height. These are bound by the maximum number of extents the
> > tree can index, not the depth of btrees allowed within an AG.
> > Changing the size of the BMBT tree should not affect the per-ag
> > btrees in any way, nor the log reservations required to manipulate
> > the per-ag btrees...
> 
> Ah, I didn't realize that XFS_BTREE_MAXLEVELS was applicable only to per-AG
> btrees. As mentioned in your response to Darrick, memory for "struct
> xfs_btree_cur" should be allocated based on the maximum height of the btree
> that the code is about to traverse.
> 
> Thanks once again for providing an insight into this.

Yeah, before my eye problems flared up again I was stabilising a
patchset that gets rid of MAXLEVELS entirely.

> -- 
> chandan
> 
> 
> 
