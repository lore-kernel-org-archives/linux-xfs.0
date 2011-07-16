Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1rpbm229811 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:53:52 -0500
Date: Fri, 15 Jul 2011 21:53:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] [PATCH] xfs: failure mapping nfs fh to inode
	should return ESTALE
Message-ID: <20110716015346.GA589@infradead.org>
References: <20110714205036.GA19457@fieldses.org>
	<20110714223126.GA28694@infradead.org>
	<20110716015014.GF21663@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110716015014.GF21663@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com

On Sat, Jul 16, 2011 at 11:50:14AM +1000, Dave Chinner wrote:
> Bulkstat also checks for ENOENT returns from xfs_iget() as the
> lookup it does is inherently racy. That is, if the inode is
> allocated when it is read from the IBT, but then has been unlinked
> before the actual xfs_iget() call, it expects to get back an ENOENT
> to tell it the inode has been unlinked and shouldn't be included in
> the bulkstat output. Otherwise, it returns the error to userspace.
> 
> So converting the mode checks to return ESTALE definitely has the
> chance of breaking stuff that uses bulkstat (e.g. xfsdump) because
> it will return errors now where it previously just skipped the
> (unlinked) inode.

Sounds like we should simply go with the original version of the patch
then.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
