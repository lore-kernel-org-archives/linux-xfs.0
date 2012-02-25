Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1P9eXKW135811 for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 03:40:36 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	j7R1NKVBXLmeAwdU (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Feb 2012 01:40:31 -0800 (PST)
Date: Sat, 25 Feb 2012 04:40:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] V2 xfs: fix deadlock in xfs_rtfree_extent with
	kernel v2.6.37
Message-ID: <20120225094030.GA3148@infradead.org>
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
	<33346035.post@talk.nabble.com> <33346043.post@talk.nabble.com>
	<33346051.post@talk.nabble.com>
	<20120219224118.GA31535@infradead.org>
	<33365485.post@talk.nabble.com> <33379323.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33379323.post@talk.nabble.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 23, 2012 at 08:52:57AM -0800, Kamal Dasu wrote:
> 
> To fix the deadlock caused by recursively calling xfs_rtfree_extent
> from xfs_bunmapi():
> 
>  - removed  xfs_trans_iget() from xfs_rtfree_extent(),
>    instead added asserts that the inode is locked and has an inode_item
>    attached to it.
>  - in xfs_bunmapi() when dealing with an inode with the rt flag
>    call xfs_ilock() and xfs_trans_ijoin() so that the
>    reference count is bumped on the inode and attached it to the
>    transaction before calling into xfs_bmap_del_extent, similar to
>    what we do in xfs_bmap_rtalloc.
> 
> Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>

This looks good, thanks a lot!

Do you have an easily reproducable testcase for this which we could
put into xfstests?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
