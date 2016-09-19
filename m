Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35491 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758956AbcISH0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Sep 2016 03:26:32 -0400
Date: Mon, 19 Sep 2016 17:26:23 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160919172623.14f2d5cb@roar.ozlabs.ibm.com>
In-Reply-To: <20160919061120.GK2356@ZenIV.linux.org.uk>
References: <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
        <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
        <20160909023452.GO2356@ZenIV.linux.org.uk>
        <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
        <20160909221945.GQ2356@ZenIV.linux.org.uk>
        <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
        <20160914031648.GB2356@ZenIV.linux.org.uk>
        <20160914133925.2fba4629@roar.ozlabs.ibm.com>
        <20160918053337.GA32207@ZenIV.linux.org.uk>
        <20160919130830.14bde3b0@roar.ozlabs.ibm.com>
        <20160919061120.GK2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org

On Mon, 19 Sep 2016 07:11:21 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Sep 19, 2016 at 01:08:30PM +1000, Nicholas Piggin wrote:
> 
> > Without looking through all the patches again, I believe the issue was
> > just that filesystems were not expecting (or at least, not audited to
> > expect) pages being added to their pagecache in that particular state
> > (they'd expect to go through ->readpage or see !uptodate in prepare_write).
> > 
> > If some wanted to attach metadata to uptodate pages for example, this
> > may have caused a problem. It wasn't some big fundamental problem, just a
> > mechanical one.  
> 
> Umm...  Why not make it non-uptodate/locked, try to replace the original
> with it in pagecache and then do full-page ->write_begin immediately
> followed by full-page ->write_end?  Looks like that ought to work in
> all in-tree cases...

That sounds like it probably should work for that case. IIRC, I was looking
at using a write_begin flag to notify the case of of replacing the page, so
the fs could also handle the case of replacing existing pagecache.

