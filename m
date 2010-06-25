Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5P6XVYf133128 for <xfs@oss.sgi.com>; Fri, 25 Jun 2010 01:33:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9324240319C
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 23:36:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H8AiEmiaCM3qBQmO for
	<xfs@oss.sgi.com>; Thu, 24 Jun 2010 23:36:14 -0700 (PDT)
Date: Fri, 25 Jun 2010 02:36:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] direct-io: move aio_complete into ->end_io
Message-ID: <20100625063610.GA4128@infradead.org>
References: <20100622122144.302857146@bombadil.infradead.org>
	<20100622123113.011371666@bombadil.infradead.org>
	<20100624215922.GE3345@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100624215922.GE3345@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 24, 2010 at 11:59:22PM +0200, Jan Kara wrote:
>   Umm, I don't get this. Looking at the ->end_io callback it has been
> always called with i_alloc_sem held. It's only aio_complete() which will
> be called with i_alloc_sem held after your changes. Or am I missing
> something?

No, that part of the commit message is flat out wrong.  Not sure what
I was thinking when I wrote it.

>   Moreover the async testing you do does not seem to be completely right.
> dio->is_async is a flag that controls whether dio code waits for IO to be
> completed or not. In particular it is not set for AIO that spans beyond
> current i_size so it does not seem to be exactly what you need (at least
> for ext4 it isn't). I think that is_sync_kiocb() is a test that should be
> used to recognize AIO - and that has an advantage that you don't have to
> pass the is_async flag around.

No.  is_sync_kiocb() means the ioctb was not intended as sync I/O from
the start.  But we can only call aio_complete when we returned
-EIOCBQUEUED from ->aio_read/write.  Take a look at the comment near the
end of direct_io_worker().

AIO beyond i_size is not supported using blockdev_direct_IO yet.  I
think I can add it fairly easily for XFS, but that will require
passing a new DIO_* flag to __blockdev_direct_IO which will make
is_async true for writes beyond i_size.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
