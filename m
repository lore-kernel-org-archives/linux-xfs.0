Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A9E127F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 13:13:11 -0500 (CDT)
Message-ID: <51F6B0B4.1070508@sgi.com>
Date: Mon, 29 Jul 2013 13:13:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 45/49] xfs: avoid CIL allocation during insert
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-46-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-46-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Now that we have the size of the log vector that has been allocated,
> we can determine if we need to allocate a new log vector for
> formatting and insertion. We only need to allocate a new vector if
> it won't fit into the existing buffer.
>
> However, we need to hold the CIL context lock while we do this so
> that we can't race with a push draining the currently queued log
> vectors. It is safe to do this as long as we do GFP_NOFS allocation
> to avoid avoid memory allocation recursing into the filesystem.
> Hence we can safely overwrite the existing log vector on the CIL if
> it is large enough to hold all the dirty regions of the current
> item.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

back to the CIl commit opt series now that the log space leak has been 
found..

Looks good - avoid allocation if dirtying existing dirty chunks. Remove 
the IOP_PIN

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
