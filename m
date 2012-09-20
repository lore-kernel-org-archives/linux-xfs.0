Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KHagra117431 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 12:36:42 -0500
Message-ID: <505B546A.6070105@sgi.com>
Date: Thu, 20 Sep 2012 12:37:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: restrict allocate worker to x86_64
References: <20120919163133.097340199@sgi.com>
	<20120919163145.367256258@sgi.com> <20120919215405.GE31501@dastard>
In-Reply-To: <20120919215405.GE31501@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/19/12 16:54, Dave Chinner wrote:
> On Wed, Sep 19, 2012 at 11:31:34AM -0500, tinguely@sgi.com wrote:
>> Restrict the allocation worker to X86_64 machines. This will improve
>> performance on non-X86-64 machines and avoid the AGF buffer hang.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>
> NACK.
>
> The stack overflow problems that this works around are not limited
> to x86-64. In the past we've seen overflows on i686 (even with 8k
> stacks), s390 and other platforms, so it's not an isolated issue.
>
> It either works or it doesn't - let's not start down the rathole of
> having different code paths and behaviours for different platforms.
>
> Cheers,
>
> Dave.

Well, I was expecting a 4 letter word from Dave on this patch and "NACK" 
was surprisingly mild.

When the allocation worker was placed into XFS, even Christoph wanted a 
kernel configure switch to be able turn it off.

Dave has already placed a switch in the code that turns it off for over 
half of the direct callers xfs_alloc_vextent() because a performance issue.

We are just finding places where it causes serious issues.

This is worker is an "necessary evil" (I think those were Christoph's 
review comment). We should limit the evil to where it is necessary.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
