Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E99C2D0F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 22:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C14C20730
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 22:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDHWny (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 18:43:54 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35780 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgDHWny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 18:43:54 -0400
Received: from dread.disaster.area (pa49-180-125-11.pa.nsw.optusnet.com.au [49.180.125.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8EFA63A341E;
        Thu,  9 Apr 2020 08:43:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jMJQD-0005Ko-MI; Thu, 09 Apr 2020 08:43:49 +1000
Date:   Thu, 9 Apr 2020 08:43:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200408224349.GM24067@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200406170603.GD6742@magnolia>
 <20200406233002.GD21885@dread.disaster.area>
 <2451772.FeN4kIriKq@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2451772.FeN4kIriKq@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=2h+yFbpuifLtD1c++IMymA==:117 a=2h+yFbpuifLtD1c++IMymA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=QaacRf8putl0ykkBw3YA:9
        a=uiYzw-ef_oYewXJ7:21 a=AkmC_BgpFs2L0tZf:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 08, 2020 at 06:13:45PM +0530, Chandan Rajendra wrote:
> On Tuesday, April 7, 2020 5:00 AM Dave Chinner wrote: 
> > On Mon, Apr 06, 2020 at 10:06:03AM -0700, Darrick J. Wong wrote:
> > > On Sat, Apr 04, 2020 at 02:22:03PM +0530, Chandan Rajendra wrote:
> > > > XFS has a per-inode xattr extent counter which is 16 bits wide. A workload
> > > > which
> > > > 1. Creates 1,000,000 255-byte sized xattrs,
> > > > 2. Deletes 50% of these xattrs in an alternating manner,
> > > > 3. Tries to create 400,000 new 255-byte sized xattrs
> > > > causes the following message to be printed on the console,
> > > > 
> > > > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > > > XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> > > > 
> > > > This indicates that we overflowed the 16-bits wide xattr extent counter.
> > > > 
> > > > I have been informed that there are instances where a single file has
> > > >  > 100 million hardlinks. With parent pointers being stored in xattr,
> > > > we will overflow the 16-bits wide xattr extent counter when large
> > > > number of hardlinks are created.
> > > > 
> > > > Hence this commit extends xattr extent counter to 32-bits. It also introduces
> > > > an incompat flag to prevent older kernels from mounting newer filesystems with
> > > > 32-bit wide xattr extent counter.
> > > > 
> > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++-------
> > > >  fs/xfs/libxfs/xfs_inode_buf.c  | 27 +++++++++++++++++++--------
> > > >  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
> > > >  fs/xfs/libxfs/xfs_log_format.h |  5 +++--
> > > >  fs/xfs/libxfs/xfs_types.h      |  4 ++--
> > > >  fs/xfs/scrub/inode.c           |  7 ++++---
> > > >  fs/xfs/xfs_inode_item.c        |  3 ++-
> > > >  fs/xfs/xfs_log_recover.c       | 13 ++++++++++---
> > > >  8 files changed, 63 insertions(+), 27 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > > index 045556e78ee2c..0a4266b0d46e1 100644
> > > > --- a/fs/xfs/libxfs/xfs_format.h
> > > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > > @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
> > > >  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> > > >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> > > >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> > > > +#define XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR (1 << 3)
> > > 
> > > If you're going to introduce an INCOMPAT feature, please also use the
> > > opportunity to convert xattrs to something resembling the dir v3 format,
> > > where we index free space within each block so that we can speed up attr
> > > setting with 100 million attrs.
> > 
> > Not necessary. Chandan has already spent a lot of time investigating
> > that - I suggested doing the investigation probably a year ago when
> > he was looking for stuff to do knowing that this could be a problem
> > parent pointers hit. Long story short - there's no degradation in
> > performance in the dabtree out to tens of millions of records with
> > different fixed size or random sized attributes, nor does various
> > combinations of insert/lookup/remove/replace operations seem to
> > impact the tree performance at scale. IOWs, we hit the 16 bit extent
> > limits of the attribute trees without finding any degradation in
> > performance.
> 
> My benchmarking was limited to working with a maximum of 1,000,000 xattrs. I

/me goes and reviews old emails

Yes, there were a lot of experiements limited to 1M xattrs because
of the 16bit extent count limitations once the tree modifications
started removing blocks and allocating new ones, but:

| Dave, I have experimented and found that xattr insertion and deletion
| operations consume cpu time in a O(N) manner. Below is a sample of such an
| experiment,
|
| | Nr attributes | Create | Delete |
| |---------------+--------+--------|
| |         10000 |   0.07 |   0.06 |
| |         20000 |   0.14 |   0.13 |
| |        100000 |   0.73 |   0.69 |
| |        200000 |   1.50 |   1.30 |
| |       1000000 |   7.87 |   6.39 |
| |       2000000 |  15.76 |  12.56 |
| |      10000000 |  78.68 |  66.53 |

There's 10M attributes with expected scalability behaviour.

Space efficiency for parent-pointer style xattrs out to 10 million
xattrs:

| I extracted some more data from the experiments,
| 
|     1. 13 to 20 bytes name length; Zero length value
|        | Nr xattr | 4kAvg | 4kmin | 4kmax | stddev | Total Nr leaves | Below avg space used | Percentage |
|        |----------+-------+-------+-------+--------+-----------------+----------------------+------------|
|        |    10000 |  3156 |  2100 |  4080 |    978 |             122 |                   56 |      45.90 |
|        |    20000 |  3358 |  2100 |  4080 |    945 |             255 |                  135 |      52.94 |
|        |   100000 |  3469 |  2080 |  4080 |    910 |            1349 |                  802 |      59.45 |
|        |   200000 |  2842 |  2080 |  4080 |    747 |            2649 |                 1264 |      47.72 |
|        |   300000 |  2739 |  2080 |  4080 |    699 |            3907 |                 2045 |      52.34 |
|        |   400000 |  2949 |  2080 |  4080 |    699 |            5349 |                 2692 |      50.33 |
|        |   500000 |  2947 |  2080 |  4080 |    714 |            6795 |                 3709 |      54.58 |
|        |   600000 |  2947 |  2080 |  4080 |    588 |            7726 |                 5214 |      67.49 |
|        |   700000 |  2858 |  2080 |  4088 |    619 |            9331 |                 4821 |      51.67 |
|        |   800000 |  3076 |  2080 |  4088 |    626 |           11148 |                 6241 |      55.98 |
|        |   900000 |  3060 |  2080 |  4088 |    715 |           11355 |                 5907 |      52.02 |
|        |  1000000 |  2726 |  2080 |  4080 |    602 |           11757 |                 5422 |      46.12 |
|        |  2000000 |  2707 |  2080 |  4088 |    530 |           24508 |                10877 |      44.38 |
|        |  3000000 |  2637 |  2080 |  4088 |    506 |           36842 |                15983 |      43.38 |
|        |  4000000 |  2639 |  2080 |  4088 |    509 |           49502 |                22745 |      45.95 |
|        |  5000000 |  2609 |  2080 |  4088 |    504 |           62102 |                28536 |      45.95 |
|        |  6000000 |  2622 |  2080 |  4088 |    525 |           74640 |                34797 |      46.62 |
|        |  7000000 |  2601 |  2080 |  4088 |    511 |           87232 |                40565 |      46.50 |
|        |  8000000 |  2593 |  2080 |  4088 |    513 |           99924 |                47249 |      47.28 |
|        |  9000000 |  2584 |  2080 |  4088 |    511 |          112551 |                48683 |      43.25 |
|        | 10000000 |  2597 |  2080 |  4088 |    527 |          125158 |                54245 |      43.34 |
| 
| 
|     2. 13 to 20 bytes name length; Value length is 13 bytes
|        | Nr xattr | 4kAvg | 4kmin | 4kmax | stddev | Total Nr leaves | Below avg space used | Percentage |
|        |----------+-------+-------+-------+--------+-----------------+----------------------+------------|
|        |    10000 |  2702 |  2096 |  3536 |    564 |              65 |                   30 |      46.15 |
|        |    20000 |  2746 |  2096 |  3968 |    687 |             122 |                   44 |      36.07 |
|        |   100000 |  2718 |  2092 |  3968 |    746 |             590 |                  180 |      30.51 |
|        |   200000 |  2782 |  2092 |  3968 |    690 |            1593 |                 1166 |      73.20 |
|        |   300000 |  2834 |  2092 |  4040 |    708 |            2557 |                 1473 |      57.61 |
|        |   400000 |  2764 |  2092 |  3968 |    536 |            3206 |                 1393 |      43.45 |
|        |   500000 |  2723 |  2092 |  4040 |    651 |            4045 |                 2449 |      60.54 |
|        |   600000 |  2870 |  2092 |  4040 |    594 |            4883 |                 2727 |      55.85 |
|        |   700000 |  2776 |  2092 |  4076 |    564 |            5903 |                 2647 |      44.84 |
|        |   800000 |  2659 |  2092 |  4076 |    510 |            6275 |                 3224 |      51.38 |
|        |   900000 |  2929 |  2092 |  3968 |    491 |            7113 |                 4207 |      59.15 |
|        |  1000000 |  3138 |  2092 |  4076 |    552 |            8916 |                 5746 |      64.45 |
|        |  2000000 |  3016 |  2096 |  4076 |    615 |           18119 |                11540 |      63.69 |
|        |  3000000 |  3010 |  2096 |  4076 |    642 |           27995 |                18411 |      65.77 |
|        |  4000000 |  2988 |  2096 |  4076 |    667 |           37346 |                22439 |      60.08 |
|        |  5000000 |  2977 |  2096 |  4076 |    670 |           47275 |                28745 |      60.80 |
|        |  6000000 |  2973 |  2096 |  4076 |    680 |           56479 |                33075 |      58.56 |
|        |  7000000 |  2968 |  2096 |  4076 |    680 |           66472 |                40288 |      60.61 |
|        |  8000000 |  2961 |  2096 |  4076 |    684 |           76241 |                45640 |      59.86 |
|        |  9000000 |  2958 |  2096 |  4076 |    684 |           86070 |                52306 |      60.77 |
|        | 10000000 |  2956 |  2096 |  4076 |    688 |           95179 |                56395 |      59.25 |

And theres a couple of logarithmic overhead data tables that go out
as far as 37 million xattrs...

> will address the review comments provided on this patchset and then run the
> benchmarks once again ... but this time I will increase the upper limit to 100
> million xattrs (since we will have a 32-bit extent counter). I will post the
> results of the benchmarking (along with the benchmarking programs/scripts) to
> the mailing list before I post the patchset itself.

Sounds good.

Though given the results of what you have done so far, I don't
expect to see any scalaility issues until we hit on machine memory
limits (i.e.  can't cache all the dabtree metadata in memory) or
maximum dabtree depths.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
