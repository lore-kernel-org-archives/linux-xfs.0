Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdEARlK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 May 2017 13:41:10 -0400
Subject: Re: xlog_write: reservation ran out
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
 <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org>
 <20170501131222.GA2109@bfoster.bfoster>
From: Ming Lin <mlin@kernel.org>
Message-ID: <70def595-91a9-970a-d227-547055da5bb5@kernel.org>
Date: Mon, 1 May 2017 10:41:06 -0700
MIME-Version: 1.0
In-Reply-To: <20170501131222.GA2109@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On 5/1/2017 6:12 AM, Brian Foster wrote:
> On Sun, Apr 30, 2017 at 11:10:15PM -0700, Ming Lin wrote:
>>
>> On 4/28/2017 1:56 PM, Ming Lin wrote:
>>> I'm new to xfs code.
>>>
>>> Search  XFS_TRANS_INACTIVE and the usage is like below,
>>>
>>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>>> xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
>>>
>>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>>> xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, XFS_IFREE_SPACE_RES(mp), 0);
>>>
>>> seems tr_remove is not related.
>>> I'll just try to enlarge the reservation for tr_itruncate and tr_ifree.
>>
>> Now things are a little bit more clear. I tried below debug patch.
>> The t_decrease[] array was used to track where the space was used.
>>
>>  fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
>>  fs/xfs/xfs_log.c               | 23 ++++++++++++++++++++---
>>  fs/xfs/xfs_log_cil.c           |  8 ++++++++
>>  fs/xfs/xfs_log_priv.h          |  3 +++
>>  fs/xfs/xfs_super.c             |  1 +
>>  5 files changed, 34 insertions(+), 5 deletions(-)
>>
> ...
>>  277 static void
>>  278 xlog_cil_insert_items(
>>  279         struct xlog             *log,
>>  280         struct xfs_trans        *tp)
>>  281 {
>>
>> ....
>>
>>  340         /* do we need space for more log record headers? */
>>  341         iclog_space = log->l_iclog_size - log->l_iclog_hsize;
>>  342         if (len > 0 && (ctx->space_used / iclog_space !=
>>  343                                 (ctx->space_used + len) / iclog_space)) {
>>  344                 int hdrs;
>>  345
>>  346                 hdrs = (len + iclog_space - 1) / iclog_space;
>>  347                 /* need to take into account split region headers, too */
>>  348                 hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
>>  349                 ctx->ticket->t_unit_res += hdrs;
>>  350                 ctx->ticket->t_curr_res += hdrs;
>>  351                 tp->t_ticket->t_curr_res -= hdrs;
>>  352                 tp->t_ticket->t_decrease[6] = hdrs;
>>  353                 ASSERT(tp->t_ticket->t_curr_res >= len);
>>  354         }
>>  355         tp->t_ticket->t_curr_res -= len;
>>  356         tp->t_ticket->t_decrease[7] = len;
>>  357         ctx->space_used += len;
>>  358
>>  359         spin_unlock(&cil->xc_cil_lock);
>>  360 }
>>
>> Any idea why it used so many reservation space here?
>>
> 
> Nothing really rings a bell for me atm. Perhaps others might have ideas.
> That does appear to be a sizable overrun, as opposed to a few bytes that
> could more likely be attributed to rounding, header accounting issues or
> something of that nature.

FYI, here are some numbers.

The original "unit res" is 83024. I made it x2 larger, so now it's 166048
"unit res" - "current res" = the reservation space already used

XFS (nvme10n1p1): xlog_write: reservation summary:
  trans type  = INACTIVE (3)
  unit res    = 166048 bytes
  current res = 77088 bytes
  total reg   = 0 bytes (o/flow = 0 bytes)
  ophdrs      = 0 (ophdr space = 0 bytes)
  ophdr + reg = 0 bytes
  num regions = 0

"already used" = 166048 - 77088 = 88960
overrun = 88960 - 83024 = 5936


XFS (nvme7n1p1): xlog_write: reservation summary:
  trans type  = INACTIVE (3)
  unit res    = 166048 bytes
  current res = 53444 bytes
  total reg   = 0 bytes (o/flow = 0 bytes)
  ophdrs      = 0 (ophdr space = 0 bytes)
  ophdr + reg = 0 bytes
  num regions = 0

"already used" = 166048 - 53444 = 112604
overrun = 112604 - 83024 = 29580

The overrun bytes seems a lot to me.

> 
> The debug code doesn't really tell us much beyond that the transaction
> required logging more data than it had reserved. In the snippet above,
> len essentially refers to a byte total of what is logged across all of
> the various items (inode, buffers, etc.) in the transaction.
> 
> I'm assuming you can reproduce this often enough if you can capture

It takes about 10 hours to reproduce the problem.

> debug information. Have you tried to reproduce the actual transaction
> overrun without using Ceph (i.e., create the fs using ceph as normal,
> but run the object removal directly)? If you can do that, you could

Not exactly same.
But I did try just write the xfs fs with fio(64 threads) to 80% full,
then remove the files, but can't reproduce it.

> create an xfs_metadump of the populated fs, run a more simple reproducer
> on that and that might make it easier to 1.) try newer distro and/or
> upstream kernels to try and isolate where the problem exists and/or 2.)
> share it so we can try to reproduce and narrow down where the overrun
> seems to occur (particularly if this hasn't already been fixed
> somewhere).

I'll try to find a more simple reproducer.

Thanks,
Ming

> 
> Brian
> 
>> Thanks,
>> Ming
