Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40666 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750742AbdHUDBF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 Aug 2017 23:01:05 -0400
Subject: Re: xfs errors
References: <42ebd50b-a327-0afb-a53a-e2dedd003415@zoho.com>
 <da41ec6e-0009-6515-7c60-a48c3b07369b@sandeen.net>
 <2fd2a278-4c78-3072-e10d-d9745f5183fb@zoho.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c9ee564c-8627-ad00-cc86-5548c9688298@sandeen.net>
Date: Sun, 20 Aug 2017 22:01:04 -0500
MIME-Version: 1.0
In-Reply-To: <2fd2a278-4c78-3072-e10d-d9745f5183fb@zoho.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ToddAndMargo <ToddAndMargo@zoho.com>, linux-xfs@vger.kernel.org



On 8/20/17 8:26 PM, ToddAndMargo wrote:
> On 08/20/2017 10:59 AM, Eric Sandeen wrote:
>> On 8/20/17 12:57 AM, ToddAndMargo wrote:
>>> Dear Xfs,
>>>
>>> Do I report this to you or Red Hat?
>>>
>>> Fedora Core 26, x564
>>
>> Here is fine, or Fedora if you want, but it'll be the same people responding in any case.
>>
>>> xfsdump-3.1.6-4.fc26.x86_64
>>>
>>> When I run the following
>>>
>>>      # /sbin/xfsdump -v verbose -M 1 -L 1 -l 0 -f /lin-bak/2017-08-19_22-30-27_md126p2.XfsDump  /
>>>
>>> randomly, I get this error message when I run xfsdump:
>>>
>>>
>>>      /sbin/xfsdump: ino map phase 1: constructing initial dump list
>>>      /sbin/xfsdump: WARNING: failed to get bulkstat information for inode 739
>>>      /sbin/xfsdump: WARNING: failed to get bulkstat information for inode 954
>>>      /sbin/xfsdump: WARNING: failed to get bulkstat information for inode 1118
>>>      about 40 more of them
>>>
>>> And the next time it will run clean.  What gives?
>>
>> Most likely it's files that got deleted while xfsdump was running.  xfsdump has a bad habit of issuing warnings for things that are not actually problematic.
>>
>> But you could also look for those inodes on the filesystem you're dumping; what are they?  Are they still there, or were they transient files?
>>
>> If you quiesce the filesystem first, or dump from a snapshot, you should not see such errors.
>>
>> -Eric
>>
>>> I put a `sunc; sync` before the dump command and it seems to help, but it is random, so who knows.
>>>
>>> Is this a bug?  Or am I doing something wrong?
>>>
>>> Many thanks,
>>> -T
> 
> Hi Eric,
> 
> Thank you for responding!
> 
> After I added `sync; sync` before the call to xfsdump, I ran
> about 10 more backups without a hitch.
> 
> I also run xfsdump at my office.  It does complain about missing
> stuff if I leave Thunderbird running during the backup.
> But it is the occasional single error.  Not a broken fire hydrant
> of millions of errors.
> 
> My office version is xfsdump-3.1.4-1.el7.x86_64  (Scientific
> Linux, a.k.a. "old-out-of-date").
> 
> As a test, I ssh logged into the server question while writing
> this, it having been running overnight, and ran the sync
> modified dump again.  The problem did not reproduce.
> 
> The difference between my office and the customer is
> that I use a hardware raid (raid 1) card and the customer
> uses RSTe ("e" for enterprise) RAID 1, which is a pseudo
> software raid.  Maybe a lot of stuff is floating around
> in the either (cache) that is not sync'ed to the drive pair
> and xfsdump is not happy about it.

The underlying storage will not affect this.

> I am wonder if it would be possible for xfsdump to can
> "sync; sync" itself before starting.  That would insure
> a clean slate.

No; that's a guess, not a root cause analysis - we won't
be putting hacks like that in based on hunches.

If you want to investigate more, find out where in the code
the error spits out, and do more error reporting there; find out
what error code is actually being returned.  actually I suppose
strace would work for this as well.  Knowing which error code
the ioctl fails with would offer a clue about why.

-Eric

> -T
> 
