Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBSHGmqS201965
	for <linux-xfs@oss.sgi.com>; Wed, 28 Dec 2011 11:16:49 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Uh5dSShiFAxeu6JA for <linux-xfs@oss.sgi.com>;
	Wed, 28 Dec 2011 09:16:43 -0800 (PST)
Date: Wed, 28 Dec 2011 12:16:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bug in fs/xfs/xfs_aops.c:959! (kernel 3.1.5)
Message-ID: <20111228171643.GA18895@infradead.org>
References: <jcn0ip$hsk$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <jcn0ip$hsk$1@dough.gmane.org>
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
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-xfs@oss.sgi.com

On Mon, Dec 19, 2011 at 09:36:24AM +0000, Jeremy Sanders wrote:
> Hello - this was just produced in kernel 3.1.5 (Fedora 16, x86-64, 
> kernel-3.1.5-1.fc16.x86_64).

Line 959 in 3.1.5 is this:

        bh = head = page_buffers(page);

page_buffers expands to:

#define page_buffers(page)                                      \
	({                                                      \
		BUG_ON(!PagePrivate(page));			\
		((struct buffer_head *)page_private(page));     \
	})

so what we got here is a page without buffers.  Very odd.


[<ffffffff8111dec7>]  __writepage+0x17/0x40
[<ffffffff8111e32d>]  write_cache_pages+0x20d/0x460
[<ffffffff8111e5ca>]  generic_writepages+0x4a/0x70
[<ffffffffa02eb8fd>]  xfs_vm_writepages+0x4d/0x60 [xfs]
[<ffffffff8111f8d1>]  do_writepages+0x21/0x40
[<ffffffff81198af9>]  writeback_single_inode+0x149/0x3e0
[<ffffffff81198f30>]  writeback_sb_inodes+0x1a0/0x240
[<ffffffff8119906e>]  __writeback_inodes_wb+0x9e/0xd0
[<ffffffff8119a25b>]  wb_writeback+0x25b/0x340
[<ffffffff8119a7b3>]  wb_do_writeback+0x1c3/0x200
[<ffffffff8119a873>]  bdi_writeback_thread+0x83/0x2a0
[<ffffffff8108ddbc>]  kthread+0x8c/0xa0
[<ffffffff815d9974>]  kernel_thread_helper+0x4/0x10

And this looks like an entirely normal callchain for the flusher thread.

Something must have set the page dirty without going through the normal
XFS codepath.  Did you use any interesting virtualization things, or
utrace / systemtap or anything odd?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
