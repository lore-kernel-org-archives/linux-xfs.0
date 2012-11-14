Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAELQY4S176250 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 15:26:34 -0600
Message-ID: <50A40D03.6040307@sgi.com>
Date: Wed, 14 Nov 2012 15:28:35 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 12/32 V2] xfs: verify AGF blocks as they are read from disk
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-13-git-send-email-david@fromorbit.com>
	<20121114064456.GD1710@dastard>
In-Reply-To: <20121114064456.GD1710@dastard>
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

On 11/14/12 00:44, Dave Chinner wrote:
> xfs: verify AGF blocks as they are read from disk
>
> From: Dave Chinner<dchinner@redhat.com>
>
> Add an AGF block verify callback function and pass it into the
> buffer read functions. This replaces the existing verification that
> is done after the read completes.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> ---
> V2: fix duplicate logic in verifier function.
>

looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
