Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44JsdBV080789 for <xfs@oss.sgi.com>; Fri, 4 May 2012 14:54:39 -0500
Message-ID: <4FA433FF.9070405@sgi.com>
Date: Fri, 04 May 2012 14:54:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/10] xfs: remove struct xfs_dabuf and infrastructure
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-10-git-send-email-david@fromorbit.com>
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

On 04/24/12 01:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The struct xfs_dabuf now only tracks a single xfs_buf and all the
> information it holds can be gained directly from the xfs_buf. Hence
> we can remove the struct dabuf and pass the xfs_buf around
> everywhere.
>
> Kill the struct dabuf and the associated infrastructure.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

wow, that must have been fun...


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
