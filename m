Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56636 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdLSVEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 16:04:13 -0500
Date: Tue, 19 Dec 2017 13:04:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/13] xfs: create structure verifier function for
 shortform xattrs
Message-ID: <20171219210409.GF12613@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320953564.30654.16063573622569255317.stgit@magnolia>
 <20171219052329.GQ4094@dastard>
 <20171219204147.GC12613@magnolia>
 <20171219205129.GA4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219205129.GA4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 20, 2017 at 07:51:29AM +1100, Dave Chinner wrote:
> On Tue, Dec 19, 2017 at 12:41:47PM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 19, 2017 at 04:23:29PM +1100, Dave Chinner wrote:
> > > On Wed, Dec 13, 2017 at 03:58:55PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create a function to perform structure verification for short form
> > > > extended attributes.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > > +		/* Check for invalid namespace combinations. */
> > > > +		if ((sfep->flags & XFS_ATTR_ROOT) &&
> > > > +		    (sfep->flags & XFS_ATTR_SECURE))
> > > > +			return __this_address;
> > > 
> > > #define ATTR_SF_FLAGS	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
> > 
> > XFS_ATTR_NSP_ONDISK_MASK?
> 
> Yeah, that works. I didn't go looking for an existing definition :/
> 
> > > 
> > > 		if (sfep->flags & ~ATTR_SF_FLAGS)
> > > 			return __this_address;
> > > 		if ((sfep->flags & ATTR_SF_FLAGS) == ATTR_SF_FLAGS)
> > > 			return __this_address;
> > 
> > Also, can we just use hweight8() > 1 here?  We only allow one namespace
> > bit per attr.
> 
> With a comment, yes, otherwise someone unfamiliar with what
> hweight() does will have to go do lots of extra work to understand
> the code.

/*
 * Check for invalid namespace combinations.  We only allow
 * one namespace flag per xattr, so we can just count the
 * bits (i.e. hweight) here.
 */

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
