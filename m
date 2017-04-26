Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21250 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933592AbdDZSZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 14:25:40 -0400
Date: Wed, 26 Apr 2017 11:25:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/4] xfs_db: use iocursor type to guess btree geometry
 if bad magic
Message-ID: <20170426182535.GW23371@birch.djwong.org>
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
 <149186447366.32572.11858750403661352513.stgit@birch.djwong.org>
 <20170411002012.GB5094@birch.djwong.org>
 <3442dd3a-9b3c-ea83-62eb-ab3972773d8b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3442dd3a-9b3c-ea83-62eb-ab3972773d8b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 12:48:48PM -0500, Eric Sandeen wrote:
> On 4/10/17 7:20 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The function block_to_bt plays an integral role in determining the btree
> > geometry of a block that we want to manipulate with the debugger.
> > Normally we use the block magic to find the geometry profile, but if the
> > magic is bad we'll never find it and return NULL.  The callers of this
> > function do not check for NULL and crash.
> > 
> > Therefore, if we can't find a geometry profile matching the magic
> > number, use the iocursor type to guess the profile and scowl about that
> > to stdout.  This makes it so that even with a corrupt magic we can try
> > to print the fields instead of crashing the debugger.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Makes sense generally, minor things below.
> 
> > ---
> > v2: be less macro-happy and only evaluate hascrc once
> > v3: braces around the for loop body
> > ---
> >  db/btblock.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 46 insertions(+), 8 deletions(-)
> > 
> > diff --git a/db/btblock.c b/db/btblock.c
> > index 835a5f0..b819fa5 100644
> > --- a/db/btblock.c
> > +++ b/db/btblock.c
> > @@ -25,6 +25,8 @@
> >  #include "print.h"
> >  #include "bit.h"
> >  #include "init.h"
> > +#include "io.h"
> > +#include "output.h"
> >  
> >  /*
> >   * Definition of the possible btree block layouts.
> > @@ -122,13 +124,52 @@ static struct xfs_db_btree *
> 
> urgh:
> 
> /*
>  * Find the right block defintion for a given ondisk block.
>  *
>  * We use the least significant bit of the magic number as index into
>  * the array of block defintions.
> 
> (nope, we don't, I can remove that on commit...)

Oops.  Should've nuked that comment from the start.

>  */
> static struct xfs_db_btree *
> 
> >  block_to_bt(
> >  	struct xfs_btree_block	*bb)
> >  {
> > -	struct xfs_db_btree *btp = &btrees[0];
> > +	struct xfs_db_btree	*btp;
> > +	uint32_t		magic;
> > +	bool			crc;
> >  
> > -	do {
> > -		if (be32_to_cpu((bb)->bb_magic) == btp->magic)
> > +	magic = be32_to_cpu((bb)->bb_magic);
> 
> maybe -
> 
> again:

Eww, backwards jumping gotos :)

I guess that works so long as you're sure we can't accidentally jump
backwards with an unrecognized magic and thus end up in an infinite
loop.

> > +	for (btp = &btrees[0]; btp->magic != 0; btp++) {
> > +		if (magic == btp->magic)
> > +			return btp;
> > +	}
> 
> 	/* Magic is invalid/unknown.  Guess based on iocur type */
> 
> > +	crc = xfs_sb_version_hascrc(&mp->m_sb);
> 
> Bah, wish we could use something like:
> 
> 	magic = xfs_magics[crc][btnum];
> 
> but that's static to libxfs/xfs_btree.c and I guess btnum != typnm.
> Because of course.
> 
> (btnum = xfs_typnm_to_btnum[iocur_top->typ->typnm]; ? :) Ok I'll
> drop it...)

:D

> > +	switch (iocur_top->typ->typnm) {
> > +	case TYP_BMAPBTA:
> > +	case TYP_BMAPBTD:
> > +		magic = crc ? XFS_BMAP_CRC_MAGIC : XFS_BMAP_MAGIC;
> > +		break;
> > +	case TYP_BNOBT:
> > +		magic = crc ? XFS_ABTB_CRC_MAGIC : XFS_ABTB_MAGIC;
> > +		break;
> > +	case TYP_CNTBT:
> > +		magic = crc ? XFS_ABTC_CRC_MAGIC : XFS_ABTC_MAGIC;
> > +		break;
> > +	case TYP_INOBT:
> > +		magic = crc ? XFS_IBT_CRC_MAGIC : XFS_IBT_MAGIC;
> > +		break;
> > +	case TYP_FINOBT:
> > +		magic = crc ? XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
> > +		break;
> > +	case TYP_RMAPBT:
> > +		magic = crc ? XFS_RMAP_CRC_MAGIC : 0;
> > +		break;
> > +	case TYP_REFCBT:
> > +		magic = crc ? XFS_REFC_CRC_MAGIC : 0;
> > +		break;
> > +	default:
> > +		ASSERT(0);
> > +	}
> 
> 	ASSERT(magic);
> 
> we'd better have that by now, yes?

Yes.

> Or could we hit the RMAP/REFC types w/o crc set?

In theory, no, because xfs_db sets up a different type profile for the
!crc case, and that type profile excludes TYP_RMAPBT/TYP_REFCBT.

>  I guess then the caller ASSERTs anyway?

<shrug>

> > +
> > +	dbprintf(_("Bad btree magic 0x%x; coercing to %s.\n"),
> > +		be32_to_cpu((bb)->bb_magic),
> > +		iocur_top->typ->name);
> 
> 
> 	goto again;
> 
> to avoid the cut & paste of the loop below?  But maybe that's uglier.

Mostly a matter of taste, I think.  If the machinery was more complex
I'd argue for a backwards goto to avoid having to maintain two identical
loops, but this is pretty simple.

> > +
> > +	for (btp = &btrees[0]; btp->magic != 0; btp++) {
> > +		if (magic == btp->magic)
> >  			return btp;
> > -		btp++;
> > -	} while (btp->magic != 0);
> > +	}
> >  
> >  	return NULL;
> >  }
> > @@ -193,7 +234,6 @@ btblock_key_offset(
> >  	int			offset;
> >  
> >  	ASSERT(startoff == 0);
> > -	ASSERT(block->bb_level != 0);
> 
> Help me out, why are these now removed?

/me doesn't remember, maybe they should just go away.

> -Eric
> 
> >  
> >  	offset = bt->block_len + (idx - 1) * bt->key_len;
> >  	return bitize(offset);
> > @@ -214,7 +254,6 @@ btblock_ptr_offset(
> >  	int			maxrecs;
> >  
> >  	ASSERT(startoff == 0);
> > -	ASSERT(block->bb_level != 0);
> >  
> >  	maxrecs = btblock_maxrecs(bt, mp->m_sb.sb_blocksize);
> >  	offset = bt->block_len +
> > @@ -238,7 +277,6 @@ btblock_rec_offset(
> >  	int			offset;
> >  
> >  	ASSERT(startoff == 0);
> > -	ASSERT(block->bb_level == 0);
> >  
> >  	offset = bt->block_len + (idx - 1) * bt->rec_len;
> >  	return bitize(offset);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
