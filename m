Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 43B2F7F51
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 18:53:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16063304048
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 16:53:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WdalW5P3qBOCQO5i for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 16:53:13 -0700 (PDT)
Date: Wed, 28 May 2014 09:53:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/16] xfs: reduce direct usage of mp->m_dir_geo
Message-ID: <20140527235307.GG8554@dastard>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-13-git-send-email-david@fromorbit.com>
	<20140527155957.GD11265@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527155957.GD11265@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, May 27, 2014 at 11:59:57AM -0400, Brian Foster wrote:
> On Fri, May 23, 2014 at 10:03:48AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > There are many places in the directory code were we don't pass the
> > args into and so have to extract the geometry direct from the mount
> > structure. Push the args or the geometry into these leaf functions
> > so that we don't need to grab it from the struct xfs_mount.
> > 
> > This, in turn, brings use to the point where directory geometry is
> > no longer a property of the struct xfs_mount; it is not a global
> > property anymore, and hence we can start to consider per-directory
> > configuration of physical geometries.
> > 
> > Start by converting the xfs_dir_isblock/leaf code - pass in the
> > xfs_da_args and convert the readdir code to use xfs_da_args like
> > the rest of the directory code to pass information around.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> >  STATIC int
> >  xfs_dir2_leaf_readbuf(
> > -	struct xfs_inode	*dp,
> > +	struct xfs_da_args	*args,
> >  	size_t			bufsize,
> >  	struct xfs_dir2_leaf_map_info *mip,
> >  	xfs_dir2_off_t		*curoff,
> >  	struct xfs_buf		**bpp)
> >  {
> > -	struct xfs_mount	*mp = dp->i_mount;
> > +	struct xfs_inode	*dp = args->dp;
> >  	struct xfs_buf		*bp = *bpp;
> >  	struct xfs_bmbt_irec	*map = mip->map;
> >  	struct blk_plug		plug;
> > @@ -304,7 +297,7 @@ xfs_dir2_leaf_readbuf(
> >  	int			length;
> >  	int			i;
> >  	int			j;
> > -	struct xfs_da_geometry	*geo = mp->m_dir_geo;
> > +	struct xfs_da_geometry	*geo = args->geo;
> 
> I notice that we remove the local geo pointer in some of the immediately
> previous fixups. Here we keep it...
> 
> >  
> >  	/*
> >  	 * If we have a buffer, we need to release it and
> > @@ -314,7 +307,7 @@ xfs_dir2_leaf_readbuf(
> >  	if (bp) {
> >  		xfs_trans_brelse(NULL, bp);
> >  		bp = NULL;
> > -		mip->map_blocks -= geo->fsbcount;
> > +		mip->map_blocks -= args->geo->fsbcount;
> 
> ... convert some calls to use args...
> 
> >  		/*
> >  		 * Loop to get rid of the extents for the
> >  		 * directory block.
> > @@ -338,8 +331,7 @@ xfs_dir2_leaf_readbuf(
> >  	/*
> >  	 * Recalculate the readahead blocks wanted.
> >  	 */
> > -	mip->ra_want = howmany(bufsize + geo->blksize,
> > -			       mp->m_sb.sb_blocksize) - 1;
> > +	mip->ra_want = howmany(bufsize + geo->blksize, (1 << geo->fsblog)) - 1;
> >  	ASSERT(mip->ra_want >= 0);
> 
> ... and not others. So we should probably at least be consistent within
> function. :) Otherwise this patch looks good to me.

Yup, brain fart. i converted each function in the entire file to use
a local geo variable....

-Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
