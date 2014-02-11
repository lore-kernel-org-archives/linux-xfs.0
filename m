Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 176687F50
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 19:31:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A667AC009
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 17:31:54 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Vj3FjZZB2D6GL5LU for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 17:31:48 -0800 (PST)
Date: Tue, 11 Feb 2014 12:31:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_db: fix the setting of unaligned directory fields
Message-ID: <20140211013145.GA13647@dastard>
References: <20140210230923.268327906@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140210230923.268327906@sgi.com>
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

On Mon, Feb 10, 2014 at 05:09:12PM -0600, Mark Tinguely wrote:
> Setting the directory startoff, startblock, and blockcount
> fields are difficult on both big and little endian machines.
> The setting of extentflag was completely broken.
.....
> +	char	*in = ibuf;
> +	char	*out = obuf;
> +	int	bit;
> +
> +	if (bitoff % NBBY || nbits % NBBY) {
> +		for (bit=0; bit<nbits; bit++)
> +			setbit(out, bit+bitoff, getbit(in, bit));
> +	} else
> +		memcpy(out+byteize(bitoff), in, byteize(nbits));

Still whitespace challenged ;)

> Index: b/db/write.c
> ===================================================================
> --- a/db/write.c
> +++ b/db/write.c
> @@ -439,55 +439,78 @@ convert_oct(
>  
>  #define NYBBLE(x) (isdigit(x)?(x-'0'):(tolower(x)-'a'+0xa))
>  
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
> + *
> + * A decimal or hexadecimal integer to be used with setbitval().
> + *	---
> + * Numbers that will use setbitval() are in big endian format and
> + * are adjusted in the array so that the first input bit is to be
> + * be written to the first bit in the output.
> + */
>  static char *
>  convert_arg(
> -	char *arg,
> -	int  bit_length)
> +	char		*arg,
> +	int		bit_length)
>  {
> -	int i;
> -	static char *buf = NULL;
> -	char *rbuf;
> -	long long *value;
> -	int alloc_size;
> -	char *ostr;
> -	int octval, ret;
> +	int		i;
> +	int		alloc_size;
> +	int		octval;
> +	int		offset;
> +	int		ret;
> +	static char	*buf = NULL;
> +	char		*endp;
> +	char		*rbuf;
> +	char		*ostr;
> +	__u64		*value;
> +	__u64		val = 0;
>  
>  	if (bit_length <= 64)
>  		alloc_size = 8;
>  	else
> -		alloc_size = (bit_length+7)/8;
> +		alloc_size = (bit_length + 7)/8;

		alloc_size = (bit_length + 7) / 8;
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

If you are touching these, the preferred form is

		ostr = strrchr(arg + 1, '\"');
		if (ostr)
			*ostr = '\0';

>  
> -		ostr = arg+1;
> +		ostr = arg + 1;
>  		for (i = 0; i < alloc_size; i++) {
>  			if (!*ostr)
>  				break;
>  
> -			/* do octal */
> +			/* do octal conversion */
>  			if (*ostr == '\\') {
> -				if (*(ostr+1) >= '0' || *(ostr+1) <= '7') {
> -					ret = convert_oct(ostr+1, &octval);
> +				if (*(ostr + 1) >= '0' || *(ostr + 1) <= '7') {
> +					ret = convert_oct(ostr + 1, &octval);
>  					*rbuf++ = octval;
> -					ostr += ret+1;
> +					ostr += ret + 1;
>  					continue;
>  				}
>  			}
>  			*rbuf++ = *ostr++;
>  		}
> -
>  		return buf;
> -	} else if (arg[0] == '#' || ((arg[0] != '-') && strchr(arg,'-'))) {
> +	}
> +
> +	if (arg[0] == '#' || ((arg[0] != '-') && strchr(arg,'-'))) {
>  		/*
>  		 * handle hex blocks ie
>  		 *    #00112233445566778899aabbccddeeff
> @@ -495,49 +518,89 @@ convert_arg(
>  		 *    1122334455667788-99aa-bbcc-ddee-ff00112233445566778899
>  		 *
>  		 * (but if it starts with "-" assume it's just an integer)
> +		 *
> +		 * Treat all requests 64 bits or smaller as numbers and
> +		 * requests larger than 64 bits as hex blocks arrays.
>  		 */
> -		int bytes=bit_length/8;
> +		int bytes = bit_length / NBBY;
>  
>  		/* skip leading hash */
> -		if (*arg=='#') arg++;
> +		if (*arg == '#') arg++;
>  
>  		while (*arg && bytes--) {
> -		    /* skip hypens */
> -		    while (*arg=='-') arg++;
> +			/* skip hypens */
> +			while (*arg == '-') arg++;
			while (*arg == '-')
				arg++;
>  
> -		    /* get first nybble */
> -		    if (!isxdigit((int)*arg)) return NULL;
> -		    *rbuf=NYBBLE((int)*arg)<<4;
> -		    arg++;
> -
> -		    /* skip more hyphens */
> -		    while (*arg=='-') arg++;
> -
> -		    /* get second nybble */
> -		    if (!isxdigit((int)*arg)) return NULL;
> -		    *rbuf++|=NYBBLE((int)*arg);
> -		    arg++;
> +			/* get first nybble */
> +			if (!isxdigit((int)*arg))
> +				return NULL;
> +			if (bit_length <= 64)
> +				val = (val << 4) + NYBBLE((int)*arg);
> +			else
> +				*rbuf = NYBBLE((int)*arg) << 4;
> +			arg++;
> +
> +			/* skip more hyphens */
> +			while (*arg == '-')
> +				arg++;
> +
> +			/* get second nybble */
> +			if (!isxdigit((int)*arg))
> +				return NULL;
> +			if (bit_length <= 64)
> +				val = (val << 4) + NYBBLE((int)*arg);
> +			else
> +				*rbuf++ |= NYBBLE((int)*arg);
> +			arg++;
>  		}
> -		if (bytes<0&&*arg) return NULL;
> -		return buf;
> -	} else {
> +		if (bytes < 0 && *arg)
> +			return NULL;
> +
>  		/*
> -		 * handle integers
> +		 * Values larger than 64 bits are array of hex digits that
> +		 * already in the desired ordering (example UUID).
>  		 */
> -		*value = strtoll(arg, NULL, 0);
> +		if (bit_length > 64)
> +			return buf;

I don't understand why you added this - how can we have input left
that we need to parse after the above loop? @bytes will always be <=
0 at this point in time, which means we have no space in the bit
field left to put values into....

> +	} else {
> +		/* handle decimal / hexadecimal integers */
>  
> -#if __BYTE_ORDER == BIG_ENDIAN
> -		/* hackery for big endian */
> -		if (bit_length <= 8) {
> -			rbuf += 7;
> -		} else if (bit_length <= 16) {
> -			rbuf += 6;
> -		} else if (bit_length <= 32) {
> -			rbuf += 4;
> -		}
> -#endif
> -		return rbuf;
> +		val = strtoll(arg, &endp, 0);
> +		/* return if not a clean number */
> +		if (*endp != '\0')
> +			return NULL;
>  	}
> +
> +	/* Is this value valid for the bit length? */
> +	if (val >> bit_length)
> +		return NULL;

That's quite ambiguous - it's not obviously correct as it requires
close attention to determine that the code actually functions
correctly. i.e. I had to look very closely to determine ">>" or ">"
should have been used here. Can you rewrite it as:

	/* Check if the value can fit into the supplied bitfield */
	if ((val >> bit_length) > 0)
		return NULL;

> +	/*
> +	 * If the length of the field is not a multiple of a byte, push
> +	 * the bits up in the field, so the most signicant field bit is
> +	 * the most significant bit in the byte:
> +	 *
> +	 * before:
> +	 * val  |----|----|----|----|----|--MM|mmmm|llll|
> +	 * after
> +	 * val  |----|----|----|----|----|MMmm|mmll|ll00|
> +	 */
> +	offset = bit_length % NBBY;
> +	if (offset)
> +		val <<= (NBBY - offset);
> +
> +	/*
> +	 * convert to big endian and copy into the array
> +	 * rbuf |----|----|----|----|----|MMmm|mmll|ll00|
> +	 */
> +	*value = cpu_to_be64(val);
> +
> +	/*
> +	 * Align the array to point to the field in the array.
> +	 *  rbuf  = |MMmm|mmll|ll00|
> +	 */
> +	offset = sizeof(__be64) - 1 - ((bit_length - 1)/ sizeof(__be64));
                                                      ^^
whitespace

Other that that, the comments greatly improve this code. Thanks for
doing that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
