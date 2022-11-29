Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5D3C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 06:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiK2Guq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 01:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK2Gup (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 01:50:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D2427FE3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 22:50:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECBB3B8110A
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 06:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789EDC433D6;
        Tue, 29 Nov 2022 06:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669704641;
        bh=hvyH7t2EHLRYvpGobr944KrDVuSoVw2SnLW4k0jocoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJ4+tXfZG864hF4jqD/4/4twf0R7/X2Ln8HLbH15aIWotDXZ7c8SR8O/8FdgGVU7d
         qjYzyT6EBwLB9RT3toGSR7Z7rb+yLqB/Td2G9A9nKUmbg6WdLh8NGYNKZuNbp6VPAG
         lJOEY/wjNYkVWnxEOzi6Ms/jDHCQUOGJeCyxg1a7jMuUNHSgprKiA/9g093Byf6gj+
         1gwEswfAzVkGJRmclboyBWX8g/rO5eQsi91IAwRU8hAfw256bGtAhVQBl1hUyAl8yd
         WMo0aJ+86gJRhzJXAaryVv9e99/vbSIBc5r80myMw7k1LFAhTLcqO6YkIcoHoDVgxw
         2wi1Cd7DV7qyQ==
Date:   Mon, 28 Nov 2022 22:50:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/3] xfs: attach dquots to inode before reading data/cow
 fork mappings
Message-ID: <Y4WrwDE/318NJ+tz@magnolia>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <Y4OuLTwPVdiHMBGi@magnolia>
 <20221129063104.GD3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129063104.GD3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 05:31:04PM +1100, Dave Chinner wrote:
> On Sun, Nov 27, 2022 at 10:36:29AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I've been running near-continuous integration testing of online fsck,
> > and I've noticed that once a day, one of the ARM VMs will fail the test
> > with out of order records in the data fork.
> > 
> > xfs/804 races fsstress with online scrub (aka scan but do not change
> > anything), so I think this might be a bug in the core xfs code.  This
> > also only seems to trigger if one runs the test for more than ~6 minutes
> > via TIME_FACTOR=13 or something.
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf
> .....
> > So.  Fix this by moving the dqattach_locked call up, and add a comment
> > about how we must attach the dquots *before* sampling the data/cow fork
> > contents.
> > 
> > Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_iomap.c |   12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 1bdd7afc1010..d903f0586490 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -984,6 +984,14 @@ xfs_buffered_write_iomap_begin(
> >  	if (error)
> >  		goto out_unlock;
> >  
> > +	/*
> > +	 * Attach dquots before we access the data/cow fork mappings, because
> > +	 * this function can cycle the ILOCK.
> > +	 */
> > +	error = xfs_qm_dqattach_locked(ip, false);
> > +	if (error)
> > +		goto out_unlock;
> > +
> >  	/*
> >  	 * Search the data fork first to look up our source mapping.  We
> >  	 * always need the data fork map, as we have to return it to the
> > @@ -1071,10 +1079,6 @@ xfs_buffered_write_iomap_begin(
> >  			allocfork = XFS_COW_FORK;
> >  	}
> >  
> > -	error = xfs_qm_dqattach_locked(ip, false);
> > -	if (error)
> > -		goto out_unlock;
> > -
> >  	if (eof && offset + count > XFS_ISIZE(ip)) {
> >  		/*
> >  		 * Determine the initial size of the preallocation.
> > 
> 
> Why not attached the dquots before we call xfs_ilock_for_iomap()?

I wanted to minimize the number of xfs_ilock calls -- under the scheme
you outline, xfs_qm_dqattach will lock it once; a dquot cache miss
will drop and retake it; and then xfs_ilock_for_iomap would take it yet
again.  That's one more ilock song-and-dance than this patch does...

> That way we can just call xfs_qm_dqattach(ip, false) and just return
> on failure immediately. That's exactly what we do in the
> xfs_iomap_write_direct() path, and it avoids the need to mention
> anything about lock cycling because we just don't care
> about cycling the ILOCK to read in or allocate dquots before we
> start the real work that needs to be done...

...but I guess it's cleaner once you start assuming that dqattach has
grown its own NOWAIT flag.  I'd sorta prefer to commit this corruption
fix as it is and rearrange dqget with NOWAIT as a separate series since
Linus has already warned us[1] to get things done sooner than later.

[1] https://lore.kernel.org/lkml/CAHk-=wgUZwX8Sbb8Zvm7FxWVfX6CGuE7x+E16VKoqL7Ok9vv7g@mail.gmail.com/

(OTOH it's already 6pm your time so I may very well be done with all
the quota nowait changes before you wake up :P)

> Hmmmmm - this means there's a potential problem with IOCB_NOWAIT
> here - if the dquots are not in memory, we're going to drop and then
> retake the ILOCK_EXCL without trylocks, potentially blocking a task
> that should not get blocked. That's a separate problem, though, and
> we probably need to plumb NOWAIT through to the dquot lookup cache
> miss case to solve that.

It wouldn't be that hard to turn that second parameter into the usual
uint flags argument, but I agree that's a separate patch.

How much you wanna bet the FB people have never turned on quota and
hence have not yet played whackanowait with that subsystem?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
