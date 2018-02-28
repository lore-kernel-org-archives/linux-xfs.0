Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m213138.ym.163.com ([223.252.213.138]:39517 "EHLO
        m213138.ym.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbeB1Dkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Feb 2018 22:40:40 -0500
Subject: Re: xfs_repair: add '-F' option to ignore writable mount checking
References: <5A914B45.8080200@xtaotech.com>
 <5c0df437-0f09-129c-945f-0f917bfdaa7e@sandeen.net>
 <20180224220428.GB30854@dastard> <5A953693.8080101@xtaotech.com>
 <5aeeed0a-f808-0331-d528-04fdd42d90be@sandeen.net>
From: Yang Joseph <joseph.yang@xtaotech.com>
Message-ID: <5A962355.1090408@xtaotech.com>
Date: Wed, 28 Feb 2018 11:34:45 +0800
MIME-Version: 1.0
In-Reply-To: <5aeeed0a-f808-0331-d528-04fdd42d90be@sandeen.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, nathans@debian.org, linux-xfs@vger.kernel.org



On 02/27/2018 10:47 PM, Eric Sandeen wrote:
> On 2/27/18 4:44 AM, Yang Joseph wrote:
>> xfs_repair should not touch non-xfs mountpoints in platform_check_mount().
>> If non-xfs mountpoints can be filtered out, the dead fuse mountpoint can
>> never block our xfs_repair. The following patch can fix my problem and not
>> add dangerous option to xfs_repair.
> I don't think this is a safe solution.  For example:
>
> # mkfs.ext4 /dev/sdb1
> # mount /dev/sdb1 /mnt/test
>
> Old behavior:
>
> # xfs_repair /dev/sdb1
> xfs_repair: /dev/sdb1 contains a mounted filesystem
>
> New behavior with your patch:
>
> # repair/xfs_repair /dev/sdb1
> xfs_repair: cannot open /dev/sdb1: Device or resource busy
>
> With your patch, if we explicitly ask xfs_repair to repair a non-xfs
> filesystem which is mounted, it will get past all of the checks and
> try to open the device O_EXCL - which should fail if the device is
> mounted, but I'm guessing your fuse case would now simply hang here
> instead.
As fuse mountpoint is filtered out, xfs_repair will not hang here.
(No stat(/fuse/mountpoint/))
>
> Worse, other utilities aren't so graceful.
>
> Old:
>
> # xfs_copy /dev/sdb2 /dev/sdb1
> xfs_copy:  a filesystem is mounted on target device "/dev/sdb1".
> xfs_copy cannot copy to mounted filesystems.  Aborting
>
> New:
>
> copy/xfs_copy /dev/sdb2 /dev/sdb1
>   0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ... 80%  ... 90%  ... 100%
>
> All copies completed.
>
> (now we've just written over a mounted, writable ext4 filesystem)
>
> (Anyone want to investigate whether every device open in xfsprogs should
> be O_EXCL?)
>
> Also, in general:
>
> When sending a patch to the list, please prefix the subject with
> [PATCH] to make it obvious; patches also require a Signed-off-by:
> line similar to:
>
>    Signed-off-by: Yang Joseph <joseph.yang@xtaotech.com>
>
> The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch.
>
> It essentially states that you are the author of this work and you have
> the right to submit it for inclusion in this project.
>
> Thanks,
> -Eric
>
>
>> thx,
>>
>> Yang Honggang
>>
>> -------------------------new patch----------------------
>> diff --git a/libxfs/linux.c b/libxfs/linux.c
>> index 0bace3e..6ad24ce 100644
>> --- a/libxfs/linux.c
>> +++ b/libxfs/linux.c
>> @@ -44,6 +44,7 @@ static int max_block_alignment;
>>   #endif
>>
>>   #define PROC_MOUNTED   "/proc/mounts"
>> +#define MNTTYPE_XFS        "xfs"
> indentation should be consistent with the string above; the whole
> patch is whitespace-mangled and won't apply.
>
>>   /*
>>    * Check if the filesystem is mounted.  Be verbose if asked, and
>> @@ -78,6 +79,9 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
>>                  return 1;
>>          }
>>          while ((mnt = getmntent(f)) != NULL) {
>> +               /* filter out non xfs mountpoint */
>> +               if (strncmp(mnt->mnt_type, MNTTYPE_XFS, strlen(mnt->mnt_type)))
>> +                       continue;
>>                  if (stat(mnt->mnt_dir, &mst) < 0)
>>                          continue;
>>                  if (mst.st_dev != s->st_rdev)
>> -------------------------new patch end-----------------
>>
>> On 02/25/2018 06:04 AM, Dave Chinner wrote:
>>> On Sat, Feb 24, 2018 at 11:56:44AM -0600, Eric Sandeen wrote:
>>>> On 2/24/18 5:23 AM, Yang Joseph wrote:
>>>>> hello,
>>>>>
>>>>> Before the repair process, xfs_repair will check if user specified device already
>>>>> has a writable mountpoint. And it will stat all the mountpoints of the system. If there
>>>>> is a dead mountpoint, this checking will be blocked and xfs_repair will enter 'D' state.
>>> So why is the mount point dead?
>>>
>>> That kinda means that the filesystem is still mounted, but something
>>> has hung somewhere and the filesystem may still have active
>>> references to the underlying device and be doing stuff that is
>>> modifying the filesystem....
>>>
>>> And if the device is still busy, then you aren't going to be able to
>>> mount the repaired device, anyway, because the block device is still
>>> busy...
>>>
>>>> That sounds like a bug worth fixing, but I am much
>>>> less excited about adding options which could do serious damage
>>>> to a filesystem.
>>> TO me it sounds like something that should be fixed by a reboot, not
>>> by adding dangerous options to xfs_repair...
>>>
>>> Cheers,
>>>
>>> Dave.
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

