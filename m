Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41650 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753528AbdIDMal (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Sep 2017 08:30:41 -0400
Date: Mon, 4 Sep 2017 14:30:39 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: kernel BUG at fs/xfs/xfs_aops.c:853! in kernel 4.13 rc6
Message-ID: <20170904123039.GA5664@quack2.suse.cz>
References: <CABXGCsOL+_OgC0dpO1+Zeg=iu7ryZRZT4S7k-io8EGB0ZRgZGw@mail.gmail.com>
 <20170903074306.GA8351@infradead.org>
 <CABXGCsMmEvEh__R2L47jqVnxv9XDaT_KP67jzsUeDLhF2OuOyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABXGCsMmEvEh__R2L47jqVnxv9XDaT_KP67jzsUeDLhF2OuOyA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun 03-09-17 19:08:54, Михаил Гаврилов wrote:
> On 3 September 2017 at 12:43, Christoph Hellwig <hch@infradead.org> wrote:
> >
> > This is:
> >
> >         bh = head = page_buffers(page);
> >
> > Which looks odd and like some sort of VM/writeback change might
> > have triggered that we get a page without buffers, despite always
> > creating buffers in iomap_begin/end and page_mkwrite.
> >
> > Ccing linux-mm if anything odd happen in that area recently.
> >
> > Can you tell anything about the workload you are running?
> >
> 
> On XFS partition stored launched KVM VM images, + home partition with
> Google Chrome profiles.
> Seems the bug triggering by high memory consumption and using swap
> which two times larger than system memory.
> I saw that it happens when swap has reached size of system memory.

Can you reproduce this? I've seen one occurence of this on our distro
4.4-based kernel but we were never able to reproduce and find the culprit.
If you can reproduce, could you run with the attached debug patch to see
whether the WARN_ON triggers? Because my suspicion is that there is some
subtle race in page table teardown vs writeback vs page reclaim which can
result in page being dirtied without filesystem being notified about it (I
have seen very similar oops for ext4 as well which leads me to suspicion
this is a generic issue). Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--vkogqOf2sHV7VnPd
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfs-Debug-when-page-can-get-dirty-without-buffers.patch"

>From 6161b656c3c1df43bc552a60056bc12d7913a90b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 4 Sep 2017 14:26:38 +0200
Subject: [PATCH] xfs: Debug when page can get dirty without buffers

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_aops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6bf120bb1a17..117535086bc7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1380,6 +1380,7 @@ xfs_vm_set_page_dirty(
 	offset = page_offset(page);
 
 	spin_lock(&mapping->private_lock);
+	WARN_ON_ONCE(!page_has_buffers(page));
 	if (page_has_buffers(page)) {
 		struct buffer_head *head = page_buffers(page);
 		struct buffer_head *bh = head;
-- 
2.12.3


--vkogqOf2sHV7VnPd--
