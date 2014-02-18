Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4C757FDD
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 04:34:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2DB2304062
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 02:34:51 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	z5kgX9pH8OmZ1JU7 for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 02:34:49 -0800 (PST)
Date: Tue, 18 Feb 2014 21:34:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs_db: fix the setting of unaligned directory fields
Message-ID: <20140218103444.GF28666@dastard>
References: <20140210230923.268327906@sgi.com>
	<20140213202555.996721782@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140213202555.996721782@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 13, 2014 at 02:25:36PM -0600, Mark Tinguely wrote:
> Setting the directory startoff, startblock, and blockcount
> fields are difficult on both big and little endian machines.
> The setting of extentflag was completely broken.
> 
> big endian test:
> xfs_db> write u.bmx[0].startblock 12
> u.bmx[0].startblock = 0
> xfs_db> write u.bmx[0].startblock 0xc0000
> u.bmx[0].startblock = 192
> 
> little endian test:
> xfs_db> write u.bmx[0].startblock 12
> u.bmx[0].startblock = 211106232532992
> xfs_db> write u.bmx[0].startblock 0xc0000
> u.bmx[0].startblock = 3221225472
> 
> Since the output fields and the lengths are not aligned to a byte,
> setbitval requires them to be entered in big endian and properly
> byte/nibble shifted. The extentflag output was aligned to a byte
> but was not shifted correctly.
> 
> Convert the input to big endian on little endian machines and
> nibble/byte shift on all platforms so setbitval can set the bits
> correctly.
> 
> Clean some whitespace while in the setbitbal() function.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> v3:
>  Hex input is not a number.
>  More ten year old white space cleanups.
> 
> v2:
>  Ignore extra characters in input.
>  Fix hash input if still used as an integer input.
>   It was broken on big endian, but someone may use this input in a
>   little endian script.
>  Add documentation.
>  Did more clean up.
> 
>  db/bit.c   |   84 ++++++++++++------------------
>  db/write.c |  166 ++++++++++++++++++++++++++++++++++++++++---------------------
>  2 files changed, 143 insertions(+), 107 deletions(-)
> 
> Index: b/db/bit.c
> ===================================================================
> --- a/db/bit.c
> +++ b/db/bit.c
> @@ -128,57 +128,41 @@ getbitval(
>  	return rval;
>  }
>  
> +/*
> + * The input data can be 8, 16, 32, and 64 sized numeric values
> + * aligned on a byte boundry, or odd sized numbers stored on odd
> + * aligned offset (for example the bmbt fields).
> + *
> + * The input data sent to this routine has been converted to big endian
> + * and has been adjusted in the array so that the first input bit is to
> + * be written in the first bit in the output.
> + *
> + * If the field length and the output buffer are byte aligned, then use
> + * memcpy from the input to the output, but if either entries are not byte
> + * aligned, then loop over the entire bit range reading the input value
> + * and set/clear the matching bit in the output.
> + *
> + * example when ibuf is not multiple of a byte in length:
> + *
> + * ibuf:	| BBBBBBBB | bbbxxxxx |
> + *		  \\\\\\\\--\\\\
> + * obuf+bitoff:	| xBBBBBBB | Bbbbxxxx |
> + *
> + */
>  void
>  setbitval(
> -	void *obuf,      /* buffer to write into */
> -	int bitoff,      /* bit offset of where to write */
> -	int nbits,       /* number of bits to write */
> -	void *ibuf)      /* source bits */
> +	void	*obuf,		/* start of buffer to write into */
> +	int	bitoff,		/* bit offset into the output buffer */
> +	int	nbits,		/* number of bits to write */
> +	void	*ibuf)		/* source bits */
>  {
> -	char    *in           = (char *)ibuf;
> -	char    *out          = (char *)obuf;
> -
> -	int     bit;
> -
> -#if BYTE_ORDER == LITTLE_ENDIAN
> -	int     big           = 0;
> -#else
> -	int     big           = 1;
> -#endif
> -
> -	/* only need to swap LE integers */
> -	if (big || (nbits!=16 && nbits!=32 && nbits!=64) ) {
> -		/* We don't have type info, so we can only assume
> -		 * that 2,4 & 8 byte values are integers. sigh.
> -		 */
> -
> -		/* byte aligned ? */
> -		if (bitoff%NBBY) {
> -			/* no - bit copy */
> -			for (bit=0; bit<nbits; bit++)
> -				setbit(out, bit+bitoff, getbit(in, bit));
> -		} else {
> -			/* yes - byte copy */
> -			memcpy(out+byteize(bitoff), in, byteize(nbits));
> -		}
> -
> -	} else {
> -		int     ibit;
> -		int     obit;
> -
> -		/* we need to endian swap this value */
> -
> -		out+=byteize(bitoff);
> -		obit=bitoffs(bitoff);
> -
> -		ibit=nbits-NBBY;
> -
> -		for (bit=0; bit<nbits; bit++) {
> -			setbit(out, bit+obit, getbit(in, ibit));
> -			if (ibit%NBBY==NBBY-1)
> -				ibit-=NBBY*2-1;
> -			else
> -				ibit++;
> -		}
> -	}
> +	char	*in = ibuf;
> +	char	*out = obuf;
> +	int	bit;
> +
> +	if (bitoff % NBBY || nbits % NBBY) {
> +		for (bit=0; bit < nbits; bit++)

Still whitespace damaged. I'll fix it when I commit it.


> +/*
> + * convert_arg allow input in the following forms:
> + * A string ("ABTB") whose ASCII value is placed in an array in the order
> + * matching the input.
> + *
> + * An even number of hex numbers. If the length is greater than
> + * 64 bits, then the output is an array of bytes whose top nibble
> + * is the first hex digit in the input, the lower nibble is the second
> + * hex digit in the input. UUID entries are entered in this manner.
> + * If the length is 64 bits or less, then treat the hex input characters
> + * as a number used with setbitval().

Comment is now wrong. I'll fix it when I commit it.

> +	char		*ostr;
> +	__u64		*value;
> +	__u64		val = 0;
>  
>  	if (bit_length <= 64)
>  		alloc_size = 8;
>  	else
> -		alloc_size = (bit_length+7)/8;
> +		alloc_size = (bit_length + 7)/8;

Whitespace still broken. I'll fix it when I commit it.

>  
>  	buf = xrealloc(buf, alloc_size);
>  	memset(buf, 0, alloc_size);
> -	value = (long long *)buf;
> +	value = (__u64 *)buf;
>  	rbuf = buf;
>  
>  	if (*arg == '\"') {
> -		/* handle strings */
> +		/* input a string and output ASCII array of characters */
>  
>  		/* zap closing quote if there is one */
> -		if ((ostr = strrchr(arg+1, '\"')) != NULL)
> +		if ((ostr = strrchr(arg + 1, '\"')) != NULL)
>  			*ostr = '\0';

You didn't update this like I asked. I'll fix it when I commit it.

> @@ -496,48 +519,77 @@ convert_arg(
>  		 *
>  		 * (but if it starts with "-" assume it's just an integer)
>  		 */
> -		int bytes=bit_length/8;
> +		int bytes = bit_length / NBBY;
> +
> +		/* is this an array of hec numbers? */
> +		if (bit_length % NBBY)
> +			return NULL;
>  
>  		/* skip leading hash */
> -		if (*arg=='#') arg++;
> +		if (*arg == '#') arg++;

You didn't update this like I asked. I'll fix it when I commit it.

> +	/*
> +	 * Align the array to point to the field in the array.
> +	 *  rbuf  = |MMmm|mmll|ll00|
> +	 */
> +	offset = sizeof(__be64) - 1 - ((bit_length - 1)/ sizeof(__be64));

More whitespace that I've previously pointed out. I'll fix it when I
commit it.

The fix works, so I'll say:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

with the caveat that, as the maintainer, I'm going just going to fix
the whitespace problems I've pointed out twice now because I just
want the bug fixed ASAP.

Mark, please take more care in future to address all the review
comments that are made.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
