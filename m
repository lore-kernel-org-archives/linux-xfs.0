Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57949 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731114AbeLUJjU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Dec 2018 04:39:20 -0500
Date: Fri, 21 Dec 2018 10:39:19 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in
 iomap_page_create/release()"
Message-ID: <20181221093919.GA2337@lst.de>
References: <20181220122324.17082-1-david@fromorbit.com> <20181220174130.GA21065@lst.de> <20181220205342.GC4205@dastard> <CAHk-=wgdbrbV+jNUmhJ7KZsR77CY+pUF7EmtxP2mWKnE8ZyFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgdbrbV+jNUmhJ7KZsR77CY+pUF7EmtxP2mWKnE8ZyFSQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@fromorbit.com, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, pjaroszynski@nvidia.com, william.kucharski@oracle.com, stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Dec 20, 2018 at 02:42:15PM -0800, Linus Torvalds wrote:
> Yeah. I already applied the revert. If somebody finds a "duh" moment,
> and an alternate fix gets posted and tested we can revert the revert
> and fix it properly, but for 4.20 (and for xmas) I do think that just
> going back to the previous state is otherwise the right choice.

As far as I can tell the commit simply missed updating the recounts
in the actual migrate callback for which it was added.  The fixed
version looks something like this (still running xfstests):

diff --git a/fs/iomap.c b/fs/iomap.c
index d6bc98ae8d35..20c9c1cadd4e 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -116,6 +116,12 @@ iomap_page_create(struct inode *inode, struct page *page)
 	atomic_set(&iop->read_count, 0);
 	atomic_set(&iop->write_count, 0);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
+
+	/*
+	 * migrate_page_move_mapping() assumes that pages with private data have
+	 * their count elevated by 1.
+	 */
+	get_page(page);
 	set_page_private(page, (unsigned long)iop);
 	SetPagePrivate(page);
 	return iop;
@@ -132,6 +138,7 @@ iomap_page_release(struct page *page)
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
+	put_page(page);
 	kfree(iop);
 }
 
@@ -556,8 +563,10 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
 
 	if (page_has_private(page)) {
 		ClearPagePrivate(page);
+		get_page(newpage);
 		set_page_private(newpage, page_private(page));
 		set_page_private(page, 0);
+		put_page(page);
 		SetPagePrivate(newpage);
 	}
 
