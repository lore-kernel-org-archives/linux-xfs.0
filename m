Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DHujQU079896 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 12:56:45 -0500
Message-ID: <4F8868DA.7040000@sgi.com>
Date: Fri, 13 Apr 2012 12:56:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/18] xfs: check for buffer errors before waiting
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-8-git-send-email-david@fromorbit.com>
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
> If we call xfs_buf_iowait() on a buffer that failed dispatch due to
> an IO error, it will wait forever for an Io that does not exist.
> This is hndled in xfs_buf_read, but there is other code that calls
> xfs_buf_iowait directly that doesn't.
>
> Rather than make the call sites have to handle checking for dispatch
> errors and then checking for completion errors, make
> xfs_buf_iowait() check for dispatch errors on the buffer before
> waiting. This means we handle both dispatch and completion errors
> with one set of error handling at the caller sites.
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
