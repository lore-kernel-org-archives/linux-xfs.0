Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 15:19:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m29MIhPC001265
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 15:18:47 -0700
Date: Mon, 10 Mar 2008 09:18:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: assfail during unmount xfs 2.6.24.3 [from 2.6.24.y git]
Message-ID: <20080309221858.GS155407@sgi.com>
References: <200803062329.10486.Chris.Knadle@coredump.us> <20080307224645.GW155259@sgi.com> <200803081555.11695.Chris.Knadle@coredump.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803081555.11695.Chris.Knadle@coredump.us>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Knadle <Chris.Knadle@coredump.us>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Sat, Mar 08, 2008 at 03:55:08PM -0500, Chris Knadle wrote:
> On Friday 07 March 2008, David Chinner wrote:
> > On Thu, Mar 06, 2008 at 11:29:07PM -0500, Chris Knadle wrote:
> > > During the final unmount before reboot there was an assertion failure
> > > from XFS 
> ...
> > > When replying please CC me, as I am not currently subscribed to the list.
> ...
> > > Assertion failed: atomic_read(&mp->m_active_trans) == 0, file:
> > > fs/xfs/xfs_vfsops.c, line: 708
> 
>    Thank you for taking the time to look and reply to this.
> 
> > Known problem. Race in the VFS w.r.t. read-only remounts:
> >
> > http://marc.info/?l=linux-kernel&m=120106649923499&w=2
> 
>    At the bottom of the above message there's a patch which is not currently 
> merged in either the linux-2.6.24.y.git or linux-2.6.git trees.  That's 
> perhaps as it should be, but I would like to know if it's worth trying 
> merging the patch locally as an attempted workaround until such time as 
> 2.6.25 is released and stable.

Sure, the patch is harmless - I've had it running in my local tree for
quite some time now.

> 
> > The fix for the problem lies outside XFS:
> >
> > http://marc.info/?l=linux-kernel&m=120109304227035&w=2
> 
>    If I understand the above correctly, it sounds like the per-vfsmount is 
> going to be a new feature committed to 2.6.25, but probably not backported to 
> prior kernel trees.

Right.

> If this feature was was added at 2.6.23.9 then if I 
> understand corectly it's only an issue between that version and 2.6.25; is 
> that correct?

Only if the per-vfsmount writer counts got merged in 2.6.25-rcX. I'm not sure
that they did. Christoph?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
