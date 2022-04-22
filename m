Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66B9C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 23:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiDVXyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 19:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiDVXya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 19:54:30 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51C3017859F
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 16:51:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 65F9953470C;
        Sat, 23 Apr 2022 09:51:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ni33l-003MZP-Ai; Sat, 23 Apr 2022 09:51:33 +1000
Date:   Sat, 23 Apr 2022 09:51:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: stop artificially limiting the length of bunmap
 calls
Message-ID: <20220422235133.GG1544202@dread.disaster.area>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997687142.383881.7160925177236303538.stgit@magnolia>
 <20220422220120.GA1544202@dread.disaster.area>
 <20220422221820.GH17059@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422221820.GH17059@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62633f86
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Sqpns60_8NikWA0TIEcA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 22, 2022 at 03:18:20PM -0700, Darrick J. Wong wrote:
> On Sat, Apr 23, 2022 at 08:01:20AM +1000, Dave Chinner wrote:
> > On Thu, Apr 14, 2022 at 03:54:31PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > In commit e1a4e37cc7b6, we clamped the length of bunmapi calls on the
> > > data forks of shared files to avoid two failure scenarios: one where the
> > > extent being unmapped is so sparsely shared that we exceed the
> > > transaction reservation with the sheer number of refcount btree updates
> > > and EFI intent items; and the other where we attach so many deferred
> > > updates to the transaction that we pin the log tail and later the log
> > > head meets the tail, causing the log to livelock.
> > > 
> > > We avoid triggering the first problem by tracking the number of ops in
> > > the refcount btree cursor and forcing a requeue of the refcount intent
> > > item any time we think that we might be close to overflowing.  This has
> > > been baked into XFS since before the original e1a4 patch.
> > > 
> > > A recent patchset fixed the second problem by changing the deferred ops
> > > code to finish all the work items created by each round of trying to
> > > complete a refcount intent item, which eliminates the long chains of
> > > deferred items (27dad); and causing long-running transactions to relog
> > > their intent log items when space in the log gets low (74f4d).
> > > 
> > > Because this clamp affects /any/ unmapping request regardless of the
> > > sharing factors of the component blocks, it degrades the performance of
> > > all large unmapping requests -- whereas with an unshared file we can
> > > unmap millions of blocks in one go, shared files are limited to
> > > unmapping a few thousand blocks at a time, which causes the upper level
> > > code to spin in a bunmapi loop even if it wasn't needed.
> > > 
> > > This also eliminates one more place where log recovery behavior can
> > > differ from online behavior, because bunmapi operations no longer need
> > > to requeue.
> > > 
> > > Partial-revert-of: e1a4e37cc7b6 ("xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent")
> > > Depends: 27dada070d59 ("xfs: change the order in which child and parent defer ops ar finished")
> > > Depends: 74f4d6a1e065 ("xfs: only relog deferred intent items if free space in the log gets low")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c     |   22 +---------------------
> > >  fs/xfs/libxfs/xfs_refcount.c |    5 ++---
> > >  fs/xfs/libxfs/xfs_refcount.h |    8 ++------
> > >  3 files changed, 5 insertions(+), 30 deletions(-)
> > 
> > This looks reasonable, but I'm wondering how the original problem
> > was discovered and whether this has been tested against that
> > original problem situation to ensure we aren't introducing a
> > regression here....
> 
> generic/447, and yes, I have forced it to run a deletion of 1 million
> extents without incident. :)

Ok, that's all I wanted to know :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
