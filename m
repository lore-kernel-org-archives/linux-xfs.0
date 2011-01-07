Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p078hB6Q015675 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 02:43:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63513F10254
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 00:45:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id C45BDDGEuiNjIqG2 for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 00:45:20 -0800 (PST)
Date: Fri, 7 Jan 2011 03:45:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfs: ensure sync write errors are returned
Message-ID: <20110107084518.GA10829@infradead.org>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294116518-14908-2-git-send-email-david@fromorbit.com>
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

> +		if (ret == -ENOSPC && !enospc) {
> +			ssize_t ret2 = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
> +			if (ret2) {
> +				ret = ret2;
>  				goto out_unlock_internal;
> +			}
>  			enospc = 1;
>  			goto write_retry;
>  		}

I don't think there is any reason for the ret2 variale here.  If it's
non-zero we assign it to ret, and if it's zero we overwrite it again
after jumping to the write_retry label.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
