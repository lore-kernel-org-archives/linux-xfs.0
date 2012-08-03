Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q732bIK7014830 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 21:37:19 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Gw0wAxevx5GCrOs8 for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 19:37:16 -0700 (PDT)
Date: Fri, 3 Aug 2012 12:37:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_db: bug in bmap command?
Message-ID: <20120803023711.GR2877@dastard>
References: <CAH4wwdGbecJ42ONkk3WQRhqUuLUALaSHP-+Ran0Lu8aofW5M8A@mail.gmail.com>
	<20120802233025.GP2877@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120802233025.GP2877@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 03, 2012 at 09:30:25AM +1000, Dave Chinner wrote:
> > diff --git a/db/bmap.c b/db/bmap.c
> > index ddad49c..0ef7a62 100644
> > --- a/db/bmap.c
> > +++ b/db/bmap.c
> > @@ -101,9 +101,9 @@ bmap(
> >  			block = (struct xfs_btree_block *)iocur_top->data;
> >  			if (be16_to_cpu(block->bb_level) == 0)
> >  				break;
> > -			pp = XFS_BMDR_PTR_ADDR(block, 1,
> > +			pp = XFS_BMBT_PTR_ADDR(mp, block, 1,
> >  				xfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
> > -			kp = XFS_BMDR_KEY_ADDR(block, 1);
> > +			kp = XFS_BMBT_KEY_ADDR(mp, block, 1);
> 
> That, I'm pretty sure, is wrong, too, because the root block is a
> different format to the tree blocks. IOWs,the old code parses
> tree node blocks with the root block format macro, while your code
> parses the root node with tree block format macros. Both are wrong.
> The original was also wrong in that it used xfs_bmbt_maxrecs()
> instead of xfs_bmdr_maxrecs() for the number of records in the inode
> root block.

Ignore this, I misread the code in bmap(). the root block is already
dealt with before entering the first loop, so it will never come
across the root block and so have to handle it. My mistake, the
patch as is should work just fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
