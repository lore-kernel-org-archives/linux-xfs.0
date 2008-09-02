Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 23:26:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m826QDLC016975
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 23:26:13 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB8D012FE3DD
	for <xfs@oss.sgi.com>; Mon,  1 Sep 2008 23:27:39 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id k3FByMjEWSeunL7n for <xfs@oss.sgi.com>; Mon, 01 Sep 2008 23:27:39 -0700 (PDT)
Date: Tue, 2 Sep 2008 16:27:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Tweak tracing allocation sizes
Message-ID: <20080902062722.GF15962@disturbed>
References: <48BCD3BE.5040107@sgi.com> <20080902055604.GD15962@disturbed> <48BCD93E.9040407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BCD93E.9040407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 02, 2008 at 04:12:14PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Tue, Sep 02, 2008 at 03:48:46PM +1000, Lachlan McIlroy wrote:
>>> The size of a single ktrace entry is 16 pointers so 128 bytes.  For the case
>>> of XFS_RW_KTRACE_SIZE which is 128 entries this equates to 16KB and on a system
>>> with 4KB pages that is under memory pressure this can stall that process for a
>>> significant time while it hunts for 4 free pages.  Cutting this value back to
>>> 32 means it will only need one page.
>>
>> That will effectively render that type of tracing useless - 32
>> entries is not enough history to capture enough
>> read/write/map/invalidate trace events to be meaningful. In the past
>> I've often had to increase this to 256 or 512 entries to be able to
>> capture the events necessary to debug problems...
>
> A system that constantly locks up and/or stalls is useless too.  Allocating
> 4 or more pages for every inode just taxes the system.  Can you offer an
> alternative

Buy more memory for your test machine? (I can't beleive I'm saying that
to an SGI guy ;)

How about using the SLUB allocator rather than SLAB and tweaking
it's settings to do order 2 allocations for every slab so most
allocations are doing order 2 allocations?

> - maybe a very large global trace buffer that is allocated at mount
> time and shared by all inodes?

Sure, we've got that for various other trace types (e.g. the "vnode"
trace). You'd need to add idbg stuff for filtering based on the
inode the buffer belongs to....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
