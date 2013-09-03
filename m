Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A81B87F50
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 15:04:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 953758F8035
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:04:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IxqgZay50lieZ37f for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 13:04:03 -0700 (PDT)
Date: Wed, 4 Sep 2013 06:04:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: fix some new memory allocation failures
Message-ID: <20130903200401.GF23571@dastard>
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
	<5224C4E9.8080604@sgi.com> <20130902222004.GI12779@dastard>
	<5225DF07.4080509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5225DF07.4080509@sgi.com>
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

On Tue, Sep 03, 2013 at 08:07:19AM -0500, Mark Tinguely wrote:
> On 09/02/13 17:20, Dave Chinner wrote:
> >On Mon, Sep 02, 2013 at 12:03:37PM -0500, Mark Tinguely wrote:
> >>On 09/02/13 05:52, Dave Chinner wrote:
> >>>Hi folks,
> >>>
> >>>These failures are a result of order-4 allocations being done on v5
> >>>filesystems to support the large ACL count xattrs. The first patch
> >>>puts out usual falbback to vmalloc workaround in place. The second
> >>>patch factors all the places we now have this fallback-to-vmalloc
> >>>and makes it transparent to the callers.
> >>>
> >>>Cheers,
> >>>
> >>>Dave.
> >>
> >>Thanks for clean up. Broken record time: Do we really need order
> >>allocation in the filesystem? Esp in xfs_ioctl.c.
> >
> >I don't understand your question. Are you asking why we need high
> >order allocation?
> >
> >Cheers,
> >
> >Dave.
> 
> In patch 2, why not drop the physically contiguous allocation
> attempt and just do the virtually contiguous allocation?

Because:

	a) virtual memory space is extremely limited on some
	platforms - we regularly get people reporting that they've
	exhausted vmalloc space on 32 bit systems.
	b) when there is free contiguous memory, allocating that
	contiguous memory is much faster than allocating
	virtual memory.
	c) virtual memory access is slower than physical memory
	access and it puts pressure on the page tables.

IOWs, we want to avoid allocating virtual memory if at all possible.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
