Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD90AC77B60
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 00:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbjD0Axh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Apr 2023 20:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbjD0Axg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2023 20:53:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2158D3586
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2023 17:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD22E6344E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 00:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B14C433EF;
        Thu, 27 Apr 2023 00:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682556814;
        bh=tabQwZdPjUqnbpuExaTyZBWABHW5E8XgUVlHhLf8r/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qz5rzBRAOcDQl8ZAeRceP/vz+dyAfZfUOk4+ipFlcQaHbSqvwAVH577CSCvPHl2Fd
         K5RcexdnAPAorPATsSgsA1h6bRAovE2jDqHXBbQBMYiautubTF7vnmQ1KYJGgaAZvi
         VKb8dQu0zJdzQZeSX67cqHpnH+CxFWfPFQq7ghJ3e4d1ViJKoPt6OmIdK+YHyrgl8/
         YxO19Jah8koIc8xPB2Hfl3LZenzxL7rx9ll/inTH8i0Q+KGkols07+Uj1q6qrLNbV6
         F2ntpykSEPvDeJlVntyac6g2auqu5Hsb7NxTcdesWiBa3i3Qa5wMBx26Vv96NlnNTg
         aEy7B3Ix1n1zQ==
Date:   Wed, 26 Apr 2023 17:53:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <20230427005333.GC59245@frogsfrogsfrogs>
References: <20230421222440.2722482-1-david@fromorbit.com>
 <20230425152052.GT360889@frogsfrogsfrogs>
 <20230426230135.GJ3223426@dread.disaster.area>
 <20230426233831.GB59245@frogsfrogsfrogs>
 <20230427001124.GL3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427001124.GL3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 10:11:24AM +1000, Dave Chinner wrote:
> On Wed, Apr 26, 2023 at 04:38:31PM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 27, 2023 at 09:01:35AM +1000, Dave Chinner wrote:
> > > On Tue, Apr 25, 2023 at 08:20:52AM -0700, Darrick J. Wong wrote:
> > > > On Sat, Apr 22, 2023 at 08:24:40AM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > On a filesystem with a non-zero stripe unit and a large sequential
> > > > > write, delayed allocation will set a minimum allocation length of
> > > > > the stripe unit. If allocation fails because there are no extents
> > > > > long enough for an aligned minlen allocation, it is supposed to
> > > > > fall back to unaligned allocation which allows single block extents
> > > > > to be allocated.
> > > > > 
> > > > > When the allocator code was rewritting in the 6.3 cycle, this
> > > > > fallback was broken - the old code used args->fsbno as the both the
> > > > > allocation target and the allocation result, the new code passes the
> > > > > target as a separate parameter. The conversion didn't handle the
> > > > > aligned->unaligned fallback path correctly - it reset args->fsbno to
> > > > > the target fsbno on failure which broke allocation failure detection
> > > > > in the high level code and so it never fell back to unaligned
> > > > > allocations.
> > > > > 
> > > > > This resulted in a loop in writeback trying to allocate an aligned
> > > > > block, getting a false positive success, trying to insert the result
> > > > > in the BMBT. This did nothing because the extent already was in the
> > > > > BMBT (merge results in an unchanged extent) and so it returned the
> > > > > prior extent to the conversion code as the current iomap.
> > > > > 
> > > > > Because the iomap returned didn't cover the offset we tried to map,
> > > > > xfs_convert_blocks() then retries the allocation, which fails in the
> > > > > same way and now we have a livelock.
> > > > > 
> > > > > Reported-by: Brian Foster <bfoster@redhat.com>
> > > > > Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Insofar as this has revealed a whole ton of *more* problems in mkfs,
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Thanks, I've added this to for-next and I'll include it in the pull
> > > req to Linus tomorrow because I don't want expose everyone using
> > > merge window kernels to this ENOSPC issue even for a short while.
> > > 
> > > > Specifically: if I set su=128k,sw=4, some tests will try to format a
> > > > 512M filesystem.  This results in an 8-AG filesystem with a log that
> > > > fills up almost but not all of an entire AG.  The AG then ends up with
> > > > an empty bnobt and an empty AGFL, and 25 missing blocks...
> > > 
> > > I used su=64k,sw=2 so I didn't see those specific issues. Mostly I
> > > see failures due to mkfs warnings like this:
> > > 
> > >     +Warning: AG size is a multiple of stripe width.  This can cause performance
> > >     +problems by aligning all AGs on the same disk.  To avoid this, run mkfs with
> > >     +an AG size that is one stripe unit smaller or larger, for example 129248.
> > 
> > Yeah, I noticed that one, and am testing a patch to quiet down mkfs a
> > little bit.
> > 
> > I also caught a bug in the AG formatting code where the bnobt gets
> > written out with zero records if the log happens to start beyond
> > m_ag_prealloc_size and end at EOAG.
> > 
> > I also noticed that the percpu inodegc workers occasionally run on the
> > wrong CPU, but only on arm.  Tonight I intend to test a fix for that...
> 
> Whacky. :/
> 
> > ...but I also have been tracking a fix for an issue where
> > xfs_inodegc_stop races with either the reclaim inodegc kicker or with an
> > already set-up delayed work timer, with the end result that
> > drain_workqueue sets WQ_DRAINING, someone (not the inodegc worker
> > itself) tries to queue_work the inodegc worker to the draining
> > workqueue, and we get a kernel bug message and the fs livelocks.
> 
> Yes, I've noticed that but not had time to fix it - disabling the
> inodegc whilst stuff is still in progress after checking inodegc is
> enabled is racy...
> 
> > I've also been trying to fix that problem that Ritesh mentioned months
> > ago where if we manage to mount the fs cleanly but there are unlinked
> > inodes, we'll eventually fall over when the incore unlinked list fails
> > to find those lingering unlinked inodes.
> 
> Right, I also haven't had time to get to that either. IIRC it fails
> to clear the bucket because we don't feed the error from the inodegc
> context back to the recovery code.
> 
> > I also added a su=128k,sw=4 config to the fstests fleet and am now
> > trying to fix all the fstests bugs that produce incorrect test failures.
> 
> The other thing I noticed is a couple of the FIEMAP tests fail
> because they find data blocks where they expect holes such as:
> 
> generic/225 21s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad)
>     --- tests/generic/225.out   2022-12-21 15:53:25.479044361 +1100
>     +++ /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad      2023-04-26 04:24:31.426016818 +1000
>     @@ -1,3 +1,79 @@
>      QA output created by 225
>      fiemap run without preallocation, with sync
>     +ERROR: FIEMAP claimed there was data at a block which should be a hole, and FIBMAP confirmend that it is in fact a hole, so FIEMAP is wrong: 35
>     +ERROR: found an allocated extent where a hole should be: 35
>     +map is 'DHDDHHDDHDDHHHHDDDDDHHHHHHHDHDDDHHDHDHHHHHDDHDDHHDDHDHHDDDHHHHDDDDHDHHDDHHHDDDDHHDHDDDHHDHDDDHDHHHHHDHDHDHDHHDDHDHHHHDHHDDDDDDDH'
>     +logical: [      27..      27] phys:       67..      67 flags: 0x000 tot: 1
>     +logical: [      29..      31] phys:       69..      71 flags: 0x000 tot: 3
>     ...
>     (Run 'diff -u /home/dave/src/xfstests-dev/tests/generic/225.out /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad'  to see the entire diff)
> 
> I haven't looked into this yet, but nothing is reporting data
> corruptions so I suspect it's just the stripe aligned allocation
> leaving unwritten extents in places the test is expecting holes to
> exist...

That's the FIEMAP tester program not expecting that areas of the file
that it didn't write to can have unwritten extents mapped.  I'm testing
patches to fix all that tonight too.  If I can ever get these %#@%)#%!!!
orchestration scripts to work correctly.

> > > > ...oh and the new test vms that run this config failed to finish for
> > > > some reason.  Sigh.
> > > 
> > > Yeah, I've had xfs_repair hang in xfs/155 a couple of times. Killing
> > > the xfs_repair process allows everything to keep going. I suspect
> > > it's a prefetch race/deadlock...
> > 
> > <nod> I periodically catch xfs_repair deadlocked on an xfs_buf lock
> > where the pthread mutex says the lock is owned by a thread that is no
> > longer running.
> 
> So we leaked a buffer lock somewhere?

Yep.  It also shows up every now and then in the fstests that fuzz an
entire directory block and see if repair will fix it.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
