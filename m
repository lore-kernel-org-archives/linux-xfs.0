Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GEYtsT219681 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 09:34:56 -0500
Message-ID: <4F8C2E0D.3040005@sgi.com>
Date: Mon, 16 Apr 2012 09:34:53 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 17/18] xfs: kill XBF_DONTBLOCK
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-18-git-send-email-david@fromorbit.com>
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
> Just about all callers of xfs_buf_read() and xfs_buf_get() use XBF_DONTBLOCK.
> This is used to make memory allocation use GFP_NOFS rather than GFP_KERNEL to
> avoid recursion through memory reclaim back into the filesystem.
>
> All the blocking get calls in growfs occur inside a transaction, even though
> they are no part of the transaction, so all allocation will be GFP_NOFS due to
> the task flag PF_TRANS being set. The blocking read calls occur during log
> recovery, so they will probably be unaffected by converting to GFP_NOFS
> allocations.
>
> Hence make XBF_DONTBLOCK behaviour always occur for buffers and kill the flag.
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
