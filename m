Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1QGxmAT261227
	for <linux-xfs@oss.sgi.com>; Thu, 26 Feb 2009 10:59:49 -0600
Received: from atrey.karlin.mff.cuni.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78C471585A0
	for <linux-xfs@oss.sgi.com>; Thu, 26 Feb 2009 08:59:18 -0800 (PST)
Received: from atrey.karlin.mff.cuni.cz (atrey.karlin.mff.cuni.cz
	[195.113.26.193]) by cuda.sgi.com with ESMTP id
	L4pbLmHMc5R4sNBz for <linux-xfs@oss.sgi.com>;
	Thu, 26 Feb 2009 08:59:18 -0800 (PST)
Date: Thu, 26 Feb 2009 17:59:16 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090226165916.GB9602@atrey.karlin.mff.cuni.cz>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org>
	<20090210104304.GP8830@disturbed>
	<1234432077.9204.15.camel@champagne.cantina>
	<20090226165838.GA9602@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20090226165838.GA9602@atrey.karlin.mff.cuni.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Argh, forgot the patch...

> > On Tue, 2009-02-10 at 21:43 +1100, Dave Chinner wrote:
> > > On Mon, Feb 09, 2009 at 02:53:08AM -0500, Christoph Hellwig wrote:
> > > > On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > > > > sure, attached
> > > > 
> > > > That would be a missing PagePrivate bit in page_buffers() called from
> > > > end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> > > > which requires the page not having PG_writeback set which must be
> > > > set until end_buffer_async_write is done.  Very strange, and all this
> > > > is generic code without xfs involvement.  Did this happen once
> > > > or can you reproduce it?
> > > 
> > > Hmmmm - i wonder if this has anything to do with the writeback fixes
> > > that went into 2.6.28.2? Alessandro, can you revert to 2.6.28.1 (not
> > > plain 2.6.28) and see if you can reproduce the problem?
> > 
> > another test another bug
> > kernel 2.6.29-rc4-git4 with DEBUG_PAGEALLOC and CONFIG_DEBUG_LIST
> > enabled (idea taken from a totally unrelated mail from Ingo Molnar to
> > catch a memory corruption), usual bug attached
> > 2.6.27 from ubuntu not survived to rsync
> > 
> > btw my first report of a similar problem was with a kernel 2.6.26.6 but
> > at time I was using binary driver for my radeon card and Christoph
> > suggest me that I have to recreate problem without any binary driver
> > maybe it's not a recent regression, it's simply easier to hit with a
> > newer kernel
> > 
> > I don't have abandoned idea of a hardware problem but I don't know how
> > to be sure
> > 
> > any suggestion?
>   Hmm, are you still able to reproduce the problem? As I'm looking into
> registers in your dump, no register really seems to contain sensible page
> flags so it could be some corruption of page pointer. If you are still
> able to reproduce, could you please do so with the attached patch
> applied? It will dump us much more information... Thanks.
> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.cz>
> SuSE CR Labs
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--NzB8fVQJ5HfG6fxh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Add-debuging-info.patch"

>From 289408c005dc2ffce2fb495bd5d76a4eeda9190a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 17:56:32 +0100
Subject: [PATCH] Add debuging info.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9f69741..1d42c02 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -531,6 +531,14 @@ static void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 		SetPageError(page);
 	}
 
+	if (!PagePrivate(page)) {
+		printk("Buffer %p of page %p not private! Some data to debug:\n", bh, page);
+		printk("flags: %lx, mapping: %p, index: %ld, private: %lx\n", page->flags, page->mapping, page->index, page->private);
+		printk("Buffer: state=%lx, block=%llu, b_size=%lu, b_this_page=%p\n", bh->b_state, (unsigned long long)bh->b_blocknr, (unsigned long)bh->b_size, bh->b_this_page);
+		printk("Other buffers in the page:\n");
+		for (tmp = bh->b_this_page; tmp != bh; tmp = tmp->b_this_page)
+			printk("Buffer %p: state=%lx, block=%llu, b_size=%lu, b_page=%p\n", tmp, tmp->b_state, (unsigned long long)tmp->b_blocknr, (unsigned long)tmp->b_size, tmp->b_page);
+	}
 	first = page_buffers(page);
 	local_irq_save(flags);
 	bit_spin_lock(BH_Uptodate_Lock, &first->b_state);
-- 
1.6.0.2


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--NzB8fVQJ5HfG6fxh--
