Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5EDbS26042728 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 08:37:28 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 500D112AD3BE
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 06:43:30 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id F5ph8Kf6jgwwIyWg for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 06:43:30 -0700 (PDT)
Date: Mon, 14 Jun 2010 15:39:58 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
Message-ID: <20100614133958.GH17092@basil.fritz.box>
References: <20100614081356.GA27499@basil.fritz.box>
	<20100614083021.GA29354@lst.de> <4C15EF75.5080909@linux.intel.com>
	<20100614124804.GA8547@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100614124804.GA8547@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>, dgc@fromorbit.com, xfs@oss.sgi.com

On Mon, Jun 14, 2010 at 02:48:04PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 14, 2010 at 10:59:33AM +0200, Andi Kleen wrote:
> > >How can this work?  bp->data is a void pointer.
> > 
> > It compiled with CONFIG_XFS_DEBUG enabled. Do I need to set some other
> > option to test this?
> 
> It fails for me in a normal CONFIG_XFS_DEBUG build:
> 
> fs/xfs/xfs_da_btree.c: In function 'xfs_da_root_join':
> fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer
> fs/xfs/xfs_da_btree.c:737: error: request for member 'magic' in
> something not a structure or union
> fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer


Hmm, it really compiled here (scratching head)

% grep XFS .config
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
% make CC=gcc46 SUBDIRS=fs/xfs
  LD      fs/xfs/built-in.o
  CC [M]  fs/xfs/linux-2.6/xfs_trace.o
  CC [M]  fs/xfs/linux-2.6/xfs_acl.o
  CC [M]  fs/xfs/linux-2.6/xfs_stats.o
  CC [M]  fs/xfs/linux-2.6/xfs_sysctl.o
  CC [M]  fs/xfs/linux-2.6/xfs_ioctl32.o
  CC [M]  fs/xfs/xfs_alloc.o
  CC [M]  fs/xfs/xfs_alloc_btree.o
  CC [M]  fs/xfs/xfs_attr.o
  CC [M]  fs/xfs/xfs_attr_leaf.o
  CC [M]  fs/xfs/xfs_bit.o
  CC [M]  fs/xfs/xfs_bmap.o
  CC [M]  fs/xfs/xfs_bmap_btree.o
  CC [M]  fs/xfs/xfs_btree.o
  CC [M]  fs/xfs/xfs_buf_item.o
  CC [M]  fs/xfs/xfs_da_btree.o   <---------------------------------
  CC [M]  fs/xfs/xfs_dir2.o
  CC [M]  fs/xfs/xfs_dir2_block.o
fs/xfs/xfs_dir2_block.c: In function 'xfs_dir2_sf_to_block':
fs/xfs/xfs_dir2_block.c:1153:26: warning: array subscript is above array bounds [-Warray-
bounds]
...


Do I need to set some other option?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
