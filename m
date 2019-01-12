Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f174.google.com ([209.85.222.174]:43981 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfALAau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jan 2019 19:30:50 -0500
Message-ID: <1547253047.20294.182.camel@intricatesoftware.com>
Subject: Re: Block device flush ordering
From: Kurt Miller <kurt@intricatesoftware.com>
Date: Fri, 11 Jan 2019 19:30:47 -0500
In-Reply-To: <CAAxjCEymRj+FQ-Zw1OAKVoh5LE=dwvy6PRU_BwxCoFZ6r0usyw@mail.gmail.com>
References: <1547130601.20294.152.camel@intricatesoftware.com>
         <CAAxjCEymRj+FQ-Zw1OAKVoh5LE=dwvy6PRU_BwxCoFZ6r0usyw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, 2019-01-11 at 10:24 +0100, Stefan Ring wrote:
> On Thu, Jan 10, 2019 at 3:31 PM Kurt Miller <kurt@intricatesoftware.com> wrote:
> > 
> > 
> > For a well behaved block device that has a writeback cache,
> > what is the proper behavior of flush when there are more
> > then one outstanding flush operations? Is it;
> > 
> > Flush all writes seen since the last flush.
> > or
> > Flush all writes received prior to the flush including
> > those before any prior flush.
> > 
> > For example take the following order of requests presented
> > to the block device:
> > 
> >         writes 1-5
> >         flush 1
> >         write 6
> >         flush 2
> > 
> > Can flush 2 finish with success as soon as write 6 is flushed
> > (which may be before flush 1 success)? Or must it wait for
> > all prior write operations to flush (writes 1-6)?
> > 
> > This question has come up in our implementation of an NBD
> > user-space block device and have not found a definitive answer
> > on which behavior is correct for us to conform to. We want to
> > ensure we behave as required for file-system commit write
> > ordering.
> As an interested outstanding observer who has had a bit of exposure to
> memory models I would pose the question differently: Should flushes be
> allowed to execute concurrently or should there be a total order? If a
> total order is imposed, the premise of the question does not exist,
> and otherwise I cannot see a single good reason to "wait for all prior
> write operations to flush" because the second thread (the one
> executing write 6 and flush 2) cannot even determine in a non-esoteric
> way if another flush is ongoing or not.

Hi Stefan,

Thank you for your comments. Our nbd block device implementation is
asynchronous in nature. We are able to conform to either behavior.

I can confirm that the kernel does in fact send multiple concurrent
REQ_OP_FLUSH requests to block devices. So I'm trying to determine what
behavior is acceptable when this occurs. Should we impose total ordering
of the flush operations or allow flush operations to complete out of
order when they finish first?

Best,
-Kurt
