Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 724E17F77
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 18:00:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0EDAFAC003
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 16:00:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id a8Y2QxjIiN64VBjw for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 16:00:44 -0800 (PST)
Message-ID: <54D94A2A.8020906@sandeen.net>
Date: Mon, 09 Feb 2015 18:00:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: pass mp to XFS_WANT_CORRUPTED_*
References: <54D53E8C.8070207@redhat.com>
	<20150208213502.GA4251@dastard>	<20150209130926.GA18336@laptop.bfoster>	<20150209211744.GT12722@dastard>	<20150209214359.GN18336@laptop.bfoster>
	<20150209215827.GW12722@dastard>
In-Reply-To: <20150209215827.GW12722@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2/9/15 3:58 PM, Dave Chinner wrote:
> On Mon, Feb 09, 2015 at 04:43:59PM -0500, Brian Foster wrote:
>> On Tue, Feb 10, 2015 at 08:17:44AM +1100, Dave Chinner wrote:

...

>> Sure, but ASSERT_CORRUPT_RET() is the same length as the example above.
>> ASSERT_CORRUPT_GOTO() is only a few chars longer than the associated
>> example. We could still use WANT over ASSERT I suppose to shorten it up
>> further. Either of those are at least still self-explanatory in my
>> opinion.
> 
> Thinking on it a bit further, the XFS_WANT_CORRUPTED macros have an
> internal ASSERT in them, so they are effectively an ASSERT
> statement. I could live with those names, especially as ASSERT is
> something that can be compiled into production kernels via
> CONFIG_XFS_WARN=y to turn them into error messages...

Sooooo you all want "ASSERT_CORRUPTED_RET / ASSERT_CORRUPTED_GOTO" ?

In a light mauve? ;)

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
