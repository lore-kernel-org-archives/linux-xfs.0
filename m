Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754359AbeFVKou (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Jun 2018 06:44:50 -0400
Date: Fri, 22 Jun 2018 06:44:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: zero length symlinks are not valid
Message-ID: <20180622104448.GA9644@bfoster>
References: <20180618224259.GF19934@dastard>
 <20180619115434.GB2806@bfoster>
 <20180619154810.GC21698@magnolia>
 <20180619162839.GC2806@bfoster>
 <20180619232242.GJ19934@dastard>
 <20180620115048.GA3241@bfoster>
 <20180620225918.GN19934@dastard>
 <20180621114618.GA2834@bfoster>
 <20180621223140.GU19934@dastard>
 <20180621225346.GK4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180621225346.GK4838@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Jun 21, 2018 at 03:53:46PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 22, 2018 at 08:31:41AM +1000, Dave Chinner wrote:
> > On Thu, Jun 21, 2018 at 07:46:18AM -0400, Brian Foster wrote:
> > > On Thu, Jun 21, 2018 at 08:59:18AM +1000, Dave Chinner wrote:
> > > > On Wed, Jun 20, 2018 at 07:50:48AM -0400, Brian Foster wrote:
> > > > > If I recreate that same dirty log state and mount with this patch
> > > > > applied (note that the fs is created without this patch to simulate an
> > > > > old kernel that has not changed i_mode in the same transaction that sets
> > > > > di_size = 0) along with a hack to avoid the check in
> > > > > xfs_dinode_verify(), I now hit the new assert and corruption error
> > > > > that's been placed in xfs_inactive_symlink().
> > > > > 
> > > > > So to Darrick's point, that seems to show that this is a vector to the
> > > > > pre-existing len == 0 check in xfs_inactive_symlink(). Given that, it
> > > > > seems to me that if we want to handle recovery from this state, we'd
> > > > > still need to work around the verifier check and retain the initial
> > > > > di_size == 0 check in xfs_inactive_symlink().
> > > > 
> > > > I think we should get rid of the transient state, not continue to
> > > > work around it. Because the transient state only exists in a log
> > > > recovery context, we can change the behaviour and not care about
> > > > older kernels still having the problem because all that is needed to
> > > > avoid the issue is a clean log when upgrading the kernel.
> > > > 
> > > 
> > > Right... that sounds reasonable to me, but we still need to consider how
> > > we handle a filesystem already in this state. BTW, was this a user
> > > report or a manufactured corruption due to fuzzing/shutdown testing or
> > > something?
> > 
> > It was shutdown testing. The report was that xfs_repair -n failed
> > with a zero length symlink, not that log recovery failed. I assumed
> > that log recovery worked fine before xfs_repair -n was run because
> > it didn't warn about a dirty log. However, now that you point out
> > that we just toss unlink list recovery failures (which I'd forgotten
> > about!), I'm guessing that happened and then repair tripped over
> > the leaked symlink inode.
> > 
> > > Given that additional context, I don't feel too strongly about needing
> > > to specially handle the "zero length symlink already exists in the dirty
> > > log due to xfs_inactive_symlink_rmt()" case. Chances are the mount that
> > > reported the error already nuked the state in the first place, so users
> > > shouldn't really end up "stuck" somewhere between needing a kernel fix
> > > or an 'xfs_repair -L' run (but if that's the approach we take, please
> > > just note the tradeoff in the commit log). Just my .02.
> > 
> > Yup, that seems reasonable to me - leaking the inode until repair is
> > done has no user impact.  It will do the same thing for any inode it
> > finds on the unlinked list that is corrupted, so my thoughts are
> > that if we want to improve corruption handling we need to address
> > the general unlinked list corruption issue rather than just this
> > specific inode corruption case.
> 
> FWIW I saw generic/475 trip over this last night and judging from the
> logs I saw that behavior -- first we shut down right committing the
> zero-length symlink, then recovery makes it as far as iunlink processing
> where it blows up, tosses out that failure, and then the next time we
> hit that inode we'd trip over it all over again.
> 

What do you mean by "the next time we hit that inode?" IIUC, iunlink
processing nukes the entire AGI unlinked list bucket in response to the
read error. Given the inode was unlinked, shouldn't it no longer be
accessible after that point? Are you hitting some other path that
attempts to read the inode?

Brian

> --D
> 
> > Alright - I'll clean up the patch, make notes of all this in the
> > commit message and repost.
> > 
> > Thanks, Brian!
> > 
> > Cheers,
> > 
> > Dave.
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
