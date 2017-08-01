Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:57477 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751496AbdHARtw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 13:49:52 -0400
Subject: Re: Locking problems with Linux 4.9 and 4.11 with NFSD and
 `fs/iomap.c`
References: <de171adc29600902515d1424fd800678@molgen.mpg.de>
 <20170508131843.GB29840@bfoster.bfoster> <20170509090534.GB2378@lst.de>
 <7ae18b0d-38e3-9b12-0989-ede68956ad43@molgen.mpg.de>
 <358037e8-6784-ebca-9fbb-ec7eef3977d6@molgen.mpg.de>
 <20170510171757.GA10534@localhost.localdomain>
 <f6115b81-918d-ecfe-e3d9-812bccf7c80f@molgen.mpg.de>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <979473d1-9e8a-51ba-28d9-9ace63f8105b@molgen.mpg.de>
Date: Tue, 1 Aug 2017 19:49:50 +0200
MIME-Version: 1.0
In-Reply-To: <f6115b81-918d-ecfe-e3d9-812bccf7c80f@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: it+linux-nfs@molgen.mpg.de, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

Dear Brian, dear Christoph,


On 06/27/17 13:59, Paul Menzel wrote:

> Just a small update that we were hit by the problem on a different 
> machine (identical model) with Linux 4.9.32 and the exact same symptoms.
> 
> ```
> $ sudo cat /proc/2085/stack
> [<ffffffff811f920c>] iomap_write_begin+0x8c/0x120
> [<ffffffff811f982b>] iomap_zero_range_actor+0xeb/0x210
> [<ffffffff811f9a82>] iomap_apply+0xa2/0x110
> [<ffffffff811f9c58>] iomap_zero_range+0x58/0x80
> [<ffffffff8133c7de>] xfs_zero_eof+0x4e/0xb0
> [<ffffffff8133c9dd>] xfs_file_aio_write_checks+0x19d/0x1c0
> [<ffffffff8133ce89>] xfs_file_buffered_aio_write+0x79/0x2d0
> [<ffffffff8133d17e>] xfs_file_write_iter+0x9e/0x150
> [<ffffffff81198dc0>] do_iter_readv_writev+0xa0/0xf0
> [<ffffffff81199fba>] do_readv_writev+0x18a/0x230
> [<ffffffff8119a2ac>] vfs_writev+0x3c/0x50
> [<ffffffffffffffff>] 0xffffffffffffffff
> ```
> 
> We haven’t had time to set up a test system yet to analyze that further.

Today, two systems with Linux 4.9.23 exhibited the problem of `top` 
showing that `nfsd` is at 100 %. Restarting one machine into Linux 
*4.9.38* showed the same problem. One of them with a 1 GBit/s network 
device got traffic from a 10 GBit/s system, so the connection was saturated.

But looking at the current processes, process with ID 829 does not show 
that CPU usage value. (I don’t remember what the behavior during the 
other incidents on other machines was.)

This is from 4.9.38.

The stack trace of the process with ID 857 is below.

```
$ sudo cat /proc/857/stack
[<ffffffff811f94fc>] iomap_write_begin+0x6c/0x120
[<ffffffffffffffff>] 0xffffffffffffffff
```

Then I executed Brian’s commands.

```
$ trace-cmd start -p function -l iomap* -P <pid>
$ cat /sys/kernel/debug/tracing/trace_pipe
```

This produced output.

```
             nfsd-857   [005] ....   426.650413: iomap_write_end 
<-iomap_zero_range_actor
             nfsd-857   [005] ....   426.650414: iomap_write_begin 
<-iomap_zero_range_actor
CPU:5 [LOST 115621695 EVENTS]
             nfsd-857   [005] ....   453.070439: iomap_write_begin 
<-iomap_zero_range_actor
             nfsd-857   [005] ....   453.070440: iomap_write_end 
<-iomap_zero_range_actor
```

This continues endlessly.


Kind regards,

Paul
