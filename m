Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PKvd4V245783 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:57:40 -0500
Subject: Re: [PATCH 2/6] vmap: flush vmap aliases when mapping fails
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1300860870-15471-3-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-3-git-send-email-david@fromorbit.com>
Date: Fri, 25 Mar 2011 16:00:43 -0500
Message-ID: <1301086843.2537.680.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On 32 bit systems, vmalloc space is limited and XFS can chew through
> it quickly as the vmalloc space is lazily freed. This can result in
> failure to map buffers, even when there is apparently large amounts
> of vmalloc space available. Hence, if we fail to map a buffer, purge
> the aliases that have not yet been freed to hopefuly free up enough
> vmalloc space to allow a retry to succeed.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
