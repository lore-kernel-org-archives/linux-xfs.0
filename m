Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D360C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 04:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2424264E77
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 04:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBSE3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 23:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhBSE3P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 23:29:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF0FC601FE;
        Fri, 19 Feb 2021 04:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613708915;
        bh=xGrTeDbE1Nc0hLuWcFoEdB9vZaRvLaGV7UnDvnLFvjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WwNZiz+zUMAsktzsrtM6INtxtPAIX78TMa1dnJ1tF0YDG45X9MzYHcOUtj9Ktuwg6
         bCgxsSz3QFJMMl+/wrENZvhIw1fKx8EU0HizGXf0t2wkWQe9WwsVq7xk8v/YJCQRuf
         dQpoDILh0WDQdl/fP+GNm0eziECv4S1LSOIuRP3xejqJgJ4I+O+7fQ0LNyMPmgembv
         DYM3t3DJVojJnSgzPHzlkc1nSmesrzMXdzvwZzeXza94Dd/6broKzvcZzh+f8ZrwYP
         fZbw9Vzhp1Gq9pgxQ+3Yj4zZurJPMwx9Z+rHFJHT1lsq3T154rMOURd9FrcPKcR3bx
         QCSkWeTkCd8HA==
Date:   Thu, 18 Feb 2021 20:28:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: lockdep recursive locking warning on for-next
Message-ID: <20210219042833.GA7193@magnolia>
References: <20210218181450.GA705507@bfoster>
 <20210218184926.GN7190@magnolia>
 <20210218191252.GA709084@bfoster>
 <20210218193154.GO7190@magnolia>
 <20210219041427.GE4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219041427.GE4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 03:14:27PM +1100, Dave Chinner wrote:
> On Thu, Feb 18, 2021 at 11:31:54AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 18, 2021 at 02:12:52PM -0500, Brian Foster wrote:
> > > On Thu, Feb 18, 2021 at 10:49:26AM -0800, Darrick J. Wong wrote:
> > > > On Thu, Feb 18, 2021 at 01:14:50PM -0500, Brian Foster wrote:
> > > > > Hi Darrick,
> > > > > 
> > > > > I'm seeing the warning below via xfs/167 on a test machine. It looks
> > > > > like it's just complaining about nested freeze protection between the
> > > > > scan invocation and an underlying transaction allocation for an inode
> > > > > eofblocks trim. I suppose we could either refactor xfs_trans_alloc() to
> > > > > drop and reacquire freeze protection around the scan, or alternatively
> > > > > call __sb_writers_release() and __sb_writers_acquire() around the scan
> > > > > to retain freeze protection and quiet lockdep. Hm?
> > > > 
> > > > Erk, isn't that a potential log grant livelock too?
> > > > 
> > > > Fill up the filesystem with real data and cow blocks until it's full,
> > > > then spawn exactly enough file writer threads to eat up all the log
> > > > reservation, then each _reserve() fails, so every thread starts a scan
> > > > and tries to allocate /another/ transaction ... but there's no space
> > > > left in the log, so those scans just block indefinitely.
> > > > 
> > > > So... I think the solution here is to go back to a previous version of
> > > > what that patchset did, where we'd drop the whole transaction, run the
> > > > scan, and jump back to the top of the function to get a fresh
> > > > transaction.
> > > > 
> > > 
> > > But we don't call into the scan while holding log reservation. We hold
> > > the transaction memory and freeze protection. It's probably debatable
> > > whether we'd want to scan with freeze protection held or not, but I
> > > don't see how dropping either of those changes anything wrt to log
> > > reservation..?
> > 
> > Right, sorry about the noise.  We could just trick lockdep with
> > __sb_writers_release like you said.  Though I am a tad bit concerned
> > about the rwsem behavior -- what happens if:
> > 
> > T1 calls sb_start_intwrite (which is down_read on sb_writers), gets the
> > lock, and then hits ENOSPC and goes into our scan loop; meanwhile,
> > 
> > T2 calls sb_wait_write (which is down_write on sb_writers), and is
> > scheduled off because it was a blocking lock attempt; and then,
> > 
> > T1 finds some eofblocks to delete, and now it wants to sb_start_intwrite
> > again as part of allocating that second nested transaction.  Does that
> > actually work, or will T1 stall because we don't allow more readers once
> > something is waiting in down_write()?
> 
> The stack trace nesting inside xfs_trans_alloc() looks fundamentally
> wrong to me. It screams "warning, dragons be here" to me. We're not
> allowed to nest transactions -anywhere- so actually designing a call
> path that ends up looking like we are nesting transactions but then
> plays whacky games to avoid problems associated with nesting
> seems... poorly thought out.

The original version of the code[1] in question cancelled the
transaction before starting the scan, but the reviewers didn't think it
would be a problem to hold on to the transaction or recurse intwrite.

[1] https://lore.kernel.org/linux-xfs/20210124094816.GE670331@infradead.org/

I probably should've just kept it the way it was.  Well, maybe I'll send
in my own fixpatch and see what the rest of you think.

> > > > > BTW, the stack report also had me wondering whether we had or need any
> > > > > nesting protection in these new scan invocations. For example, if we
> > > > > have an fs with a bunch of tagged inodes and concurrent allocation
> > > > > activity, would anything prevent an in-scan transaction allocation from
> > > > > jumping back into the scan code to complete outstanding work? It looks
> > > > > like that might not be possible right now because neither scan reserves
> > > > > blocks, but they do both use transactions and that's quite a subtle
> > > > > balance..
> > > > 
> > > > Yes, that's a subtlety that screams for better documentation.
> > > > 
> > > 
> > > TBH, I'm not sure that's enough. I think we should at least have some
> > > kind of warning, even if only in DEBUG mode, that explicitly calls out
> > > if we've become susceptible to this kind of scan reentry. Otherwise I
> > > suspect that if this problem is ever truly introduced, the person who
> > > first discovers it will probably be user with a blown stack. :( Could we
> > > set a flag on the task or something that warns as such (i.e. "WARNING:
> > > attempted block reservation in block reclaim context") or perhaps just
> > > prevents scan reentry in the first place?
> > 
> > What if we implemented a XFS_TRANS_TRYRESERVE flag that would skip the
> > scanning loops?  Then it would be at least a little more obvious when
> > xfs_free_eofblocks and xfs_reflink_cancel_cow_range kick on.
> 
> Isn't detecting transaction reentry exactly what PF_FSTRANS is for?
> 
> Or have we dropped that regression fix on the ground *again*?

That series isn't making progress.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
