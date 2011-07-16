Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1oJK0229523 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:50:20 -0500
Date: Sat, 16 Jul 2011 11:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] [PATCH] xfs: failure mapping nfs fh to inode
	should return ESTALE
Message-ID: <20110716015014.GF21663@dastard>
References: <20110714205036.GA19457@fieldses.org>
	<20110714223126.GA28694@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714223126.GA28694@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, xfs-masters@oss.sgi.com, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 14, 2011 at 06:31:26PM -0400, Christoph Hellwig wrote:
> On Thu, Jul 14, 2011 at 04:50:36PM -0400, J. Bruce Fields wrote:
> > From: J. Bruce Fields <bfields@redhat.com>
> > 
> > On xfs exports, nfsd is incorrectly returning ENOENT instead of ESTALE
> > on attempts to use a filehandle of a deleted file (spotted with pynfs
> > test PUTFH3).  The ENOENT was coming from xfs_iget.
> 
> With that you mean the ip->i_d.di_mode checks?  Given that we should
> only be bale to get these from NFS or the handle ioctls I suspect just
> turning them into ESTALE should be fine.

Bulkstat also checks for ENOENT returns from xfs_iget() as the
lookup it does is inherently racy. That is, if the inode is
allocated when it is read from the IBT, but then has been unlinked
before the actual xfs_iget() call, it expects to get back an ENOENT
to tell it the inode has been unlinked and shouldn't be included in
the bulkstat output. Otherwise, it returns the error to userspace.

So converting the mode checks to return ESTALE definitely has the
chance of breaking stuff that uses bulkstat (e.g. xfsdump) because
it will return errors now where it previously just skipped the
(unlinked) inode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
