Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHEKUCP023871 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 08:20:32 -0600
Date: Wed, 17 Dec 2008 09:20:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Use the incore inode size in xfs_file_readdir()
Message-ID: <20081217142028.GA22023@infradead.org>
References: <49377FBC.5020501@sgi.com> <20081204070827.GB29531@infradead.org>
	<49389E8F.5000301@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49389E8F.5000301@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 05, 2008 at 02:22:55PM +1100, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
> > On Thu, Dec 04, 2008 at 05:59:08PM +1100, Lachlan McIlroy wrote:
> >> We should be using the incore inode size here not the linux inode
> >> size.  The incore inode size is always up to date for directories
> >> whereas the linux inode size is not updated for directories.
> >>
> >> We've hit assertions in xfs_bmap() and traced it back to the linux
> >> inode size being zero here but the incore size being correct.
> > 
> > Heh. Looks good, but you can still call ->readdir with a 0 inode size,
> > so you might want to check for that (actualyl I think other pathes
> > are goign to take care of it, but..)
> 
> What if we remove bufsize and pass PAGE_SIZE into xfs_readdir()?
> No need to worry about a 0 inode size.

It is used for sizing a memory allocation in xfs_dir2_leaf_getdents, and
avoiding over-allocations for small directories seems like a good idea.

So please go ahead with your original patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
