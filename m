Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 23:03:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m82638XH014342
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 23:03:09 -0700
Message-ID: <48BCD93E.9040407@sgi.com>
Date: Tue, 02 Sep 2008 16:12:14 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Tweak tracing allocation sizes
References: <48BCD3BE.5040107@sgi.com> <20080902055604.GD15962@disturbed>
In-Reply-To: <20080902055604.GD15962@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Sep 02, 2008 at 03:48:46PM +1000, Lachlan McIlroy wrote:
>> The size of a single ktrace entry is 16 pointers so 128 bytes.  For the case
>> of XFS_RW_KTRACE_SIZE which is 128 entries this equates to 16KB and on a system
>> with 4KB pages that is under memory pressure this can stall that process for a
>> significant time while it hunts for 4 free pages.  Cutting this value back to
>> 32 means it will only need one page.
> 
> That will effectively render that type of tracing useless - 32
> entries is not enough history to capture enough
> read/write/map/invalidate trace events to be meaningful. In the past
> I've often had to increase this to 256 or 512 entries to be able to
> capture the events necessary to debug problems...

A system that constantly locks up and/or stalls is useless too.  Allocating
4 or more pages for every inode just taxes the system.  Can you offer an
alternative - maybe a very large global trace buffer that is allocated at mount
time and shared by all inodes?
