Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB478SRB031801 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 01:08:28 -0600
Date: Thu, 4 Dec 2008 02:08:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Use the incore inode size in xfs_file_readdir()
Message-ID: <20081204070827.GB29531@infradead.org>
References: <49377FBC.5020501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49377FBC.5020501@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 04, 2008 at 05:59:08PM +1100, Lachlan McIlroy wrote:
> We should be using the incore inode size here not the linux inode
> size.  The incore inode size is always up to date for directories
> whereas the linux inode size is not updated for directories.
> 
> We've hit assertions in xfs_bmap() and traced it back to the linux
> inode size being zero here but the incore size being correct.

Heh. Looks good, but you can still call ->readdir with a 0 inode size,
so you might want to check for that (actualyl I think other pathes
are goign to take care of it, but..)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
