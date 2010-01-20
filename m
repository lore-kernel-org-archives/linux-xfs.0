Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K8R9Pn253990 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 02:27:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F13C8F2615D
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:28:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id W9ti6LwcqPELKBoQ for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:28:09 -0800 (PST)
Date: Wed, 20 Jan 2010 03:28:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfstests: Don't use tempnam in growfiles.c
Message-ID: <20100120082809.GC6721@infradead.org>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
	<1263958688-435-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263958688-435-4-git-send-email-david@fromorbit.com>
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

On Wed, Jan 20, 2010 at 02:38:03PM +1100, Dave Chinner wrote:
> tempnam() generates a compiler warning as a dangerous function.
> This code doesn't care about security issues with tempnam, so
> remove it and just manually build the filenames without the
> randomness of tempnam.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>


Btw, I wonder if we should sync back changes to the ltp/* files to LTP..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
