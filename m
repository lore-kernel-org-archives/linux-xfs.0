Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9LeYt180310 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:21:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18DA1F1ECB0
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:22:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aEZiLXfuxF3jX3bn for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:22:40 -0800 (PST)
Date: Tue, 19 Jan 2010 04:22:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: suppress spurious uninitialised var warning
	in xfs_bmapi()
Message-ID: <20100119092240.GC1784@infradead.org>
References: <1263861711-13900-1-git-send-email-david@fromorbit.com>
	<1263861711-13900-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263861711-13900-2-git-send-email-david@fromorbit.com>
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

On Tue, Jan 19, 2010 at 11:41:50AM +1100, Dave Chinner wrote:
> Initialise the xfs_bmalloca_t structure to zero to avoid uninitialised
> variable warnings. This is done by zeroing the arg structure rather than
> using the uninitialised_var() trick so we know for certain that the
> structure is correctly initialised as xfs_bmapi is a very complex
> function and it is difficult to prove warnings are spurious.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
