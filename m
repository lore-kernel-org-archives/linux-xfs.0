Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3CDNxM8166564 for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 08:23:59 -0500
Message-ID: <4F86D76C.5090805@sgi.com>
Date: Thu, 12 Apr 2012 08:23:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: kill XBF_LOCK
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
	<1334052213-26870-2-git-send-email-david@fromorbit.com>
	<4F844B02.2030301@sgi.com> <20120410222027.GR18323@dastard>
	<20120411200729.GJ28816@infradead.org>
In-Reply-To: <20120411200729.GJ28816@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 04/11/12 15:07, Christoph Hellwig wrote:
> On Wed, Apr 11, 2012 at 08:20:27AM +1000, Dave Chinner wrote:
>>> The reason I ask, the sources that I have for xfs_buf_get() seems to
>>> still have a "goto no_buffer" for the failed
>>> xfs_buf_allocate_memory() call and this patch removes that call. I
>>> did not find anything in the 8 buf clean-up series that would alter
>>> this area.
>>
>> I'm sure I posted it previously. Let me update all the reviewed-by
>> tags and I'll resend the entire series....
>
> I think Mark meant the patch to fix the error handling for failed
> allocation, which needs to be redone to only insert the buffer into the
> rbtree once it's fully set up.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

That is correct.

The series in general looked good to me.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
