Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfFJRLH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 13:11:07 -0400
Date: Mon, 10 Jun 2019 10:10:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190610171003.GK1871505@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498085.1657646.3518168545540841602.stgit@magnolia>
 <20190610135848.GB6473@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610135848.GB6473@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Mon, Jun 10, 2019 at 09:58:52AM -0400, Brian Foster wrote:
> On Tue, Jun 04, 2019 at 02:49:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert quotacheck to use the new iwalk iterator to dig through the
> > inodes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
> >  1 file changed, 20 insertions(+), 42 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index aa6b6db3db0e..a5b2260406a8 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> ...
> > @@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
> >  	 * rootino must have its resources accounted for, not so with the quota
> >  	 * inodes.
> >  	 */
> > -	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
> > -		*res = BULKSTAT_RV_NOTHING;
> > -		return -EINVAL;
> > -	}
> > +	if (xfs_is_quota_inode(&mp->m_sb, ino))
> > +		return 0;
> >  
> >  	/*
> >  	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
> >  	 * at mount time and therefore nobody will be racing chown/chproj.
> >  	 */
> > -	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
> > -	if (error) {
> > -		*res = BULKSTAT_RV_NOTHING;
> > +	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
> 
> I was wondering if we should start using IGET_UNTRUSTED here, but I
> guess we're 1.) protected by quotacheck context and 2.) have the same
> record validity semantics as the existing bulkstat walker. LGTM:

Yep.  There's nothing else running in the fs at quotacheck time so inode
records should not be changing while quotacheck runs.

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	if (error == -EINVAL || error == -ENOENT)
> > +		return 0;
> > +	if (error)
> >  		return error;
> > -	}
> >  
> >  	ASSERT(ip->i_delayed_blks == 0);
> >  
> > @@ -1157,7 +1154,7 @@ xfs_qm_dqusage_adjust(
> >  		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> >  
> >  		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > -			error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> > +			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> >  			if (error)
> >  				goto error0;
> >  		}
> > @@ -1200,13 +1197,8 @@ xfs_qm_dqusage_adjust(
> >  			goto error0;
> >  	}
> >  
> > -	xfs_irele(ip);
> > -	*res = BULKSTAT_RV_DIDONE;
> > -	return 0;
> > -
> >  error0:
> >  	xfs_irele(ip);
> > -	*res = BULKSTAT_RV_GIVEUP;
> >  	return error;
> >  }
> >  
> > @@ -1270,18 +1262,13 @@ STATIC int
> >  xfs_qm_quotacheck(
> >  	xfs_mount_t	*mp)
> >  {
> > -	int			done, count, error, error2;
> > -	xfs_ino_t		lastino;
> > -	size_t			structsz;
> > +	int			error, error2;
> >  	uint			flags;
> >  	LIST_HEAD		(buffer_list);
> >  	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
> >  	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
> >  	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
> >  
> > -	count = INT_MAX;
> > -	structsz = 1;
> > -	lastino = 0;
> >  	flags = 0;
> >  
> >  	ASSERT(uip || gip || pip);
> > @@ -1318,18 +1305,9 @@ xfs_qm_quotacheck(
> >  		flags |= XFS_PQUOTA_CHKD;
> >  	}
> >  
> > -	do {
> > -		/*
> > -		 * Iterate thru all the inodes in the file system,
> > -		 * adjusting the corresponding dquot counters in core.
> > -		 */
> > -		error = xfs_bulkstat(mp, &lastino, &count,
> > -				     xfs_qm_dqusage_adjust,
> > -				     structsz, NULL, &done);
> > -		if (error)
> > -			break;
> > -
> > -	} while (!done);
> > +	error = xfs_iwalk(mp, NULL, 0, xfs_qm_dqusage_adjust, 0, NULL);
> > +	if (error)
> > +		goto error_return;
> >  
> >  	/*
> >  	 * We've made all the changes that we need to make incore.  Flush them
> > 
