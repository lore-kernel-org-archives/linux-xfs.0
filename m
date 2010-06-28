Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5S9liY4020596 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 04:47:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A0D5114B476
	for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 02:55:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JAuCcDW6ARX8UCIJ for
	<xfs@oss.sgi.com>; Mon, 28 Jun 2010 02:55:12 -0700 (PDT)
Date: Mon, 28 Jun 2010 05:50:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel Panic: Assertion failed: __xfs_iflags_test(ip,
	XFS_IRECLAIMABLE), file: fs/xfs/linux-2.6/xfs_sync.c, line: 727
Message-ID: <20100628095028.GA13389@infradead.org>
References: <20100628092948.323370@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100628092948.323370@gmx.net>
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
To: Steffen Knauf <Steffen.Knauf@gmx.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 28, 2010 at 11:29:48AM +0200, Steffen Knauf wrote:
> hi,
> 
> Hello,
> 
> i have lot's of trouble with a webserver which die with a kernel panic every week. Perhaps someone have an idea? 
> 
> Linux Kernel version: 2.6.33

It's a know issue that has been fixed in -stable since.  Please upgrade
either to the latests 2.6.33-stable release or even better to
2.6.34-stable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
