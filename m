Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96CHrxe182586 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 07:17:53 -0500
Subject: Re: [PATCH 2/2] repair: fix some valgrind reported errors on i686
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1317862891-3033-3-git-send-email-david@fromorbit.com>
References: <1317862891-3033-1-git-send-email-david@fromorbit.com>
	<1317862891-3033-3-git-send-email-david@fromorbit.com>
Date: Thu, 6 Oct 2011 07:17:52 -0500
Message-ID: <1317903472.3139.30.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-10-06 at 12:01 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fix a potential prefetch read problem due to the first loop
> execution of pf_batch_read potentially not initialising the fsbno
> varaible:
> 
> ==10177== Thread 6:
> ==10177== Conditional jump or move depends on uninitialised value(s)
> ==10177==    at 0x8079CAB: pf_batch_read (prefetch.c:408)
> ==10177==    by 0x6A2996D: clone (clone.S:130)
> ==10177==
> 
> Fix a bunch of invalid read/write errors due to excessive blkmap
> allocations when inode forks are corrupted. These show up some time
> after making a blkmap allocation for 536870913 extents on i686,
> which is followed some time later by a crash caused bymemory
> corruption.
> 
> This blkmap allocation size overflows 32 bits in such a
> way that it results in a 32 byte allocation and so access to the
> second extent results in access beyond the allocated memory and
> corrupts random memory.
> 
> ==5419== Invalid write of size 4
> ==5419==    at 0x80507DA: blkmap_set_ext (bmap.c:260)
> ==5419==    by 0x8055CF4: process_bmbt_reclist_int (dinode.c:712)
> ==5419==    by 0x8056206: process_bmbt_reclist (dinode.c:813)
> ==5419==    by 0x80579DA: process_exinode (dinode.c:1324)
> ==5419==    by 0x8059B77: process_dinode_int (dinode.c:2036)
> ==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
> ==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
> ==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
> ==5419==    by 0xFFF: ???
> ==5419==  Address 0x944cfb8 is 0 bytes after a block of size 32 alloc'd
> ==5419==    at 0x48E1102: realloc (in
> /usr/lib/valgrind/vgpreload_memcheck-x86-linux.so)
> ==5419==    by 0x80501F3: blkmap_alloc (bmap.c:56)
> ==5419==    by 0x80599F5: process_dinode_int (dinode.c:2027)
> ==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
> ==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
> ==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
> ==5419==    by 0xFFF: ???
> 
> Add overflow detection code into the blkmap allocation code to avoid
> this problem, and also free large allocations once they are finished
> with to avoid pinning large amounts of memory due to the occasional
> large extent list in a filesystem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This is good but I have a few comments below, a couple of
which really indicate you need to update this.

					-Alex
 
> ---
>  repair/bmap.c     |   37 ++++++++++++++++++++++++++++++++++++-
>  repair/prefetch.c |    2 +-
>  2 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/bmap.c b/repair/bmap.c
> index 79b9f79..1127a87 100644
> --- a/repair/bmap.c
> +++ b/repair/bmap.c
> @@ -47,6 +47,17 @@ blkmap_alloc(
>  	if (nex < 1)
>  		nex = 1;
>  
> +#if (BITS_PER_LONG != 64)

This should be == 32, not != 64.  (And if it
were possible, sizeof (int) == 32.)

> +	if (nex > (INT_MAX / sizeof(bmap_ext_t) - 1)) {

See the comment below about this calculation.

> +		do_warn(
> +	_("Number of extents requested in blkmap_alloc (%u) overflows 32 bits.\n"
> +	  "If this is not a corruption, then will need a 64 bit system\n"
		...then you will need...

> +	  "to repair this filesystem.\n"),
> +			nex);
> +		return NULL;
> +	}
> +#endif
> +
>  	key = whichfork ? ablkmap_key : dblkmap_key;
>  	blkmap = pthread_getspecific(key);
>  	if (!blkmap || blkmap->naexts < nex) {

. . .

> @@ -218,6 +244,15 @@ blkmap_grow(
>  	}
>  
>  	blkmap->naexts += 4;

The check needs to go *before* you update naexts.

> +#if (BITS_PER_LONG != 64)
> +	if (blkmap->naexts > (INT_MAX / sizeof(bmap_ext_t) - 1)) {

I don't really follow this calculation. I would expect
it to be based more closely on how BLKMAP_SIZE() is
defined.

If you move it before the increment I think it would
be better to use:
	if (BLKMAP_SIZE(nex) >= INT_MAX - sizeof (blkent_t *))
And since this would expose the internals of what
BLKMAP_SIZE() does, it might be nicer if some sort of
BLKMAP_NENTS_MAX constant were defined next to the
definition of BLKMAP_SIZE().



> +		do_error(
> +	_("Number of extents requested in blkmap_grow (%u) overflows 32 bits.\n"
> +	  "You need a 64 bit system to repair this filesystem.\n"),
> +			blkmap->naexts);
> +		return NULL;
> +	}
> +#endif
>  	blkmap = realloc(blkmap, BLKMAP_SIZE(blkmap->naexts));
>  	if (blkmap == NULL)
>  		do_error(_("realloc failed in blkmap_grow\n"));


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
