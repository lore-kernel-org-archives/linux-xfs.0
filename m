Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAUGgVcM124967 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 10:42:34 -0600
Date: Tue, 30 Nov 2010 11:44:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: ensure uint64_t is defined for <linux/fs.h>
Message-ID: <20101130164413.GA28205@infradead.org>
References: <1291068840.2425.15.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291068840.2425.15.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, Nov 29, 2010 at 04:14:00PM -0600, Alex Elder wrote:
> When compiling "fiemap-tester.c" in my environment, I am
> getting complaints at the first reference to "uint64_t"
> in <linux/fs.h>.  This simple patch resolves that.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

This should be fixed again by newer kernels, but given that the fix is
entirely harmless I'm fine with it.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
