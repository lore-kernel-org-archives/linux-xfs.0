Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:34455 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932608AbdDRRcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2017 13:32:09 -0400
Subject: Re: XFS crashes with xfs_iunlink_remove: xfs_imap returned error -22
References: <f94b7ddd-a5a0-b376-6d70-fd9472bd20e8@profihost.ag>
 <bc5aafb9-37a3-9c02-50b7-421633dbd606@sandeen.net>
 <6d9593a4-e7b0-9f8f-676a-686014768150@profihost.ag>
 <fb362f93-db4b-34e9-3902-e5a1e6ed84b6@profihost.ag>
 <76606275-5510-84bd-7f2a-c8a33826e53e@profihost.ag>
 <20170418165900.GD5193@birch.djwong.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <063805b8-3f3b-83e5-93cf-5b0c70daf39f@profihost.ag>
Date: Tue, 18 Apr 2017 19:32:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170418165900.GD5193@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

Hi,

the FS is mounted and in production. I didn't know how to dump a running FS.

Greets,
Stefan

Am 18.04.2017 um 18:59 schrieb Darrick J. Wong:
> On Tue, Apr 18, 2017 at 09:01:17AM +0200, Stefan Priebe - Profihost AG wrote:
>> System crashed again but output was the same.
>>
>> 2017-04-18 07:30:18     XFS (sda3): xfs_iunlink_remove: xfs_imap
>> returned error -22.
>> 2017-04-18 07:30:18     XFS (sda3): xfs_inactive_ifree: xfs_ifree
>> returned error -22
>> 2017-04-18 07:30:18     XFS (sda3): xfs_do_force_shutdown(0x1) called
>> from line 1872 of file fs/xfs/xfs_inode.c. Return address =
>> 0xffffffff9b33cf93
>> 2017-04-18 07:30:18     XFS (sda3): I/O Error Detected. Shutting down
>> filesystem
>> 2017-04-18 07:30:18     XFS (sda3): Please umount the filesystem and
>> rectify the problem(s)
>> 2017-04-18 07:30:18     XFS (sda3): xfs_log_force: error -5 returned.
>> 2017-04-18 07:30:28     XFS (sda3): xfs_log_force: error -5 returned.
>> 2017-04-18 07:30:58     XFS (sda3): xfs_log_force: error -5 returned.
>> 2017-04-18 07:31:28     XFS (sda3): xfs_log_force: error -5 returned.
> 
> That looks like some sort of problem with a garbage value in
> di_next_unlinked that we hit when removing inodes from the AGI unlinked
> inode list.
> 
> Could you take a metadump and get it to us for further analysis?
> Eric might be interested. ;)
> 
> --D
> 
>>
>> Stefan
>> Am 17.04.2017 um 17:06 schrieb Stefan Priebe - Profihost AG:
>>>
>>> Am 17.04.2017 um 17:04 schrieb Stefan Priebe - Profihost AG:
>>>> Hi Eric,
>>>>
>>>>> On 4/17/17 2:54 AM, Stefan Priebe wrote:
>>>>>> Hello list,
>>>>>>
>>>>>> one of my servers is crashing every night with the following errors:
>>>>>>
>>>>>> XFS (sda3): xfs_iunlink_remove: xfs_imap returned error -22.
>>>>>> XFS (sda3): xfs_inactive_ifree: xfs_ifree returned error -22 XFS
>>>>>
>>>>>
>>>>> -EINVAL
>>>>>
>>>>>> (sda3): xfs_do_force_shutdown(0x1) called from line 1872 of file
>>>>>> fs/xfs/xfs_inode.c. Return address = 0xffffffff9e33cf53 XFS (sda3):
>>>>>> I/O Error Detected. Shutting down filesystem
>>>>>>
>>>>>> I ran xfs_repair v4.9.0 but it seems unable to recover / fix this
>>>>>> error. I'm running an OpenSUSE 42.2 kernel based von v4.4. Is there
>>>>>> anything i can do to fix this?
>>>>>
>>>>> # echo 11 > /proc/sys/fs/xfs/error_level
>>>>>
>>>>> to get a full backtrace from the shutdown (if you didn't already)
>>>>> so we can at least see what process is encountering the errors.
>>>>
>>>> done.
>>>>
>>>>> I have a hunch, though - are you running xfs_fsr overnight?
>>>>
>>>> No only rsync from dev/a to dev/b. But the reported device is a (source).
>>>
>>> verified: but that job is done 3-4 hours before crashing.
>>>
>>>>
>>>> I also have two empty folders in /lost+found which i cannot delete. Even
>>>> after running xfs_repair.
>>>>
>>>> # rm -r /lost+found/
>>>> rm: cannot remove ‘/lost+found/536874081’: Directory not empty
>>>> rm: cannot remove ‘/lost+found/536874085’: Directory not empty
>>>>
>>>> Greets,
>>>> Stefan
>>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
