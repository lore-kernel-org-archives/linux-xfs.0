Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57674 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752398AbcLXRuN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Dec 2016 12:50:13 -0500
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <2626665.Hsx8YazNWY@libor-nb>
 <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
 <31558703.FzcorNpFY2@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3e3b60c5-a050-4856-01bd-733ab58d19c9@sandeen.net>
Date: Sat, 24 Dec 2016 11:50:11 -0600
MIME-Version: 1.0
In-Reply-To: <31558703.FzcorNpFY2@libor-nb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 12/21/16 2:25 AM, Libor Klepáč wrote:
> Hello,
> 
> On úterý 13. prosince 2016 10:04:27 CET Eric Sandeen wrote:
>> On 12/13/16 4:52 AM, Libor Klep�? wrote:
>>> Hello,
>>> should this patch possibly fix errors i reported in this thread?
>>> https://www.spinics.net/lists/linux-xfs/msg01728.html
>>>
>>> Is it safe to test it? (i do have backups)
>>
>> It should be safe, yes.
>>
>> (you could always run xfs_repair -n first to be extra careful).
>>
>> Were those errors during mount/replay, though, or was it when the
>> filesystem was up and running?
>>
>> I ask because I also sent a patch to ignore these empty attributes
>> in the verifier during log replay.
> 
> Is that patch in 4.8.11 kernel?

nope

> I ask, because i rebooted machine from this email
> https://www.spinics.net/lists/linux-xfs/msg02672.html
> 
> with kernel 4.8.11-1~bpo8+1 (from debian)
> mount was clean 
> [    3.220692] SGI XFS with ACLs, security attributes, realtime, no debug enabled
> [    3.222135] XFS (dm-2): Mounting V4 Filesystem
> [    3.284697] XFS (dm-2): Ending clean mount
> 
> 
> and i ran xfs_repair -n -v (xfsprogs 4.8.0 without your patch) and it came clean I think
> ---------------------------------

older repair did not detect the problem, that was the point
of the patch.

-Eric

> #xfs_repair -n -v /dev/dm-2
> Phase 1 - find and verify superblock...
>         - block cache size set to 758064 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 5035 tail block 5035
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> 
>         XFS_REPAIR Summary    Tue Dec 20 06:01:14 2016
> 
> Phase           Start           End             Duration
> Phase 1:        12/20 05:49:02  12/20 05:49:02
> Phase 2:        12/20 05:49:02  12/20 05:49:02
> Phase 3:        12/20 05:49:02  12/20 05:59:24  10 minutes, 22 seconds
> Phase 4:        12/20 05:59:24  12/20 06:00:17  53 seconds
> Phase 5:        Skipped
> Phase 6:        12/20 06:00:17  12/20 06:01:13  56 seconds
> Phase 7:        12/20 06:01:13  12/20 06:01:14  1 second
> 
> Total run time: 12 minutes, 12 seconds
> ---------------------------------
> 
> then i ran metadump and then i ran out of time of my repair window ;)
> 
> 
> 
> Libor
> 
> 
>>
>> FWIW, Only some of your reported buffers look "empty" though, the one
>> at 514098.682726 may have had something else wrong.
>>
>> Anyway, yes, probably worth checking with xfs_repair (-n) with this
>> patch added.  Let us know what you find! :)
>>
>> -Eric
>>
>>  
>>> Thanks,
>>> Libor
>>>
>>> On ?tvrtek 8. prosince 2016 12:06:03 CET Eric Sandeen wrote:
>>>> We have recently seen a case where, during log replay, the
>>>> attr3 leaf verifier reported corruption when encountering a
>>>> leaf attribute with a count of 0 in the header.
>>>>
>>>> We chalked this up to a transient state when a shortform leaf
>>>> was created, the attribute didn't fit, and we promoted the
>>>> (empty) attribute to the larger leaf form.
>>>>
>>>> I've recently been given a metadump of unknown provenance which actually
>>>> contains a leaf attribute with count 0 on disk.  This causes the
>>>> verifier to fire every time xfs_repair is run:
>>>>
>>>>  Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000
>>>>
>>>> If this 0-count state is detected, we should just junk the leaf, same
>>>> as we would do if the count was too high.  With this change, we now
>>>> remedy the problem:
>>>>
>>>>  Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000
>>>>  bad attribute count 0 in attr block 0, inode 12587828
>>>>  problem with attribute contents in inode 12587828
>>>>  clearing inode 12587828 attributes
>>>>  correcting nblocks for inode 12587828, was 2 - counted 1
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>
>>>> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
>>>> index 40cb5f7..b855a10 100644
>>>> --- a/repair/attr_repair.c
>>>> +++ b/repair/attr_repair.c
>>>> @@ -593,7 +593,8 @@ process_leaf_attr_block(
>>>>  	stop = xfs_attr3_leaf_hdr_size(leaf);
>>>>  
>>>>  	/* does the count look sorta valid? */
>>>> -	if (leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >
>>>> +	if (!leafhdr.count ||
>>>> +	    leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >
>>>>  						mp->m_sb.sb_blocksize) {
>>>>  		do_warn(
>>>>  	_("bad attribute count %d in attr block %u, inode %" PRIu64 "\n"),
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 
> 
> --------
> [1] mailto:libor.klepac@bcom.cz
> [2] tel:+420377457676
> [3] http://www.bcom.cz
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
