Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E01E27F4E
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 20:33:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC0EF304032
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 18:33:24 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id PQ6lPxWRvkx9HVX3 for
	<xfs@oss.sgi.com>; Sun, 03 Nov 2013 18:33:18 -0800 (PST)
Message-ID: <527705F3.50407@cn.fujitsu.com>
Date: Mon, 04 Nov 2013 10:26:59 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: simplify kmem_{zone_}zalloc
References: <52738187.1000807@cn.fujitsu.com> <20131101205803.GQ4446@dastard>
In-Reply-To: <20131101205803.GQ4446@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: bpm@sgi.com, elder@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Dave,
On 11/02/2013 04:58 AM, Dave Chinner wrote:

> On Fri, Nov 01, 2013 at 06:25:11PM +0800, Gu Zheng wrote:
>> Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
>> kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
>> in order to avoid the setting to zero step.
>>
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/xfs/kmem.c |   14 ++------------
>>  fs/xfs/kmem.h |    7 ++++++-
>>  2 files changed, 8 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
>> index a02cfb9..d56fcc9 100644
>> --- a/fs/xfs/kmem.c
>> +++ b/fs/xfs/kmem.c
>> @@ -65,12 +65,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>>  void *
>>  kmem_zalloc(size_t size, xfs_km_flags_t flags)
>>  {
>> -	void	*ptr;
>> -
>> -	ptr = kmem_alloc(size, flags);
>> -	if (ptr)
>> -		memset((char *)ptr, 0, (int)size);
>> -	return ptr;
>> +	return kmem_alloc(size, flags | KM_ZERO);
>>  }
>>  
>>  void *
>> @@ -132,10 +127,5 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>>  void *
>>  kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>>  {
>> -	void	*ptr;
>> -
>> -	ptr = kmem_zone_alloc(zone, flags);
>> -	if (ptr)
>> -		memset((char *)ptr, 0, kmem_cache_size(zone));
>> -	return ptr;
>> +	return kmem_zone_alloc(zone, flags | KM_ZERO);
>>  }
> 
> These functions should be made static inline functions in kmem.h
> seeing as they are now just a simple wrapper.

Agree. Thanks for your suggestion, I'll follow it.

> 
> Otherwise it's a nice cleanup.

Thanks:)

Regards,
Gu

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
