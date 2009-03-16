Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G6Rvpx072095 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 01:28:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE4A41C452FF
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:27:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Hy7g8WfPinZ8jgCR for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:27:36 -0700 (PDT)
Date: Mon, 16 Mar 2009 02:27:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] [XFSQA] Test writing to ENOSPC
Message-ID: <20090316062706.GC30641@infradead.org>
References: <1237114181-18431-1-git-send-email-david@fromorbit.com>
	<1237114181-18431-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237114181-18431-4-git-send-email-david@fromorbit.com>
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

On Sun, Mar 15, 2009 at 09:49:41PM +1100, Dave Chinner wrote:
> Use larger files and different writing styles to fill
> a 100MB filesystem to being full. In each case we should
> get very close to the filesystem being full before getting
> ENOSPC. THis tests different types of ENOSPC failures to
> test 203 and requires more changes to pass.

Looks good.   But don't we actually need a trap handler to unmount the
scratch partitions if the test gets intterupted?  I always added them
to my tests, copying that fragment from older patches.  (also applies
to the previous patch)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
