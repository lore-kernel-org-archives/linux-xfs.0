Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752833AbeEGXaR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 19:30:17 -0400
Subject: Re: [PATCH] xfs_repair: check and repair quota metadata
References: <9e494d70-53bd-db81-c118-73ef7eaad667@redhat.com>
 <20180507163242.GZ26569@magnolia> <20180507232837.GH23861@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <49a1ac19-a332-3a2f-af54-e6cd9b41eda1@redhat.com>
Date: Mon, 7 May 2018 18:30:16 -0500
MIME-Version: 1.0
In-Reply-To: <20180507232837.GH23861@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 5/7/18 6:28 PM, Dave Chinner wrote:
> On Mon, May 07, 2018 at 09:32:42AM -0700, Darrick J. Wong wrote:
>> On Mon, May 07, 2018 at 09:20:28AM -0500, Eric Sandeen wrote:

...

>>> diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
>>> index bb1b13a9..067475e2 100644
>>> --- a/libxfs/xfs_quota_defs.h
>>> +++ b/libxfs/xfs_quota_defs.h
>>> @@ -30,6 +30,8 @@
>>>  typedef uint64_t	xfs_qcnt_t;
>>>  typedef uint16_t	xfs_qwarncnt_t;
>>>  
>>> +#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
>>
>> Requires a kernel patch, right? :)
> 
> It's already defined in the kernel in fs/xfs/xfs_qm.h.
> 
> And userspace also defines it as a private define to allow libxfs to
> build:
> 
> $ git grep XFS_DQUOT_CLUSTER_SIZE_FSB
> libxfs/libxfs_priv.h:#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
> libxfs/xfs_trans_resv.c:                        XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
> libxfs/xfs_trans_space.h:        XFS_DQUOT_CLUSTER_SIZE_FSB)
> $
> 
> If it's going to be used outside libxfs in userspace, then it should
> be lifted to a libxfs header file both in the kernel and userspace,
> such as fs/xfs/xfs_quota_defs.h....


Ok, which is what I did in the first place.  :)  Ok, so can change it
on the kernel side to keep up with this patch, then.

Thanks,
-Eric

