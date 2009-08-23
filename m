Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7NMouDa084609 for <xfs@oss.sgi.com>; Sun, 23 Aug 2009 17:51:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB7B43F01D2
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2009 15:51:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3peUcbqFJHiecez1 for
	<xfs@oss.sgi.com>; Sun, 23 Aug 2009 15:51:47 -0700 (PDT)
Date: Sun, 23 Aug 2009 18:48:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.26.3 / loop-aes/xfs corruption?
Message-ID: <20090823224838.GB19942@infradead.org>
References: <alpine.DEB.2.00.0908221040220.30321@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908221040220.30321@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Sat, Aug 22, 2009 at 10:44:31AM -0400, Justin Piszcz wrote:
> Hi,
>
> On an older machine:
>
> [2340962.903497] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1545 of file
>  fs/xfs/xfs_alloc.c.  Caller 0xc021ccd8
> [2340962.903497] Pid: 24649, comm: mv Not tainted 2.6.26.3 #1

This is a very typical sign for corruption cause by the lack of write
barriers on enabled write caches.

> [2340962.911473] Filesystem "loop0": Corruption of in-memory data detected.  Shu

And using the loop device is kindof a worsened version of hanving write
caches as we don't just have small disk caches that can fill up but
major amounts of the main memory.

The loop device before 2.6.30 is unfortunately not safe in case of
system crashes.  And given your other report we'll have to see if maybe
the barrier support in 2.6.30 cause other kinds of problems to, although
it could be something else.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
