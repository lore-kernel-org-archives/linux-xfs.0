Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1D3LIk209024 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 07:03:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D92C1C8695E
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 05:05:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6so5STpUVC4BwNKR for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 05:05:05 -0800 (PST)
Date: Wed, 1 Dec 2010 08:05:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/14] xfs: convert log grant heads to LSN notation
Message-ID: <20101201130504.GA18379@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-4-git-send-email-david@fromorbit.com>
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

> -STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
> +STATIC int	 xlog_space_left(int logsize, xfs_lsn_t tail_lsn,
> +				xfs_lsn_t head);

Looking further through the series I have to say I really hate
passing in the logsize instead of the log structure.  Passing the
log pointer from higher level functions just makes a lot more sense.

Also in this case passing the tail_lsn explicitly doesn't make any sense
- it becomes atomic later and thus there is no locking requirement for
it.

> -xlog_grant_sub_space(struct log *log, int bytes)
> +__xlog_grant_sub_space(
> +	xfs_lsn_t	*head,
> +	int		bytes,
> +	int		logsize)

Same thing here - the calling convention would be a lot more regular
by still passing the log as first argument.

After the factoring I also think we could cut down on the amount of
wrappers in this area.  Just rename __xlog_grant_sub_space and
__xlog_grant_add_space to not have the __ prefix, and kill the wrappers
around it - they only have one or two callers, and just having two
helpers and passing the heads we're interested in is a lot simpler and
cleaner.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
