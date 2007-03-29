Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Mar 2007 19:34:48 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2T2Yi6p027537
	for <xfs@oss.sgi.com>; Wed, 28 Mar 2007 19:34:45 -0700
Message-ID: <460B25BE.3050808@tlinx.org>
Date: Wed, 28 Mar 2007 19:34:38 -0700
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com> <460A6298.4040702@j-o-a.de> <460A821B.4080308@sandeen.net> <460AC857.6040305@j-o-a.de> <460B068C.6060903@tlinx.org>
In-Reply-To: <460B068C.6060903@tlinx.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <lkml@tlinx.org>
Cc: Oliver Joa <oliver@j-o-a.de>, Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>


Oliver Joa wrote:
>> eason or another, xfs has detected a corrupted on-disk inode format 
>> which it cannot recognize, and shuts down.
----
Oh, one other thing that may not apply in your case, but may.
Does your SATA disk support write caching?  Does it support
something called a barrier function?  (not real clear on all
the ways this can go wrong, but I believe barriers are supposed
to guarantee previous data has been fixed on disk (not in write
cache).  If the SATA controller issues a reset, it may very well
purge the write cache.  Theoretically, I can think of a _possibility_,
that the reset disk would purge the write cache and the barrier
indicator would tell xfs to resume writing.  From a recent thread
on the xfs list, it would appear this could be a "bad" thing (like
crossing the streams ala "ghostbusters", but in a data-integrity
context).

Just a "shot in the dark" -- absent knowing anything specific
about your hardware or situation...

If that's the case, you might want to turn off write
caching, since when xfs thinks "barriers" work, it turns
off some "protection", that can enable some significant
speedup in some situations. As an aside, some disks, I gather,
may "claim" to support barriers, but really don't.  Xfs tries
to verify the barrier claim, but I don't know that a reset
issued to the disk will have deterministic behavior across
all manufacturer's disks.  A bunch of "coulds" and "maybe's",
but just thinking off top of head...

Linda
