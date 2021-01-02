Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD2AC433DB
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Jan 2021 22:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC6FA20798
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Jan 2021 22:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbhABWpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:45:14 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:52230 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbhABWpO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Jan 2021 17:45:14 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id C4B271AD229;
        Sun,  3 Jan 2021 09:44:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kvpdF-002PvI-7O; Sun, 03 Jan 2021 09:44:21 +1100
Date:   Sun, 3 Jan 2021 09:44:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20210102224421.GC331610@dread.disaster.area>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <7bd30426-11dc-e482-dcc8-55d279bc75bd@molgen.mpg.de>
 <20201231215919.GA331610@dread.disaster.area>
 <def7bbfc-c57e-bcec-f81b-b5ccb0e562e8@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def7bbfc-c57e-bcec-f81b-b5ccb0e562e8@molgen.mpg.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=HAyNdGBD1icRRfbRyHwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 02, 2021 at 08:12:56PM +0100, Donald Buczek wrote:
> On 31.12.20 22:59, Dave Chinner wrote:
> > On Thu, Dec 31, 2020 at 12:48:56PM +0100, Donald Buczek wrote:
> > > On 30.12.20 23:16, Dave Chinner wrote:

> > One could argue that, but one should also understand the design
> > constraints for a particular algorithm are before suggesting
> > that their solution is "robust". :)
>
> Yes, but an understanding to the extend required by the
> argument should be sufficient :-)

And that's the fundamental conceit described by Dunning-Kruger.

I.e. someone thinks they know enough to understand the argument,
when in fact they don't understand enough about the subject matter
to realise they don't understand what the expert at the other end is
saying at all....

> > > # seq 29
> > > 
> > > 2020-12-29T20:08:15.652167+01:00 deadbird kernel: [ 1053.860637] XXX trigger cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=33554656      , push_seq=29, ctx->sequence=29
> > 
> > So, at 20:08:15 we get a push trigger and the work is queued. But...
> > 
> > .....
> > > 2020-12-29T20:09:04.961088+01:00 deadbird kernel: [ 1103.168964] XXX wake    cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
> > 
> > It takes the best part of *50 seconds* before the push work actually
> > runs?
> > 
> > That's .... well and truly screwed up - the work should run on that
> > CPU on the very next time it yeilds the CPU. If we're holding the
> > CPU without yeilding it for that long, hangcheck and RCU warnings
> > should be going off...
> 
> No such warnings.
> 
> But the load is probably I/O bound to the log:
> 
> - creates `cp -a` copies of a directory tree with small files (linux source repository)
> - source tree probably completely cached.
> - two copies in parallel
> - slow log (on software raid6)
> 
> Isn't it to be expected that sooner or later you need to wait for
> log writes when you write as fast as possible with lots of
> metadata updates and not so much data?

No, incoming transactions waits for transaction reservation space,
not log writes. Reservation space is freed up by metadata writeback.
So if you have new transactions blocking in xfs_trans_reserve(),
then we are blocking on metadata writeback.

The CIL worker thread may be waiting for log IO completion before it
issues more log IO, and in that case it is waiting on iclog buffer
space (i.e. only waiting on internal log state, not metadata
writeback).  Can you find that kworker thread stack and paste it? If
bound on log IO, it will be blocked in xlog_get_iclog_space().

Please paste the entire stack output, too, not just the bits you
think are relevant or understand....

Also, cp -a of a linux source tree is just as data intensive as it
is metadata intensive. There's probably more data IO than metadata
IO, so that's more likely to be what is slowing the disks down as
metadata writeback is...

> I'm a bit concerned, though, that there seem to be a rather
> unlimited (~ 1000) number of kernel worker threads waiting for the
> cil push and indirectly for log writes.

That's normal - XFS is highly asynchronous and defers a lot of work
to completion threads.

> > So it dropped by 16 bytes (seems to be common) which is
> > unexpected.  I wonder if it filled a hole in a buffer and so
> > needed one less xlog_op_header()? But then the size would have
> > gone up by at least 128 bytes for the hole that was filled, so
> > it still shouldn't go down in size.
> > 
> > I think you need to instrument xlog_cil_insert_items() and catch
> > a negative length here:
> > 
> > 	/* account for space used by new iovec headers  */
> > 	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t); len +=
> > 	iovhdr_res; ctx->nvecs += diff_iovecs;
> > 
> > (diff_iovecs will be negative if the number of xlog_op_header
> > structures goes down)
> > 
> > And if this happens, then dump the transaction ticket via
> > xlog_print_trans(tp) so we can see all the log items types and
> > vectors that the transaction has formatted...
> 
> I tried that, but the output was difficult to understand, because
> at that point you can only log the complete transaction with the
> items already updated.  And a shrinking item is not switched to the
> shadow vector, so the formatted content is already overwritten and
> not available for analysis.

Yes, that's exactly the information I need to see.

But the fact you think this is something I don't need to know about
is classic Dunning-Kruger in action. You don't understand why I
asked for this information, and found the information "difficult to
understand", so you decided I didn't need it either, despite the
fact I asked explicitly for it.

What I first need to know is what operations are being performed by
the transaciton that shrunk and what all the items in it are, not
which specific items shrunk and by how much. There can be tens to
hundreds of items in a single transaction, and it's the combination
of the transaction state, the reservation, the amount of the
reservation that has been consumed, what items are consuming that
reservation, etc. that I need to first see and analyse.

I don't ask for specific information just for fun - I ask for
specific information because it is *necessary*. If you want the
problem triaged and fixed, then please supply the information you
are asked for, even if you don't understand why or what it means.

> So I've added some code to dump an item in its old and its new
> state in xlog_cil_insert_format_items when either the requested
> buffer len or the number of vectors decreased.

Yes, that would be useful when trying to understand the low level
details of where a specific operation might be doing something
unexpected, but I don't have a high level picture of what operations
are triggering this issue so have no clue about the context in which
these isolated, context free changes are occuring.

That said ....

> Several examples of different kind with a little bit of manual annotation following
> 
> Best
>   Donald
> 
> - XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL from 32 to 20 bytes
> 
> [   29.606212] XFS (sda1): XXX required buf size 184 -> 172
> [   29.612591] XFS (sda1): XXX niovecs           3 -> 3
> 
> [   29.618570] XFS (sda1): XXX old log item:
> [   29.623469] XFS (sda1): log item:
> [   29.627683] XFS (sda1):   type       = 0x123b                                               # XFS_LI_INODE
> [   29.632375] XFS (sda1):   flags      = 0x8
> [   29.636858] XFS (sda1):   niovecs    = 3
> [   29.647442] XFS (sda1):   size       = 312
> [   29.651814] XFS (sda1):   bytes      = 184
> [   29.656278] XFS (sda1):   buf len    = 184
> [   29.660927] XFS (sda1):   iovec[0]
> [   29.665071] XFS (sda1):     type     = 0x5                                                  # XLOG_REG_TYPE_IFORMAT
> [   29.669592] XFS (sda1):     len      = 56
> [   29.673914] XFS (sda1):     first 32 bytes of iovec[0]:
> [   29.680079] 00000000: 3b 12 03 00 03 00 00 00 00 00 20 00 00 00 00 00  ;......... .....
> [   29.689363] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
> [   29.698633] XFS (sda1):   iovec[1]
> [   29.702756] XFS (sda1):     type     = 0x6                                                  # XLOG_REG_TYPE_ICORE
> [   29.707263] XFS (sda1):     len      = 96
> [   29.711571] XFS (sda1):     first 32 bytes of iovec[1]:
> [   29.717720] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
> [   29.726986] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
> [   29.736241] XFS (sda1):   iovec[2]
> [   29.740364] XFS (sda1):     type     = 0x9                                                  # XLOG_REG_TYPE_ILOCAL
> [   29.744873] XFS (sda1):     len      = 32
> [   29.749184] XFS (sda1):     first 32 bytes of iovec[2]:
> [   29.755336] 00000000: 02 00 30 e7 02 26 06 00 40 73 65 72 76 65 72 00  ..0..&..@server.
> [   29.764612] 00000010: 08 92 ef 04 00 58 6d 78 36 34 00 d3 93 58 00 58  .....Xmx64...X.X
> 
> [   29.773900] XFS (sda1): XXX new log item:
> [   29.778718] XFS (sda1): log item:
> [   29.782856] XFS (sda1):   type       = 0x123b
> [   29.787478] XFS (sda1):   flags      = 0x8
> [   29.791902] XFS (sda1):   niovecs    = 3
> [   29.796321] XFS (sda1):   size       = 312
> [   29.800640] XFS (sda1):   bytes      = 172
> [   29.805052] XFS (sda1):   buf len    = 176
> [   29.809659] XFS (sda1):   iovec[0]
> [   29.813781] XFS (sda1):     type     = 0x5
> [   29.818289] XFS (sda1):     len      = 56
> [   29.822599] XFS (sda1):     first 32 bytes of iovec[0]:
> [   29.828754] 00000000: 3b 12 03 00 03 00 00 00 00 00 14 00 00 00 00 00  ;...............
> [   29.838024] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
> [   29.847292] XFS (sda1):   iovec[1]
> [   29.851420] XFS (sda1):     type     = 0x6
> [   29.855933] XFS (sda1):     len      = 96
> [   29.860247] XFS (sda1):     first 32 bytes of iovec[1]:
> [   29.866406] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
> [   29.875677] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
> [   29.884949] XFS (sda1):   iovec[2]
> [   29.889081] XFS (sda1):     type     = 0x9
> [   29.893601] XFS (sda1):     len      = 20
> [   29.897924] XFS (sda1):     first 20 bytes of iovec[2]:
> [   29.904096] 00000000: 01 00 30 e7 02 26 04 00 58 6d 78 36 34 00 d3 93  ..0..&..Xmx64...
> [   29.913381] 00000010: 58 92 ef 04                                      X...

That may be removal of a directory entry from a local form
directory. Hmmm - local form inode forks only log the active byte
range so that could be the issue here.

Hold on - where did this come from? "cp -a" doesn't result in file
and directory removals, right?

> - (then) XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL from 20 to 8 bytes
> 
> [   29.982907] XFS (sda1): XXX required buf size 172 -> 160
> [   29.992716] XFS (sda1): XXX niovecs           3 -> 3
> 
> [   29.998728] XFS (sda1): XXX old log item:
> [   30.003624] XFS (sda1): log item:
> [   30.007835] XFS (sda1):   type       = 0x123b
> [   30.012654] XFS (sda1):   flags      = 0x8
> [   30.017145] XFS (sda1):   niovecs    = 3
> [   30.021638] XFS (sda1):   size       = 312
> [   30.026012] XFS (sda1):   bytes      = 172
> [   30.030610] XFS (sda1):   buf len    = 176
> [   30.035292] XFS (sda1):   iovec[0]
> [   30.039480] XFS (sda1):     type     = 0x5
> [   30.044054] XFS (sda1):     len      = 56
> [   30.048534] XFS (sda1):     first 32 bytes of iovec[0]:
> [   30.054749] 00000000: 3b 12 03 00 03 00 00 00 00 00 14 00 00 00 00 00  ;...............
> [   30.064091] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
> [   30.073545] XFS (sda1):   iovec[1]
> [   30.077744] XFS (sda1):     type     = 0x6
> [   30.082455] XFS (sda1):     len      = 96
> [   30.086824] XFS (sda1):     first 32 bytes of iovec[1]:
> [   30.093025] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
> [   30.102346] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
> [   30.111801] XFS (sda1):   iovec[2]
> [   30.115989] XFS (sda1):     type     = 0x9
> [   30.120715] XFS (sda1):     len      = 20
> [   30.125102] XFS (sda1):     first 20 bytes of iovec[2]:
> [   30.131331] 00000000: 01 00 30 e7 02 26 04 00 58 6d 78 36 34 00 d3 93  ..0..&..Xmx64...
> [   30.140808] 00000010: 58 92 ef 04                                      X...
> 
> [   30.149006] XFS (sda1): XXX new log item:
> [   30.154039] XFS (sda1): log item:
> [   30.154039] XFS (sda1):   type       = 0x123b
> [   30.154041] XFS (sda1):   flags      = 0x8
> [   30.167436] XFS (sda1):   niovecs    = 3
> [   30.167437] XFS (sda1):   size       = 312
> [   30.167438] XFS (sda1):   bytes      = 160
> [   30.180881] XFS (sda1):   buf len    = 160
> [   30.180882] XFS (sda1):   iovec[0]
> [   30.180882] XFS (sda1):     type     = 0x5
> [   30.180883] XFS (sda1):     len      = 56
> [   30.180884] XFS (sda1):     first 32 bytes of iovec[0]:
> [   30.180884] 00000000: 3b 12 03 00 03 00 00 00 00 00 08 00 00 00 00 00  ;...............
> [   30.180885] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
> [   30.180886] XFS (sda1):   iovec[1]
> [   30.180886] XFS (sda1):     type     = 0x6
> [   30.180887] XFS (sda1):     len      = 96
> [   30.180887] XFS (sda1):     first 32 bytes of iovec[1]:
> [   30.180888] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
> [   30.180889] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
> [   30.180889] XFS (sda1):   iovec[2]
> [   30.180890] XFS (sda1):     type     = 0x9
> [   30.180890] XFS (sda1):     len      = 8
> [   30.180890] XFS (sda1):     first 8 bytes of iovec[2]:
> [   30.180891] 00000000: 00 00 30 e7 02 26 04 00                          ..0..&..

And that looks to be another unlink in the same directory inode, now
empty.

> 
> - (then) XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL removed - niovecs from 3 to 2
> 
> [   30.197403] XFS (sda1): XXX required buf size 160 -> 152
> [   30.296091] XFS (sda1): XXX niovecs           3 -> 2
> 
> [   30.296092] XFS (sda1): XXX old log item:
> [   30.296093] XFS (sda1): log item:
> [   30.297552] ixgbe 0000:01:00.1 net03: renamed from eth3
> [   30.317524] XFS (sda1):   type       = 0x123b
> [   30.317524] XFS (sda1):   flags      = 0x8
> [   30.317525] XFS (sda1):   niovecs    = 3
> [   30.317525] XFS (sda1):   size       = 304
> [   30.317526] XFS (sda1):   bytes      = 160
> [   30.317526] XFS (sda1):   buf len    = 160
> [   30.317527] XFS (sda1):   iovec[0]
> [   30.317527] XFS (sda1):     type     = 0x5
> [   30.317528] XFS (sda1):     len      = 56
> [   30.317528] XFS (sda1):     first 32 bytes of iovec[0]:
> [   30.317529] 00000000: 3b 12 03 00 03 00 00 00 00 00 08 00 00 00 00 00  ;...............
> [   30.317530] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
> [   30.317531] XFS (sda1):   iovec[1]
> [   30.317531] XFS (sda1):     type     = 0x6
> [   30.317531] XFS (sda1):     len      = 96
> [   30.317532] XFS (sda1):     first 32 bytes of iovec[1]:
> [   30.317533] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
> [   30.317533] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
> [   30.317533] XFS (sda1):   iovec[2]
> [   30.317534] XFS (sda1):     type     = 0x9
> [   30.317534] XFS (sda1):     len      = 8
> [   30.317535] XFS (sda1):     first 8 bytes of iovec[2]:
> [   30.317535] 00000000: 00 00 30 e7 02 26 04 00                          ..0..&..
> 
> [   30.317536] XFS (sda1): XXX new log item:
> [   30.317537] XFS (sda1): log item:
> [   30.317537] XFS (sda1):   type       = 0x123b
> [   30.317538] XFS (sda1):   flags      = 0x8
> [   30.317539] XFS (sda1):   niovecs    = 2
> [   30.317539] XFS (sda1):   size       = 304
> [   30.317540] XFS (sda1):   bytes      = 152
> [   30.317540] XFS (sda1):   buf len    = 152
> [   30.317541] XFS (sda1):   iovec[0]
> [   30.317541] XFS (sda1):     type     = 0x5
> [   30.317542] XFS (sda1):     len      = 56
> [   30.317542] XFS (sda1):     first 32 bytes of iovec[0]:
> [   30.317543] 00000000: 3b 12 02 00 01 00 00 00 00 00 00 00 00 00 00 00  ;...............
> [   30.317543] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
> [   30.317544] XFS (sda1):   iovec[1]
> [   30.317544] XFS (sda1):     type     = 0x6
> [   30.317545] XFS (sda1):     len      = 96
> [   30.317545] XFS (sda1):     first 32 bytes of iovec[1]:
> [   30.317546] 00000000: 4e 49 00 00 02 02 00 00 00 00 00 00 00 00 00 00  NI..............
> [   30.317546] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................

And maybe that's an rmdir() triggering an unlink on the same - now
empty - directory.

Does your workload also do 'rm -rf' anywhere because I can't explain
how a concurrent 'cp -a' workload would trigger this behaviour...

> - XFS_LI_INODE.XLOG_REG_TYPE_IEXT removed - niovecs from 3 to 2
> 
> [   37.983756] XFS (sda1): XXX required buf size 168 -> 152
> [   37.990253] XFS (sda1): XXX niovecs           3 -> 2
> 
> [   37.996202] XFS (sda1): XXX old log item:
> [   38.001061] XFS (sda1): log item:
> [   38.005239] XFS (sda1):   type       = 0x123b
> [   38.009885] XFS (sda1):   flags      = 0x9
> [   38.014330] XFS (sda1):   niovecs    = 3
> [   38.018764] XFS (sda1):   size       = 440
> [   38.023100] XFS (sda1):   bytes      = 168
> [   38.027533] XFS (sda1):   buf len    = 168
> [   38.032157] XFS (sda1):   iovec[0]
> [   38.036286] XFS (sda1):     type     = 0x5
> [   38.040796] XFS (sda1):     len      = 56
> [   38.045114] XFS (sda1):     first 32 bytes of iovec[0]:
> [   38.051277] 00000000: 3b 12 03 00 05 00 00 00 00 00 10 00 00 00 00 00  ;...............
> [   38.060562] 00000010: cb 91 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   38.069853] XFS (sda1):   iovec[1]
> [   38.073989] XFS (sda1):     type     = 0x6
> [   38.078525] XFS (sda1):     len      = 96
> [   38.082871] XFS (sda1):     first 32 bytes of iovec[1]:
> [   38.089052] 00000000: 4e 49 a4 81 02 02 00 00 62 00 00 00 62 00 00 00  NI......b...b...
> [   38.098331] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 09  ..............B.
> [   38.107611] XFS (sda1):   iovec[2]
> [   38.111754] XFS (sda1):     type     = 0x7                                                # XLOG_REG_TYPE_IEXT
> [   38.116285] XFS (sda1):     len      = 16
> [   38.120608] XFS (sda1):     first 16 bytes of iovec[2]:
> [   38.126770] 00000000: 00 00 00 00 00 00 00 00 00 00 00 11 31 80 00 01  ............1...
> 
> [   38.136054] XFS (sda1): XXX new log item:
> [   38.140878] XFS (sda1): log item:
> [   38.145025] XFS (sda1):   type       = 0x123b
> [   38.149645] XFS (sda1):   flags      = 0x9
> [   38.154067] XFS (sda1):   niovecs    = 2
> [   38.158490] XFS (sda1):   size       = 440
> [   38.162799] XFS (sda1):   bytes      = 152
> [   38.167202] XFS (sda1):   buf len    = 152
> [   38.171801] XFS (sda1):   iovec[0]
> [   38.175911] XFS (sda1):     type     = 0x5
> [   38.180409] XFS (sda1):     len      = 56
> [   38.184708] XFS (sda1):     first 32 bytes of iovec[0]:
> [   38.190852] 00000000: 3b 12 02 00 01 00 00 00 00 00 00 00 00 00 00 00  ;...............
> [   38.200115] 00000010: cb 91 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   38.209373] XFS (sda1):   iovec[1]
> [   38.213488] XFS (sda1):     type     = 0x6
> [   38.217990] XFS (sda1):     len      = 96
> [   38.222297] XFS (sda1):     first 32 bytes of iovec[1]:
> [   38.228442] 00000000: 4e 49 a4 81 02 02 00 00 62 00 00 00 62 00 00 00  NI......b...b...
> [   38.237707] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 09  ..............B.

truncate() or directory entry removal resulting in block to
shortform conversion, maybe? Implies 'rm -rf', too.

> 
> - XFS_LI_BUF.XLOG_REG_TYPE_BCHUNK removed - niovecs from 3 to 2
> 
> [ 2120.030590] XFS (md0): XXX required buf size 3992 -> 4120
> [ 2120.037257] XFS (md0): XXX niovecs           3 -> 2

Logged buffer size went up because a hole was filled. Not a
candidate. Was a directory buffer.

> 
> [ 2279.729095] XFS (sda1): XXX required buf size 152 -> 24
> [ 2279.735437] XFS (sda1): XXX niovecs           2 -> 1
> 
> [ 2279.741360] XFS (sda1): XXX old log item:
> [ 2279.746199] XFS (sda1): log item:
> [ 2279.750512] XFS (sda1):   type       = 0x123c
> [ 2279.755181] XFS (sda1):   flags      = 0x8
> [ 2279.759644] XFS (sda1):   niovecs    = 2
> [ 2279.764246] XFS (sda1):   size       = 256
> [ 2279.768625] XFS (sda1):   bytes      = 152
> [ 2279.773094] XFS (sda1):   buf len    = 152
> [ 2279.777741] XFS (sda1):   iovec[0]
> [ 2279.782044] XFS (sda1):     type     = 0x1
> [ 2279.786607] XFS (sda1):     len      = 24
> [ 2279.790980] XFS (sda1):     first 24 bytes of iovec[0]:
> [ 2279.797290] 00000000: 3c 12 02 00 00 20 08 00 b0 41 f8 08 00 00 00 00  <.... ...A......
> [ 2279.806730] 00000010: 01 00 00 00 01 00 00 00                          ........
> [ 2279.815287] XFS (sda1):   iovec[1]
> [ 2279.819604] XFS (sda1):     type     = 0x2
> [ 2279.824408] XFS (sda1):     len      = 128
> [ 2279.828888] XFS (sda1):     first 32 bytes of iovec[1]:
> [ 2279.835126] 00000000: 42 4d 41 50 00 00 00 09 ff ff ff ff ff ff ff ff  BMAP............
> [ 2279.844617] 00000010: ff ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00  ................

Hold on - BMAP?

But the directory buffer above was a XDB3, and so a matching BMAP
btree buffer should have a BMA3 signature. So this is output from
two different filesystems, one formatted with crc=0, the other with
crc=1....

Oh, wait, now that I look at it, all the inodes in the output are v2
inodes. Yet your testing is supposed to be running on CRC+reflink
enabled filesystems, which use v3 inodes. So none of these traces
come from the filesystem under your 'cp -a' workload, right?

Fmeh, it's right there - "XFS (sda1)...". These are all traces from
your root directory, not md0/md1 which are your RAID6 devices
running the 'cp -a' workload. The only trace from md0 was the hole
filling buffer which grew the size of the log vector.

Ok, can you plese filter the output to limit it to just the RAID6
filesystem under test so we get the transaction dumps just before it
hangs? If you want to, create a separate dump output from the root
device to capture the things it is doing, but the first thing is to
isolate the 'cp -a' hang vector...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
