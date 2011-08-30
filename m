Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U6dq3c118035 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 01:39:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BD4E13AD537
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 23:43:09 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	TYeklDOlYcjcNZyo for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 23:43:09 -0700 (PDT)
Date: Tue, 30 Aug 2011 02:39:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: fix xfs_mark_inode_dirty during umount
Message-ID: <20110830063949.GA19262@infradead.org>
References: <20110827055731.GA24159@infradead.org>
	<20110827055744.GA28351@infradead.org>
	<20110830062416.GN3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830062416.GN3162@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 30, 2011 at 04:24:16PM +1000, Dave Chinner wrote:
> >  xfs_mark_inode_dirty_sync(
> > @@ -82,6 +81,10 @@ xfs_mark_inode_dirty_sync(
> >  
> >  	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
> >  		mark_inode_dirty_sync(inode);
> > +	else {
> > +		barrier();
> > +		ip->i_update_core = 1;
> > +	}
> >  }
> 
> Why the barrier()? Isn't that just a compiler barrier? If you are
> worried about catching the update vs clearing it in transaction
> commit, shouldn't that use smp_mb() instead (in both places)?

It's a blind copy & past from xfs_fs_dirty_inode.  The comments
there suggests it is for update ordering.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
