Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15Ah8Hh129712 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 04:43:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8D1E137ED00
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 02:44:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	yKYYcC3a8WHJ4cZJ for <xfs@oss.sgi.com>;
	Fri, 05 Feb 2010 02:44:17 -0800 (PST)
Date: Fri, 5 Feb 2010 21:44:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: make install in the brave new build system world
Message-ID: <20100205104414.GC11483@discord.disaster>
References: <20100205092229.GA32454@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100205092229.GA32454@infradead.org>
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

On Fri, Feb 05, 2010 at 04:22:29AM -0500, Christoph Hellwig wrote:
> When doing make install in xfsprogs I get a lot of spew like this:
> 
> /usr/bin/make -C include install
> make[1]: Entering directory `/root/xfsprogs-dev/include'
> make[1]: Nothing to be done for `install'.
> make[1]: Leaving directory `/root/xfsprogs-dev/include'
> /usr/bin/make -C libxfs install
> make[1]: Entering directory `/root/xfsprogs-dev/libxfs'
>     [DEP]
> gcc -MM -I. -g -O2 -DNDEBUG -DVERSION=\"3.1.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall cache.c init.c kmem.c logitem.c rdwr.c trans.c util.c xfs_alloc.c xfs_ialloc.c xfs_inode.c xfs_btree.c xfs_alloc_btree.c xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c linux.c | /bin/sed -e 's,^\([^:]*\)\.o,\1.lo,' > .dep
> make[1]: Leaving directory `/root/xfsprogs-dev/libxfs'
> 
> 
> So it seems like for some reason we do
> 
>  a) regenerate the dependencies in the install target (we already re-did
>     them once before as part of the all target implied by make install)

The dependencies are always regenerated due to the default target
requiring the depend target. Rebuilding the dependencies is the only
way to catch changes between builds and so ensure the correct files
are rebuilt.

The install target is building the dependencies because it has a
dependency on the default target.

>  b) for some reason the new silent make rules don't apply to this.

That's something I can't answer off the top of my head. I'll have a
look into it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
