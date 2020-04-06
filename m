Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FFDC2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C6D2078C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgDFW6D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 18:58:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41557 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbgDFW6D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 18:58:03 -0400
Received: from dread.disaster.area (pa49-180-164-3.pa.nsw.optusnet.com.au [49.180.164.3])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A3F8C3A3F2B;
        Tue,  7 Apr 2020 08:57:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jLago-0005IN-Iq; Tue, 07 Apr 2020 08:57:58 +1000
Date:   Tue, 7 Apr 2020 08:57:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandan@linux.ibm.com,
        darrick.wong@oracle.com
Subject: Re: [PATCH 1/2] xfs: Fix log reservation calculation for xattr
 insert operation
Message-ID: <20200406225758.GC21885@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200404085203.1908-2-chandanrlinux@gmail.com>
 <20200406152540.GE20708@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406152540.GE20708@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=K0+o7W9luyMo1Ua2eXjR1w==:117 a=K0+o7W9luyMo1Ua2eXjR1w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=7-415B0cAAAA:8 a=GE30oH4zwSWN6tBuY0cA:9 a=ng0Gpdaf1y5s0x8T:21
        a=HzkbBQZa9KOz2IzN:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 06, 2020 at 11:25:40AM -0400, Brian Foster wrote:
> On Sat, Apr 04, 2020 at 02:22:02PM +0530, Chandan Rajendra wrote:
> > Log space reservation for xattr insert operation is divided into two
> > parts,
> > 1. Mount time
> >    - Inode
> >    - Superblock for accounting space allocations
> >    - AGF for accounting space used by count, block number, rmap and refcnt
> >      btrees.
> > 
> > 2. The remaining log space can only be calculated at run time because,
> >    - A local xattr can be large enough to cause a double split of the da
> >      btree.
> >    - The value of the xattr can be large enough to be stored in remote
> >      blocks. The contents of the remote blocks are not logged.
> > 
> >    The log space reservation could be,
> >    - (XFS_DA_NODE_MAXDEPTH + 1) number of blocks. The "+ 1" is required in
> >      case xattr is large enough to cause another split of the da btree path.
> >    - BMBT blocks for storing (XFS_DA_NODE_MAXDEPTH + 1) record
> >      entries.
> >    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> > 
> > At present, mount time log reservation includes block count required for a
> > single split of the dabtree. The dabtree block count is also taken into
> > account by xfs_attr_calc_size().
> > 
> > Also, AGF log space reservation isn't accounted for.
> > 
> > Due to the reasons mentioned above, log reservation calculation for xattr
> > insert operation gives an incorrect value.
> > 
> > Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> > an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> > 
> > The above mentioned inconsistencies were discoverd when trying to mount a
> > modified XFS filesystem which uses a 32-bit value as xattr extent counter
> > caused the following warning messages to be printed on the console,
> > 
> > XFS (loop0): Mounting V4 Filesystem
> > XFS (loop0): Log size 2560 blocks too small, minimum size is 4035 blocks
> > XFS (loop0): Log size out of supported range.
> > XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> > XFS (loop0): Ending clean mount
> > 
> > To fix the inconsistencies described above, this commit replaces 'mount'
> > and 'runtime' components with just one static reservation. The new
> > reservation calculates the log space for the worst case possible i.e. it
> > considers,
> > 1. Double split of the da btree.
> >    This happens for large local xattrs.
> > 2. Bmbt blocks required for mapping the contents of a maximum
> >    sized (i.e. XATTR_SIZE_MAX bytes in size) remote attribute.
> > 
> 
> Hmm.. so the last I recall looking at this, the change was more around
> refactoring the mount vs. runtime portions of the xattr reservation to
> be more accurate. This approach eliminates the runtime portion for a
> 100% mount time reservation calculation. Can you elaborate on why the
> change in approach? Also, it looks like at least one tradeoff here is
> reservation size (to the point where we increase min log size on small
> filesystems?).

What's not in this commit message is that this was actually my idea
that I had when Chandan contacted me off list about his refactoring
of the reservation blowing out reservations for attribute operations
by a factor of 10.

My fault, I should have pushed the discussion back to the mailing
list rather than answering directly.  I'll repeat a lot of my
analysis from that discussion below to get everyone up to speed.

[ Chandan, in future I'm going to insist that all your XFS questions
need to be on the list, so that everyone sees the discusions and
understands the reasons why things are suggested. It's also a good
idea to use "suggested-by" when presenting code based on other
people's ideas, just so that everyone knows that there were more
people involved than just yourself... ]

So, when I went through all the reservations changes that Chandan
had made I realised that the current code was wrong in lots of ways,
and when I looked at it from the fundamental changes being made the
mount vs runtime split made no sense at all.

Such as:

- the dabtree double split was a double _leaf block split only_. It
  is not a full tree split, and can only result in a single parent
  split because there is only one path update after the double leaf
  split has been done. Hence it can only do one full dabtree split
  and the code in xfs_attr_calc_size() that doubles the block count
  reservation for the double leaf split is wrong.  We only need on
  extra block, and that is just:

dgc>  #define XFS_DAENTER_DBS(mp,w)        \
dgc> -     (XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 0))
dgc> +     (XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 1))

[ Note: The "+ 2" for the data fork reservation is for the dir data
block and a potential free space index block that get added in a
typical directory entry addition. ]

- remote attributes are not logged, so only the BMBT block
  reservation is needed for that extent allocation. i.e. we need to
  reserve the blocks for the xattr, but we don't need log space
  for them.  xfs_attr_calc_size() gets this right,
  xfs_log_calc_max_attrsetm_res() gets this wrong in that it does
  not take into account remote attr BMBT blocks at all.

- xfs_attr_calc_size() calculates the number of blocks we need to
  allocate for the attr operation, not the number of blocks we need
  to log, hence can't be used to replace
  xfs_log_calc_max_attrsetm_res().

- the runtime reservation is just a BMBT block reservation for a
  single block to be allocated. multiplying the number of blocks we
  need to allocate by M_RES(mp)->tr_attrsetrt.tr_logres to get the
  log reservation is wrong. We are not doing a full BMBT split for
  every block in the attribute we modify, so the log reservation is
  massively oversized by xfs_log_calc_max_attrsetm_res() and
  xfs_attr_set() by multipling the block count (including BMBT
  blocks we allocate) by a full bmbt split reservation.

IOWs, the code as it stands now is just wrong. It works because it
massively oversizes the runtime reservations, but that in itself is
a problem.  To quote myself again from that analysis:

dgc> The log reservation that covers both local and remote attributes:
dgc>
dgc> blks =  full dabtree split + 1 leaf block + bmbt blocks
dgc> blks += nextent_res(MAX_ATTR_LEN/block size) // bmbt blocks only
dgc> resv =	inode + sb + agf +
dgc>		xfs_calc_buf_res(blks) +
dgc>		allocfree_log_count(blks);

THe first line takes into account the blocks we modify in a local
attribute tree modification. The second line takes into account the
BMBT logging overhead of a remote attribute. The "resv" calculation
converts that modified block count into a log reservation and adds
the freespace tree logging overhead of allocating all those blocks.

The only thing that is variable at runtime now is the size of the
remote attribute, but we already have a log reservation for the
allocation and BMBT block modification side of that and so we only
need to physically reserve the block space (i.e. via
block count passed to xfs_trans_alloc()).

IOWs, the log reservation does not need to change at runtime now.

It also makes it clear that changing the attr fork extent count from
16 to 32 bits should only impact the BMBT reservations.  The dabtree
reservations already use XFS_DA_NODE_MAXDEPTH for the attr fork and
hence so they already are sized for max dabtree depth reservations.

As a result, the attr reservation itself should not grow excessively
for 32bit attribute fork extent counts. It should maybe 20-30 blocks
on a 4kb block size filesystem as we add 4-5 levels to the max depth
of the BMBT on the attribute fork. It should certainly not grow by
400 blocks as the original reworking resulted in...

Again, sorry for not getting this discussion out onto the mailing
list originally, it should have been there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
