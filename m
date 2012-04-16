Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GFAobS224140 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 10:10:50 -0500
Message-ID: <4F8C3678.6030306@sgi.com>
Date: Mon, 16 Apr 2012 10:10:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 18/18] xfs: use iolock on XFS_IOC_ALLOCSP calls
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-19-git-send-email-david@fromorbit.com>
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

On 04/13/12 07:11, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> fsstress has a particular effective way of stopping debug XFS
> kernels. We keep seeing assert failures due finding delayed
> allocation extents where there should be none. This shows up when
> extracting extent maps and we are holding all the locks we should be
> to prevent races, so this really makes no sense to see these errors.
>
> After checking that fsstress does not use mmap, it occurred to me
> that fsstress uses something that no sane application uses - the
> XFS_IOC_ALLOCSP ioctl interfaces for preallocation. These interfaces
> do allocation of blocks beyond EOF without using preallocation, and
> then call setattr to extend and zero the allocated blocks.
>
> THe problem here is this is a buffered write, and hence the
> allocation is a delayed allocation. Unlike the buffered IO path, the
> allocation and zeroing are not serialised using the IOLOCK. Hence
> the ALLOCSP operation can race with operations holding the iolock to
> prevent buffered IO operations from occurring.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
