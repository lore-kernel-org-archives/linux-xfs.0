Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C40C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 08:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiK2IE5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 03:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiK2IE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 03:04:56 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBBF3056C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 00:04:55 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 9so12924220pfx.11
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 00:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WUGsIjgs9aqs83GOKORzCxbOjfpPAtC95brLA4ZadkE=;
        b=LmGVPRZOD5eblvoVVHjdjy2mo+W2hMmoQpFY3EDKwvSrqDTsFpC3Tx9jAvCLOz5QqA
         6kjIsMzpvmoZFmLhZ3jNp2cg9JPtK9zupn+vP4GThYrmAVxuNkkjOyML5cQCm8RvjuMu
         n4FKeo+vIeLG88CxXJvwuxd0X9iTa4+47XysuYiQghPEDDGYZUi6W/97DMEQYygCFmzI
         hoqL2pslZ7kzO7V5x+9BAs+lb/AdJRQbZBtQbssVQsAPqC9vKrWFxRaJtEZYeKocznMT
         WZdt7+Lq+aco7oxyRstWbTJiYQNmSOsc3mgd2DbdRlk+a8QEGqmJ5XaEqtb0Lr+Qws3T
         GUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUGsIjgs9aqs83GOKORzCxbOjfpPAtC95brLA4ZadkE=;
        b=tNHenuacODTxjfQKyX0VcgxGXlRf7vIKUkgLepdtSIQKgXOohFB5Ebr558kJHfwo7D
         YNtNhHEppfRGRGmOn78/RUOBsT9aRnrgvopBiPmuz8/3bghLXRL5tepP0c0mpZRps4YW
         my4zfyf4jsDlQEwkx4BZSMpXpFEiIawL54WURzscjhEhGf30NXYOuaV+yNR3y7hrwStn
         QB8mzP/qnwRGA1TUtupHGDTaht0Ta0sc8MBYAHYHtUcABQcdfhK1ompw2uBHSvE1OWkc
         lWg1e7aO2ctVLeJMGG8Hq3yuY8PBHclwxw/BWgS6peBWbLpad4aVDPH8OzcdotUR3xMj
         uPeA==
X-Gm-Message-State: ANoB5pnqRLYOQGY66DYs6z6MnoHke+S/R2QwAgGET5wlHImI5I5EPXyN
        3sb1gjWiXFDiC6QHEH9iyqN9VYvqWbgCwQ==
X-Google-Smtp-Source: AA0mqf5kZlvkD+4EJAMFUfcpFBaaLyiXlvnhFY/UrTwy4Sfd7j9S/7rQqh933wzX556WzzfEELmi3w==
X-Received: by 2002:a63:4d49:0:b0:46f:b030:7647 with SMTP id n9-20020a634d49000000b0046fb0307647mr30715483pgl.13.1669709095033;
        Tue, 29 Nov 2022 00:04:55 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id ns14-20020a17090b250e00b00218fb3bec27sm723403pjb.56.2022.11.29.00.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:04:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ozvbm-002M76-Ng; Tue, 29 Nov 2022 19:04:50 +1100
Date:   Tue, 29 Nov 2022 19:04:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/3] xfs: attach dquots to inode before reading data/cow
 fork mappings
Message-ID: <20221129080450.GE3600936@dread.disaster.area>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <Y4OuLTwPVdiHMBGi@magnolia>
 <20221129063104.GD3600936@dread.disaster.area>
 <Y4WrwDE/318NJ+tz@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4WrwDE/318NJ+tz@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 10:50:40PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 29, 2022 at 05:31:04PM +1100, Dave Chinner wrote:
> > On Sun, Nov 27, 2022 at 10:36:29AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > I've been running near-continuous integration testing of online fsck,
> > > and I've noticed that once a day, one of the ARM VMs will fail the test
> > > with out of order records in the data fork.
> > > 
> > > xfs/804 races fsstress with online scrub (aka scan but do not change
> > > anything), so I think this might be a bug in the core xfs code.  This
> > > also only seems to trigger if one runs the test for more than ~6 minutes
> > > via TIME_FACTOR=13 or something.
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf
> > .....
> > > So.  Fix this by moving the dqattach_locked call up, and add a comment
> > > about how we must attach the dquots *before* sampling the data/cow fork
> > > contents.
> > > 
> > > Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_iomap.c |   12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 1bdd7afc1010..d903f0586490 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -984,6 +984,14 @@ xfs_buffered_write_iomap_begin(
> > >  	if (error)
> > >  		goto out_unlock;
> > >  
> > > +	/*
> > > +	 * Attach dquots before we access the data/cow fork mappings, because
> > > +	 * this function can cycle the ILOCK.
> > > +	 */
> > > +	error = xfs_qm_dqattach_locked(ip, false);
> > > +	if (error)
> > > +		goto out_unlock;
> > > +
> > >  	/*
> > >  	 * Search the data fork first to look up our source mapping.  We
> > >  	 * always need the data fork map, as we have to return it to the
> > > @@ -1071,10 +1079,6 @@ xfs_buffered_write_iomap_begin(
> > >  			allocfork = XFS_COW_FORK;
> > >  	}
> > >  
> > > -	error = xfs_qm_dqattach_locked(ip, false);
> > > -	if (error)
> > > -		goto out_unlock;
> > > -
> > >  	if (eof && offset + count > XFS_ISIZE(ip)) {
> > >  		/*
> > >  		 * Determine the initial size of the preallocation.
> > > 
> > 
> > Why not attached the dquots before we call xfs_ilock_for_iomap()?
> 
> I wanted to minimize the number of xfs_ilock calls -- under the scheme
> you outline, xfs_qm_dqattach will lock it once; a dquot cache miss
> will drop and retake it; and then xfs_ilock_for_iomap would take it yet
> again.  That's one more ilock song-and-dance than this patch does...

Ture, but we don't have an extra lock cycle if the dquots are
already attached to the inode - xfs_qm_dqattach() checks for
attached inodes before it takes the ILOCK to attach them. Hence if
we are doing lots of small writes to a file, we only take this extra
lock cycle for the first delalloc reservation that we make, not
every single one....

We have to do it this way for anything that runs an actual
transaction (like the direct IO write path we take if an extent size
hint is set) as we can't cycle the ILOCK within a transaction
context, so the code is already optimised for the "dquots already
attached" case....

> > That way we can just call xfs_qm_dqattach(ip, false) and just return
> > on failure immediately. That's exactly what we do in the
> > xfs_iomap_write_direct() path, and it avoids the need to mention
> > anything about lock cycling because we just don't care
> > about cycling the ILOCK to read in or allocate dquots before we
> > start the real work that needs to be done...
> 
> ...but I guess it's cleaner once you start assuming that dqattach has
> grown its own NOWAIT flag.  I'd sorta prefer to commit this corruption
> fix as it is and rearrange dqget with NOWAIT as a separate series since
> Linus has already warned us[1] to get things done sooner than later.
> 
> [1] https://lore.kernel.org/lkml/CAHk-=wgUZwX8Sbb8Zvm7FxWVfX6CGuE7x+E16VKoqL7Ok9vv7g@mail.gmail.com/

<shrug>

If that's your concern, then

Reviewed-by: Dave Chinner <dchinner@redhat.com>

However, as maintainer I was never concerned about being "too late
in the cycle". I'd just push it into the for next tree with a stable
tag and when it gets merged in a couple of weeks the stable
maintainers should notice it and backport it appropriately
automatically....

For distro backports, merging into the XFS tree is good enough to be
iconsidered upstream as it's pretty much guaranteed to end up in the
mainline tree once it's been merged by the maintainer....

> (OTOH it's already 6pm your time so I may very well be done with all
> the quota nowait changes before you wake up :P)

NOWAIT changes are definitely next cycle stuff :)

> > Hmmmmm - this means there's a potential problem with IOCB_NOWAIT
> > here - if the dquots are not in memory, we're going to drop and then
> > retake the ILOCK_EXCL without trylocks, potentially blocking a task
> > that should not get blocked. That's a separate problem, though, and
> > we probably need to plumb NOWAIT through to the dquot lookup cache
> > miss case to solve that.
> 
> It wouldn't be that hard to turn that second parameter into the usual
> uint flags argument, but I agree that's a separate patch.

*nod*

> How much you wanna bet the FB people have never turned on quota and
> hence have not yet played whackanowait with that subsystem?

No bet, we both know the odds. :/

Indeed, set an extent size hint on a file and then run io_uring
async buffered writes and watch all the massive long tail latencies
that occur on the transaction reservations and btree block IO and
locking in the allocation path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
