Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E47C4CEC7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 22:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3851420830
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 22:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfILWf0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 18:35:26 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37493 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726800AbfILWf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 18:35:26 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8B75743EAE5;
        Fri, 13 Sep 2019 08:35:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8XgN-0007Zd-TW; Fri, 13 Sep 2019 08:35:19 +1000
Date:   Fri, 13 Sep 2019 08:35:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190912223519.GP16973@dread.disaster.area>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912143223.24194-2-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=b7jh_wy-ebAO6o63PZMA:9
        a=_nUvI3FnCbdFHSyR:21 a=O3kMLlaqYzumFUlf:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 12, 2019 at 10:32:22AM -0400, Brian Foster wrote:
> The bmap block allocation code issues a sequence of retries to
> perform an optimal allocation, gradually loosening constraints as
> allocations fail. For example, the first attempt might begin at a
> particular bno, with maxlen == minlen and alignment incorporated. As
> allocations fail, the parameters fall back to different modes, drop
> alignment requirements and reduce the minlen and total block
> requirements.
> 
> For large extent allocations with an args.total value that exceeds
> the allocation length (i.e., non-delalloc), the total value tends to
> dominate despite these fallbacks. For example, an aligned extent
> allocation request of tens to hundreds of MB that cannot be
> satisfied from a particular AG will not succeed after dropping
> alignment or minlen because xfs_alloc_space_available() never
> selects an AG that can't satisfy args.total. The retry sequence
> eventually reduces total and ultimately succeeds if a minlen extent
> is available somewhere, but the first several retries are
> effectively pointless in this scenario.
> 
> Beyond simply being inefficient, another side effect of this
> behavior is that we drop alignment requirements too aggressively.
> Consider a 1GB fallocate on a 15GB fs with 16 AGs and 128k stripe
> unit:
> 
>  # xfs_io -c "falloc 0 1g" /mnt/file
>  # <xfstests>/src/t_stripealign /mnt/file 32
>  /mnt/file: Start block 347176 not multiple of sunit 32

Ok, so what Carlos and I found last night was an issue with the
the agresv code leading to the maximum free extent calculated
by xfs_alloc_longest_free_extent() being longer than the largest
allowable extent allocation (mp->m_ag_max_usable) resulting in the
situation where blen > args->maxlen, and so in the case of initial
allocation here, we never run this:

	/*
	 * Adjust for alignment
	 */
	if (blen > args.alignment && blen <= args.maxlen)
		args.minlen = blen - args.alignment;
	args.minalignslop = 0;

this is how we end up with args.minlen = args.maxlen and the
initial allocation failing.

The issue is the way mp->m_ag_max_usable is calculated versus how
the pag->pag_meta_resv.ar_reserved value is set up for the finobt.
That is, "ask" = max tree size, and "used" = 1 because we have a
root block allocated. that code does:

	mp->m_ag_max_unused -= ask;
...
	pag->pag_meta_resv.ar_reserved = ask - used

That means when we calculate the longest extent in the AG, we do:

	longest = pag->pagf_longest - min_needed - resv(NONE)
		= pag->pagf_longest - min_needed - pag->pag_meta_resv.ar_reserved

whilst mp->m_ag_max_usable is calculated as

	usable = agf_length - AG header blocks - AGFL - resv(ask)

When the AG is empty, this ends up with

	pag->pagf_longest = agf_length - AG header blocks
and
	min_needed = AGFL blocks
and
	resv(ask) = pag->pag_meta_resv.ar_reserved + 1

and so:
	longest = usable + 1

And that's how we get blen = maxlen + 1, and that's why alignment is
being dropped for the initial allocation in this "allocate full AG"
corner case.

> Despite the filesystem being completely empty, the fact that the
> allocation request cannot be satisifed from a single AG means the
> allocation doesn't succeed until xfs_bmap_btalloc() drops total from
> the original value based on maxlen. This occurs after we've dropped
> minlen and alignment (unnecessarily).

Right, we'll continue to fail until minlen is reduced appropriately.
But that's not an issue in the fallback algorithms, that's a problem
with the initial conditions not being set up correctly.

> As a step towards addressing this problem, insert a new retry in the
> bmap allocation sequence to drop minlen (from maxlen) before tossing
> alignment. This should still result in as large of an extent as
> possible as the block allocator prioritizes extent size in all but
> exact allocation modes. By itself, this does not change the behavior
> of the command above because the preallocation code still specifies
> total based on maxlen. Instead, this facilitates preservation of
> alignment once extra reservation is separated from the extent length
> portion of the total block requirement.

AFAICT this is not necessary. The prototypoe patch I wrote last
night while working through this with Carlos is attached below. I
updated with a variant of your patch 2 to demonstrate that it does
actually solve the problem of full AG allocation failing to be
aligned.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: cap longest free extent to maximum allocatable

From: Dave Chinner <dchinner@redhat.com>

Cap longest extent to the largest we can allocate based on limits
calculated at mount time. Dynamic state (such as finobt blocks)
can result in the longest free extent exceeding the size we can
allocate, and that results in failure to align full AG allocations
when the AG is empty.

Result:

xfs_io-4413  [003]   426.412459: xfs_alloc_vextent_loopfailed: dev 8:96 agno 0 agbno 32 minlen 243968 maxlen 244000 mod 0 prod 1 minleft 1 total 262148 alignment 32 minalignslop 0 len 0 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x5 firstblock 0xffffffffffffffff

minlen and maxlen are now separated by the alignment size, and
allocation fails because args.total > free space in the AG.

Update: add a hacked version of Brian's xfs_bmapi_write() args.total
hack to actually allow this initial aligned allocation to succeed:

$ sudo mkfs.xfs -f -d su=128k,sw=4,size=15g /dev/sdg
meta-data=/dev/sdg               isize=512    agcount=16, agsize=245728 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3931648, imaxpct=25
         =                       sunit=32     swidth=128 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount /dev/sdg /mnt/test
$ sudo xfs_io -f -c "falloc 0 1g" -c "bmap -vvp" /mnt/test/file
/mnt/test/file:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET          TOTAL FLAGS
   0: [0..1951999]:       1966080..3918079  1 (256..1952255)   1952000 010001
   1: [1952000..2097151]: 3931904..4077055  2 (256..145407)     145152 010011
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width
$ sudo ~/src/xfstests-dev/src/t_stripealign /mnt/test/file 32
/mnt/test/file: well-aligned
$

Note that it skips AG 1 now because AG 0 is not the AG with the
longest free space - it's got a root inode chunk in it so it has
less space in it than the other AGs. Hence it can't do a maximally
sized aligned allocation, while AG 1 can. Note the difference in
total compared to the initial trace above.

xfs_io-4398  [003]   207.663502: xfs_ag_resv_needed:   dev 8:96 agno 0 resv 0 freeblks 245707 flcount 4 resv 0 ask 0 len 1713
xfs_io-4398  [003]   207.663502: xfs_alloc_vextent_loopfailed: dev 8:96 agno 0 agbno 32 minlen 243968 maxlen 244000 mod 0 prod 1 minleft 1 total 0 alignment 32 minalignslop 0 len 0 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x5 firstblock 0xffffffffffffffff
....
xfs_io-4398  [003]   207.663503: xfs_ag_resv_needed:   dev 8:96 agno 1 resv 0 freeblks 245715 flcount 4 resv 0 ask 0 len 1713
.....
xfs_io-4398  [003]   207.666010: xfs_alloc_size_done:  dev 8:96 agno 1 agbno 32 minlen 243968 maxlen 244000 mod 0 prod 1 minleft 1 total 0 alignment 32 minalignslop 0 len 244000 type THIS_AG otype START_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x5 firstblock 0xffffffffffffffff

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c  | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 533b04aaf6f6..9dead25d2e70 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1989,7 +1989,8 @@ xfs_alloc_longest_free_extent(
 	 * reservations and AGFL rules in place, we can return this extent.
 	 */
 	if (pag->pagf_longest > delta)
-		return pag->pagf_longest - delta;
+		return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
+				pag->pagf_longest - delta);
 
 	/* Otherwise, let the caller try for 1 block if there's space. */
 	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 054b4ce30033..b05683f649a6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4286,6 +4286,20 @@ xfs_bmapi_write(
 #endif
 	whichfork = xfs_bmapi_whichfork(flags);
 
+	/*
+	 * XXX: Hack!
+	 *
+	 * If the total blocks requested is larger than an AG, we can't allocate
+	 * all the space atomically and within a single AG. This will be a
+	 * "short" allocation. In this case, just ignore the total block count
+	 * and rely on minleft calculations to ensure the allocation we do fits
+	 * inside an AG properly.
+	 *
+	 * Based on a patch from Brian.
+	 */
+	if (bma.total > mp->m_ag_max_usable)
+		bma.total = 0;
+
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
 	ASSERT(tp != NULL);
