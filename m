Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51614 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfDCBIp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Apr 2019 21:08:45 -0400
Subject: Re: [PATCH] xfs: return correct XFS_IOC_DIOINFO for DAX inode
References: <b3af182f-a547-9d04-3b29-232857e83fc4@redhat.com>
 <20190402175632.GD5147@magnolia> <20190402213119.GU26298@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ced3ea37-b77f-f53b-2fdd-d24fbdf8653e@sandeen.net>
Date: Tue, 2 Apr 2019 20:08:43 -0500
MIME-Version: 1.0
In-Reply-To: <20190402213119.GU26298@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>



On 4/2/19 4:31 PM, Dave Chinner wrote:
> On Tue, Apr 02, 2019 at 10:56:32AM -0700, Darrick J. Wong wrote:
>> On Tue, Apr 02, 2019 at 10:44:38AM -0500, Eric Sandeen wrote:
>>> pmem is byte addressable, and indeed byte-aligned DIO works on
>>> a DAX file.  So, teach XFS_IOC_DIOINFO to return the correct
>>> alignment information if IS_DAX(inode).
>>
>> If it's a DAX filesystem, do we want to try to steer people towards
>> things like 2MB pages since (in theory) we can get away with fewer page
>> table mappings?  And (seeing as that's mmap that cares, not directio)
>> would advertising preferential page mapping sizes be more appropriate
>> advertised in a different ioctl?
>>
>> --D
>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>> index 6ecdbb3..35eae7d 100644
>>> --- a/fs/xfs/xfs_ioctl.c
>>> +++ b/fs/xfs/xfs_ioctl.c
>>> @@ -1919,12 +1919,21 @@ xfs_file_ioctl(
>>>  	}
>>>  	case XFS_IOC_DIOINFO: {
>>>  		struct dioattr	da;
>>> -		xfs_buftarg_t	*target =
>>> -			XFS_IS_REALTIME_INODE(ip) ?
>>> -			mp->m_rtdev_targp : mp->m_ddev_targp;
>>>  
>>> -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
>>> -		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
>>> +		if (IS_DAX(inode)) {
>>> +			/* pmem is byte addressable */
>>> +			da.d_mem = 1;
>>> +			da.d_miniosz = 1;
>>> +			da.d_maxiosz = INT_MAX;
> 
> I don't think we want to open that can of worms.

It's already open... byte-granularity dax+dio succeeds today.
Does it work? ;)

> Have you run fsx on dax mixing mmap/dio with byte range granularity?

Like:

# fsx -Z -r 1 -w 1 daxfile

?

yes (now that you asked) ;)
not to a bazillion ops, but I've not seen a failure yet.
This is on simulated pmem, on a 5.0 kernel.

-Eric

> Cheers,
> 
> Dave.
> 
