Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PC2AWf052621 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 06:02:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B745C135E0F5
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 04:03:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xA1iSyLdZlDZvfHa for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 04:03:14 -0800 (PST)
Date: Mon, 25 Jan 2010 07:03:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] xfs: Use delay write promotion for dquot flushing
Message-ID: <20100125120314.GF8595@infradead.org>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264400564-19704-6-git-send-email-david@fromorbit.com>
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

On Mon, Jan 25, 2010 at 05:22:42PM +1100, Dave Chinner wrote:
> xfs_qm_dqflock_pushbuf_wait() does a very similar trick to item
> pushing used to do to flush out delayed write dquot buffers. Change
> it to use the new promotion method rather than an async flush.
> 
> Also, xfs_qm_dqflock_pushbuf_wait() can return without the flush lock
> held, yet the callers make the assumption that after this call the
> flush lock is held. Always return with the flush lock held.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

This also removes the last user of xfs_bawrite, so you might want to
kill it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
