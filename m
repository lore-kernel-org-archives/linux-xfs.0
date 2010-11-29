Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATCsLTT162963 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 06:54:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC4621B0E80
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 04:56:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DGlHM1OaruPGIxO4 for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 04:56:03 -0800 (PST)
Date: Mon, 29 Nov 2010 07:56:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] xfs: buffer cache shrinker overhaul V2
Message-ID: <20101129125601.GA14222@infradead.org>
References: <1290992339-20849-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290992339-20849-1-git-send-email-david@fromorbit.com>
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

On Mon, Nov 29, 2010 at 11:58:56AM +1100, Dave Chinner wrote:
> This series effectively means that the buffer cache can now be made
> independent of the page cache as we now have our own optimised
> buffer cache reclaim mechanisms.

What happened to that part of the first series?  Implementing the
sub-page blocksize support using kmalloc should be fairly straight
forward.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
