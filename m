Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C96Ee6023631 for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 04:06:17 -0500
Date: Tue, 12 Jul 2011 05:06:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: reshuffle dir2 headers
Message-ID: <20110712090609.GA8364@infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205016.890382263@bombadil.infradead.org>
	<1310423560.7019.53.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310423560.7019.53.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 05:32:40PM -0500, Alex Elder wrote:
> - It looks like the three files are:
>     - external interface (just function prototypes)
>     - internal interface (just function prototypes)
>     - structures and accessors, other types, and constants
>   Did it just happen to turn out that that the two interface
>   files had nothing but prototypes?  Or was that what you
>   intended to do?

It's more or less intentional.  If actually had non-opaque data types
that weren't part of the disk format we might have them here, but the
dir2 code doesn't have any of those.

> - The contents of "xfs_dir2_format.h" comprise more than
>   just the on-disk format, it really seems to capture all
>   substantive data types and definitions related to directory
>   structures in XFS.  

The only type not part of the disk format is xfs_dir2_data_aoff_t,
which is a type that we probably should get rid of anyway.

> - None of the dir2 header files themselves #included
>   anything else.  The same is true for your (new) three
>   header files.  However, the internal interface file
>   (xfs_dir2_priv.h) seems to *always* require the data
>   types file (xfs_dir2_format.h) to be included first.
>   What are your thoughts about just putting the #include
>   of "xfs_dir2_format.h" into "xfs_dir2_priv.h".  I
>   realize that's really a philosophical question, broader
>   than this particular case.

We haven't done that for any of the XFS headers, so I don't
plan to change it with this patch.

> > +#define	XFS_DIR2_BLOCK_MAGIC	0x58443242	/* XD2B: for one block dirs */
>                                       /* XD2B: for single block dirs */
> 
> > +#define	XFS_DIR2_DATA_MAGIC	0x58443244	/* XD2D: for multiblock dirs */
> > +#define	XFS_DIR2_FREE_MAGIC	0x58443246	/* XD2F */
>                                       /* XD2F: for free index blocks */

These lines were taken as-is from the old headers, but your variants
are beter, I'll change it.

> > +typedef union {
> > +	xfs_dir2_ino8_t	i8;
> > +	xfs_dir2_ino4_t	i4;
> > +} xfs_dir2_inou_t;
> > +#define	XFS_DIR2_MAX_SHORT_INUM	((xfs_ino_t)0xffffffffULL)
> 
> I know this is historical, but I don't like the use of
> "SHORT" here to mean "4-byte," since "short" in the
> context of directories has a very different meaning
> (i.e., shortform).

We can fix this up later, but I don't want to change identifiers in
addition to the header consolidation.

> 
> > +
> > +/*
> > + * Directory layout when stored internal to an inode.
> > + *
> > + * Small directories are packed as tightly as possible so as to fit into the
> > + * literal area of the inode.  They consist of a single xfs_dir2_sf_hdr header
>         ...of the inode.  These "shortform" directories consist...

Ok.

> > + * followed by zero or more xfs_dir2_sf_entry structures.  Due the different
> > + * inode number storage size and the variable length name field in
> > + * the xfs_dir2_sf_entry all these structure are variable length, and the
> > + * accessors in this file should be used to iterate over them.
> > + *
> > + *
> > + * The parent directory has a dedicated field, and the self-pointer must
> > + * be calculated on the fly.
> 
> This sentence is not very meaningful standing by itself here.
> I think it either needs a bit more context, or maybe it can
> just be removed.

It doesn't seem overly useful, so I'll remove it.

> 
> > + *
> > + * Entries are packed toward the top as tightly as possible, and thus may
> > + * be misaligned.  Care needs to be taken to access them through special
> > + * helpers or copy them into aligned variables first.
> 
> Can this last sentence just be deleted, since above you
> now say that the accessors here should be used?

I'll remove it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
