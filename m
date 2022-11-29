Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8726C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbiK2VD6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiK2VD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:03:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABCE54B36
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 181A5B818F8
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4136C433C1;
        Tue, 29 Nov 2022 21:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669755833;
        bh=Ly1pQh5Ix5Mt6TpnRzyCsaiN25LU943ArJ7QK5xDoJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mnWpFUA3VkfCkKxCkeoMBPIMsbxKpLxsIU00WR7GAipVKDYh82QvjvuuKpTjG+lTa
         h6J1Kc7AXrZkxh0Up3YEhMy5wmx9yzhwQTofIiv9Us/BYkza+OhTjIb48yfMTqHjOR
         GhrNbfmrn1bgWgrTxSI4bzd8jUKOw2oWTiYHDhZqRjYCNWV/6YkAmwvU+LTpKb5oOT
         J3aVVwbYephoQo4kjoVtWuID8nsdKhUL+Ms6yEPX9ED5KyB+7+FwPNmjE6QSXmU9gE
         wXp0Wuf0rjtBaIU53Yzmasr9nEYJvsaWwy7nZaTRXzmEorEfUqpacSQ/Ecpuzf0vX9
         +wuhXYd8niyzA==
Date:   Tue, 29 Nov 2022 13:03:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/3] xfs: attach dquots to inode before reading data/cow
 fork mappings
Message-ID: <Y4ZzuZsBWZcbrrzm@magnolia>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <Y4OuLTwPVdiHMBGi@magnolia>
 <20221129063104.GD3600936@dread.disaster.area>
 <Y4WrwDE/318NJ+tz@magnolia>
 <20221129080450.GE3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129080450.GE3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 07:04:50PM +1100, Dave Chinner wrote:
> On Mon, Nov 28, 2022 at 10:50:40PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 29, 2022 at 05:31:04PM +1100, Dave Chinner wrote:
> > > On Sun, Nov 27, 2022 at 10:36:29AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > I've been running near-continuous integration testing of online fsck,
> > > > and I've noticed that once a day, one of the ARM VMs will fail the test
> > > > with out of order records in the data fork.
> > > > 
> > > > xfs/804 races fsstress with online scrub (aka scan but do not change
> > > > anything), so I think this might be a bug in the core xfs code.  This
> > > > also only seems to trigger if one runs the test for more than ~6 minutes
> > > > via TIME_FACTOR=13 or something.
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf
> > > .....
> > > > So.  Fix this by moving the dqattach_locked call up, and add a comment
> > > > about how we must attach the dquots *before* sampling the data/cow fork
> > > > contents.
> > > > 
> > > > Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_iomap.c |   12 ++++++++----
> > > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > > index 1bdd7afc1010..d903f0586490 100644
> > > > --- a/fs/xfs/xfs_iomap.c
> > > > +++ b/fs/xfs/xfs_iomap.c
> > > > @@ -984,6 +984,14 @@ xfs_buffered_write_iomap_begin(
> > > >  	if (error)
> > > >  		goto out_unlock;
> > > >  
> > > > +	/*
> > > > +	 * Attach dquots before we access the data/cow fork mappings, because
> > > > +	 * this function can cycle the ILOCK.
> > > > +	 */
> > > > +	error = xfs_qm_dqattach_locked(ip, false);
> > > > +	if (error)
> > > > +		goto out_unlock;
> > > > +
> > > >  	/*
> > > >  	 * Search the data fork first to look up our source mapping.  We
> > > >  	 * always need the data fork map, as we have to return it to the
> > > > @@ -1071,10 +1079,6 @@ xfs_buffered_write_iomap_begin(
> > > >  			allocfork = XFS_COW_FORK;
> > > >  	}
> > > >  
> > > > -	error = xfs_qm_dqattach_locked(ip, false);
> > > > -	if (error)
> > > > -		goto out_unlock;
> > > > -
> > > >  	if (eof && offset + count > XFS_ISIZE(ip)) {
> > > >  		/*
> > > >  		 * Determine the initial size of the preallocation.
> > > > 
> > > 
> > > Why not attached the dquots before we call xfs_ilock_for_iomap()?
> > 
> > I wanted to minimize the number of xfs_ilock calls -- under the scheme
> > you outline, xfs_qm_dqattach will lock it once; a dquot cache miss
> > will drop and retake it; and then xfs_ilock_for_iomap would take it yet
> > again.  That's one more ilock song-and-dance than this patch does...
> 
> Ture, but we don't have an extra lock cycle if the dquots are
> already attached to the inode - xfs_qm_dqattach() checks for
> attached inodes before it takes the ILOCK to attach them. Hence if
> we are doing lots of small writes to a file, we only take this extra
> lock cycle for the first delalloc reservation that we make, not
> every single one....
> 
> We have to do it this way for anything that runs an actual
> transaction (like the direct IO write path we take if an extent size
> hint is set) as we can't cycle the ILOCK within a transaction
> context, so the code is already optimised for the "dquots already
> attached" case....

<nod> In the end, I decided to rewrite the patch to xfs_qm_dqattach at
the start of xfs_buffered_write_iomap_begin.  I'll send that shortly.

> > > That way we can just call xfs_qm_dqattach(ip, false) and just return
> > > on failure immediately. That's exactly what we do in the
> > > xfs_iomap_write_direct() path, and it avoids the need to mention
> > > anything about lock cycling because we just don't care
> > > about cycling the ILOCK to read in or allocate dquots before we
> > > start the real work that needs to be done...
> > 
> > ...but I guess it's cleaner once you start assuming that dqattach has
> > grown its own NOWAIT flag.  I'd sorta prefer to commit this corruption
> > fix as it is and rearrange dqget with NOWAIT as a separate series since
> > Linus has already warned us[1] to get things done sooner than later.
> > 
> > [1] https://lore.kernel.org/lkml/CAHk-=wgUZwX8Sbb8Zvm7FxWVfX6CGuE7x+E16VKoqL7Ok9vv7g@mail.gmail.com/
> 
> <shrug>
> 
> If that's your concern, then
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks! ;)

> However, as maintainer I was never concerned about being "too late
> in the cycle". I'd just push it into the for next tree with a stable
> tag and when it gets merged in a couple of weeks the stable
> maintainers should notice it and backport it appropriately
> automatically....

<nod> Normally I wouldn't care about timing since it's a bugfix, but I
kinda want to get all these sharp ends wrapped up, to minimize the
number of fixes that we still have to work on for -rc1+ in January.

> For distro backports, merging into the XFS tree is good enough to be
> iconsidered upstream as it's pretty much guaranteed to end up in the
> mainline tree once it's been merged by the maintainer....
> 
> > (OTOH it's already 6pm your time so I may very well be done with all
> > the quota nowait changes before you wake up :P)
> 
> NOWAIT changes are definitely next cycle stuff :)
> 
> > > Hmmmmm - this means there's a potential problem with IOCB_NOWAIT
> > > here - if the dquots are not in memory, we're going to drop and then
> > > retake the ILOCK_EXCL without trylocks, potentially blocking a task
> > > that should not get blocked. That's a separate problem, though, and
> > > we probably need to plumb NOWAIT through to the dquot lookup cache
> > > miss case to solve that.
> > 
> > It wouldn't be that hard to turn that second parameter into the usual
> > uint flags argument, but I agree that's a separate patch.
> 
> *nod*
> 
> > How much you wanna bet the FB people have never turned on quota and
> > hence have not yet played whackanowait with that subsystem?
> 
> No bet, we both know the odds. :/
> 
> Indeed, set an extent size hint on a file and then run io_uring
> async buffered writes and watch all the massive long tail latencies
> that occur on the transaction reservations and btree block IO and
> locking in the allocation path....

Granted, I wonder what would

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
