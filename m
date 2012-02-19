Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JMfKjE031711 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 16:41:21 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6h9LuB2NYiP1bFxI (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 14:41:19 -0800 (PST)
Date: Sun, 19 Feb 2012 17:41:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: fix deadlock in xfs_rtfree_extent with kernel
	v2.6.37
Message-ID: <20120219224118.GA31535@infradead.org>
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
	<33346035.post@talk.nabble.com> <33346043.post@talk.nabble.com>
	<33346051.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33346051.post@talk.nabble.com>
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
To: kdasu <kdasu.kdev@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 17, 2012 at 03:00:09PM -0800, kdasu wrote:
> 
> 
> On the 2.6.37 kernel, xfs_fs_evict_inode() leads to a deadlock when
> freeing multiple realtime extents. On further debugging the root
> cause it was determined to be recursive locking of the RT bitmap
> inode during evict operation within the same task context.
> The same vfs evict sequence is replayed by the xfs log recovery on
> mounts on a reboot after the problem happens first time.
> This problem exists on kernel v2.6.39 as well.

I think you're better off fixing this problem like I did for the
allocation side, that is:

 - remove the xfs_ilock and xfs_trans_ijoin (or probably still
   xfs_trans_iget in your version) from xfs_rtfree_extent, and
   instead add asserts that the inode is locked and has an inode_item
   attach to it.
 - in xfs_bunmapi if we are dealing with an inode with the rt flag
   bump the reference count on the inode there and attach it to the
   transaction before calling into xfs_bmap_del_extent, similar to
   what we do in xfs_bmap_rtalloc.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
