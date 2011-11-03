Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3AQDJf260478 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 05:26:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A69311CDDE42
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 03:26:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XIBmLVhk9E9nReUY for <xfs@oss.sgi.com>;
	Thu, 03 Nov 2011 03:26:10 -0700 (PDT)
Date: Thu, 3 Nov 2011 06:26:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair fails with corrupt dinode 17491441757, extent total =
	1, nblocks = 0.  This is a bug.
Message-ID: <20111103102609.GA12066@infradead.org>
References: <201110311156.20421.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110311156.20421.arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Mon, Oct 31, 2011 at 11:56:20AM +0100, Arkadiusz Mi??kiewicz wrote:
> 
> xfs_repair version 3.1.6
> 
> disconnected inode 17491441754, moving to lost+found
> disconnected inode 17491441755, moving to lost+found
> disconnected inode 17491441756, moving to lost+found
> disconnected inode 17491441757, moving to lost+found
> corrupt dinode 17491441757, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x21450c90)
> 
> fatal error -- 117 - couldn't iget disconnected inode
> 
> 30GB metadump image, 6.1GB compressed of ~7TB real partition
> http://ixion.pld-linux.org/~arekm/lv_storage1.metadump.xz
> 
> You need ~8-12GB of memory for xfs_repair on this.
> 
> I can also provide ssh access to the system with this image and all needed 
> stuff, so you don't need to download it or waste own resources.

I think I understand the problem - we found a disconnected inode,
which we try to move to lost + found.  For some reason the inode
is found to be incorrect by xfs_iformat, so iget bailds out.

The fix will be to do a pass over the the inodes we want to move
to correct such inconsistencies and/or junk them.  I'll try to prepare
a fix as soon as I get some time, but I'm fairly busy at the moment.

Btw, what did you to to the fs?  Having the total blocks out of sync
with the numbers in the data and attribute forks seems like an extremly
unusal error case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
