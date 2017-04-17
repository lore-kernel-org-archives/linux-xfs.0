Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:64001 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753164AbdDQPGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Apr 2017 11:06:31 -0400
Subject: Re: XFS crashes with xfs_iunlink_remove: xfs_imap returned error -22
References: <f94b7ddd-a5a0-b376-6d70-fd9472bd20e8@profihost.ag>
 <bc5aafb9-37a3-9c02-50b7-421633dbd606@sandeen.net>
 <6d9593a4-e7b0-9f8f-676a-686014768150@profihost.ag>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <fb362f93-db4b-34e9-3902-e5a1e6ed84b6@profihost.ag>
Date: Mon, 17 Apr 2017 17:06:28 +0200
MIME-Version: 1.0
In-Reply-To: <6d9593a4-e7b0-9f8f-676a-686014768150@profihost.ag>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org


Am 17.04.2017 um 17:04 schrieb Stefan Priebe - Profihost AG:
> Hi Eric,
> 
>> On 4/17/17 2:54 AM, Stefan Priebe wrote:
>>> Hello list,
>>>
>>> one of my servers is crashing every night with the following errors:
>>>
>>> XFS (sda3): xfs_iunlink_remove: xfs_imap returned error -22.
>>> XFS (sda3): xfs_inactive_ifree: xfs_ifree returned error -22 XFS
>>
>>
>> -EINVAL
>>
>>> (sda3): xfs_do_force_shutdown(0x1) called from line 1872 of file
>>> fs/xfs/xfs_inode.c. Return address = 0xffffffff9e33cf53 XFS (sda3):
>>> I/O Error Detected. Shutting down filesystem
>>>
>>> I ran xfs_repair v4.9.0 but it seems unable to recover / fix this
>>> error. I'm running an OpenSUSE 42.2 kernel based von v4.4. Is there
>>> anything i can do to fix this?
>>
>> # echo 11 > /proc/sys/fs/xfs/error_level
>>
>> to get a full backtrace from the shutdown (if you didn't already)
>> so we can at least see what process is encountering the errors.
> 
> done.
> 
>> I have a hunch, though - are you running xfs_fsr overnight?
> 
> No only rsync from dev/a to dev/b. But the reported device is a (source).

verified: but that job is done 3-4 hours before crashing.

> 
> I also have two empty folders in /lost+found which i cannot delete. Even
> after running xfs_repair.
> 
> # rm -r /lost+found/
> rm: cannot remove ‘/lost+found/536874081’: Directory not empty
> rm: cannot remove ‘/lost+found/536874085’: Directory not empty
> 
> Greets,
> Stefan
> 
