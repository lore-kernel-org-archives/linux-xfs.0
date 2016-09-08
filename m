Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50155 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbcIHCEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2016 22:04:02 -0400
Date: Wed, 7 Sep 2016 19:03:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] xfsdocs: document the realtime reverse mapping btree
Message-ID: <20160908020353.GA9314@birch.djwong.org>
References: <147216761636.32447.4229640006064129056.stgit@birch.djwong.org>
 <147216766221.32447.9777486170830928374.stgit@birch.djwong.org>
 <20160908013838.GT30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908013838.GT30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 11:38:38AM +1000, Dave Chinner wrote:
> On Thu, Aug 25, 2016 at 04:27:42PM -0700, Darrick J. Wong wrote:
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  .../allocation_groups.asciidoc                     |    8 +
> >  design/XFS_Filesystem_Structure/docinfo.xml        |   14 +
> >  .../internal_inodes.asciidoc                       |    2 
> >  design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
> >  .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    6 -
> >  design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  |  234 ++++++++++++++++++++
> >  6 files changed, 263 insertions(+), 2 deletions(-)
> >  create mode 100644 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
> > 
> > 
> > diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > index cafa8b7..7ba636a 100644
> > --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > @@ -105,6 +105,7 @@ struct xfs_sb
> >  	xfs_ino_t		sb_pquotino;
> >  	xfs_lsn_t		sb_lsn;
> >  	uuid_t			sb_meta_uuid;
> > +	xfs_ino_t		sb_rrmapino;
> >  };
> >  ----
> >  *sb_magicnum*::
> > @@ -449,6 +450,13 @@ If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
> >  all metadata blocks must match this UUID.  If not, the block header UUID field
> >  must match +sb_uuid+.
> >  
> > +*sb_rrmapino*::
> > +If the +XFS_SB_FEAT_COMPAT_RMAPBT+ feature is set and a real-time
> 
> XFS_SB_FEAT_RO_COMPAT_RMAPBT?
> 
> (yes, I am reading these patches!)

Woohoo!!!

Thank you for catching this! :)

--D

> 
> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
