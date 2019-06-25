Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51492 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfFYTuA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 15:50:00 -0400
Subject: Re: Want help with messed-up dump
References: <2fE_FncH_93Kynhm46N3zVvFfq26C-AMOypRvdJX2gQM9UPDFVqsyW6svbeS_v1PWpH1lNG7P2cRBL81XDNXn8qioH18PY6aQYwn9_LHwBw=@unascribed.com>
 <df58093d-9b7f-a6e2-5859-bcab9e9617e1@sandeen.net>
 <E0REDMxgD0Z9MMDCXHS6GANHPUbjnE1afm9LzPBon36dr_WRyN0GNZsm9y1Yeagb2HoCqGq60LqFgmAscZvqSKF6mAVTUN8PluTThvD2s2c=@unascribed.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b519068c-4b52-f234-56d9-af327ecd6de5@sandeen.net>
Date: Tue, 25 Jun 2019 14:49:57 -0500
MIME-Version: 1.0
In-Reply-To: <E0REDMxgD0Z9MMDCXHS6GANHPUbjnE1afm9LzPBon36dr_WRyN0GNZsm9y1Yeagb2HoCqGq60LqFgmAscZvqSKF6mAVTUN8PluTThvD2s2c=@unascribed.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Una Thompson <una@unascribed.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>



On 6/25/19 2:04 PM, Una Thompson wrote:
> On Tuesday, June 25, 2019 6:06 AM, Eric Sandeen wrote:
> 
>> On 6/25/19 12:00 AM, Una Thompson wrote:
>>
>>> Hi,
>>> Years ago (around 2015, if I remember correctly), while shrinking a 4.3TiB XFS partition on a RAID5 array, I attempted to perform a dump/restore cycle and lost exactly half of my data. (I was shrinking the partition by a few MB to make room for LUKS metadata to encrypt the filesystem.)
>>> The array had 4 disks (3 online, 1 spare) - I took two disks out, degrading the array, to make room for the dump. Rather than join the two disks into a JBOD, I used xfsdump's ability to write two files, as the disks were 3.7TiB each and the filesystem was nearly full. As said, this was years ago, I forget the exact invocation.
>>
>> Unfortunately xfsdump doesn't have a lot of experts anymore, but we can at least try.
>>
>> Just to be clear, you did something like
>>
>> xfsdump .... -f file1 -f file2 ?
> 
> Probably something like that; I can't be sure, this was years ago and the system that used to own this array that would have the .bash_history has since failed.
> 
>>
>> and
>>
>> "The split is done in filesystem inode number (ino) order, at boundaries selected
>> to equalize the size of each stream."
>>
>> and now you only have file2, and file1 is lost?
> 
> Yes. However, as far as I can tell, I successfully restored file1 at the time, and still have the restored files.
> 
>>
>>> After restoring the dump to the new filesystem with the desired smaller size, I realized the filesystem was only half full. I looked around and a bunch of directories and files were missing. I tried xfsrestore again in various ways to try and get it to read both halves of the dump, but it'd always abort with an error when it finished with the first half.
>>> I fully accept this was my fault and is user error, and I chalked it up as a learning experience at the time, and to avoid losing any more data, rejoined the disk with the first part of the dump to the array. However, now, I'm attempting to find some important files from 2011 or so that were on the array that were lost during this messed up dump/restore.
>>> The spare was never used, and still has the second part of the dump on it; the part I believe didn't get restored correctly. The first part is now gone, after the RAID resync and LUKS format.
>>> I've run photorec on the dump in an attempt to recover the files I'm looking for. I've found a few things that are familiar, but I'm mainly looking for a directory, not an archive, and photorec has been little help. Running xfsrestore on the orphaned half of the dump gives an error about a missing directory dump.
>>
>> sharing the exact error you get when you try would be helpful.
> 
> Knew I forgot something; sorry.
> 
>     xfsrestore: using file dump (drive_simple) strategy
>     xfsrestore: version 3.1.6 (dump format 3.0) - type ^C for status and control
>     xfsrestore: searching media for dump
>     xfsrestore: examining media file 0
>     xfsrestore: dump description:
>     xfsrestore: hostname: phi
>     xfsrestore: mount point: /mnt/big
>     xfsrestore: volume: /dev/md0
>     xfsrestore: session time: Wed May 31 06:26:20 2017
>     xfsrestore: level: 0
>     xfsrestore: session label: ""
>     xfsrestore: media label: ""
>     xfsrestore: file system id: 19672483-ca53-4536-a1ff-eaf79740df38
>     xfsrestore: session id: 8cbb75f6-8739-40ba-97fc-880780463595
>     xfsrestore: media id: 9736ac42-07a4-4622-82c8-1a2bdf3e7f0b
>     xfsrestore: searching media for directory dump
>     xfsrestore: ERROR: no directory dump found
>     xfsrestore: restore complete: 0 seconds elapsed
>     xfsrestore: Restore Summary:
>     xfsrestore:   stream 0 /mnt/foo/bigdump2 ERROR (operator error or resource exhaustion)
>     xfsrestore: Restore Status: SUCCESS
> 
> Evidently, I did this in 2017. My time perception's pretty warped.

Ok, so, the directory structure was (I guess) in the first file.  There is surely a way to hack up xfsrestore to just spit out files into 1 top-level dir, maybe with inode numbers appended or something, but it'd take some hackery to do so, and I can't really guarantee that I have the time to look anytime soon, I'm afraid.

If I do have some downtime I'll try to look but can't make any promises for now.

-Eric
