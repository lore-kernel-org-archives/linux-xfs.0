Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0O94YN5073824 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 03:04:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A20728A933
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 01:06:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bBjk9XWNnZiaMegB for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 01:06:56 -0800 (PST)
Date: Mon, 24 Jan 2011 04:06:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: limit extsize to size of AGs and/or MAXEXTLEN
Message-ID: <20110124090656.GE26744@infradead.org>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
	<1295411400-15614-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295411400-15614-5-git-send-email-david@fromorbit.com>
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

On Wed, Jan 19, 2011 at 03:29:59PM +1100, Dave Chinner wrote:
> +		 * Also, for non-realtime files, limit the extent size hint to
> +		 * half the size of the AGs in the filesystem so alignment
> +		 * doesn't result in extents larger than an AG.

What do we do about the last AG, which potentionally is smaller than the
others?

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
