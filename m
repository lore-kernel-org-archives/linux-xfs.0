Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C1547F47
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 11:23:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07DE68F8040
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 09:23:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ewMH5NWLJySEVjbq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jul 2014 09:23:04 -0700 (PDT)
Date: Mon, 28 Jul 2014 12:23:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/18] xfs: set sparse inodes feature bit when a sparse
	chunk is allocated
Message-ID: <20140728162300.GE59542@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-11-git-send-email-bfoster@redhat.com>
	<20140724224628.GS20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140724224628.GS20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 25, 2014 at 08:46:28AM +1000, Dave Chinner wrote:
> On Thu, Jul 24, 2014 at 10:23:00AM -0400, Brian Foster wrote:
> > The sparse chunk inode record format is backwards compatible with old
> > format inobt records as long as full chunks are allocated. The holemask
> > field uses higher order bytes of the freecount. While sparse chunks can
> > be enabled on previously unsupported fs, older kernel drivers cannot
> > parse sparse inode records.
> > 
> > Set the feature incompatible bit once a sparse inode chunk is allocated
> > to prevent older XFS drivers from tripping over the new format.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 4226b1b..4dd45c2 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -407,6 +407,27 @@ error:
> >  	return error;
> >  }
> >  
> > +STATIC void
> > +xfs_sbversion_add_spinodes(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
> > +					    XFS_SB_FEAT_INCOMPAT_SPINODES))
> 
> wrong function. xfs_sb_has_incompat_feature().
> 

Oops, right.

> > +		return;
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
> > +					    XFS_SB_FEAT_INCOMPAT_SPINODES)) {
> > +		spin_unlock(&mp->m_sb_lock);
> > +		return;
> > +	}
> > +
> > +	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
> > +	spin_unlock(&mp->m_sb_lock);
> > +	xfs_mod_sb(tp, XFS_SB_FEATURES_INCOMPAT);
> > +}
> > +
> >  /*
> >   * Allocate new inodes in the allocation group specified by agbp.
> >   * Return 0 for success, else error code.
> > @@ -631,6 +652,18 @@ xfs_ialloc_ag_alloc(
> >  		if (error)
> >  			return error;
> >  	}
> > +
> > +	/*
> > +	 * Set an incompat feature bit as old drivers can't parse sparse
> > +	 * records. Pre-sparse inode chunk drivers will include the
> > +	 * holemask in the higher order freecount bits, resulting in a
> > +	 * bogus value.
> > +	 *
> > +	 * XXX: when is this bit removed?
> > +	 */
> > +	if (xfs_inobt_issparse(&rec))
> > +		xfs_sbversion_add_spinodes(tp, args.mp);
> 
> I'd like to avoid this dynamic feature bit adding if possible. Do we
> really need it?
> 

Nope. As discussed, I'll move to something purely manual for the next
iteration and we can move forward from there with regard to if/when to
set it by default.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
