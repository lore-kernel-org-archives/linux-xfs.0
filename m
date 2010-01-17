Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBw7Fh010075 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:58:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42A321C576A0
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:59:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PXmW0JJhI1nLsh2C for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:59:06 -0800 (PST)
Date: Sun, 17 Jan 2010 06:59:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Clean up build output
Message-ID: <20100117115905.GB16856@infradead.org>
References: <1263384325-15300-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263384325-15300-1-git-send-email-david@fromorbit.com>
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

On Wed, Jan 13, 2010 at 11:05:25PM +1100, Dave Chinner wrote:
> While doing this, remove explicit target-per-file rules in the
> subdirectories being built and replace them with target based rules
> using the buildrules hooks for doing this.  This results in the
> makefiles being simpler, smaller and more consistent.

I agree, but it's also rather unrelated to the output..

A side effect of that rule cleanup seems that we now link all binaries
against all libraries used in a subdirectory.  I don't think it's a
problem, but it's at least worth mentioning.

I'd really prefer if you could split this into two patches, but if
that's too much work consider this reviewed anyway:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
