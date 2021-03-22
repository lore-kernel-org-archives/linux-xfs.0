Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58ABC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF2E61998
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhCVQaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhCVQ3p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 12:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A87761923;
        Mon, 22 Mar 2021 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616430585;
        bh=YcBIMfJpLQfr2/t4Tf6vXUShwV5aeuNM29CUxIryY6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ojKNLfkhpNP49QxPnH1cLY+xYDawlER1rkARI3yjYZsffKqiXn2cRuigzN8a4ZcQb
         Ejew2iu8tRh6P2dx63lmSvWNVOvn/zdkDoKDEQAIN9S1ctVT9SafVs7x+mrOxBfzFb
         dCWsEpBTwEJEZFthIjrniD1IyRoFXHlp9CVpQfyGgsGuP+Ksf3V6VKEEhgVFCT78if
         ztp71BDvgAYfqYYu7Geq32/1u9Bdn8aQq+n40mkCdehKLsinpUu8Jlojr5lyXtj3DR
         4VMNj6tV2vbyIs/eID4OzIEWRguq1GGguPJcFzuGa69ymR2i32uTk/RWY2hfkaxUeP
         3oAYAFM8ul2ag==
Date:   Mon, 22 Mar 2021 09:29:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210322162944.GC22100@magnolia>
References: <20210320164007.GX22100@magnolia>
 <YFiyneMtdTccoe+N@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFiyneMtdTccoe+N@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 11:07:09AM -0400, Brian Foster wrote:
> On Sat, Mar 20, 2021 at 09:40:07AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While running some fuzz tests on inode metadata, I noticed that the
> > filesystem health report (as provided by xfs_spaceman) failed to report
> > the file corruption even when spaceman was run immediately after running
> > xfs_scrub to detect the corruption.  That isn't the intended behavior;
> > one ought to be able to run scrub to detect errors in the ondisk
> > metadata and be able to access to those reports for some time after the
> > scrub.
> > 
> > After running the same sequence through an instrumented kernel, I
> > discovered the reason why -- scrub igets the file, scans it, marks it
> > sick, and ireleases the inode.  When the VFS lets go of the incore
> > inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
> > inode before it moves to RECLAIM state, iget reinitializes the VFS
> > state, clears the sick and checked masks, and hands back the inode.  At
> > this point, the caller has the exact same incore inode, but with all the
> > health state erased.
> > 
> 
> So this requires some degree of cache pressure to reproduce, right?

None at all, actually -- xfs_scrub uses bulkstat to find inodes to
scrub.  Bulkstat sets I_DONTCACHE on the files it reads, so the VFS
drops the inode (if there are no dentries or the dentries are also
marked DONTCACHE) as soon as irele drops the refcount to zero.

IOWs, the fuzz test can do this on an idle system:

# xfs_db -x -c 'inode XXX' -c 'fuzz -d core.blah random' /dev/sda
# mount /dev/sda /mnt
# xfs_scrub -d -T -v -n /mnt/
Corruption: inode XXX record
# xfs_spaceman -c 'health -c' /mnt/

and spaceman doesn't report the corruption that we /just/ found.

> I.e., the inode likely does not immediately go to reclaimable state on
> release, but rather the vfs eventually decides to evict and we
> inactivate from there. If we grab the inode after that point, it
> effectively behaves as if the inode structure was freed and we re-read
> from disk because we cleared health state earlier than necessary.

Right.

> If I'm following that correctly, do you observe a noticeable impact in
> terms of health state lifetime? The change seems reasonable, I'm just
> wondering how much longer we'd expect to have this information available
> after vfs eviction occurs and if/how that impacts userspace scrub
> behavior.

I notice /some/ increase in health state lifetime.  With the patch
applied the shell code above works as intended (spaceman reports inode
XXX is broken) so long as inode reclaim doesn't run before spaceman.
Because these days reclaim is triggered by the AIL releasing the inodes,
this means that spaceman only has to be run before the next fsync or the
log force expiration.

Similarly, if a different user program open()s the inode after a scan,
then the health state will stick around as long as there hasn't been
enough memory pressure to push the inode out of memory for real.

My development tree also contains a patchset that adds the ability for
inode reclaim to notice that it's freeing an inode that had health
problems, and record in the per-AG health state that some inode
somewhere in that AG had a problem, but that's for a future submission.
This will close the hole that inode health state perishes rather quickly
under memory pressure.

--D

> Brian
> 
> > In other words, we're erasing the incore inode's health state flags when
> > we've decided NOT to sever the link between the incore inode and the
> > ondisk inode.  This is wrong, so we need to remove the lines that zero
> > the fields from xfs_iget_cache_hit.
> > 
> > As a precaution, we add the same lines into xfs_reclaim_inode just after
> > we sever the link between incore and ondisk inode.  Strictly speaking
> > this isn't necessary because once an inode has gone through reclaim it
> > must go through xfs_inode_alloc (which also zeroes the state) and
> > xfs_iget is careful to check for mismatches between the inode it pulls
> > out of the radix tree and the one it wants.
> > 
> > Fixes: 6772c1f11206 ("xfs: track metadata health status")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 595bda69b18d..5325fa28d099 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -587,8 +587,6 @@ xfs_iget_cache_hit(
> >  		ip->i_flags |= XFS_INEW;
> >  		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
> >  		inode->i_state = I_NEW;
> > -		ip->i_sick = 0;
> > -		ip->i_checked = 0;
> >  
> >  		spin_unlock(&ip->i_flags_lock);
> >  		spin_unlock(&pag->pag_ici_lock);
> > @@ -1205,6 +1203,8 @@ xfs_reclaim_inode(
> >  	spin_lock(&ip->i_flags_lock);
> >  	ip->i_flags = XFS_IRECLAIM;
> >  	ip->i_ino = 0;
> > +	ip->i_sick = 0;
> > +	ip->i_checked = 0;
> >  	spin_unlock(&ip->i_flags_lock);
> >  
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > 
> 
