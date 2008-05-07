Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 May 2008 01:44:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m478hsGw026303
	for <xfs@oss.sgi.com>; Wed, 7 May 2008 01:43:56 -0700
Date: Wed, 7 May 2008 18:44:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: question about xfs_alloc_fix_freelist()
Message-ID: <20080507084421.GY103491721@sgi.com>
References: <20080504235048.GC155679365@sgi.com> <4820CBF5.8090206@agami.com> <20080507053108.GV103491721@sgi.com> <48215740.5050501@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48215740.5050501@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, May 07, 2008 at 12:16:16AM -0700, Michael Nishimoto wrote:
> David Chinner wrote:
> >On Tue, May 06, 2008 at 02:21:57PM -0700, Michael Nishimoto wrote:
> > > David Chinner wrote:
> > > >On Fri, May 02, 2008 at 02:01:47PM -0700, Michael Nishimoto wrote:
> > > > > The following code can be found near the end of xfs_alloc_fix_freelist:
.....
> > > > > Don't we need to release agbp too by calling xfs_trans_brelse(tp, agbp)?
> > > >
> > > >I don't think so. AFAICT, The agbp (agf block) is linked into the
> > > >transaction and by this point we may have modified the AGF (think
> > > >multiple iterations of the loop to fill the free list). Given that
> > > >it may be modified, we shouldn't release it here but instead allow
> > > >the transaction commit/abort to do that for us at the appropriate
> > > >time.
> > >
> > > I understood that the transaction abort code will free resources/locks
> > > when passing back an error.  However, by returning args->agbp = NULL,
> > > aren't we telling the calling code that we have not satisfied the request
> > > in the current AG?
> >
> >Yes.
> 
> If this happens and the calling function decides to choose another AG, is
> there a possibility of using up the entire transaction log reservation?

Yes, it could, but remember that if the calling code is obeying the
rules then the AG will be considered ENOSPC before we try to touch
the AGFL. i.e. this case will never happen if the code is correct.

As it turns out, the recent fix I made for a long standing shutdown
at ENOSPC during inode create was a result of the inode creation
code not following the rules correctly - making it follows the rules
meant it the early checks in xfs_alloc_fix_freelist() prevented the
piece of code you pointed out dirtying the AGF/AGFL and then ENOSPCing
in the AG. See:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3

> Couldn't we end up affecting freelists in multiple AGs with the same
> transaction?

Yes and that is a bug if we don't actually end up allocating out of
those AGs.  However, in almost cases it is not a fatal bug and the
code reflects that....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
