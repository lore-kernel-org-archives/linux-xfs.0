Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JLGNkR027379 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 15:16:24 -0600
Date: Sun, 19 Feb 2012 16:16:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 12/12] xfs: split and cleanup xfs_log_reserve
Message-ID: <20120219211621.GA22831@infradead.org>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141435.692631989@bombadil.infradead.org>
	<20120216213646.GA7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120216213646.GA7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 03:36:46PM -0600, Ben Myers wrote:
> This has me wondering if it is possible to get rid of
> XFS_LOG_REL_PERM_RESERV too...

Yes, that's possible.  I started it and then more cleanups in that area
became obvious.  I stopped at the log space waiting bits for now, and
will return to this area once I'll get a bit more time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
