Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAFGT4pb004941
	for <linux-xfs@oss.sgi.com>; Sat, 15 Nov 2008 08:29:05 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EA361B82380
	for <linux-xfs@oss.sgi.com>; Sat, 15 Nov 2008 08:29:03 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168])
	by cuda.sgi.com with ESMTP id pG8lViLyx7NC7mxZ for
	<linux-xfs@oss.sgi.com>; Sat, 15 Nov 2008 08:29:03 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id k3so115536ugf.9
	for <linux-xfs@oss.sgi.com>; Sat, 15 Nov 2008 08:29:02 -0800 (PST)
Subject: Re: kernel BUG at fs/buffer.c:471! with 2.6.27.6
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <20081114175031.GA11737@infradead.org>
References: <gfjqlf$kpt$1@ger.gmane.org> <20081114175031.GA11737@infradead.org>
Date: Sat, 15 Nov 2008 14:44:19 +0100
Message-Id: <1226756659.12440.7.camel@champagne.cantina>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 12:50 -0500, Christoph Hellwig wrote:
> On Fri, Nov 14, 2008 at 12:24:19PM +0000, Alessandro Bono wrote:
> > Hi all
> > 
> > second time I hit this bug, first time with 2.6.26.6 (reported to xfs ml 
> > without response)
> > Condition are similar: rsync from remote server via ssh to a local usb hd 
> > with a xfs filesystem but connection this time is with a wired ethernet 
> > not wifi
> > Tell me if you need other info
> > 
> > kernel BUG at fs/buffer.c:471!
> 
> In 2.6.27.6 line 471 in fs/buffer.c is inside write and looks like this:
> 
> 	first = page_buffers(page)
> 
> and page_buffers is defined as:
> 
> #define page_buffers(page)                              \
> ({                                                      \
> 	BUG_ON(!PagePrivate(page));			\
> 	((struct buffer_head *)page_private(page));     \
> })
> 
> So we get a page without page_private set.
> 
> Now XFS always creates buffers in writepage when it doesn't have those
> yet using the VFS helper create_empty_buffers which calls
> attach_page_buffers, which sets the page private flag.
> 
> 
> Given that the binary 3d driver always caused random VM problems can you
> try to reproduce it with one loaded?

Hi Christoph

I switched from fglrx to radeon and I'll try to reproduce this bug (I
didn't know my card is supported form normal radeon driver), but it's
not easy to hit. I'll report back if I can recreate the same condition

Thanks for your response

---

Cordiali Saluti
Alessandro Bono

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
