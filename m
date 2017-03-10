Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38676 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754107AbdCJQry (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Mar 2017 11:47:54 -0500
Subject: Re: [PATCH] repair: handle reading superblock from image on larger
 sector size filesystem
References: <1488998407-9094-1-git-send-email-zlang@redhat.com>
 <41576a80-2f48-14e3-78c0-7425afe402c3@sandeen.net>
 <20170310162859.GA21915@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c63969a0-9fce-fc9f-3713-76e46c7b6e0c@sandeen.net>
Date: Fri, 10 Mar 2017 10:47:52 -0600
MIME-Version: 1.0
In-Reply-To: <20170310162859.GA21915@dhcp12-143.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 3/10/17 10:28 AM, Zorro Lang wrote:
> On Thu, Mar 09, 2017 at 08:58:07PM -0600, Eric Sandeen wrote:
>> On 3/8/17 12:40 PM, Zorro Lang wrote:
>>> Due to xfs_repair uses direct IO, sometimes it can't read superblock
>>> from an image file has smaller sector size than host filesystem.
>>> Especially that superblock doesn't align with host filesystem's
>>> sector size.
>>>
>>> To avoid this, when direct read returns EINVAL, turn off direct IO,
>>> then try to read again.
>>
>> Ok, so the problem is that while we already do this after phase1,
>> you're running into trouble /during/ phase1.
> 
> Yes,
> 
>>
>>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>>> ---
>>>
>>> Hi,
>>>
>>> I found this bug when I try to modify xfstests' xfs/078 on s390x,
>>> manually reproduce this bug by below steps:
>>
>> I bet you could write an xfstest for this using scsi_debug, yes?
> 
> xfs/078 (after my patch can be merged) can reproducer this bug on
> s390x or other machines with 4k sector size disk. Do you think we
> need a separate one case to test that?

That would be best, because few people test on s390x or machines with
hard 4k sector disks.

...

>> So I think that before we start either the superblock verification or
>> discovery loops in verify_set_primary_sb() or find_secondary_sb(),
>> check whether the sector size or block size is less than the host
>> filesystem's geometry, and if so, turn off DIO.
>>
>> It probably doesn't hurt to call it again after phase1, when we have
>> a valid superblock (same place as we do today)
>>
>> I think that'll work...
> 
> Hmm, that sounds good, but I need to read the code to make sure how
> to do this change :)

Yes, it'll require a little thought.

Goals are to avoid cut and paste, and try to find out beforehand if
we'll be doing unaligned IOs.  Thinking more about the EINVAL test,
it's not the best heuristic - we can know ahead of time whether or
not our IOs will be aligned to the underlying filesystem's constrants.

Thanks,
-Eric

> Thanks,
> Zorro
> 
>>
>> -Eric
>>
>>>  	}
>>>  	libxfs_sb_from_disk(sbp, buf);
>>>  
>>>
> 
