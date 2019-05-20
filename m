Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43263 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729963AbfETN1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 09:27:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id r4so14583875wro.10
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 06:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-12-hch@lst.de>
 <20190520131232.GB31317@bfoster> <20190520131946.GA8717@lst.de>
In-Reply-To: <20190520131946.GA8717@lst.de>
From: Bryan Gurney <bgurney@redhat.com>
Date: Mon, 20 May 2019 09:27:37 -0400
Message-ID: <CAHhmqcQaFiQjyfFq0yQQTHrEAMJ68JBN4dZfD6nXZ6DfKPtDiQ@mail.gmail.com>
Subject: Re: [PATCH 11/20] xfs: use a list_head for iclog callbacks
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 9:20 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, May 20, 2019 at 09:12:33AM -0400, Brian Foster wrote:
> > > +                           spin_unlock(&iclog->ic_callback_lock);
> > > +                           xlog_cil_process_commited(&tmp, aborted);
> >
> > s/commited/committed/ please.
>
> Ok.
>
> > > +   while ((ctx = list_first_entry_or_null(list,
> >
> > Are double braces necessary here?
>
> Without them gcc is unhappy:
>
> fs/xfs/xfs_log_cil.c: In function ‘xlog_cil_process_commited’:
> fs/xfs/xfs_log_cil.c:624:9: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
>   while (ctx = list_first_entry_or_null(list,
>

It's probably to guard against an assignment in a while / if / etc. statement.

In other words: Are you sure you didn't intend the following?

     while (ctx == list_first_entry_or_null(list,
                     struct xfs_cil_ctx, iclog_entry)) {

(I've stumbled on a bug like this before, so I figured I'd ask, just
to be certain.)


Thanks,

Bryan

> > >     /* attach all the transactions w/ busy extents to iclog */
> >
> > Any idea what this ^ comment means? ISTM it's misplaced or stale. If so,
> > we might as well toss/replace it.
>
> No idea.  We can probbaly remove it.
