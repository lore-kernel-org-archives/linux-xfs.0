Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:42873 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751061AbdGKAQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2017 20:16:37 -0400
Date: Tue, 11 Jul 2017 10:08:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] sb_fdblocks counting error caused by too large indlen
 returned from xfs_bmap_worst_indlen()
Message-ID: <20170711000859.GG17762@dastard>
References: <20170707120040.GG29475@eguan.usersys.redhat.com>
 <20170708064937.GH4103@magnolia>
 <20170709140818.GI29475@eguan.usersys.redhat.com>
 <20170710161824.GI4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170710161824.GI4103@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jul 10, 2017 at 09:18:24AM -0700, Darrick J. Wong wrote:
> On Sun, Jul 09, 2017 at 10:08:18PM +0800, Eryu Guan wrote:
> > On Fri, Jul 07, 2017 at 11:49:37PM -0700, Darrick J. Wong wrote:
> > > On Fri, Jul 07, 2017 at 08:01:43PM +0800, Eryu Guan wrote:
> > > > Hi all,
> > > > 
> > > > I recently hit a repeatable sb_fdblocks corruption as below:
> > > > 
> > > > Phase 1 - find and verify superblock...
> > > > Phase 2 - using internal log
> > > >         - zero log...
> > > >         - scan filesystem freespace and inode maps...
> > > > sb_fdblocks 14538692, counted 14669764
> > > >         - found root inode chunk
> > > > Phase 3 - for each AG...
> > > > ...
> > > > 
> > > > And the count diff is always 14669764 - 14538692 = 131072 (128k). The
> > > > XFS in question was formated with "-m rmapbt=1 -b 1k" option.
> > > > 
> > > > After turning on XFS_WARN and adding some debug printks (I appended the
> > > > detailed logs at the end of mail), I found that this was caused by too
> > > > large 'indlen' returned by xfs_bmap_worst_indlen(), which can't fit in a
> > > > 17 bits value (STARTBLOCKVALBITS is defined as 17), so the assert in
> > > > nullstartblock() failed: ASSERT(k < (1 << STARTBLOCKVALBITS));
> > > > 
> > > > From the log, newlen = 151513, which needs 18 bits, so nullstartblock()
> > > > throws away the 18th bit, and the sb_fdblocks difference is always 2^17
> > > > = 131072.
> > > 
> > > br_startblock is encoded in memory (and in the on-disk bmbt records) as
> > > a 52-bit unsigned integer.  We signal a delayed allocation record by
> > > setting the uppermost STARTBLOCKMASKBITS (35) bits to 1 and stash the
> > > 'indlen' reservation (i.e. the worst case estimate of the space we need
> > > to grow the bmbt/rmapbt to map the entire delayed allocation) in the
> > > lower 17 bits of br_startblock.  In theory this is ok because we're
> > > still quite a ways from having enough storage to create an fs where
> > > the upper bits in the agno part of an xfs_fsblock_t are actually set.
> > 
> > This confirms what I read from the code, thanks! But I'm still curious
> > about how these numbers are chosen, especially STARTBLOCKMASKBITS is
> > defined as (15 + 20), where are they from?
> 
> <shrug> Dave? :)

You mean these definitions?

#define STARTBLOCKVALBITS	17
#define STARTBLOCKMASKBITS	(15 + 20)

Today: a history lesson. :)

Remember that these are stored encoded in a xfs_bmbt_rec on disk and
a xfs_bmbt_rec_host in memory, so they need to fit in this
definition both on disk and in memory:

/*
 * Bmap btree record and extent descriptor.
 *  l0:63 is an extent flag (value 1 indicates non-normal).
 *  l0:9-62 are startoff.
 *  l0:0-8 and l1:21-63 are startblock.
 *  l1:0-20 are blockcount.
 */
#define BMBT_EXNTFLAG_BITLEN    1
#define BMBT_STARTOFF_BITLEN    54
#define BMBT_STARTBLOCK_BITLEN  52
#define BMBT_BLOCKCOUNT_BITLEN  21

We're looking at BMBT_STARTBLOCK_BITLEN here so it's obvious that

that 15 + 20 + 17 is 52 bits. And that the startblock encoding for
delayed allocation obivously fits inside the space in on disk and
host extent tree records correctly.

But what about the old "small block" format that was originally
used on 32 bit MIPS systems? That only had 32 bits in the start
block encoding *in memory*, so it should be clear that:

	15 + 17 = 32 bits

Indeed, look back at the older code:

(http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=blob;f=fs/xfs/xfs_bmap_btree.h;h=a4555abb6622a5d2ac6c08ab0f585761d6ff4585;hb=HEAD)

#define STARTBLOCKMASKBITS      (15 + XFS_BIG_BLKNOS * 20)
#define DSTARTBLOCKMASKBITS     (15 + 20)

And you can see we had different definitions for in-memory and
on-disk start block masks, and that difference was the size of the
block addresses the compiled kernel could manage.

IOWs, the "15 + 20" is the old definition that recognised the
difference in block size between 32 bit and 64 bit systems could
originally support in memory vs what the 64-bit on-disk format
supported. We now only support 64bit in memory, so the in-memory and
on-disk definitions are now the same....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
