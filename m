Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BMWjs5256170 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:32:45 -0500
Subject: Re: [PATCH 01/11] xfs: reshuffle dir2 headers
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110710205016.890382263@bombadil.infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205016.890382263@bombadil.infradead.org>
Date: Mon, 11 Jul 2011 17:32:40 -0500
Message-ID: <1310423560.7019.53.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> Replace the current mess of dir2 headers with just three that have a clear
> purpose:
> 
>  - xfs_dir2_format.h for all format defintions, including the inline helpers
                                      definitions
>    to access our variable size structures
>  - xfs_dir2_priv.h for all prototypes that are internal to the dir2 code
>    and no needed by anything outside of the directory code.  For this
        not
>    purpose xfs_da_btree.c, and phase6.c in xfs_repair are considered part
>    of the directory code.
>  - xfs_dir2.h for the public interface to the directory code
> 
> In addition to the reshuffle I have also update the comments to not only
> match the new file structure, but also to describe the directory format
> better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

OK, I looked over this probably more closely than necessary.
In any case, it all looks good, but I'll mention just a few
things, but really they're mostly curiosity and observations
rather than anything all that pressing.
- It looks like the three files are:
    - external interface (just function prototypes)
    - internal interface (just function prototypes)
    - structures and accessors, other types, and constants
  Did it just happen to turn out that that the two interface
  files had nothing but prototypes?  Or was that what you
  intended to do?
- The contents of "xfs_dir2_format.h" comprise more than
  just the on-disk format, it really seems to capture all
  substantive data types and definitions related to directory
  structures in XFS.  
- None of the dir2 header files themselves #included
  anything else.  The same is true for your (new) three
  header files.  However, the internal interface file
  (xfs_dir2_priv.h) seems to *always* require the data
  types file (xfs_dir2_format.h) to be included first.
  What are your thoughts about just putting the #include
  of "xfs_dir2_format.h" into "xfs_dir2_priv.h".  I
  realize that's really a philosophical question, broader
  than this particular case.

A few other details, below.  I'll look for whatever your
response is, but I found no real problems and I trust
you'll do what you think is best with my suggestions here.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> Index: xfs/fs/xfs/xfs_dir2_format.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs/fs/xfs/xfs_dir2_format.h	2011-07-09 13:29:33.488251514 +0200
> @@ -0,0 +1,602 @@
> +/*
> + * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.

. . .

> + * Directory version 2.
> + *
> + * There are 4 possible formats:
> + *  - shortform - embedded into the inode
> + *  - single block - data with embedded leaf at the end
> + *  - multiple data blocks, single leaf+freeindex block
> + *  - data blocks, node and leaf blocks (btree), freeindex blocks
> + *
> + * Note: many node blocks structures and constants are shared with the attributes
> + * code and defined in xfs_da_btree.h.
> + */
> +
> +#define	XFS_DIR2_BLOCK_MAGIC	0x58443242	/* XD2B: for one block dirs */
                                      /* XD2B: for single block dirs */

> +#define	XFS_DIR2_DATA_MAGIC	0x58443244	/* XD2D: for multiblock dirs */
> +#define	XFS_DIR2_FREE_MAGIC	0x58443246	/* XD2F */
                                      /* XD2F: for free index blocks */

> +
> +/*
> + * Byte offset in data block and shortform entry.
> + */
> +typedef	__uint16_t	xfs_dir2_data_off_t;

. . .

> +
> +typedef union {
> +	xfs_dir2_ino8_t	i8;
> +	xfs_dir2_ino4_t	i4;
> +} xfs_dir2_inou_t;
> +#define	XFS_DIR2_MAX_SHORT_INUM	((xfs_ino_t)0xffffffffULL)

I know this is historical, but I don't like the use of
"SHORT" here to mean "4-byte," since "short" in the
context of directories has a very different meaning
(i.e., shortform).

> +
> +/*
> + * Directory layout when stored internal to an inode.
> + *
> + * Small directories are packed as tightly as possible so as to fit into the
> + * literal area of the inode.  They consist of a single xfs_dir2_sf_hdr header
        ...of the inode.  These "shortform" directories consist...

> + * followed by zero or more xfs_dir2_sf_entry structures.  Due the different
> + * inode number storage size and the variable length name field in
> + * the xfs_dir2_sf_entry all these structure are variable length, and the
> + * accessors in this file should be used to iterate over them.
> + *
> + *
> + * The parent directory has a dedicated field, and the self-pointer must
> + * be calculated on the fly.

This sentence is not very meaningful standing by itself here.
I think it either needs a bit more context, or maybe it can
just be removed.

> + *
> + * Entries are packed toward the top as tightly as possible, and thus may
> + * be misaligned.  Care needs to be taken to access them through special
> + * helpers or copy them into aligned variables first.

Can this last sentence just be deleted, since above you
now say that the accessors here should be used?

> + */
> +typedef struct xfs_dir2_sf_hdr {
> +	__uint8_t		count;		/* count of entries */
> +	__uint8_t		i8count;	/* count of 8-byte inode #s */
> +	xfs_dir2_inou_t		parent;		/* parent dir inode number */
> +} __arch_pack xfs_dir2_sf_hdr_t;

. . .

> + *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
> + *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
> + *    | ...                                             |
> + *    +-------------------------------------------------+
> + *    | unused space                                    |
> + *    +-------------------------------------------------+
> + *
> + * As all the entries are variable size structures the accessors below should
> + * be used to iterate over them.
> + *
> + * In addition to the pure data blocks for the data and node formats it,
                                                    and node formats,

> + * most structures are also used for the combined data/freespace "block"

. . .

> + *    +---------------------------+
> + *    | xfs_dir2_leaf_tail_t      |
> + *    +---------------------------+
> + *
> + * The xfs_dir2_data_off_t members (bests) and tail are at the end of the block
> + * for single-leaf (magic = XFS_DIR2_LEAF1_MAGIC) blocks only, but not present
> + * for directories with separate leaf nodes and free space blocks
> + * (magic = XFS_DIR2_LEAFN_MAGIC).

This was nicely reworded.  Not a lot different, but better.

. . .
> + * Leaf block.
> + */
> +typedef struct xfs_dir2_leaf {
> +	xfs_dir2_leaf_hdr_t	hdr;		/* leaf header */
> +	xfs_dir2_leaf_entry_t	ents[];	/* entries */
                                        ^^^ insert a tab here

> +} xfs_dir2_leaf_t;
> +

. . .

That's it.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
