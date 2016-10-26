Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:49794 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933267AbcJZVPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 17:15:44 -0400
Date: Thu, 27 Oct 2016 08:15:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 28/39] xfs_repair: handle multiple owners of data blocks
Message-ID: <20161026211540.GL23194@dastard>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743679506.11035.9193078348507369875.stgit@birch.djwong.org>
 <20161026105758.GC8254@infradead.org>
 <20161026171553.GC26572@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026171553.GC26572@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 10:15:53AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 26, 2016 at 03:57:58AM -0700, Christoph Hellwig wrote:
> > > --- a/repair/dinode.c
> > > +++ b/repair/dinode.c
> > > @@ -722,6 +722,9 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
> > >  			 * checking each entry without setting the
> > >  			 * block bitmap
> > >  			 */
> > > +			if (type == XR_INO_DATA &&
> > > +			    xfs_sb_version_hasreflink(&mp->m_sb))
> > > +				goto skip_dup;
> > >  			if (search_dup_extent(agno, agbno, ebno)) {
> > >  				do_warn(
> > >  _("%s fork in ino %" PRIu64 " claims dup extent, "
> > > @@ -731,6 +734,7 @@ _("%s fork in ino %" PRIu64 " claims dup extent, "
> > >  					irec.br_blockcount);
> > >  				goto done;
> > >  			}
> > > +skip_dup:
> > 
> > For some weird reason this goto makes me sad.  I'm getting into
> > major nitpick terretory here, but can we avoid it?  Either duplicate
> > the *tot increment or find some funky condition?
> > 
> > Otherwise this looks fine.
> 
> Ugh, unnecessary goto.  Sad! ;)
> 
> But in all seriousness an 'else if' could do the same work, so:
> 
> if (type == XR_INO_DATA &&
>     xfs_sb_version_hasreflink(&mp->m_sb))
> 	; /* avoid the dup extent check below */
> else if (search_dup_extent(agno, agbno, ebno)) {
> 	do_warn(...);
> }
> *tot += irec.br_blockcount;

Even that is unnecessary, yes?

	if ((type != XR_INO_DATA ||
	     !xfs_sb_version_hasreflink(&mp->m_sb)) &&
	    search_dup_extent(agno, agbno, ebno) {
		do_warn(...);
	}


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
