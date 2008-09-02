Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 23:49:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m826nSYR018946
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 23:49:30 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D1247A5322
	for <xfs@oss.sgi.com>; Mon,  1 Sep 2008 23:50:52 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id mlZjEl8XIWN82I0i for <xfs@oss.sgi.com>; Mon, 01 Sep 2008 23:50:52 -0700 (PDT)
Subject: Re: [PATCH] Tweak tracing allocation sizes
From: Andi Kleen <andi@firstfloor.org>
References: <48BCD3BE.5040107@sgi.com> <20080902055604.GD15962@disturbed>
	<48BCD93E.9040407@sgi.com>
Date: Tue, 02 Sep 2008 08:50:52 +0200
In-Reply-To: <48BCD93E.9040407@sgi.com> (Lachlan McIlroy's message of "Tue, 02 Sep 2008 16:12:14 +1000")
Message-ID: <87fxojvy5v.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy <lachlan@sgi.com> writes:

> Dave Chinner wrote:
>> On Tue, Sep 02, 2008 at 03:48:46PM +1000, Lachlan McIlroy wrote:
>>> The size of a single ktrace entry is 16 pointers so 128 bytes.  For the case
>>> of XFS_RW_KTRACE_SIZE which is 128 entries this equates to 16KB and on a system
>>> with 4KB pages that is under memory pressure this can stall that process for a
>>> significant time while it hunts for 4 free pages.  Cutting this value back to
>>> 32 means it will only need one page.
>> That will effectively render that type of tracing useless - 32
>> entries is not enough history to capture enough
>> read/write/map/invalidate trace events to be meaningful. In the past
>> I've often had to increase this to 256 or 512 entries to be able to
>> capture the events necessary to debug problems...
>
> A system that constantly locks up and/or stalls is useless too.  Allocating
> 4 or more pages for every inode just taxes the system.  Can you offer an
> alternative - maybe a very large global trace buffer that is allocated at mount
> time and shared by all inodes?

You could use vmalloc(). While that is also not fast it will at least
not stall.

-Andi

-- 
ak@linux.intel.com
