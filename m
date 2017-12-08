Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49547 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750930AbdLHE7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 23:59:54 -0500
Date: Fri, 8 Dec 2017 15:59:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] mkfs: document sb_feat_args members
Message-ID: <20171208045951.GM5858@dastard>
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
 <3d8eeb94-8333-9d3d-7767-0a0267a2986e@sandeen.net>
 <20171208042722.GK19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208042722.GK19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 07, 2017 at 08:27:22PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 07, 2017 at 10:17:12PM -0600, Eric Sandeen wrote:
> > Some of these are more self-explanatory than others ("nci?").
> > Just mention the bit each one controls, and put them in order
> > while we're at it.  There are more comments about each bit
> > near its definition.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 22 +++++++++++-----------
> >  1 file changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index f6e2fad..3f6315d 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -760,17 +760,17 @@ struct sb_feat_args {
> >  	int	log_version;
> >  	int	attr_version;
> >  	int	dir_version;
> > -	bool	inode_align;
> > -	bool	nci;
> > -	bool	lazy_sb_counters;
> > -	bool	projid32bit;
> > -	bool	crcs_enabled;
> > -	bool	dirftype;
> > -	bool	finobt;
> > -	bool	spinodes;
> > -	bool	rmapbt;
> > -	bool	reflink;
> > -	bool	parent_pointers;
> > +	bool	inode_align;		/* XFS_SB_VERSION_ALIGNBIT */
> > +	bool	nci;			/* XFS_SB_VERSION_BORGBIT */
> 
> Is there a compelling reason for leaving all these weird names?
> 
> nci, borg, asciici...
> 
> "names case insensitive"
> "buy organic ratty gallbladders"
> "ascii case insensitive"
> 
> They're all kinda terrible, but at least I get the gist with the third one.

Well, "borg" makes sense when you know the historic context:  the
asciici feature was implemented specifically to improve performance
on Samba fileserving to MS machines.....

But, yeah, I always planned to follow up the refacting merge with a
bunch of cleanups like this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
