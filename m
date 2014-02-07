Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A0D17CBE
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 17:13:22 -0600 (CST)
Message-ID: <52F56891.5020305@sgi.com>
Date: Fri, 07 Feb 2014 17:13:21 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: fix the setting of unaligned directory fields
References: <20140207210348.249387765@sgi.com> <20140207223327.GG13647@dastard>
In-Reply-To: <20140207223327.GG13647@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/07/14 16:33, Dave Chinner wrote:
> On Fri, Feb 07, 2014 at 04:03:42PM -0600, Mark Tinguely wrote:
>> Setting the directory startoff, startblock, and blockcount
>> bit fields is difficult on both big and little endian machines.
>> The setting of extentflag bit field was completely broken.
>>
>> big endian test:
>> xfs_db>  write u.bmx[0].startblock 12
>> u.bmx[0].startblock = 0
>> xfs_db>  write u.bmx[0].startblock 0xc0000
>> u.bmx[0].startblock = 192
>>
>> little endian test:
>> xfs_db>  write u.bmx[0].startblock 12
>> u.bmx[0].startblock = 211106232532992
>> xfs_db>  write u.bmx[0].startblock 0xc0000
>> u.bmx[0].startblock = 3221225472
>
> Can you please write an xfstest for this? The BMBT extent records
> are the only structures that have unaligned bit offsets and hence
> the only ones that exercise this specific code. Clearly no-one
> has needed to write a BMBT record in the past 10 years....

nod. I manually ran through the values valid values for the fields to 
test. A test would be nice.

>> Since these output fields and the lengths are not aligned to a byte,
>> setbitval requires them to be entered in big endian and properly
>> byte/nibble shifted. The extentflag out field is aligned to a byte
>> boundary but was not shifted correctly.
>>
>> Convert the input to big endian on little endian machines and
>> bit/byte shift on all platforms so setbitval can set the bits
>> correctly. As noted in the comment, the bit shift must be done
>> before doing the endian conversion or end result will be shifted
>> in the wrong direction..
>
> Ok, so while we are touching this code, some documentation
> explaining the bit shifting requirements, the format of the return
> buffer from convert_args, what parameter format setbitval() expects,
> etc. Some ascii art demonstrating the incoming and outgoing buffer
> contents for convert_arg would be a great help.
>

okay.

>> +	char	*in	= (char *)ibuf;
>> +	char	*out	= (char *)obuf;
>> +	int	bit;
>
> ibuf/obuf are void *, so don't need casts. Also, whitespace:
>
> 	char	*in = ibuf;
> 	char	*out = obuf;
>
>> +	/*
>> +	 * The input data is in big endian and aligned to the bit length.
>> +	 * Set the individual bits if the destination field or the source
>> +	 * end are not aligned.
>> +	 */
>> +	if (bitoff % NBBY || nbits % NBBY) {
>> +		for (bit=0; bit<nbits; bit++)
>> +			setbit(out, bit+bitoff, getbit(in, bit));
>> +	} else
>> +		memcpy(out+byteize(bitoff), in, byteize(nbits));
>
> This is also rather whitespace challenged.

Nod, did not see that.

>
>>   }
>> Index: b/db/write.c
>> ===================================================================
>> --- a/db/write.c
>> +++ b/db/write.c
>> @@ -451,6 +451,7 @@ convert_arg(
>>   	int alloc_size;
>>   	char *ostr;
>>   	int octval, ret;
>> +	int offadj;
>
> Just "offset" is sufficient here, and with the scope of use, it
> can be declared in the else branch where it is used.
>
>>
>>   	if (bit_length<= 64)
>>   		alloc_size = 8;
>> @@ -526,16 +527,20 @@ convert_arg(
>>   		 */
>>   		*value = strtoll(arg, NULL, 0);
>
> If we are touching this code, the return value here should be error
> checked.
>
> xfs_db>  write u3.bmx[0].startblock 3rgfdw
> u3.bmx[0].startblock = 52776558133248

hmm, It should stop at 3. I will take a look.

> xfs_db>  write u3.bmx[0].startblock x3rgfdw
> u3.bmx[0].startblock = 0
> xfs_db>
>
> i.e. it accepts garbage rather than erroring out.

as does all the other writes ...
xfs_db>  write core.nblocks x3rgfdw
core.nblocks = 0

Fixing convert_arg() is beyond the scope of just this patch.

>> -#if __BYTE_ORDER == BIG_ENDIAN
>> -		/* hackery for big endian */
>> -		if (bit_length<= 8) {
>> -			rbuf += 7;
>> -		} else if (bit_length<= 16) {
>> -			rbuf += 6;
>> -		} else if (bit_length<= 32) {
>> -			rbuf += 4;
>> -		}
>> -#endif
>> +		/*
>> +		 * Align the significant bits in the result length.
>> +		 * Must be done before the endian conversion.
>> +		 */
>> +		offadj = bit_length % NBBY;
>> +		if (offadj)
>> +			*value<<= (8 - offadj);
>
> So it gets shifted up by a number 1-7 bits to align the first bit of
> the range to a byte boundary. So, that magic "8" should be:
>
> 			*value<<= NBBY - offadj;
>
> Ascii art to help readers. Before (host order):
>
> 	rbuf
> 	+---+---+---+---+---+--n+nnn+nnn+
> 		               + bitlen +
> After (host order):
> 	+---+---+---+---+---+nnn+nnn+n--+
> 			    + bitlen +
> then
>
>> +
>> +		/* convert to big endian */
>> +		*value = cpu_to_be64(*value);
>> +
>> +		/* Align the signifant bytes in the result length. */
>> +		offadj = 7 - (bit_length - 1)/ 8;
>> +		rbuf += offadj;
>
> So the buffer pointer get moved forward by a certain number of bytes
> to point at the first byte of the 64 bit big endian value. IOWs, the
> magic "7" is actually (sizeof(__be64) - 1) and the "8" is
> "sizeof(__be64)" because we are talking about adjusting the offset
> within a __be64 variable. IOWs the calculation should be:
>
> 		offset = sizeof(__be64) - 1 -
> 				((bit_length - 1) / sizeof(__be64));
>
> Ascii art to help readers. Before (big endian):
>
> 	rbuf
> 	+---+---+---+---+---+nnn+nnn+n--+
> 			    + bitlen +
>
> After (big endian):
> 		            rbuf
>                              +nnn+nnn+n--+
> 			    + bitlen +
>
> And a similar diagram should be added to setbitval to describe the
> format of the bit information required in @ibuf.
>

Yep, good idea.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
