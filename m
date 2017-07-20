Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11789 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936091AbdGTWth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 18:49:37 -0400
Date: Fri, 21 Jul 2017 08:49:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170720224934.GW17762@dastard>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
 <20170720055057.GQ4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720055057.GQ4224@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Jul 19, 2017 at 10:50:57PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 20, 2017 at 12:26:02PM +1000, Dave Chinner wrote:
> > On Wed, Jul 19, 2017 at 09:03:18AM -0700, Darrick J. Wong wrote:
> > > +
> > > +	/* Check the attribute fork if there is one. */
> > > +	if (XFS_IFORK_PTR(ip, XFS_ATTR_FORK) &&
> > > +	    ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > 
> > If there is no attr fork, then ip->i_d.di_aformat should be set to
> > XFS_DINODE_FMT_EXTENTS. Hence we can just do the same check as
> > for the data fork....
> > 
> > OTOH, having a value of XFS_DINODE_FMT_LOCAL in di_aformat without
> > an attr fork indicates corruption, so perhaps we need to catch that
> 
> Hm, the documentation ought to reflect that. :)
> 
> > here as it's not checked in xfs_ifork_format() or xfs_iflush_int().
> > Indeed, there are partial attr/data fork format/size checks in
> > xfs_ifork_format() and xfs_iflush_int(), but we don't do
> > comprehensive checks in either place. Maybe they should all be moved
> > inside this function and expanded to check that all the fork format
> > information is valid?
> 
> Yes, this could get cleaned up this way...  What if we make
> _iformat_fork check that the sizes requested aren't insane, allocate
> memory, and load contents from the dinode; then we later use
> _verify_ifork_content to pick all the bugs out and destroy the inode if
> we finds any.
> 
> Hm.  The bmbt root actually needs numrecs read out of the header.  The
> sf attr header has the total size, though we're never going to need more
> than (inodesize - forkoff) bytes for it.  The bmdr thing could
> complicate this.

Right, but that's only when the fork format is in
XFS_DINODE_FMT_BTREE, so it's not an issue for local format
validation.

> (Maybe I'll sleep on this...)
> 
> Also, I thought di_forkoff was multiplied by 8 to calculate the distance
> of the attr fork from the data fork?  If that's the case, then isn't
> this verifier wrong?
> 
>     if (unlikely(dip->di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {

Yeah, but rather than "wrong" it's better to think of it as "not
exact". It'll catch most errors, but not really small ones. ISTR
that quite a few of the initial verifiers I wrote did things like
this because it wasn't possible or not clear how to do exact range
checks on some values.

In this case, if we want exact checks then we have to consider that
the di_forkoff has both a minimum and a maximum valid value - the
minimum valid value is dependent on data fork contents, the maximum
is inodesize - inode core size....

> <rambling off topic now>
> 
> While we're on the subject of verifiers, Eric Sandeen has been wishing
> that we could make it easier to figure out which buffer verifier test
> failed, and it would seem that the XFS_CORRUPTION_ERROR macro is used to
> highlight bad inode fork contents.  Perhaps we should create a similar
> macro that we could use to log exactly which buffer verifier test
> failed?

I don't want to put some shouty macro on every second line of a
verifier. Think differently - we currently return a true/false
from the internal verifier functions to trigger a call to
xfs_verifier_error(). How about they return __line__
on error and 0 on success and then pass that returned value into
xfs_verifier_error() and add that to the error output?

That tells us which check failed without adding more code to every
single verifier check - use the compiler to give us what we need
without any additional code, maintenance or runtime overhead.  All
we need to know is the kernel version so we can translate the line
number to a failed check...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
