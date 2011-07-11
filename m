Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6B01fRn161352 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 19:01:42 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 486D417B09DD
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 17:01:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RrpG6chC9zOMo9oI for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 17:01:39 -0700 (PDT)
Date: Mon, 11 Jul 2011 10:01:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Updated xfsprogs 2.6.38 merge
Message-ID: <20110711000135.GA23038@dastard>
References: <20110705024855.GA561@dastard>
	<20110710210113.GA14527@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110710210113.GA14527@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sun, Jul 10, 2011 at 05:01:13PM -0400, Christoph Hellwig wrote:
> On Tue, Jul 05, 2011 at 12:48:55PM +1000, Dave Chinner wrote:
> > Folks,
> > 
> > I pushed out an updated 2.6.38 kernel merge to xfsprogs patchset a
> > couple of days ago. I've been doing quite a bit of testing on it,
> > both 32 bit and 64 bit, with 512 byte, 1k and 4k block size
> > filesystems and I haven't come across any regressions. The patchset
> > can be found here:
> > 
> >   git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev kernel-2.6.38-sync
> > 
> > It's pretty much unchanged from the last set of patches I sent,
> > except for one minor fix to the radix tree code for an off by one in
> > the path array size for item and tag deletes.
> > 
> > I'm pretty much ready to commit this update so I can then move
> > forward with updating it to the 3.0 kernel code base as a smaller
> > incremental series.
> 
> It's still missing the fix for the xfs_imap.h removal I pointed out last
> round:
> 
> Index: xfsprogs-dev/include/Makefile
> ===================================================================
> --- xfsprogs-dev.orig/include/Makefile	2011-07-10 20:51:24.000000000 +0000
> +++ xfsprogs-dev/include/Makefile	2011-07-10 20:51:31.000000000 +0000
> @@ -27,7 +27,7 @@ QAHFILES = libxfs.h libxlog.h \
>  	xfs_dir2.h xfs_dir2_block.h xfs_dir2_data.h xfs_dir2_leaf.h \
>  	xfs_dir2_node.h xfs_dir2_sf.h xfs_dir_leaf.h xfs_dir_sf.h \
>  	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
> -	xfs_imap.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
> +	xfs_inode.h xfs_inode_item.h xfs_inum.h \
>  	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
>  	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h xfs_trace.h \
>  	xfs_trans.h xfs_trans_space.h xfs_types.h xfs_dfrag.h

Strangely enough I don't see that failure. Fixed, anyway.

> But even after that a simple mkfs crashed for me on 32-bit x86.  Here is
> the gdb backtrace:
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0805736b in tag_get (root=0xffffda5c, index=0) at radix-tree.c:82
> 82		return 1 & (((const __uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
> (gdb) bt
> #0  0x0805736b in tag_get (root=0xffffda5c, index=0) at radix-tree.c:82
> #1  radix_tree_delete (root=0xffffda5c, index=0) at radix-tree.c:726
> #2  0x08054ee7 in libxfs_umount (mp=0xffffd8f8) at init.c:822
> #3  0x0805277c in main (argc=3, argv=0xffffdd94) at xfs_mkfs.c:2683

What size block device? It's not failing here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
