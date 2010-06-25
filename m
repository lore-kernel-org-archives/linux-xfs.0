Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5PAXYpv140158 for <xfs@oss.sgi.com>; Fri, 25 Jun 2010 05:33:35 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AD8F1D6139F
	for <xfs@oss.sgi.com>; Fri, 25 Jun 2010 03:36:17 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ZllTy3DxKRehNZEO for <xfs@oss.sgi.com>;
	Fri, 25 Jun 2010 03:36:17 -0700 (PDT)
Date: Fri, 25 Jun 2010 12:35:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] direct-io: move aio_complete into ->end_io
Message-ID: <20100625103550.GA3586@quack.suse.cz>
References: <20100622122144.302857146@bombadil.infradead.org>
	<20100622123113.011371666@bombadil.infradead.org>
	<20100624215922.GE3345@quack.suse.cz>
	<20100625063610.GA4128@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100625063610.GA4128@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 25-06-10 02:36:10, Christoph Hellwig wrote:
> On Thu, Jun 24, 2010 at 11:59:22PM +0200, Jan Kara wrote:
> >   Moreover the async testing you do does not seem to be completely right.
> > dio->is_async is a flag that controls whether dio code waits for IO to be
> > completed or not. In particular it is not set for AIO that spans beyond
> > current i_size so it does not seem to be exactly what you need (at least
> > for ext4 it isn't). I think that is_sync_kiocb() is a test that should be
> > used to recognize AIO - and that has an advantage that you don't have to
> > pass the is_async flag around.
> 
> No.  is_sync_kiocb() means the ioctb was not intended as sync I/O from
> the start.  But we can only call aio_complete when we returned
> -EIOCBQUEUED from ->aio_read/write.  Take a look at the comment near the
> end of direct_io_worker().
  Ah, I see. Thanks for explanation. It's ugly but I also don't see a
nicer way how to handle this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
