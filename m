Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DLKXRP099774 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 16:20:33 -0500
Message-ID: <4F88989D.7030801@sgi.com>
Date: Fri, 13 Apr 2012 16:20:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 15/18] xfs: kill XBF_LOCK
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-16-git-send-email-david@fromorbit.com>
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
> Buffers are always returned locked from the lookup routines. Hence
> we don't need to tell the lookup routines to return locked buffers,
> on to try and lock them. Remove XBF_LOCK from all the callers and
> from internal buffer cache usage.
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
