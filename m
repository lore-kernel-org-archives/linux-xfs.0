Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:60292 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754672AbcK3T1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 14:27:09 -0500
Message-ID: <583F2806.7080102@tlinx.org>
Date: Wed, 30 Nov 2016 11:27:02 -0800
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: default mount options
References: <583E1488.7090502@tlinx.org> <6ecda11c-a993-3dd7-5b87-1947506953ff@sandeen.net>
In-Reply-To: <6ecda11c-a993-3dd7-5b87-1947506953ff@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org



Eric Sandeen wrote:
> On 11/29/16 5:51 PM, L.A. Walsh wrote:
>> Is it possible for the 'mount' man page to be enhanced to show
>> what the defaults are?  Or if that's not possible,
>> maybe the xfs(5) manpage?
> 
> xfs(5) covers xfs mount options now.  AFAIK, defaults are clearly
> stated.  Is something missing?
> i.e. -
> "Barriers are enabled by default."
> "For this reason, nodiscard is the default."
> "For kernel v3.7 and later, inode64 is the default."
> "noikeep is the default."
> etc.
----
	Most of the text is the same as on the manpage, with small
insertions that weren't obvious at the time I sent the email, however
logbsize -- default for v2 logs is MAX(32768, log_sunit).  What
does 'log' mean?  As in the arithmetic function?
	"noalign" is only relevant to filesystems created with
non-zero data alignment parms by mkfs.  Does it apply if the container
that xfs is in is not zero aligned?  If the partitions weren't created
on boundaries or the "volumes" on top of the partitions weren't created
on boundaries, how would one specify the overall file system alignment --
especially when, say, lvm's on-disk allocs at he beginning of a volume
may not be a multiple of a strip-size (had 768K w/a 3-stripe, 4-data
disk RAID5 (RAID50).
	"noquota" to force off all quota.  So I don't specify
any quotas, is that the same as "noquota" -- does that mean it is
the default?  
	It seems one can figure things out if one makes certain
assumptions, but that makes me uneasy.

> If there's something missing, please let us know (or send a patch).
>
>> Also, I'm again "unclear" on barriers.
> It means that the xfs "barrier" mount option is enabled by default.  ;)
---
	Then why doesn't it say "the barrier option" telling
xfs to add barriers, is the default".


> There is no "barrier implemented in hardware" - having barriers
> turned on means that XFS will requeseet block device flushes at
> appropriate times to maintain consistency, even with write caching.
---
	"requeseet"?  Is that "request"?  (Seriously, I had
to google it to be sure).


> 
>> It also says drives may enable write-caching -- but this should
>> only be done if they support write barriers.  How is this "decided"?
>> I.e is it done "automatically" in HW? in SW? Or should the user "know"?
> 
> What this means is that if barriers are enabled, write-caching
> on the drive can be safely enabled.
> 
> The user should leave barriers on.  Devices which don't need them
> should ignore them.
====
	Not my experience.  Devices with non-volatile cache
or UPS-backed cache, in the past, have been considered "not needing
barriers".  Has this changed?  Why?
> 
> Simplified, if turning barriers /off/ made your workload go faster,
> that means you should have left them on in the first place.  If it
> didn't, then there was no reason to turn the knob in the first place...
====
	Not my experience.  Devices with non-volatile cache
or UPS-backed cache, in the past, have been considered "not needing
barriers".  But those systems also, sometimes, change runtime
behavior based on the UPS or battery state -- using write-back on
a full-healthy battery, or write-through when it wouldn't be safe.

	In that case, it seems nobarrier would be a better choice
for those volumes -- letting the controller decide.


>> Is this related to whether or not the drives support "state" over
>> power interruptions?  By having non-volatile "write-cache" memory,
>> battery-backed cache, or backed by a UPS?  Wouldn't SSD's be
>> considers safe for this purpose (because their state is non-volatile?).
> 
> I'm not sure there is any universal answer for what SSDs may do
> on a power loss, but I think it's certainly common for them to
> have a volatile write cache as well.
---
	I've yet to see one that does.  Not saying they couldn't 
exist, but just that I've yet to see one -- with the behavior
being that if it accepts the write and returns, the data is
on the SSD.

> Just leave the option at the default, and you'll be fine.  There is
> rarely, if ever, a reason to change it.
---	
	Fine isn't what I asked.  I wanted to know if the switch
specified that xfs should add barriers or that barriers were already
handled in the backing store for those file systems.  If the prior
then I would want nobarrier on some file systems, if the latter, I
might want the default.  But it sounds like the switch applies
to the former -- meaning I don't want them for partitions that
don't need them.


