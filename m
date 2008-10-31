Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 18:28:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V1SBR4003428
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:28:11 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B4161B6D453
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:28:10 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id AlxH2pBz2FFAUmlh for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:28:10 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Kvinu-0000r6-Th
	for xfs@oss.sgi.com; Fri, 31 Oct 2008 12:27:58 +1100
Date: Fri, 31 Oct 2008 12:27:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: remove i_gen from incore inode
Message-ID: <20081031012758.GT17077@disturbed>
References: <1223417549-9920-1-git-send-email-david@fromorbit.com> <20081022062044.GJ18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022062044.GJ18495@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Ping?

On Wed, Oct 22, 2008 at 05:20:44PM +1100, Dave Chinner wrote:
> Ping?
> 
> On Wed, Oct 08, 2008 at 09:12:29AM +1100, Dave Chinner wrote:
> > i_gen is incremented in directory operations when the
> > directory is changed. It is never read or otherwise used
> > so it should be removed to help reduce the size of the
> > struct xfs_inode.
> > 
> > The patch also removes a duplicate logging of the directory
> > inode core. We only need to do this once per transaction
> > so kill the one associated with the i_gen increment.
> > 
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/xfs/xfs_inode.h    |    1 -
> >  fs/xfs/xfs_rename.c   |   12 ++----------
> >  fs/xfs/xfs_vnodeops.c |   29 ++---------------------------
> >  3 files changed, 4 insertions(+), 38 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index a8f1e68..5784f8e 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -272,7 +272,6 @@ typedef struct xfs_inode {
> >  	unsigned short		i_flags;	/* see defined flags below */
> >  	unsigned char		i_update_core;	/* timestamps/size is dirty */
> >  	unsigned char		i_update_size;	/* di_size field is dirty */
> > -	unsigned int		i_gen;		/* generation count */
> >  	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
> >  
> >  	xfs_icdinode_t		i_d;		/* most of ondisk inode */
> > diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
> > index d700dac..02f0e8f 100644
> > --- a/fs/xfs/xfs_rename.c
> > +++ b/fs/xfs/xfs_rename.c
> > @@ -367,19 +367,11 @@ xfs_rename(
> >  					&first_block, &free_list, spaceres);
> >  	if (error)
> >  		goto abort_return;
> > -	xfs_ichgtime(src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> >  
> > -	/*
> > -	 * Update the generation counts on all the directory inodes
> > -	 * that we're modifying.
> > -	 */
> > -	src_dp->i_gen++;
> > +	xfs_ichgtime(src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> >  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> > -
> > -	if (new_parent) {
> > -		target_dp->i_gen++;
> > +	if (new_parent)
> >  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> > -	}
> >  
> >  	/*
> >  	 * If this is a synchronous mount, make sure that the
> > diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> > index 8b6812f..7a72b0a 100644
> > --- a/fs/xfs/xfs_vnodeops.c
> > +++ b/fs/xfs/xfs_vnodeops.c
> > @@ -1625,8 +1625,6 @@ xfs_create(
> >  		xfs_trans_set_sync(tp);
> >  	}
> >  
> > -	dp->i_gen++;
> > -
> >  	/*
> >  	 * Attach the dquot(s) to the inodes and modify them incore.
> >  	 * These ids of the inode couldn't have changed since the new
> > @@ -1993,13 +1991,6 @@ xfs_remove(
> >  	}
> >  	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> >  
> > -	/*
> > -	 * Bump the in memory generation count on the parent
> > -	 * directory so that other can know that it has changed.
> > -	 */
> > -	dp->i_gen++;
> > -	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
> > -
> >  	if (is_dir) {
> >  		/*
> >  		 * Drop the link from ip's "..".
> > @@ -2017,8 +2008,8 @@ xfs_remove(
> >  	} else {
> >  		/*
> >  		 * When removing a non-directory we need to log the parent
> > -		 * inode here for the i_gen update.  For a directory this is
> > -		 * done implicitly by the xfs_droplink call for the ".." entry.
> > +		 * inode here.  For a directory this is done implicitly
> > +		 * by the xfs_droplink call for the ".." entry.
> >  		 */
> >  		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
> >  	}
> > @@ -2178,7 +2169,6 @@ xfs_link(
> >  	if (error)
> >  		goto abort_return;
> >  	xfs_ichgtime(tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> > -	tdp->i_gen++;
> >  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
> >  
> >  	error = xfs_bumplink(tp, sip);
> > @@ -2355,18 +2345,10 @@ xfs_mkdir(
> >  	}
> >  	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> >  
> > -	/*
> > -	 * Bump the in memory version number of the parent directory
> > -	 * so that other processes accessing it will recognize that
> > -	 * the directory has changed.
> > -	 */
> > -	dp->i_gen++;
> > -
> >  	error = xfs_dir_init(tp, cdp, dp);
> >  	if (error)
> >  		goto error2;
> >  
> > -	cdp->i_gen = 1;
> >  	error = xfs_bumplink(tp, dp);
> >  	if (error)
> >  		goto error2;
> > @@ -2653,13 +2635,6 @@ xfs_symlink(
> >  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
> >  
> >  	/*
> > -	 * Bump the in memory version number of the parent directory
> > -	 * so that other processes accessing it will recognize that
> > -	 * the directory has changed.
> > -	 */
> > -	dp->i_gen++;
> > -
> > -	/*
> >  	 * If this is a synchronous mount, make sure that the
> >  	 * symlink transaction goes to disk before returning to
> >  	 * the user.
> > -- 
> > 1.5.6.5
> > 
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> 

-- 
Dave Chinner
david@fromorbit.com
