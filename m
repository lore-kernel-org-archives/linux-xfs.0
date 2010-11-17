Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9MZY1217754 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:22:35 -0600
Date: Wed, 17 Nov 2010 04:24:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/9] xfsrestore: cache path lookups
Message-ID: <20101117092408.GF17317@infradead.org>
References: <20101116150502.179825893@sgi.com>
	<20101116150704.237582191@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101116150704.237582191@sgi.com>
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, Nov 16, 2010 at 09:05:05AM -0600, wkendall@sgi.com wrote:
> In order to resolve a pathname, xfsrestore must work from an inode
> number (from the dump) and recurse up the directory entry tree that it
> has constructed. Each level of recursion requires a seek and read to
> get the name of the dirent, and possibly a mmap of a section of the
> directory entry tree if it is not already mapped (and in that case,
> possibly a munmap of another section). It's quite common to resolve
> pathnames in the same directory consecutively, so simply caching the
> parent directory pathname from the previous lookup saves quite a bit
> of overhead.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
