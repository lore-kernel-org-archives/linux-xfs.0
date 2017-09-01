Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5084 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdIAB0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 21:26:21 -0400
Subject: Re: [PATCH v2] xfs: add online uevent for mount operation
References: <1504189030-18608-1-git-send-email-houtao1@huawei.com>
 <20170831150334.GI3775@magnolia> <20170831233416.GU10621@dastard>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <70654563-0abd-6786-ef64-a3df4ce5fa34@huawei.com>
Date: Fri, 1 Sep 2017 09:26:08 +0800
MIME-Version: 1.0
In-Reply-To: <20170831233416.GU10621@dastard>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi,

On 2017/9/1 7:34, Dave Chinner wrote:
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index 3a3812b4..6f8351c 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -70,6 +70,11 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>>>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>>>  #endif
>>>  
>>> +enum {
>>> +	XFS_UEVENT_ENV_CNT = 2,
>>
>> XFS_UEVENT_MAX_ENV_COUNT ?
> 
> Why 2 when there's only one environment string passed?
Will fix them, I take the last NULL pointer into account, and
Yes, "XFS_UEVENT_MAX_ENV_COUNT" is a better name.

>>> +	XFS_UEVENT_UUID_LEN = UUID_STRING_LEN + 6,
> 
> And the magic number needs a comment.
> 
> Actually, I think it needs more than this - it's tightly bound to
> the implementation in xfs_fs_uevent(), so this enum should be
> defined there, not as a global all this distance away.....
OK, I will move it into xfs_fs_uevent().

>>> +};
>>> +
>>>  /*
>>>   * Table driven mount option parser.
>>>   */
>>> @@ -1530,6 +1535,28 @@ xfs_destroy_percpu_counters(
>>>  	percpu_counter_destroy(&mp->m_fdblocks);
>>>  }
>>>  
>>> +static void
>>> +xfs_fs_uevent(
>>> +	struct xfs_mount	*mp,
>>> +	enum kobject_action	action)
>>> +{
>>> +	int err;
>>> +	char *envp[XFS_UEVENT_ENV_CNT];
>>> +	int i = 0;
> 
> Indent the variables to match the function declaration.
I will fix them. I didn't event notice the indentations of these variables before.

>>> +
>>> +	if (!uuid_is_null(&mp->m_super->s_uuid)) {
> 
> This will never be false. XFS filesystems should always have a valid
> UUID.
A null uuid is possible if we use "nouuid" to mount a XFS filesystem, so
the check is still needed.

> 
>>> +		char uuid[XFS_UEVENT_UUID_LEN];
>>> +
>>> +		snprintf(uuid, sizeof(uuid), "UUID=%pUb", &mp->m_super->s_uuid);
> 
> That buffer is not a uuid. i.e. this code looks to me like it is
> encoding a string larger than a uuid into a uuid that is the
> size of a uuid. Perhaps something like this?
> 
> 		char *id = "ID_FS_UUID=";
> 		char buf[UUID_STRING_LEN + strlen(id) + 1] = {};
> 
> 		snprintf(buf, sizeof(buf), "%s%pUb", id, &mp->m_super->s_uuid);
> 
Accepted, much clearer than the original code.

>> Should this be "ID_FS_UUID=%pUb" to keep the name consistent with
>> what blkid injects into the udev environment for block devices?
> 
> Sounds like a good idea to me...
OK, I will check blkid and fix the name of the uuid environment accordingly.

Tao

