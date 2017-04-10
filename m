Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58638 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754371AbdDJQBt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 12:01:49 -0400
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem dead,
 xfs_repair won't help)
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <58EB53CA.7030608@tlinx.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
Date: Mon, 10 Apr 2017 11:01:47 -0500
MIME-Version: 1.0
In-Reply-To: <58EB53CA.7030608@tlinx.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>, linux-xfs@vger.kernel.org

On 4/10/17 4:43 AM, L A Walsh wrote:
> Avi Kivity wrote:
>> Today my kernel complained that in memory metadata is corrupt and
>> asked that I run xfs_repair.  But xfs_repair doesn't like the
>> superblock and isn't able to find a secondary superblock.
>>   
> Why doesn't xfs have an option to mount with metadata checksumming
> disabled so people can recover their data?

Because if checksums are bad, your metadata is almost certainly bad,
and with bad metadata, you're not going to be recovering data either.

(and FWIW, CRCs are only the first line of defense: structure verifiers
come after that.  The chance of a CRC being bad and everything else
checking out is extremely small.)

> Seems like it should be easy to provide, no?
> 
> Or rather, if a disk is created with the crc option, is it possible
> to later switch it off or mount it without with checking disabled?

It is not possible.

> Yes, I know the mantra is that they should have had backups, but
> in practice it's seems not the case in a majority of uses outside
> of enterprise usage.  It sure seems that disabling a particular file
> or directory (if necessary) affected by a bad-crc, would be
> preferable to losing the whole disk.  That said, how many crc
> errors would be likely to make things unreadable or inaccessible?

How log is a piece of string?  ;)  Totally depends on the details.

> Given that the default before crc-checking was that the disks
> were still usable (often with no error being flagged or noticed),

Before, we had a lot of ad-hoc checks (or not.)  Many of those checks,
and/or IO errors when trying to read garbage metadata, would also
shut down the filesystem.

Proceeding with mutilated metadata is almost never a good thing.
You'll wander off into garbage and shut down the fs at best, and OOPS
at worst.  (Losing a filesystem is preferable to losing a system!)

> I'd suspect that the crc-checking is causing many errors to be
> be flagged that before wouldn't have even been noticed.

Yes, that's precisely the point of CRCs.  :)

> Overall I'm wondering if the crc option won't cause more disk-losses
> than would occur without the option.  Or, in other words, it seems
> that since crc-checking seems to cause the disk to be lost, turning
> on crc checking is almost guaranteed to cause a higher incidence of
> data loss if it can't be disable.

When CRCs detect metadata corruption, the next step is to run
xfs_repair to salvage what can be salvaged, and retrieve what's left of
your data after that.  Disabling CRCs and proceeding in kernelspace with
known metadata corruption would be a dangerous total crapshoot.

-Eric
