Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5528 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdIDEBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 00:01:20 -0400
Subject: Re: [PATCH v2] xfs: add online uevent for mount operation
References: <1504189030-18608-1-git-send-email-houtao1@huawei.com>
 <20170831150334.GI3775@magnolia> <20170831233416.GU10621@dastard>
 <70654563-0abd-6786-ef64-a3df4ce5fa34@huawei.com>
 <20170901020643.GY10621@dastard>
 <4cc94844-e154-c002-04b8-9e006bad4750@huawei.com>
 <20170901152016.GY3775@magnolia> <20170901215236.GA10621@dastard>
 <20170904000321.GA4671@magnolia>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <9164a88d-63c6-a1b3-a995-45c3981a7b80@huawei.com>
Date: Mon, 4 Sep 2017 12:01:04 +0800
MIME-Version: 1.0
In-Reply-To: <20170904000321.GA4671@magnolia>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick,

On 2017/9/4 8:03, Darrick J. Wong wrote:
> On Sat, Sep 02, 2017 at 07:52:36AM +1000, Dave Chinner wrote:
>> On Fri, Sep 01, 2017 at 08:20:16AM -0700, Darrick J. Wong wrote:
>>> On Fri, Sep 01, 2017 at 01:11:09PM +0800, Hou Tao wrote:
>>>>> The "nouuid" mount option means "don't check if there is already a
>>>>> filesystem ialready mounted with the same uuid as the one we are
>>>>> mounting". It does not mean the filesystem does not have a UUID.
>>>>>
>>>>> Indeed, in xfs_uuid_mount():
>>>>>
>>>>> xfs_uuid_mount(
>>>>>         struct xfs_mount        *mp)
>>>>> {
>>>>>         uuid_t                  *uuid = &mp->m_sb.sb_uuid;
>>>>>         int                     hole, i;
>>>>>
>>>>>         /* Publish UUID in struct super_block */
>>>>>         uuid_copy(&mp->m_super->s_uuid, uuid);
>>>>>
>>>>>         if (mp->m_flags & XFS_MOUNT_NOUUID)
>>>>>                 return 0;
>>>>>
>>>>> We copy the filesystem's uuid into the VFS superblock before we
>>>>> check the nouuid mount option flag. Hence a mounted XFS filesystem
>>>>> always has a valid UUID in the superblock s_uuid field.
>>>> Maybe you miss the following "uuid_is_null(uuid)" check in xfs_uuid_mount() ?
>>>>
>>>> xfs_uuid_mount(
>>>>     struct xfs_mount    *mp)
>>>> {
>>>>
>>>>     if (mp->m_flags & XFS_MOUNT_NOUUID)
>>>>         return 0;
>>>>
>>>>     if (uuid_is_null(uuid)) {
>>>>         xfs_warn(mp, "Filesystem has null UUID - can't mount");
>>>>         return -EINVAL;
>>>>     }
>>>>
>>>> And we can clear the uuid of a XFS filesystem, and mount it with "nouuid" option successfully.
>>>> $ xfs_admin -U nil /dev/vda
>>>> $ mount -t xfs -o nouuid /dev/vda /tmp/vda
>>
>> IMO, that's a bug, because...
>>
>>>> So I still think the null check in xfs_fs_uevent is needed.
>>>
>>> I was /about/ to reply with "Why does it matter if the UUID is null?
>>> That's just another value, albeit a weird one.", but then I actually
>>> tried it:
>>>
>>> $ truncate -s 500m /tmp/a
>>> $ mkfs.xfs -m uuid=00000000-0000-0000-0000-000000000000 -f /tmp/a
>>> $ sudo mount /tmp/a /mnt
>>> [161296.189297] XFS (loop0): Filesystem has nil UUID - can't mount
>>> $ sudo mount /tmp/a /mnt -o nouuid
>>> [161301.335715] XFS (loop0): Mounting V5 Filesystem
>>> [161301.335881] XFS (loop0): nil uuid in log - IRIX style log
>>> [161301.338524] XFS (loop0): Ending clean mount
>>> [161311.233536] XFS (loop0): Unmounting Filesystem
>>>
>>> Now I'm wondering just what that's all about, especially on a v5 fs? :)
>>
>> ... uuids were added to the log to identify external log devices on
>> Linux. THey weren't needed on Irix because external log devices were
>> set up through the volume manager (XLV/XVM) and discovered at mount
>> time by the kernel code (libxfs/mkfs still has support for
>> "volume logs"). On linux, we have an external block device, so
>> something needed to be added to the log record headers so the
>> filesystem could determine it was about to replay the correct log
>> device....
>>
>> IOWs finding a log with a null uuid is a big red flag that something
>> is not right with the filesystem setup, and we should definitely not
>> be mounting it if it's a v5 filesystem (uuid is mandatory in that
>> format). For v4, well, irix is long gone, as are the vast majority
>> of Irix XFS filesystems, so we should probably not mount them,
>> either.
> 
> <nod> Patches to reject zero-uuid filesystems welcome. ;)
> 
> That said, I think that the uevent should include ID_FS_UUID regardless
> of the fsuuid contents; it's the job of the mount code to decide if the
> uuid is screwy and therefore we should scuttle everything.  I also
> decided to defer this one to 4.15 on the grounds that if the purpose of
> adding a uevent is to get a userspace helper to read in the xfs config,
> let's see at least a draft of that piece on the mailing list first.
> 
> TBH I'm also a little confused about the repost of the default config
> values patchset immediately prior to this patch -- if the goal is to
> delegate loading default vs. fs-specific configuration policy to a
> userland daemon via uevent, then why would we need a sysfs directory of
> default config knobs in addition to the existing per-fs knobs?
One scenario I think the default config sysfs files are needed is embedded
environment under which udevd or a similar daemon is not available. It also
provides a shortcut for the "default" configuration options which can be set
in one time instead of one-by-one, but I'm not sure these "advantages" is worthy
of the workload of code.

I should have asked Dave for the explanation before the reworking of the patchset,
so Dave, Any explanation or ideas ?

Regards,

Tao


> --D
> 
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

