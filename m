Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GFxoCq226624 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 10:59:50 -0500
Message-ID: <4F8C41F3.7020005@sgi.com>
Date: Mon, 16 Apr 2012 10:59:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/18] xfs: Use preallocation for inodes with extsz hints
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-6-git-send-email-david@fromorbit.com>
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

On 04/13/12 07:10, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfstest 229 exposes a problem with buffered IO, delayed allocation
> and extent size hints. That is when we do delayed allocation during
> buffered IO, we reserve space for the extent size hint alignment and
> allocate the physical space to align the extent, but we do not zero
> the regions of the extent that aren't written by the write(2)
> syscall. The result is that we expose stale data in unwritten
> regions of the extent size hints.
>
> There are two ways to fix this. The first is to detect that we are
> doing unaligned writes, check if there is already a mapping or data
> over the extent size hint range, and if not zero the page cache
> first before then doing the real write. This can be very expensive
> for large extent size hints, especially if the subsequent writes
> fill then entire extent size before the data is written to disk.
>
> The second, and simpler way, is simply to turn off delayed
> allocation when the extent size hint is set and use preallocation
> instead. This results in unwritten extents being laid down on disk
> and so only the written portions will be converted. This matches the
> behaviour for direct IO, and will also work for the real time
> device. The disadvantage of this approach is that for small extent
> size hints we can get file fragmentation, but in general extent size
> hints are fairly large (e.g. stripe width sized) so this isn't a big
> deal.
>
> Implement the second approach as it is simple and effective.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
