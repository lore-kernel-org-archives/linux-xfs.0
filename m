Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G6NvDC071804 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 01:24:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4BE91C452F0
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:23:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id i8Rh2V7BLADp8gU6 for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:23:36 -0700 (PDT)
Date: Mon, 16 Mar 2009 02:23:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] [XFSQA] Add simple delayed allocation ENOSPC test.
Message-ID: <20090316062336.GB30641@infradead.org>
References: <1237114181-18431-1-git-send-email-david@fromorbit.com>
	<1237114181-18431-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237114181-18431-3-git-send-email-david@fromorbit.com>
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

On Sun, Mar 15, 2009 at 09:49:40PM +1100, Dave Chinner wrote:
> Using a small (100MB) filesystem and writing lots of
> single block files can result in spurious ENOSPCs
> being reported. Reproduce this test case so we can confirm
> that it gets fixed.

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
