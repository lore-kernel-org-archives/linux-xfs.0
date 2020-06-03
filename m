Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C51C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB2E2072F
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgFCDCr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:02:47 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:56630 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgFCDCr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 23:02:47 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 19BAF1A7E0E;
        Wed,  3 Jun 2020 13:02:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgJft-0002X2-Tj; Wed, 03 Jun 2020 13:02:41 +1000
Date:   Wed, 3 Jun 2020 13:02:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200603030241.GM2040@dread.disaster.area>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603012734.GL2040@dread.disaster.area>
 <20200603014039.GB12304@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603014039.GB12304@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ziUE-deqfqgMTHQSlJEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 09:40:39AM +0800, Gao Xiang wrote:
> On Wed, Jun 03, 2020 at 11:27:34AM +1000, Dave Chinner wrote:
> > On Tue, Jun 02, 2020 at 10:52:38PM +0800, Gao Xiang wrote:
> > >  fs/xfs/libxfs/xfs_ag.c             |  4 ++--
> > >  fs/xfs/libxfs/xfs_alloc.c          | 22 ++++++-----------
> > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 10 ++++----
> > >  fs/xfs/libxfs/xfs_ialloc.c         | 28 ++++++----------------
> > >  fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
> > >  fs/xfs/libxfs/xfs_rmap_btree.c     |  5 ++--
> > >  fs/xfs/xfs_inode.c                 | 38 +++++++++---------------------
> > >  7 files changed, 35 insertions(+), 77 deletions(-)
> > 
> > There were more places using this pattern than I thought. :)
> > 
> > With an updated commit message,
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Thanks for your review. b.t.w, would you tend to drop all extra ASSERTs
> or leave these ASSERTs for a while to catch potential issues on this
> patch?...

We typically use ASSERT() statements to document assumptions the
function implementation makes. e.g. if we expect that the inode is
locked on entry to a function, rather than adding that as a comment
we'll do:

	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));

That way our debug builds validate that all the callers of the
function are doing the right thing.

I frequently add ASSERT()s when debugging my code, but then remove
once I've found the issue. Typically I'm adding asserts to cover
conditions I know shouldn't occur, but could be caused by a bug and
I try to place the asserts to catch the issue earlier than what I'm
currently seeing. Depending on which debug assert fires first, I'll
change/add/remove asserts to further narrow down the problem.

Hence the ASSERTs I tend to leave in the code are either documenting
assumptions or were the ones that were most helpful in debugging the
changes I was making.

I did think about the asserts you added, wondering if they were
necessary. But then I noticed they were replicating a pattern in
other parts of the code so they seemed like a reasonable addition.

> And in addition I will try to find more potential cases, if
> not, I will just send out with updated commit messages (maybe without
> iunlink orphan inode related part, just to confirm?).

Your original patch is fine including those iunlink bits. I was was
simply pointing out that spending more time cleaning up the iunlink
code wasn't worth spending time on because I've got much more
substantial changes that address those issues already...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
