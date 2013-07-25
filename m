Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29D017CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 19:53:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 08DF98F8033
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 17:53:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aoG6YnZHeILM9FdS for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 17:53:25 -0700 (PDT)
Date: Thu, 25 Jul 2013 10:52:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/48] libxfs: add version 3 inode support
Message-ID: <20130725005259.GD11222@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-8-git-send-email-david@fromorbit.com>
	<20130723223007.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130723223007.GN3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 23, 2013 at 05:30:07PM -0500, Ben Myers wrote:
> Dave,
> 
> On Fri, Jun 07, 2013 at 10:25:30AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Header from folded patch 'debug':
> > 
> > xfs_quota: fix report command parsing
> > 
> > 
> > The report command line needs to be parsed as a whole not as
> > individual elements - report_f() is set up to do this correctly.
> > When treated as non-global command line, the report function is
> > called once for each command line arg, resulting in reports being
> > issued multiple times.
> > 
> > Set the command to be a global command so that it is only called
> > once.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This header looks like it came from an unrelated patch.

So remove it ;)

> Looks like this patch mostly corresponds to commit 93848a999cf.
> There is also:
> 
> * changes to printing i4_count, i8_count, and size fields for shortform directories
> * changes to start filling in v3 inode specific fields
> * make logprint stop asserting on v3 inodes
> * add support for creating v3 realtime bitmap, realtime summary, and root_dir inodes
> 
> There are a couple of issues below:
>   
> > diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> > index feb4a4e..57fbae2 100644
> > --- a/libxfs/xfs_ialloc.c
> > +++ b/libxfs/xfs_ialloc.c
> > @@ -146,6 +146,7 @@ xfs_ialloc_inode_init(
> >  	int			version;
> >  	int			i, j;
> >  	xfs_daddr_t		d;
> > +	xfs_ino_t		ino = 0;
> >  
> >  	/*
> >  	 * Loop over the new block(s), filling in the inodes.
> > @@ -169,8 +170,18 @@ xfs_ialloc_inode_init(
> >  	 * the new inode format, then use the new inode version.  Otherwise
> >  	 * use the old version so that old kernels will continue to be
> >  	 * able to use the file system.
> > +	 *
> > +	 * For v3 inodes, we also need to write the inode number into the inode,
> > +	 * so calculate the first inode number of the chunk here as
> > +	 * XFS_OFFBNO_TO_AGINO() only works on filesystem block boundaries, not
> > +	 * cluster boundaries and so cannot be used in the cluster buffer loop
> > +	 * below.
> >  	 */
> > -	if (xfs_sb_version_hasnlink(&mp->m_sb))
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		version = 3;
> > +		ino = XFS_AGINO_TO_INO(mp, agno,
> > +				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
> > +	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
> >  		version = 2;
> >  	else
> >  		version = 1;
> > @@ -196,13 +207,21 @@ xfs_ialloc_inode_init(
> >  		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
> 
> There is a section in commit 93848a999cf where the above line is
> modified to this:
> 
> xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
> 
> I suggest you pull that in here too.

It's correct in the current TOT, so I'm not going to change it here.

> You added a #define for uuid_copy in an earlier patch.  I suggest you use it if
> you can.  There are several occurances.

There's only two calls to platform_uuid_copy() left in the current
patchset, and they were introduced in the current patchset. SO I'm
not going to go back and fix it here, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
