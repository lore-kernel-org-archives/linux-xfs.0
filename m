Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C9387F52
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 15:37:10 -0600 (CST)
Message-ID: <52FBE989.1000304@sgi.com>
Date: Wed, 12 Feb 2014 15:37:13 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs_db: fix the setting of unaligned directory fields
References: <20140210230923.268327906@sgi.com>
	<20140211013145.GA13647@dastard> <52FA3141.20901@sgi.com>
	<20140212002222.GO13647@dastard>
In-Reply-To: <20140212002222.GO13647@dastard>
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

On 02/11/14 18:22, Dave Chinner wrote:
> On Tue, Feb 11, 2014 at 08:18:41AM -0600, Mark Tinguely wrote:
>> On 02/10/14 19:31, Dave Chinner wrote:

...

> Hence I'd suggest that "if (bit_field & NBBY) return NULL;" is
> appropriate for hex block format input, and the input should never
> be treated as a host-endian integer...
>
> Cheers,
>
> Dave.

I don't like having the hex block format as an integer input. My change 
would change the result if used as an integer, I just trying to keep 
compatibility with the previous code.

I will gladly leave the hex block input alone and remove the test that 
uses it as an integer.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
