Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BNpfGM168884 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 18:51:42 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92B483C0C2F
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 16:54:15 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id Kb6lzoGSW2Q6QOk8 for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 16:54:15 -0700 (PDT)
Message-ID: <4C12CCA6.8060700@sandeen.net>
Date: Fri, 11 Jun 2010 18:54:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Make fiemap works with sparse file.
References: <1276236135-12051-1-git-send-email-tao.ma@oracle.com>
	<4C125C0D.4080600@sandeen.net> <4C12C8BB.50604@oracle.com>
In-Reply-To: <4C12C8BB.50604@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Tao Ma wrote:
> Eric Sandeen wrote:
>> Tao Ma wrote:
>>  
>>> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
>>> to return fi_extent_max extents, but actually it won't work for
>>> a sparse file. The reason is that in xfs_getbmap we will
>>> calculate holes and set it in 'out', while out is malloced by
>>> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
>>> worst case, if 'out' vector looks like
>>> [hole, extent, hole, extent, hole, ... hole, extent, hole],
>>> we will only return half of fi_extent_max extents.
>>>
>>> So in xfs_vn_fiemap, we should consider this worst case. If the
>>> user wants fi_extent_max extents, we need a 'out' with size of
>>> 2 *fi_extent_max + 1.
>>>     
>>
>> This all seems right to me, though your commit message above (+1)
>> doesn't match the comment and code in the patch (+2)
>>   
> oh, yes, I will change the commit log and send a v2.
> and can I add your ack for this patch?

Sure, it seems right to me.

Thanks,
-Eric

> Regards,
> Tao
>> -Eric
>>
>>  
>>> Cc: Alex Elder <aelder@sgi.com>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Dave Chinner <david@fromorbit.com>
>>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>>> ---
>>>  fs/xfs/linux-2.6/xfs_iops.c |   16 ++++++++++++++--
>>>  1 files changed, 14 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
>>> index 9c8019c..1db92e3 100644
>>> --- a/fs/xfs/linux-2.6/xfs_iops.c
>>> +++ b/fs/xfs/linux-2.6/xfs_iops.c
>>> @@ -672,9 +672,21 @@ xfs_vn_fiemap(
>>>      else
>>>          bm.bmv_length = BTOBB(length);
>>>  
>>> -    /* We add one because in getbmap world count includes the header */
>>> +    /*
>>> +     * It is a bit tricky for us to calculate the bmv_count from
>>> +     * fi_extent_max.
>>> +     * If we support to return fi_extent_max extents to the user,
>>> +     * we need at most 2 * fi_extent_max + 1 for bmv_count since
>>> +     * in xfs_getbmap we will calculate holes while fi_extent_max
>>> +     * don't have them. So in the worst case, bmv can looks like
>>> +     * [hole, extent, hole, extent, hole, ... hole, extent, hole].
>>> +     * So there will be 2 *fi_extent_max + 1.
>>> +     * What's more, in getbmap world count have to include the
>>> +     * header, so we need another bmv. So the total number will
>>> +     * be 2 * fieinfo->fi_extents_max + 2.
>>> +     */
>>>      bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
>>> -                    fieinfo->fi_extents_max + 1;
>>> +            2 * fieinfo->fi_extents_max + 2;
>>>      bm.bmv_count = min_t(__s32, bm.bmv_count,
>>>                   (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
>>>      bm.bmv_iflags = BMV_IF_PREALLOC;
>>>     
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>   
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
