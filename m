Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1DAPuD209478 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 07:10:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44C391BA3EC
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 05:12:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id q64kedN01J7Mzlkm for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 05:12:09 -0800 (PST)
Date: Wed, 1 Dec 2010 08:12:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/14] xfs: introduce new locks for the log grant ticket
	wait queues
Message-ID: <20101201131208.GA22455@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-10-git-send-email-david@fromorbit.com>
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

> +		/* co-ordinate with xfs_log_force_shutdown */
> +		if (XLOG_FORCED_SHUTDOWN(log)) {
> +			spin_unlock(&log->l_grant_reserve_lock);
> +			goto error_return;
> +		}

Where is this coming from?  Otherwise the patch looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
