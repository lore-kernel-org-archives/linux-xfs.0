Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13801 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726307AbfFZBmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 21:42:19 -0400
Message-ID: <5D12CD78.8080208@cn.fujitsu.com>
Date: Wed, 26 Jun 2019 09:42:16 +0800
From: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: remove useless log options in usage
References: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com> <20190612150155.GA3773859@magnolia>
In-Reply-To: <20190612150155.GA3773859@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

on 2019/06/12 23:01, Darrick J. Wong wrote:

> On Wed, Jun 12, 2019 at 05:09:35PM +0800, Yang Xu wrote:
>> Since commit 2cf637cf(mkfs: remove logarithm based CLI options),
>> xfsprogs has discarded log options in node_options, remove it in usage.
>>
>> Signed-off-by: Yang Xu<xuyang2018.jy@cn.fujitsu.com>
> Looks ok,
> Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
>
> --D
>
Hi sandeen

My patch missed for xfsprogs for-next branch 8bfb5eac.
By the way, the patch only removes useless log usage in inode option.
So I think we don't need to resubmit it again.

Thanks
Yang Xu


>> ---
>>   mkfs/xfs_mkfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index db3ad38e..91391b72 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -858,7 +858,7 @@ usage( void )
>>   			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>>   			    sectsize=num\n\
>>   /* force overwrite */	[-f]\n\
>> -/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
>> +/* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
>>   			    projid32bit=0|1,sparse=0|1]\n\
>>   /* no discard */	[-K]\n\
>>   /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
>> -- 
>> 2.18.1
>>
>>
>>
>
>
