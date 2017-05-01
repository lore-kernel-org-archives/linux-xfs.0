Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751432AbdEAUTl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 May 2017 16:19:41 -0400
MIME-Version: 1.0
In-Reply-To: <20170501184822.GB3775@bfoster.bfoster>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
 <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org> <20170501131222.GA2109@bfoster.bfoster>
 <70def595-91a9-970a-d227-547055da5bb5@kernel.org> <20170501184822.GB3775@bfoster.bfoster>
From: Ming Lin <mlin@kernel.org>
Date: Mon, 1 May 2017 13:18:58 -0700
Message-ID: <CAF1ivSZgh-v1=LqeFwKZWuzcARwy9w37Qg_J3r_Hm-jnbmaH6g@mail.gmail.com>
Subject: Re: xlog_write: reservation ran out
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On Mon, May 1, 2017 at 11:48 AM, Brian Foster <bfoster@redhat.com> wrote:
>>
>> It takes about 10 hours to reproduce the problem.
>>
>
> Out of curiosity, is that 10 hours of removing files or 10 hours of
> repopulating and removing until the problem happens to occur? If the
> latter, roughly how many fill/remove cycles does that entail (tens,
> hundreds, thousands)?

10 hours of repopulating the cluster. Then remove all rbd images with
"rbd rm xxx"
Just 1 cycle: fill then remove.

> You could try to populate the fs using Ceph as with your current
> reproducer, particularly since it may use patterns or features that
> could affect this problem (xattrs?) that fio may not induce, and then
> try to directly reproduce the overrun via manual file removals. This
> would be sufficient for debugging because if you can share a metadump
> image of the original fs and appropriate steps to reproduce, we don't
> particularly need to care about how the fs was constructed in the first
> place.
>
> For example, if you have a test that currently populates and depopulates
> the fs through Ceph, something I might try is to update the test to
> generate a metadump image of the fs every time your test cycles from
> populating to depopulating. Once the problem reproduces, you now have a
> metadump image of the original fs that you can restore and use to try to
> reproduce the overrun manually (repeatedly, if nec.).

That's a nice idea to debug it.
I'll try.

Thanks.
