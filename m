Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q66J7D6p197119 for <xfs@oss.sgi.com>; Fri, 6 Jul 2012 14:07:13 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id zkJ5jsjb7QbC8o0i for <xfs@oss.sgi.com>;
	Fri, 06 Jul 2012 12:07:11 -0700 (PDT)
Message-ID: <4FF7375E.4060009@sandeen.net>
Date: Fri, 06 Jul 2012 14:07:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: Fix extent record printing on big endian
References: <4FE23555.7070606@redhat.com>
In-Reply-To: <4FE23555.7070606@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/20/12 3:40 PM, Eric Sandeen wrote:
> Extent records which should have been printed as:
> 
> a.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,12,17,0]
> 
> for example, were instead being printed as:
> 
> a.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,12884910592,0,0]
> 
> in xfs_db.  It was simply mis-parsing the extent records due to wrong
> #defines for big-endian machines.
> 
> It's been broken since at least xfsprogs-2.6.13, causing xfstests 021
> to fail.

Ping on this one?  I'd like to get 021 passing on big-endian.  Do I need to
do more due diligence on the correctness of it?

addr_f
	(*adf)(iocur_top->data, tfl->offset, next);
		fa_cfsblock(obj, bit, next);
			bno = (xfs_dfsbno_t)getbitval(obj, bit, BMBT_STARTBLOCK_BITLEN,
				BVUNSIGNED);

fa_cfsblock is getting the wrong "bit" passed to it due to the offset in this structure
being wrong, because of the defines in question.  

const field_t   bmapbta_rec_flds[] = {
        { "startoff", FLDT_CFILEOFFA, OI(BMBT_STARTOFF_BITOFF), C1, 0,
          TYP_ATTR },
        { "startblock", FLDT_CFSBLOCK, OI(BMBT_STARTBLOCK_BITOFF), C1, 0,
          TYP_ATTR },
	...

So we pass it an opaque "obj", and the bit offset into the on-disk inode for the extent
data is the same whether we are on big endian or little endian - I think that is the
issue here.

getbitval() itself handles endian converions once we get to the right data.  We just need
the proper offsets to it...

Thanks,
-Eric
 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Why this works is, um ...left as an exercise to the reviewer for now ;)
> TBH I get lost in xfs_db, and I'm not sure how endianness is handled,
> but it's pretty clearly not like this!
> 
> diff --git a/db/btblock.c b/db/btblock.c
> index f6e8a68..2c199b2 100644
> --- a/db/btblock.c
> +++ b/db/btblock.c
> @@ -250,23 +250,12 @@ const field_t	bmapbtd_key_flds[] = {
>  };
>  #undef KOFF
>  
> -#ifndef XFS_NATIVE_HOST
> -
>  #define BMBT_EXNTFLAG_BITOFF	0
>  #define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF + BMBT_EXNTFLAG_BITLEN)
>  #define BMBT_STARTBLOCK_BITOFF	(BMBT_STARTOFF_BITOFF + BMBT_STARTOFF_BITLEN)
>  #define BMBT_BLOCKCOUNT_BITOFF	\
>  	(BMBT_STARTBLOCK_BITOFF + BMBT_STARTBLOCK_BITLEN)
>  
> -#else
> -
> -#define BMBT_EXNTFLAG_BITOFF	63
> -#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF - BMBT_STARTOFF_BITLEN)
> -#define BMBT_STARTBLOCK_BITOFF	85 /* 128 - 43 (other 9 is in first word) */
> -#define BMBT_BLOCKCOUNT_BITOFF	64 /* Start of second 64 bit container */
> -
> -#endif /* XFS_NATIVE_HOST */
> -
>  const field_t	bmapbta_rec_flds[] = {
>  	{ "startoff", FLDT_CFILEOFFA, OI(BMBT_STARTOFF_BITOFF), C1, 0,
>  	  TYP_ATTR },
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
