Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25358 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdIAXmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 19:42:00 -0400
Subject: Re: How do I stop the roll backs?
References: <15e3d125e44.1006338d5356.4004547008347294090@zoho.com>
 <20170901113853.27txrjvdcnc7gcgb@hades.localdomain>
From: ToddAndMargo <ToddAndMargo@zoho.com>
Message-ID: <52e5faf2-9e64-17e1-c368-38d193ffeb86@zoho.com>
Date: Fri, 1 Sep 2017 16:41:56 -0700
MIME-Version: 1.0
In-Reply-To: <20170901113853.27txrjvdcnc7gcgb@hades.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 09/01/2017 04:38 AM, Carlos Maiolino wrote:
> Hi,
> 
> On Fri, Sep 01, 2017 at 03:52:47AM -0700, toddandmargo wrote:
>> Hi All,
>>
>> Fedora 26
>>
>> Every time I shutdown, everything i have modifies or added  gets rolled back.
>> And I have to restore everything from backup, including most of the customer's
>> data that was copied from Samba on the old server.  It is a disaster.
>>
> 
> This is quite weird, are you able to reproduce it by just
> mounting/modifying/unmounting the filesystem?
> 
> Only thing that comes to my mind at a first glance would be if something went
> wrong with the journal.
> 
> Can you provide more details about your setup? Mainly regarding the storage
> organization where your XFS filesystem is in. Logs, from the system too.
> 
> A good guide of what information to provide can be found here:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> 
>> How do I stop this?
>>
>> Many thanks,
>> -T
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Carlos,

For the full run down and details on this stinker, see
https://bugzilla.redhat.com/show_bug.cgi?id=1483279
It includes a full hardware and OS list.

Basically, the stinking (not my "actual" word) backup drive itself
turned out to be the problem: Western Digital WD20NPVZ 2TB.

If you are using the OS drive when this happens, you are just toast.
If you are booted off a live USB, then this is the error you get:

     Failed to mount "894 GB Volume"
     Error mounting /dev/md126p2 at 
/run/media/todd/f1c297de-d5c6-48ba-ac8f-d2c1a7b4702d: Command-line 
`mount -t "xfs" -o "uhelper=udisks2,nodev,nosuid" "/dev/md126p2" 
"/run/media/todd/f1c297de-d5c6-48ba-ac8f-d2c1a7b4702d"' exited with 
non-zero exit status 32: mount: 
/run/media/todd/f1c297de-d5c6-48ba-ac8f-d2c1a7b4702d: can't read 
superblock on /dev/md126p2.

The bug report is full of details.

You unmount the drive, pull it out of the hot swap sleave,
put it back in, wait 20 seconds, and your main hard drive
seizes.  You have to power off to recover.  The one fingered
reset doesn't even work,  Then XFS senses a crash and journals
(rolls back) gigabytes of your data.

So XFS was actually doing what it was suppose to do, which
is to fix a crash.  For my purposes, it was altogether much to
aggressive.  I would prefer it checked for corruptions before
it journaled backwards.

I converted the system to all ext4.  I was at the customer's
site till 06:00 in the morning repairing everything.  Fortunately
I keep good backup.  Unfortunately, when switching file systems
your can't just restore your home partition and use the new
install.  I tried about five different ways and then just
went through everything an reinstalled it from backup.  Some of
the back up data was journalled too.  Fortunately I has old
backups too.  And having to switch from "legacy" to "EUFI"
was a pain in the neck (again, not my "actual" word).

And SELinux almost ate my lunch.  But I prevailed
and kept extensive notes on each service it affected: cups-lpd,
samba, named, ssh, xrdp, iptables.  About drove me nuts.
Samba was a "real treat" to figure out.


So, I got to see XFS in action.  I can see were this would be
an advantage in a large data setting.  But, again, it is way too
aggressive for me.  I would rather it did an fsck and then
journaled back what it couldn't fix.

Oh, I came up with a unique way of blanking out a disk!
In BIOS set it up as RAID (which blanks the drive), then
remove it from the raid for reuse.

gparted really need some kind of blank the drive option.
It gave me fits at times.  I must have installed the OS 20 times
last night narrowing the hot swap crash down to the stinking back
up drive.  This weird as I do this all over the place, including
my own office.

I figure I am now out about 1000 U$D with all the free
troubleshooting to figure this out.  And a lot of lost sleep.
Life in the fast lane.  Huh!

-T

