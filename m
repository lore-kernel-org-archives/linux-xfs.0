Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:5506 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdIAFLn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 01:11:43 -0400
Subject: Re: [PATCH v2] xfs: add online uevent for mount operation
References: <1504189030-18608-1-git-send-email-houtao1@huawei.com>
 <20170831150334.GI3775@magnolia> <20170831233416.GU10621@dastard>
 <70654563-0abd-6786-ef64-a3df4ce5fa34@huawei.com>
 <20170901020643.GY10621@dastard>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <4cc94844-e154-c002-04b8-9e006bad4750@huawei.com>
Date: Fri, 1 Sep 2017 13:11:09 +0800
MIME-Version: 1.0
In-Reply-To: <20170901020643.GY10621@dastard>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Hi Dave,

On 2017/9/1 10:06, Dave Chinner wrote:
> On Fri, Sep 01, 2017 at 09:26:08AM +0800, Hou Tao wrote:
>> Hi,
>>
>> On 2017/9/1 7:34, Dave Chinner wrote:
>>>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>>>> index 3a3812b4..6f8351c 100644
>>>>> --- a/fs/xfs/xfs_super.c
>>>>> +++ b/fs/xfs/xfs_super.c
>>>>> @@ -70,6 +70,11 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>>>>>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>>>>>  #endif
>>>>>  
>>>>> +enum {
>>>>> +	XFS_UEVENT_ENV_CNT = 2,
>>>>
>>>> XFS_UEVENT_MAX_ENV_COUNT ?
>>>
>>> Why 2 when there's only one environment string passed?
>> Will fix them, I take the last NULL pointer into account, and
>> Yes, "XFS_UEVENT_MAX_ENV_COUNT" is a better name.
>>
>>>>> +	XFS_UEVENT_UUID_LEN = UUID_STRING_LEN + 6,
>>>
>>> And the magic number needs a comment.
>>>
>>> Actually, I think it needs more than this - it's tightly bound to
>>> the implementation in xfs_fs_uevent(), so this enum should be
>>> defined there, not as a global all this distance away.....
>> OK, I will move it into xfs_fs_uevent().
>>
>>>>> +};
>>>>> +
>>>>>  /*
>>>>>   * Table driven mount option parser.
>>>>>   */
>>>>> @@ -1530,6 +1535,28 @@ xfs_destroy_percpu_counters(
>>>>>  	percpu_counter_destroy(&mp->m_fdblocks);
>>>>>  }
>>>>>  
>>>>> +static void
>>>>> +xfs_fs_uevent(
>>>>> +	struct xfs_mount	*mp,
>>>>> +	enum kobject_action	action)
>>>>> +{
>>>>> +	int err;
>>>>> +	char *envp[XFS_UEVENT_ENV_CNT];
>>>>> +	int i = 0;
>>>
>>> Indent the variables to match the function declaration.
>> I will fix them. I didn't event notice the indentations of these variables before.
>>
>>>>> +
>>>>> +	if (!uuid_is_null(&mp->m_super->s_uuid)) {
>>>
>>> This will never be false. XFS filesystems should always have a valid
>>> UUID.
>> A null uuid is possible if we use "nouuid" to mount a XFS filesystem, so
>> the check is still needed.
> 
> The "nouuid" mount option means "don't check if there is already a
> filesystem ialready mounted with the same uuid as the one we are
> mounting". It does not mean the filesystem does not have a UUID.
> 
> Indeed, in xfs_uuid_mount():
> 
> xfs_uuid_mount(
>         struct xfs_mount        *mp)
> {
>         uuid_t                  *uuid = &mp->m_sb.sb_uuid;
>         int                     hole, i;
> 
>         /* Publish UUID in struct super_block */
>         uuid_copy(&mp->m_super->s_uuid, uuid);
> 
>         if (mp->m_flags & XFS_MOUNT_NOUUID)
>                 return 0;
> 
> We copy the filesystem's uuid into the VFS superblock before we
> check the nouuid mount option flag. Hence a mounted XFS filesystem
> always has a valid UUID in the superblock s_uuid field.
Maybe you miss the following "uuid_is_null(uuid)" check in xfs_uuid_mount() ?

xfs_uuid_mount(
    struct xfs_mount    *mp)
{

    if (mp->m_flags & XFS_MOUNT_NOUUID)
        return 0;

    if (uuid_is_null(uuid)) {
        xfs_warn(mp, "Filesystem has null UUID - can't mount");
        return -EINVAL;
    }

And we can clear the uuid of a XFS filesystem, and mount it with "nouuid" option successfully.
$ xfs_admin -U nil /dev/vda
$ mount -t xfs -o nouuid /dev/vda /tmp/vda

So I still think the null check in xfs_fs_uevent is needed.

Regards,

Tao

