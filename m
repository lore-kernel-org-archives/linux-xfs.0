Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36311 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750859AbdLSUvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:51:31 -0500
Date: Wed, 20 Dec 2017 07:51:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/13] xfs: create structure verifier function for
 shortform xattrs
Message-ID: <20171219205129.GA4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320953564.30654.16063573622569255317.stgit@magnolia>
 <20171219052329.GQ4094@dastard>
 <20171219204147.GC12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219204147.GC12613@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 12:41:47PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 19, 2017 at 04:23:29PM +1100, Dave Chinner wrote:
> > On Wed, Dec 13, 2017 at 03:58:55PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create a function to perform structure verification for short form
> > > extended attributes.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > +		/* Check for invalid namespace combinations. */
> > > +		if ((sfep->flags & XFS_ATTR_ROOT) &&
> > > +		    (sfep->flags & XFS_ATTR_SECURE))
> > > +			return __this_address;
> > 
> > #define ATTR_SF_FLAGS	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
> 
> XFS_ATTR_NSP_ONDISK_MASK?

Yeah, that works. I didn't go looking for an existing definition :/

> > 
> > 		if (sfep->flags & ~ATTR_SF_FLAGS)
> > 			return __this_address;
> > 		if ((sfep->flags & ATTR_SF_FLAGS) == ATTR_SF_FLAGS)
> > 			return __this_address;
> 
> Also, can we just use hweight8() > 1 here?  We only allow one namespace
> bit per attr.

With a comment, yes, otherwise someone unfamiliar with what
hweight() does will have to go do lots of extra work to understand
the code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
