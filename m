Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FBFF7CB0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 07:47:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB6BF30405F
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 05:46:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id svIu2Ip6IsP8VDXF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 05:46:57 -0700 (PDT)
Date: Fri, 15 Apr 2016 08:46:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/11] xfs: mark reclaimed inodes invalid earlier
Message-ID: <20160415124655.GB36382@bfoster.bfoster>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-8-git-send-email-david@fromorbit.com>
	<20160413064900.GP567@dastard>
	<20160414121048.GB20696@bfoster.bfoster>
	<20160414233101.GY567@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160414233101.GY567@dastard>
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

On Fri, Apr 15, 2016 at 09:31:01AM +1000, Dave Chinner wrote:
> On Thu, Apr 14, 2016 at 08:10:49AM -0400, Brian Foster wrote:
> > On Wed, Apr 13, 2016 at 04:49:00PM +1000, Dave Chinner wrote:
> > > On Wed, Apr 13, 2016 at 03:31:28PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > The last thing we do before using call_rcu() on an xfs_inode to be
> > > > freed is mark it as invalid. This means there is a window between
> > > > when we know for certain that the inode is going to be freed and
> > > > when we do actually mark it as "freed".
> > > > 
> > > > This is important in the context of RCU lookups - we can look up the
> > > > inode, find that it is valid, and then use it as such not realising
> > > > that it is in the final stages of being freed.
> > > > 
> > > > As such, mark the inode as being invalid the moment we know it is
> > > > going to be reclaimed. This can be done while we still hold the
> > > > XFS_ILOCK_EXCL and the flush lock in xfs_inode_reclaim, meaning that
> > > > it occurs well before we remove it from the radix tree, and that
> > > > the i_flags_lock, the XFS_ILOCK and the inode flush lock all act as
> > > > synchronisation points for detecting that an inode is about to go
> > > > away.
> > > > 
> > > > For defensive purposes, this allows us to add a further check to
> > > > xfs_iflush_cluster to ensure we skip inodes that are being freed
> > > > after we grab the XFS_ILOCK_SHARED and the flush lock - we know that
> > > > if the inode number if valid while we have these locks held we know
> > > > that it has not progressed through reclaim to the point where it is
> > > > clean and is about to be freed.
> > > > 
> > > > [bfoster: fixed __xfs_inode_clear_reclaim() using ip->i_ino after it
> > > > 	  had already been zeroed.]
> > > 
> > > And, of course, in reordering this I dropped this fix because it was
> > > handled by the reworking of tagging code to use pag->pag_agno.
> > > 
> > > So I've brought that small change forward to this patch (using
> > > pag->pag_agno instead of deriving it from the ip->i_ino in
> > > __xfs_inode_clear_reclaim()).
> > > 
> > 
> > I don't see any such change in this patch..?
> > __xfs_inode_clear_reclaim() still uses ip->i_ino.
> 
> I meant that I realised that I'd screwed it up and so I'd changed my
> local copy after I sent this.
> 

Oh, Ok. Anyways, the long running reproducer I had running (against v2 +
the reclaim tag hunk that I had posted) completed without an error.
That's the first time I've seen that, so I think it's safe to confirm
this series fixes the original problem:

Tested-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
