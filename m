Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n485K7A4259404 for <xfs@oss.sgi.com>; Fri, 8 May 2009 00:20:07 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA0CB8F80E6
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 22:20:08 -0700 (PDT)
Message-Id: <9375AA94-2051-42CB-A7EB-9A32E3F94A24@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A039F85.8010506@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs: fix double unlock in xfs_swap_extents()
Date: Fri, 8 May 2009 00:20:06 -0500
References: <1241745202-7452-1-git-send-email-felixb@sgi.com>
	<4A039F85.8010506@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org, a.beregalov@gmail.com, xfs@oss.sgi.com


On May 7, 2009, at 9:57 PM, Eric Sandeen wrote:

> Felix Blyakher wrote:
>> Regreesion from commit ef8f7fc, which rearranged the code in
>> xfs_swap_extents() leading to double unlock of xfs inode iolock.
>> That resulted in xfs_fsr deadlocking itself on platforms, which
>> don't handle double unlock of rw_semaphore nicely. It caused the
>> count go negative, which represents the write holder, without
>> really having one. ia64 is one of the platforms where deadlock
>> was easily reproduced and the fix was tested.
>>
>> Signed-off-by: Felix Blyakher <felixb@sgi.com>
>
> Also-written-by: Eric Sandeen <sandeen@sandeen.net>
> Independently-arrived-at-by: Eric Sandeen <sandeen@sandeen.net>

That would make it: Signed-off-by: Eric Sandeen <sandeen@sandeen.net> :)

> ;)
>
> But seriously ...

Seriously.

Felix

>
>
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
>
>> ---
>> fs/xfs/xfs_dfrag.c |    8 +++++---
>> 1 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
>> index e6d839b..7465f9e 100644
>> --- a/fs/xfs/xfs_dfrag.c
>> +++ b/fs/xfs/xfs_dfrag.c
>> @@ -347,13 +347,15 @@ xfs_swap_extents(
>>
>> 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
>>
>> -out_unlock:
>> -	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> -	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> out:
>> 	kmem_free(tempifp);
>> 	return error;
>>
>> +out_unlock:
>> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> +	goto out;
>> +
>> out_trans_cancel:
>> 	xfs_trans_cancel(tp, 0);
>> 	goto out_unlock;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
