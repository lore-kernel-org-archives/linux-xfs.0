Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8FA17F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 08:18:40 -0600 (CST)
Message-ID: <52FA3141.20901@sgi.com>
Date: Tue, 11 Feb 2014 08:18:41 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs_db: fix the setting of unaligned directory fields
References: <20140210230923.268327906@sgi.com> <20140211013145.GA13647@dastard>
In-Reply-To: <20140211013145.GA13647@dastard>
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

On 02/10/14 19:31, Dave Chinner wrote:
> On Mon, Feb 10, 2014 at 05:09:12PM -0600, Mark Tinguely wrote:

<delete>

>> >  +		 * Values larger than 64 bits are array of hex digits that
>> >  +		 * already in the desired ordering (example UUID).
>> >    		*/
>> >  -		*value = strtoll(arg, NULL, 0);
>> >  +		if (bit_length > 64)
>> >  +			return buf;
> I don't understand why you added this - how can we have input left
> that we need to parse after the above loop? @bytes will always be<=
> 0 at this point in time, which means we have no space in the bit
> field left to put values into....

The comment explains the return.

If the input bit_length is bigger than 64 bit then it is an array of hex 
numbers (for example UUID can be entered this way).

buf is the beginning of the allocated array before rbuf pointer put 
nibbles into it. So this returns the beginning of the hex bytes.

If this return is not taken then it is 64 bits or less and is some kind 
of integer. The integer will get its fields fixed and converted to big 
endian....

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
