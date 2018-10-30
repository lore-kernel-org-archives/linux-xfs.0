Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:52098 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbeJaFte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 01:49:34 -0400
Date: Wed, 31 Oct 2018 07:54:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] repair: Protect bad inode list with mutex
Message-ID: <20181030205427.GQ19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-6-david@fromorbit.com>
 <20181030174434.GJ4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030174434.GJ4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:44:34AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 30, 2018 at 10:20:41PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To enable phase 6 parallelisation, we need to protect the bad inode
> > list from concurrent modification and/or access. Wrap it with a
> > mutex and clean up the nasty typedefs.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  repair/dir2.c | 32 +++++++++++++++++++++-----------
> >  1 file changed, 21 insertions(+), 11 deletions(-)
> > 
> > diff --git a/repair/dir2.c b/repair/dir2.c
> > index ba5763ed3d26..a73a675b97c8 100644
> > --- a/repair/dir2.c
> > +++ b/repair/dir2.c
> > @@ -20,40 +20,50 @@
> >   * Known bad inode list.  These are seen when the leaf and node
> >   * block linkages are incorrect.
> >   */
> > -typedef struct dir2_bad {
> > +struct dir2_bad {
> >  	xfs_ino_t	ino;
> >  	struct dir2_bad	*next;
> > -} dir2_bad_t;
> > +};
> 
> Just out of curiosity, how fast does this linked list grow?  In theory
> we could hoist scrub/bitmap.c to libfrog and turn this into a bitmap,
> but that probably depends on how often we find inodes with bad link
> counts...?  And admittedly, avlnodes aren't cheap either...

Never seen it in profiles, so I don't see it as problem we need to
solve at this point. The dir_hash code, OTOH....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
