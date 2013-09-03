Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 376027F4E
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 08:07:23 -0500 (CDT)
Message-ID: <5225DF07.4080509@sgi.com>
Date: Tue, 03 Sep 2013 08:07:19 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: fix some new memory allocation failures
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
	<5224C4E9.8080604@sgi.com> <20130902222004.GI12779@dastard>
In-Reply-To: <20130902222004.GI12779@dastard>
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

On 09/02/13 17:20, Dave Chinner wrote:
> On Mon, Sep 02, 2013 at 12:03:37PM -0500, Mark Tinguely wrote:
>> On 09/02/13 05:52, Dave Chinner wrote:
>>> Hi folks,
>>>
>>> These failures are a result of order-4 allocations being done on v5
>>> filesystems to support the large ACL count xattrs. The first patch
>>> puts out usual falbback to vmalloc workaround in place. The second
>>> patch factors all the places we now have this fallback-to-vmalloc
>>> and makes it transparent to the callers.
>>>
>>> Cheers,
>>>
>>> Dave.
>>
>> Thanks for clean up. Broken record time: Do we really need order
>> allocation in the filesystem? Esp in xfs_ioctl.c.
>
> I don't understand your question. Are you asking why we need high
> order allocation?
>
> Cheers,
>
> Dave.

In patch 2, why not drop the physically contiguous allocation attempt 
and just do the virtually contiguous allocation?

Things that now call kmem_zalloc_large() do not need a physically 
contiguous memory, it will simplify the allocation, it will leave the 
physically contiguous pieces for other Linux code that really need it.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
