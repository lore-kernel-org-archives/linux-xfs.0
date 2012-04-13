Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DIWRnQ083782 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 13:32:27 -0500
Message-ID: <4F88713B.7070805@sgi.com>
Date: Fri, 13 Apr 2012 13:32:27 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/18] xfs: fix buffer lookup race on allocation failure
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-7-git-send-email-david@fromorbit.com>
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
> When memory allocation fails to add the page array or tht epages to
> a buffer during xfs_buf_get(), the buffer is left in the cache in a
> partially initialised state. There is enough state left for the next
> lookup on that buffer to find the buffer, and for the buffer to then
> be used without finishing the initialisation.  As a result, when an
> attempt to do IO on the buffer occurs, it fails with EIO because
> there are no pages attached to the buffer.
>
> We cannot remove the buffer from the cache immediately and free it,
> because there may already be a racing lookup that is blocked on the
> buffer lock. Hence the moment we unlock the buffer to then free it,
> the other user is woken and we have a use-after-free situation.
>
> To avoid this race condition altogether, allocate the pages for the
> buffer before we insert it into the cache.  This then means that we
> don't have an allocation  failure case to deal after the buffer is
> already present in the cache, and hence avoid the problem
> altogether.  In most cases we won't have racing inserts for the same
> buffer, and so won't increase the memory pressure allocation before
> insertion may entail.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---



Much simpler idea than v1. Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
