Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17D7C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A912207DE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mskTVdxs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgHUCj5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgHUCjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:39:55 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C14CC061385
        for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2020 19:39:55 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z17so358707ioi.6
        for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2020 19:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R5Gvyk0NTnxVgnHDcwaC9F/QEfUZmJSn0eEbpGehXC4=;
        b=mskTVdxskeQtLxfhtRnc9qQffAmZH+FB441Itr2p/kW9s+oj9FxHy7b4teXtYRWimA
         2OjiWXDJnu6s4B8Z+EQmJ1fzUHcgU0uqjjnwoKka+2heTiZT/08xOLlAf95hwTScSGT+
         tnBAkpQs0EqyuLjpjjlke9MVaCWgLBoRsDLX7wUceltSQMkqcQhTKqPyfVprid/LdW+6
         Kj6VYdk+/1rkMXimyFfc3JK1InikA9HTzhu/Yq6iF4mI4clH7iyfEn9Ji4cKeYDOeJ+h
         cZ+vVY2BsUkJEklUHjih42jrrtBgoJbLCmIvmbvkx+aaoyTjvATxEb/D/BykOSZIYipg
         wlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R5Gvyk0NTnxVgnHDcwaC9F/QEfUZmJSn0eEbpGehXC4=;
        b=V20CLHu2ZUERZEdnP7M5ZUH6pBq2PXSDiFChO88oVH32XrsjakVhPRFMPJrkfNkGxJ
         g3DRkfOynwm/3BsmjSpnaxIJZXZlk6e3TaboOaKECEFNUXJzGyQpcvhkGRfM43D3rKON
         R9ECrwBeMDbqGgdeaFRPJ4iyi9lw0O3NIB6JfPw3+xqZPvOVISnxqo9SlXsHQNNbfc6X
         1YLX7V+iCtikgLk/6QYDLbSIsiVLUiMruFtQOogpnjQBRtTp5wm+TivZMvLUNYhq5G7t
         sxnu//PRV7OcTdGCxROTJLDqtxoM04votJ6qSHLRjtBCL4onyja7wVy3m2A80zgY2W/6
         kp+g==
X-Gm-Message-State: AOAM532AIOD8Rtjki7SYoudQ4mXxUy5Xl4Vsfqqm2v/RgtSmXlDS1BIX
        vsRylN5Tsqnr42inI2ktlEBd9Ss9bUpKPsz3YSwWLAR9x0Q=
X-Google-Smtp-Source: ABdhPJxey99BQ4L/qSx39NU1kxEwcU3FDWlG+56JD4J3sQjlP90eP8AzmyRTG0h6rTD1X7lVjK8KAOq67t8L/TguJIc=
X-Received: by 2002:a02:3f16:: with SMTP id d22mr744987jaa.30.1597977594532;
 Thu, 20 Aug 2020 19:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200728154753.GS23808@casper.infradead.org> <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org> <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org> <20200729230503.GA2005@dread.disaster.area>
 <20200730135040.GD23808@casper.infradead.org> <20200730220857.GD2005@dread.disaster.area>
 <20200730234517.GM23808@casper.infradead.org> <20200731204713.GA24067@casper.infradead.org>
 <20200731221313.GF2005@dread.disaster.area>
In-Reply-To: <20200731221313.GF2005@dread.disaster.area>
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Fri, 21 Aug 2020 10:39:43 +0800
Message-ID: <CAOOPZo6KGEwooo984+4NRh7aoFiPiKsr+AdtXOyFa9jOHVcY0w@mail.gmail.com>
Subject: Re: [Question] About XFS random buffer write performance
To:     Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks for your discussions.
For this issue,  if we have plans to fix?

On Sat, Aug 1, 2020 at 6:13 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Jul 31, 2020 at 09:47:13PM +0100, Matthew Wilcox wrote:
> > On Fri, Jul 31, 2020 at 12:45:17AM +0100, Matthew Wilcox wrote:
> > > On Fri, Jul 31, 2020 at 08:08:57AM +1000, Dave Chinner wrote:
> > > > On Thu, Jul 30, 2020 at 02:50:40PM +0100, Matthew Wilcox wrote:
> > > > > On Thu, Jul 30, 2020 at 09:05:03AM +1000, Dave Chinner wrote:
> > > > > > On Wed, Jul 29, 2020 at 07:50:35PM +0100, Matthew Wilcox wrote:
> > > > > > > I had a bit of a misunderstanding.  Let's discard that proposal
> > > > > > > and discuss what we want to optimise for, ignoring THPs.  We don't
> > > > > > > need to track any per-block state, of course.  We could implement
> > > > > > > __iomap_write_begin() by reading in the entire page (skipping the last
> > > > > > > few blocks if they lie outside i_size, of course) and then marking the
> > > > > > > entire page Uptodate.
> > > > > >
> > > > > > __iomap_write_begin() already does read-around for sub-page writes.
> > > > > > And, if necessary, it does zeroing of unwritten extents, newly
> > > > > > allocated ranges and ranges beyond EOF and marks them uptodate
> > > > > > appropriately.
> > > > >
> > > > > But it doesn't read in the entire page, just the blocks in the page which
> > > > > will be touched by the write.
> > > >
> > > > Ah, you are right, I got my page/offset macros mixed up.
> > > >
> > > > In which case, you just identified why the uptodate array is
> > > > necessary and can't be removed. If we do a sub-page write() the page
> > > > is not fully initialised, and so if we then mmap it readpage needs
> > > > to know what part of the page requires initialisation to bring the
> > > > page uptodate before it is exposed to userspace.
> > >
> > > You snipped the part of my mail where I explained how we could handle
> > > that without the uptodate array ;-(  Essentially, we do as you thought
> > > it worked, we read the entire page (or at least the portion of it that
> > > isn't going to be overwritten.  Once all the bytes have been transferred,
> > > we can mark the page Uptodate.  We'll need to wait for the transfer to
> > > happen if the write overlaps a block boundary, but we do that right now.
> >
> > OK, so this turns out to be Hard.  We enter the iomap code with
> >
> > iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
> >                 const struct iomap_ops *ops)
> >
> > which does:
> >                 ret = iomap_apply(inode, pos, iov_iter_count(iter),
> >                                 IOMAP_WRITE, ops, iter, iomap_write_actor);
> >
> > so iomap_write_actor doesn't get told about the blocks in the page before
> > the starting pos.  They might be a hole or mapped; we have no idea.
>
> So this is a kind of the same problem block size > page size has to
> deal with for block allocation - the zero-around issue. THat is,
> when a sub block write triggers a new allocation, it actually has to
> zero the entire block in the page cache first, which means it needs
> to expand the IO range in iomap_write_actor()....
>
> https://lore.kernel.org/linux-xfs/20181107063127.3902-10-david@fromorbit.com/
> https://lore.kernel.org/linux-xfs/20181107063127.3902-14-david@fromorbit.com/
>
> > We could allocate pages _here_ and call iomap_readpage() for the pages
> > which overlap the beginning and end of the I/O,
>
> FWIW, this is effective what calling iomap_zero() from
> iomap_write_actor() does - it allocates pages outside the write
> range via iomap_begin_write(), then zeroes them in memory and marks
> them dirty....
>
> > but I'm not entirely
> > convinced that the iomap_ops being passed in will appreciate being
> > called for a read that has no intent to write the portions of the page
> > outside pos.
>
> I don't think it should matter what the range of the read being done
> is - it has the same constraints whether it's to populate the
> partial block or whole blocks just before the write. Especially as
> we are in the buffered write path and so the filesystem has
> guaranteed us exclusive access to the inode and it's mapping
> here....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
