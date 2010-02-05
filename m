Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o159LKCj125074 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 03:21:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E2B51CA0265
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 01:22:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HhIA1QpyNAqQXt2u for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 01:22:31 -0800 (PST)
Date: Fri, 5 Feb 2010 04:22:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: make install in the brave new build system world
Message-ID: <20100205092229.GA32454@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: xfs@oss.sgi.com

When doing make install in xfsprogs I get a lot of spew like this:

/usr/bin/make -C include install
make[1]: Entering directory `/root/xfsprogs-dev/include'
make[1]: Nothing to be done for `install'.
make[1]: Leaving directory `/root/xfsprogs-dev/include'
/usr/bin/make -C libxfs install
make[1]: Entering directory `/root/xfsprogs-dev/libxfs'
    [DEP]
gcc -MM -I. -g -O2 -DNDEBUG -DVERSION=\"3.1.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall cache.c init.c kmem.c logitem.c rdwr.c trans.c util.c xfs_alloc.c xfs_ialloc.c xfs_inode.c xfs_btree.c xfs_alloc_btree.c xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c linux.c | /bin/sed -e 's,^\([^:]*\)\.o,\1.lo,' > .dep
make[1]: Leaving directory `/root/xfsprogs-dev/libxfs'


So it seems like for some reason we do

 a) regenerate the dependencies in the install target (we already re-did
    them once before as part of the all target implied by make install)
 b) for some reason the new silent make rules don't apply to this.

Any idea why?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
