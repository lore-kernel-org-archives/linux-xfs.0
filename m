Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A1137F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 18:22:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2243D8F8064
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 16:22:45 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HdHvc6T5pdRD0NVK for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 16:22:42 -0800 (PST)
Date: Wed, 12 Feb 2014 11:22:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_db: fix the setting of unaligned directory fields
Message-ID: <20140212002222.GO13647@dastard>
References: <20140210230923.268327906@sgi.com> <20140211013145.GA13647@dastard>
	<52FA3141.20901@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FA3141.20901@sgi.com>
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

On Tue, Feb 11, 2014 at 08:18:41AM -0600, Mark Tinguely wrote:
> On 02/10/14 19:31, Dave Chinner wrote:
> >On Mon, Feb 10, 2014 at 05:09:12PM -0600, Mark Tinguely wrote:
> 
> <delete>
> 
> >>>  +		 * Values larger than 64 bits are array of hex digits that
> >>>  +		 * already in the desired ordering (example UUID).
> >>>    		*/
> >>>  -		*value = strtoll(arg, NULL, 0);
> >>>  +		if (bit_length > 64)
> >>>  +			return buf;
> >I don't understand why you added this - how can we have input left
> >that we need to parse after the above loop? @bytes will always be<=
> >0 at this point in time, which means we have no space in the bit
> >field left to put values into....
> 
> The comment explains the return.

If the comment answered my question then I wouldn't have asked it.

> If the input bit_length is bigger than 64 bit then it is an array of
> hex numbers (for example UUID can be entered this way).

Yes, I know that.

> buf is the beginning of the allocated array before rbuf pointer put
> nibbles into it. So this returns the beginning of the hex bytes.

Yes, I know that, too.

> If this return is not taken then it is 64 bits or less and is some
> kind of integer. The integer will get its fields fixed and converted
> to big endian....

Oh, now I understand what you've done - you've changed the
definition of what a hex block contains. A hex block is a
hex-encoded binary format - it is just an array of bytes. What
you've changed is that you now define a hex block of less than 64
bits to encode a host-endian format integer.

That's what you comment didn't explain and what confused me - why we
should be bit shifting or endian converting a raw data encoding.

For example, if I want to write 4 bytes of hex data to a field, then
I use "#12345678" to do it. When I dump the raw contents of that
field, I expect to see four bytes in big endian format in that
field: 12 34 56 78. When I print the structure value, I expect to
see the host-endian conversion of that raw data, not the on-disk
encoded value.

IOWs, we do not want small hex block arrays to be interpretted as a
host endian integer - if you need to enter an integer value in host
endian then use "0x12345678". i.e. hex blocks are not integers. i.e.

xfs_db> write lsn #12345678
lsn = 0x78563412
xfs_db> write lsn 0x12345678
lsn = 0x12345678

The above behaviour is correct and expected on a little endian host.
Having them both result in "lsn = 0x12345678" is not the correct or
desired behaviour. I didn't pick this up when looking that the tst
you wrote, but it's now obvious:

+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #185a" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #a518" $SCRATCH_DEV
...
+core.gen = 6234
+core.gen = 42264

This is how a little endian host should behave:

xfs_db> write core.gen 0xa518
core.gen = 42264
xfs_db> write core.gen #a518
core.gen = 6309
xfs_db> write core.gen 0x18a5
core.gen = 6309
xfs_db> write core.gen #18a5
core.gen = 42264


So, back to my original question, now I undersand what you've done,
which was "how does hexblock data on unaligned bit_length fields
work?". The code ends up like this:

		int bytes = bit_length / NBBY;

		while (*arg && bytes--) {
			.....
		}

		if (bytes < 0 && *arg)
			return NULL;

		/*
		 * Values larger than 64 bits are array of hex digits that
		 * already in the desired ordering (example UUID).
		 */
		if (bit_length > 64)
		     return buf;
	} else {
		....
	}

	/* do integer parsing */
	......

Let's say bit length is 1 (e.g. unwritten extent flag) and we pass a
value of "#1". That gives us bytes = 0 as the initial condition.
This:

	while (*arg && bytes--)

sees *arg != NULL and bytes = 0 so it doesn't run the loop and
then post-decrements bytes Now we have bytes = -1 and *arg != 0.
So we return NULL instead of parsing the byte.

The same thing will happen with any unaligned bit field that needs
the high byte set via this code as it will fail to parse the last
character of the input.

IOWs, using hexblock format on unaligned bitfields does not work
properly. In fact, it's never been supported, as hex blocks
were never intended to be used that way. i.e. the use for a hexblock
when writting an extent record to to write the entire record as a
binary value, not to write individual elements as integer values....

Hence I'd suggest that "if (bit_field & NBBY) return NULL;" is
appropriate for hex block format input, and the input should never
be treated as a host-endian integer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
