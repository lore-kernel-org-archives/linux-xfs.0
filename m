Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0O8uNIf072132 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 02:56:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57B4A28A642
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 00:58:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ShboWafvWyutuZdq for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 00:58:46 -0800 (PST)
Date: Mon, 24 Jan 2011 03:58:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] libxfs: reintroduce old xfs_repair radix-tree code
Message-ID: <20110124085845.GA26744@infradead.org>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294649091-27174-2-git-send-email-david@fromorbit.com>
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

On Mon, Jan 10, 2011 at 07:44:49PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current kernel code uses radix trees more widely than the
> previous code, so for the next sync we need radix tree support in
> libxfs. Pull the old radix tree code out the xfs_repair git history
> and move it into libxfs to simplify the kernel code sync.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
