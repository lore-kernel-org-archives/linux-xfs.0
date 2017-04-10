Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:42016 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdDJSFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 14:05:42 -0400
Message-ID: <58EBC972.6040509@tlinx.org>
Date: Mon, 10 Apr 2017 11:05:38 -0700
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem dead,
 xfs_repair won't help)
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com> <58EB53CA.7030608@tlinx.org> <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
In-Reply-To: <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Eric Sandeen wrote:
> On 4/10/17 4:43 AM, L A Walsh wrote:
>> Avi Kivity wrote:
>>> Today my kernel complained that in memory metadata is corrupt and
>>> asked that I run xfs_repair.  But xfs_repair doesn't like the
>>> superblock and isn't able to find a secondary superblock.
>>>   
>> Why doesn't xfs have an option to mount with metadata checksumming
>> disabled so people can recover their data?
> 
> Because if checksums are bad, your metadata is almost certainly bad,
> and with bad metadata, you're not going to be recovering data either.
----

	Sorry, but I really don't by that a 1 bit error
in metadata will automatically cause problems with data recovery.

	If the date on the file shows it was created at some
time with nanoseconds=1 and that gets bumped to 3 (or virtually
any number < an equivalent of 1 second) it will trigger a crc
error.  But I don't care.

> 
> (and FWIW, CRCs are only the first line of defense: structure
> verifiers come after that.  The chance of a CRC being bad and
> everything else checking out is extremely small.)
----	

	If the crc error has caught a bit rot, that wouldn't be
true. Only if the crc error catches a bug in the XFS SW, would
that be likely.  Since I was told that it was protecting me
against bit-rot and not a lower stability or quality of XFS overall,
then it's more likely that data could be recovered.

	Though, again, this is one of those things like allowing
use of the free-space extent that you could *allow* users to use
at their own risk -- but something, likely, that you won't.  

	This is another case where your logic is flawed.  
Permitting mounting w/o enforcement is not a guarantee of 
data recovery, BUT allowing the user to make the decision of
whether or not they can recover anything useful should be up
to the owner of the computer.  Yet it seems clear you aren't
using sound engineering practice to justify your actions.

	Any bit rot metadata corruption is unlikely to wipe
10 TeraBytes of data.  

	Understand your position.  You are claiming the crc option is
detecting errors that were previously undetected.  People have
operated huge filesystems (I'm certain that my 10TB partition is
tiny compared to enterprise usage) for years without experiencing
noticeable problems.  Yet when crc is turned on, suddenly they are
expected to buy into crc detecting corruption so severe that nothing
can be recovered (when such has not been the case since XFS's
inception).  

>> Seems like it should be easy to provide, no?
>>
>> Or rather, if a disk is created with the crc option, is it possible
>> to later switch it off or mount it without with checking disabled?
> 
> It is not possible.
-----
	Not possible eh?  In the SW world?  The only way it would
not be possible is if it were *administratively prohibited*.  
Working around detected bugs or flaws isn't known to be "not
possible" by a long shot. Take ZFS, which , I'm told, 
can not only recover corrupted data from other sectors, 
but doesn't require shutting down the file system due to
the problem detection.  That certainly doesn't sound 
like "impossible".

	If the crc option is only a canary, and not a cipher then
recovery of most data should be possible.

	Are you saying that the crc option doesn't simply do an integrity
check but is converting what was "plaintext" into some encoded form?
That isn't what it is documented to do.

 
>> Yes, I know the mantra is that they should have had backups, but
>> in practice it's seems not the case in a majority of uses outside
>> of enterprise usage.  It sure seems that disabling a particular file
>> or directory (if necessary) affected by a bad-crc, would be
>> preferable to losing the whole disk.  That said, how many crc
>> errors would be likely to make things unreadable or inaccessible?
> 
> How log is a piece of string?  ;)  Totally depends on the details.
--
	That depends on whether or not it is a software error
caused by a typo or by 1 or more bit-flips in a given sector.


> 
>> Given that the default before crc-checking was that the disks
>> were still usable (often with no error being flagged or noticed),
> 
> Before, we had a lot of ad-hoc checks (or not.)  Many of those checks,
> and/or IO errors when trying to read garbage metadata, would also
> shut down the filesystem.
---
	But those checks were rarely triggered.  It was often the
case (you claim) that they went undiscovered for some time -- thus
a "need"[sic] for crc to detect a 1 bit-rot-flip in a 100TB
file system and mark the entire file system as bad.

	Sorry, that's bull.  You need to compartmentalize damage
or its worthless.  Noticing a error in 1 sector shouldn't shutdown
or prevent 100TB of other daya from being accessed (or usable).



> Proceeding with mutilated metadata is almost never a good thing.
> You'll wander off into garbage and shut down the fs at best, and OOPS
> at worst.  (Losing a filesystem is preferable to losing a system!)
----
	
> 
>> I'd suspect that the crc-checking is causing many errors to be
>> be flagged that before wouldn't have even been noticed.
> 
> Yes, that's precisely the point of CRCs.  :)
----

	If they wouldn't have been noticed -- then they wouldn't
have caused problems.  crc is creating problems where before
they didn't -- by definition -- because they catch "many errors...
that before, WOULDN'T HAVE BEEN NOTICED".  That's my point.


>> Overall I'm wondering if the crc option won't cause more
>> disk-losses than would occur without the option.  Or, in other
>> words, it seems that since crc-checking seems to cause the disk
>> to be lost, turning on crc checking is almost guaranteed to cause
>> a higher incidence of data loss if it can't be disable.
> 
> When CRCs detect metadata corruption, the next step is to run
> xfs_repair to salvage what can be salvaged, and retrieve what's
> left of your data after that.  Disabling CRCs and proceeding in
> kernelspace with known metadata corruption would be a dangerous
> total crapshoot.
---

	Right..xfsrepair -- like the base-note poster tried and
and had fail.  The crc errors I'm seen complaints about are ones
were xfsrepair don't work.  At that point, disabling the volume
is not helpful.

	I'm sure it wouldn't be trivial, but creating a separate
file system, "XFS2" from the original XFS sources that responded
to data or metadata corruption by returning empty data where
it was impossible to return anything useful instead of flagging
the disk as "bad", would be a way to allow data recovery to
the extent that it made sense (assuming the original sources
couldn't do the same toggling off a config-flag).

	I'm sure you can out-type and come up with various
reasons as to why XFS or crc can't auto-correct.  Maybe instead
of a crc, you should be using a well established check that
allows recovery from multiple data bit failure.

	Supposedly the 4K block size had more error-resistance and
*recover* than the 512-byte format.  Certainly, with crc's
on all the metadata, a more robust algorithm could automatically
recover from such errors.

	If it is that fragile, then perhaps you should consider enabling
the independant use of the free-inode, which would certainly 
raise performance on mature filesystems.

	I did get that it's been tested on virgin and fresh file
systems and showed no benefit with such, but it would be nice
if such tests were done on 7-10+ year-old filesystems that
"often" exceeded 75% disk space usage -- even going over 
80-90% usage at times for a short period.  It may not be a
normal state, but it does happen.  Certainly it would be
something worthy of testing with real-life data.

:)

*cheers*
-linda

