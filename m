Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q854NYJs230878 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 23:23:34 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NazK5vfRbsvHCXq1 for <xfs@oss.sgi.com>;
	Tue, 04 Sep 2012 21:24:31 -0700 (PDT)
Date: Wed, 5 Sep 2012 14:24:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/102]: xfs: 3.0.x stable kernel update
Message-ID: <20120905042429.GD15292@dastard>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<20120901231019.GC6896@infradead.org>
	<20120903060406.GA15292@dastard> <20120904211357.GK3274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120904211357.GK3274@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 04, 2012 at 04:13:57PM -0500, Ben Myers wrote:
> On Mon, Sep 03, 2012 at 04:04:06PM +1000, Dave Chinner wrote:
> > On Sat, Sep 01, 2012 at 07:10:19PM -0400, Christoph Hellwig wrote:
> > > I've done a brief look over the patches this week and while I can't spot
> > > anything wrong I'm defintively a bit concerned about the amount of churn
> > > for a long term stable series.  A lot of this does not seem to fit the
> > > strict -stable criteria, and given that I've not really seen any major
> > > issues with the current 3.0-stable codebase I'm wondering what the
> > > guranteed gain vs the status quo is.
> > 
> > You didn't troll the RH bugzilla ;)
> 
> Hehe.  ;)
> 
> > The XFS code base in RHEL6 is sitting at 3.0, and several of the
> > problems that have workarounds in 3.0.x don't fix the problems
> > reported (e.g. the log space hangs), while the fixes in the more
> > recent mainline kernel do.
> > 
> > I simply figured that I've got to do this much work to fix all the
> > bugs reported in RHEL6 and given the code bases are almost identical
> > I'd do a community service and push it to 3.0.x first. I'm quite
> > happy not to push it to 3.0.x if the consensus is that it is too
> > much churn.
> 
> FWIW I think it's great that you've done the community this service.
> I'm just now (finally) getting this patchset onto a machine for some
> testing.
> 
> Ok.. now that I've refreshed my memory of
> Documentation/stable_kernel_rules.txt, I can see Christoph's point.
> Some of these patches are hard to justify based upon those rules.  For
> example:
> 
> Patch 2, 'remove dead ENODEV handling in xfs_destroy_ioend' seems to
> just remove some dead code.  However, if it were clear that it fixes
> some kind of problem by removing the dead code it could easily be
> justified.

The are several patches in the series touch xfs_destroy_ioend().
Having to resolve all the conflicts by hand instead of including the
patch that removes the 5 lines of dead code means I didn't have to
modify the patches when applying them, and the result is verifiably
identical to the code in the current mainline tree...

Indeed, the very next patch would not apply without patch 2....

> Patch 94, 'm_maxioffset is redundant' seems like a cleanup.  But maybe
> it is required so that a subsequent patch will apply properly?
> 
> Patch 95, 'make largest supported offset less shouty' just cleans up a
> macro.  Again... maybe there is a good reason to pull that in besides
> the shouting.

Yeah, 94/95 can go. What probably happened there was that I was
considering a later patch that was dependent on these changes and I
ended up dropping that patch without realising I then didn't need
the m_maxioffset changes.

> So there are three examples that would probably require some kind of
> justification to apply within the rules as stated.  Maybe -stable just
> needs a link to the bug each one of them resolves.
> 
> It looks like there are plenty in the patchset that are very clearly
> appropriate within the rules, no additional justification required.  We
> certainly don't want to lose that.  We can go through the set and reply
> to those which seem questionable...

Sure, but remember that the dependent patches might be 50 patches
later in the series as the patches are applied in upstream commit
order....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
