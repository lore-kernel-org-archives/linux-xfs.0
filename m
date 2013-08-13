Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E0087F51
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 08:28:24 -0500 (CDT)
Message-ID: <520A3474.3070501@sgi.com>
Date: Tue, 13 Aug 2013 08:28:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 44/50] xfs: Reduce allocations during CIL insertion
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-45-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-45-git-send-email-david@fromorbit.com>
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

On 08/12/13 05:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Now that we have the size of the object before the formatting pass
> is called, we can allocation the log vector and it's buffer in a
> single allocation rather than two separate allocations.
>
> Store the size of the allocated buffer in the log vector so that
> we potentially avoid allocation for future modifications of the
> object.
>
> While touching this code, remove the IOP_FORMAT definition.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

...

>
>   		/* Skip items which aren't dirty in this transaction. */
> @@ -150,48 +178,39 @@ xlog_cil_prepare_log_vecs(

...

> +		lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);

Looks good

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
