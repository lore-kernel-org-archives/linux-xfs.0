Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38364 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfGaR7T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 13:59:19 -0400
Date: Wed, 31 Jul 2019 10:59:19 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC 0/2] iomap & xfs support for large pages
Message-ID: <20190731175919.GF4700@bombadil.infradead.org>
References: <20190731171734.21601-1-willy@infradead.org>
 <CAPhsuW66e=7g+rPhi3NU8jQRGqQEz0oQ5XJerg6ds=oxMz8U1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW66e=7g+rPhi3NU8jQRGqQEz0oQ5XJerg6ds=oxMz8U1g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Song Liu <liu.song.a23@gmail.com>
Cc: William Kucharski <william.kucharski@oracle.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Wed, Jul 31, 2019 at 10:50:40AM -0700, Song Liu wrote:
> On Wed, Jul 31, 2019 at 10:17 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> >
> > Christoph sent me a patch a few months ago called "XFS THP wip".
> > I've redone it based on current linus tree, plus the page_size() /
> > compound_nr() / page_shift() patches currently found in -mm.  I fixed
> > the logic bugs that I noticed in his patch and may have introduced some
> > of my own.  I have only compile tested this code.
> 
> Would Bill's set work on XFS with this set?

If there are no bugs in his code or mine ;-)

It'd also need to be wired up; something like this:

+++ b/fs/xfs/xfs_file.c
@@ -1131,6 +1131,8 @@ __xfs_filemap_fault(
        } else {
                if (write_fault)
                        ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
+               else if (pe_size)
+                       ret = filemap_huge_fault(vmf, pe_size);
                else
                        ret = filemap_fault(vmf);
        }
@@ -1156,9 +1158,6 @@ xfs_filemap_huge_fault(
        struct vm_fault         *vmf,
        enum page_entry_size    pe_size)
 {
-       if (!IS_DAX(file_inode(vmf->vma->vm_file)))
-               return VM_FAULT_FALLBACK;
-
        /* DAX can shortcut the normal fault path on write faults! */
        return __xfs_filemap_fault(vmf, pe_size,
                        (vmf->flags & FAULT_FLAG_WRITE));

(untested)
