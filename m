Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33721 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfAKJYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jan 2019 04:24:31 -0500
MIME-Version: 1.0
References: <1547130601.20294.152.camel@intricatesoftware.com>
In-Reply-To: <1547130601.20294.152.camel@intricatesoftware.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Fri, 11 Jan 2019 10:24:18 +0100
Message-ID: <CAAxjCEymRj+FQ-Zw1OAKVoh5LE=dwvy6PRU_BwxCoFZ6r0usyw@mail.gmail.com>
Subject: Re: Block device flush ordering
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kurt Miller <kurt@intricatesoftware.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jan 10, 2019 at 3:31 PM Kurt Miller <kurt@intricatesoftware.com> wrote:
>
> For a well behaved block device that has a writeback cache,
> what is the proper behavior of flush when there are more
> then one outstanding flush operations? Is it;
>
> Flush all writes seen since the last flush.
> or
> Flush all writes received prior to the flush including
> those before any prior flush.
>
> For example take the following order of requests presented
> to the block device:
>
>         writes 1-5
>         flush 1
>         write 6
>         flush 2
>
> Can flush 2 finish with success as soon as write 6 is flushed
> (which may be before flush 1 success)? Or must it wait for
> all prior write operations to flush (writes 1-6)?
>
> This question has come up in our implementation of an NBD
> user-space block device and have not found a definitive answer
> on which behavior is correct for us to conform to. We want to
> ensure we behave as required for file-system commit write
> ordering.

As an interested outstanding observer who has had a bit of exposure to
memory models I would pose the question differently: Should flushes be
allowed to execute concurrently or should there be a total order? If a
total order is imposed, the premise of the question does not exist,
and otherwise I cannot see a single good reason to "wait for all prior
write operations to flush" because the second thread (the one
executing write 6 and flush 2) cannot even determine in a non-esoteric
way if another flush is ongoing or not.
