Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8BDBB7F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:20:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07A86AC004
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 16:20:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AxNBxMUwgDeZBxFA for
	<xfs@oss.sgi.com>; Mon, 10 Jun 2013 16:20:20 -0700 (PDT)
Message-ID: <51B65E82.5030305@redhat.com>
Date: Mon, 10 Jun 2013 19:17:22 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: fsx failure on 3.10.0-rc1+ (xfstests 263) -- Mapped Read: non-zero
	data past EOF
References: <51B5D1EB.9080200@redhat.com> <20130610213100.GC29376@dastard>
In-Reply-To: <20130610213100.GC29376@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/10/2013 05:31 PM, Dave Chinner wrote:
> On Mon, Jun 10, 2013 at 09:17:31AM -0400, Brian Foster wrote:
>> Hi guys,
>>
>> I wanted to get this onto the list... I suspect this could be
>> similar/related to the issue reported here:
>>
>> http://oss.sgi.com/archives/xfs/2013-06/msg00066.html
> 
> Unlikely - generic/263 tests mmap IO vs direct IO, and Sage's
> problem has neither...
> 

Oh, Ok. I didn't look at that one closely enough then.

>> While running xfstests, the only apparent regression I hit from 3.9.0
>> was generic/263. This test fails due to the following command (and
>> resulting output):
> 
> Not a regression - 263 has been failing ever since it was introduced
> in 2011 by:
> 
> commit 0d69e10ed15b01397e8c6fd7833fa3c2970ec024
...
> 
> It is testing mmap() writes vs direct IO, something that is known to
> be fundamentally broken (i.e. racy) as mmap() page fault path does
> not hold the XFS_IOLOCK or i_mutex in any way.  The direct IO path
> tries to wark around this by flushing and invalidating cached pages
> before IO submission, but the lack of locking in the page fault path
> means we can't avoid the race entirely.
> 

Thanks for the explanation.

>> P.S., I also came across the following thread which, if related,
>> suggests this might be known/understood to a degree:
>>
>> http://oss.sgi.com/archives/xfs/2012-04/msg00703.html
> 
> Yup, that's potentially one aspect of it. However, have you run the
> test code on ext3/4? it works just fine - it's only XFS that has
> problems with this case, so it's not clear that this is a DIO
> problem. It was never able to work out where ext3/ext4 were zeroing
> the part of the page beyond EOF, and I couldn't ever make the DIO
> code reliably do the right thing. It's one of the reasons that lead
> to this discussion as LSFMM:
> 
> http://lwn.net/Articles/548351/
> 

Interesting, thanks again. I did happen to run the script and the fsx
test on the ext4 rootfs of my VM and observed expected behavior.

Note that I mentioned this was harder to reproduce with fixed alloc
sizes less than 128k or so. I don't believe ext4 does any kind of
speculative preallocation in the manner that XFS does. Perhaps that is a
factor..?

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
