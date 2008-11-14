Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAEHp4tJ012166
	for <linux-xfs@oss.sgi.com>; Fri, 14 Nov 2008 09:51:05 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B598C1B813F9
	for <linux-xfs@oss.sgi.com>; Fri, 14 Nov 2008 09:51:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BP3R7y6v79rscg1l for
	<linux-xfs@oss.sgi.com>; Fri, 14 Nov 2008 09:51:03 -0800 (PST)
Date: Fri, 14 Nov 2008 12:50:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: kernel BUG at fs/buffer.c:471! with 2.6.27.6
Message-ID: <20081114175031.GA11737@infradead.org>
References: <gfjqlf$kpt$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <gfjqlf$kpt$1@ger.gmane.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 12:24:19PM +0000, Alessandro Bono wrote:
> Hi all
> 
> second time I hit this bug, first time with 2.6.26.6 (reported to xfs ml 
> without response)
> Condition are similar: rsync from remote server via ssh to a local usb hd 
> with a xfs filesystem but connection this time is with a wired ethernet 
> not wifi
> Tell me if you need other info
> 
> kernel BUG at fs/buffer.c:471!

In 2.6.27.6 line 471 in fs/buffer.c is inside write and looks like this:

	first = page_buffers(page)

and page_buffers is defined as:

#define page_buffers(page)                              \
({                                                      \
	BUG_ON(!PagePrivate(page));			\
	((struct buffer_head *)page_private(page));     \
})

So we get a page without page_private set.

Now XFS always creates buffers in writepage when it doesn't have those
yet using the VFS helper create_empty_buffers which calls
attach_page_buffers, which sets the page private flag.


Given that the binary 3d driver always caused random VM problems can you
try to reproduce it with one loaded?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
