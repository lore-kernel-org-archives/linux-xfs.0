Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UJCEDK185892 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 14:12:14 -0500
Message-ID: <4F76058A.2010602@sgi.com>
Date: Fri, 30 Mar 2012 14:12:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/8] xfs: clean up buffer get/read call API
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-5-git-send-email-david@fromorbit.com>
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

On 03/29/12 07:23, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The xfs_buf_get/read API is not consistent in the units it uses, and
> does not use appropriate or consistent units/types for the
> variables.
>
> Convert the API to use disk addresses and block counts for all
> buffer get and read calls. Use consistent naming for all the
> functions and their declarations, and convert the internal functions
> to use disk addresses and block counts to avoid need to convert them
> from one type to another and back again.
>
> Fix all the callers to use disk addresses and block counts. In many
> cases, this removes an additional conversion from the function call
> as the callers already have a block count.
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
