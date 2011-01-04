Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p048JQrm207440 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 02:19:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F11EE161AE0E
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 00:21:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cEhvrDiRnBPGg9Nv for
	<xfs@oss.sgi.com>; Tue, 04 Jan 2011 00:21:33 -0800 (PST)
Date: Tue, 4 Jan 2011 03:21:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: ensure log covering transactions are synchronous
Message-ID: <20110104082130.GA29016@infradead.org>
References: <1294116569-15052-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294116569-15052-1-git-send-email-david@fromorbit.com>
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

Ok, my fault for asking to avoid stalling xfssyncd.

> Fix this by making the log covering transaction synchronous. To
> avoid additional log force from xfssyncd, make the log covering
> transaction take the place of the existing log force in the xfssyncd
> background sync process.

This also looks correct to me.  We replace a force with a lsn-force, but
given that we just started the transaction those should be equivalent.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
