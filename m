Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49320 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdDJVIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 17:08:15 -0400
Date: Mon, 10 Apr 2017 14:08:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs_db: use iocursor type to guess btree geometry if
 bad magic
Message-ID: <20170410210807.GP4874@birch.djwong.org>
References: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
 <149162063502.22901.11947139521251833946.stgit@birch.djwong.org>
 <20170408231953.GF23007@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170408231953.GF23007@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Sun, Apr 09, 2017 at 09:19:53AM +1000, Dave Chinner wrote:
> On Fri, Apr 07, 2017 at 08:03:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The function block_to_bt plays an integral role in determining the btree
> > geometry of a block that we want to manipulate with the debugger.
> > Normally we use the block magic to find the geometry profile, but if the
> > magic is bad we'll never find it and return NULL.  The callers of this
> > function do not check for NULL and crash.
> > 
> > Therefore, if we can't find a geometry profile matching the magic
> > number, use the iocursor type to guess the profile and scowl about that
> > to stdout.  This makes it so that even with a corrupt magic we can try
> > to print the fields instead of crashing the debugger.
> 
> ....
> 
> > +#define M(a,b) (!xfs_sb_version_hascrc(&mp->m_sb) ? (a) : (b))
> > +	switch (iocur_top->typ->typnm) {
> > +	case TYP_BMAPBTA:
> > +	case TYP_BMAPBTD:
> > +		magic = M(XFS_BMAP_MAGIC, XFS_BMAP_CRC_MAGIC);
> > +		break;
> 
> That's really quite special, Darrick. :P
> 
> This:
> 
> 	(!xfs_sb_version_hascrc(&mp->m_sb) ? (a) : (b))
> 
> Could written more simply as:
> 
> 	(xfs_sb_version_hascrc(&mp->m_sb) ? (b) : (a))
> 
> or you could swap the macro args so you only need to drop the
> negation.
> 
> Even better, though, would be to use a local variable to only
> evaluate the CRC status once and kill the macro altogether:
> 
> 	has_crc = xfs_sb_version_hascrc(&mp->m_sb);
> 	switch (iocur_top->typ->typnm) {
> 	case TYP_BMAPBTA:
> 	case TYP_BMAPBTD:
> 		magic = has_crc ? XFS_ABTB_CRC_MAGIC : XFS_ABTB_MAGIC;
> 		break;
> .....

Ok, done.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
