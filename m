Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40084 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932340AbdJZSBa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:01:30 -0400
Subject: Re: [PATCH] xfsprogs: Issue smaller discards at mkfs
From: Eric Sandeen <sandeen@sandeen.net>
References: <20171026144131.26885-1-keith.busch@intel.com>
 <20171026162518.GW5483@magnolia>
 <3ad1751a-a4df-b0ee-d2c5-d1ac4deb5b46@sandeen.net>
Message-ID: <0d50ca3b-0b27-8ac1-c102-9ea656f3f926@sandeen.net>
Date: Thu, 26 Oct 2017 13:01:29 -0500
MIME-Version: 1.0
In-Reply-To: <3ad1751a-a4df-b0ee-d2c5-d1ac4deb5b46@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Keith Busch <keith.busch@intel.com>
Cc: linux-xfs@vger.kernel.org

On 10/26/17 12:49 PM, Eric Sandeen wrote:
> On 10/26/17 11:25 AM, Darrick J. Wong wrote:
>> On Thu, Oct 26, 2017 at 08:41:31AM -0600, Keith Busch wrote:
>>> Running mkfs.xfs was discarding the entire capacity in a single range. The
>>> block layer would split these into potentially many smaller requests
>>> and dispatch all of them to the device at roughly the same time.
>>>
>>> SSD capacities are getting so large that full capacity discards will
>>> take some time to complete. When discards are deeply queued, the block
>>> layer may trigger timeout handling and IO failure, though the device is
>>> operating normally.
>>>
>>> This patch uses smaller discard ranges in a loop for mkfs to avoid
>>> risking such timeouts. The max discard range is arbitrarilly set to
>>> 128GB in this patch.
>>
>> I'd have thought devices would set sane blk_queue_max_discard_sectors
>> so that the block layer doesn't send such a huge command that the kernel
>> times out...
>>
>> ...but then I actually went and grepped that in the kernel and
>> discovered that nbd, zram, raid0, mtd, and nvme all pass in UINT_MAX,
>> which is 2T.  Frighteningly xen-blkfront passes in get_capacity() (which
>> overflows the unsigned int parameter on big virtual disks, I guess?).
>>
>> (I still think this is the kernel's problem, not userspace's, but now
>> with an extra layer of OMGWTF sprayed on.)
>>
>> I dunno.  What kind of device produces these timeouts, and does it go
>> away if max_discards is lowered?
> 
> Yeah, lots of devices are unhappy with large discards.  And yeah, in the
> end I think this papers over a kernel and/or hardware problem.
> 
> But sometimes we do that, if only to keep things working reasonably
> well with older kernels or hardware that'll never get fixed...
> 
> (TBH sometimes I regret putting mkfs-time discard in by default in the
> first place.)

I think I left this on a too-positive note.  It seems pretty clear that there
is no way to fix all of userspace to not issue "too big" discards, when
"too big" isn't even well-defined, or specified by anything at all.

I'm not wise in the ways of queueing and throttling, but from my naiive
perspective, it seems like something to be fixed in the kernel, or if it
can't, export some new "maximum discard request size" which can be trusted?

-Eric
