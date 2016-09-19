Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36339 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936649AbcISDIj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Sep 2016 23:08:39 -0400
Date: Mon, 19 Sep 2016 13:08:30 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160919130830.14bde3b0@roar.ozlabs.ibm.com>
In-Reply-To: <20160918053337.GA32207@ZenIV.linux.org.uk>
References: <20160908235521.GL2356@ZenIV.linux.org.uk>
        <20160909015324.GD30056@dastard>
        <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
        <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
        <20160909023452.GO2356@ZenIV.linux.org.uk>
        <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
        <20160909221945.GQ2356@ZenIV.linux.org.uk>
        <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
        <20160914031648.GB2356@ZenIV.linux.org.uk>
        <20160914133925.2fba4629@roar.ozlabs.ibm.com>
        <20160918053337.GA32207@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org

On Sun, 18 Sep 2016 06:33:52 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> [finally Cc'd to fsdevel - should've done that several iterations upthread]
> 
> On Wed, Sep 14, 2016 at 01:39:25PM +1000, Nicholas Piggin wrote:
> 
> > Should not be so bad, but I don't have hard numbers for you. PAGEVEC_SIZE
> > is 14, and that's conceptually rather similar operation (walk radix tree;
> > grab pages). OTOH many archs are heavier and do locking and vmas walking etc.
> > 
> > Documentation/features/vm/pte_special/arch-support.txt
> > 
> > But even for those, at 16 entries, the bulk of the cost *should* be hitting
> > struct page cachelines and refcounting. The rest should mostly stay in cache.  
> 
> OK...  That's actually important only for vmsplice_to_pipe() and 16-page
> array seems to be doing fine there.
> 
> Another question, now that you've finally resurfaced: could you reconstruct
> the story with page-stealing and breakage(s) thereof that had lead to
> commit 485ddb4b9741bafb70b22e5c1f9b4f37dc3e85bd
> Author: Nick Piggin <npiggin@suse.de>
> Date:   Tue Mar 27 08:55:08 2007 +0200
> 
>     1/2 splice: dont steal
> 
> I realize that it had been 9 years ago, but anything resembling a braindump
> would be very welcome.  Note that there is a couple of ->splice_write()
> instances that _do_ use ->steal() (fuse_dev_splice_write() and virtio_console
> port_fops_splice_write()) and I wonder if they suffer from the same problems;
> your commit message is rather short on details, unfortunately.  FUSE one
> is especially interesting...

Without looking through all the patches again, I believe the issue was
just that filesystems were not expecting (or at least, not audited to
expect) pages being added to their pagecache in that particular state
(they'd expect to go through ->readpage or see !uptodate in prepare_write).

If some wanted to attach metadata to uptodate pages for example, this
may have caused a problem. It wasn't some big fundamental problem, just a
mechanical one.

Thanks,
Nick'
