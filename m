Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TJTbia085163 for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:29:38 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 865BE8F80A1
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 12:29:50 -0700 (PDT)
Message-Id: <1A19B6F4-40CD-46C0-8221-952EEEEB265B@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090529192529.GA1599@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs: prevent deadlock in xfs_qm_shake()
Date: Fri, 29 May 2009 14:29:50 -0500
References: <1243620631-10749-1-git-send-email-felixb@sgi.com>
	<1243620631-10749-2-git-send-email-felixb@sgi.com>
	<20090529192529.GA1599@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Hedi Berriche <hedi@sgi.com>, xfs@oss.sgi.com


On May 29, 2009, at 2:25 PM, Christoph Hellwig wrote:

> On Fri, May 29, 2009 at 01:10:31PM -0500, Felix Blyakher wrote:
>> It's possible to recurse into filesystem from the memory
>> allocation, which deadlocks in xfs_qm_shake(). Add check
>> for __GFP_FS, and bailout if it is not set.
>>
>> Signed-off-by: Felix Blyakher <felixb@sgi.com>
>> Signed-off-by: Hedi Berriche <hedi@sgi.com>
>> ---
>> fs/xfs/linux-2.6/kmem.h |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
>> index af6843c..d8d2321 100644
>> --- a/fs/xfs/linux-2.6/kmem.h
>> +++ b/fs/xfs/linux-2.6/kmem.h
>> @@ -103,7 +103,7 @@ extern void *kmem_zone_zalloc(kmem_zone_t *,  
>> unsigned int __nocast);
>> static inline int
>> kmem_shake_allow(gfp_t gfp_mask)
>> {
>> -	return (gfp_mask & __GFP_WAIT) != 0;
>> +	return ((gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS) != 0;
>
> Looks good to me.  But this could be written simpler as:
>
> 	return ((gfp_mask & (__GFP_WAIT|__GFP_FS)) != 0;

Yeah, sure. Weird it didn't occur to me :)

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
