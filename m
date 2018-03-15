Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0111.outbound.protection.outlook.com ([104.47.2.111]:4096
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932397AbeCOQGe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 12:06:34 -0400
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
 <20180315155316.GY4865@magnolia>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <782fbe3a-4025-16f7-bfae-424e1bc6f073@virtuozzo.com>
Date: Thu, 15 Mar 2018 19:06:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180315155316.GY4865@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On 15.03.2018 18:53, Darrick J. Wong wrote:
> On Thu, Mar 15, 2018 at 06:01:34PM +0300, Kirill Tkhai wrote:
>> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
>> So, it's called for memcg reclaim too, e.g. this list is shrinked
>> disproportionality to another lists.
>>
>> This looks confusing, so I'm reporting about this.
>> Consider this patch as RFC.
> 
> So... I think the reasoning here is that xfs doesn't allocate inodes on
> behalf of any particular memcg (or put another way the cost of the
> inodes is shared by everything in the system) so if the shrinkers get
> called because a particular memcg is bumping up against its limits it
> makes no sense to try to purge xfs inodes?

Yes, since shrinking xfs cached objects doesn't free memcg kmem.
 
> Followup questions: does the same reasoning apply to the xfs buffer and
> quota shrinkers?

It's not need, as these shrinker don't have SHRINKER_MEMCG_AWARE flag.
So, they are called only in case of global reclaim (memcg == NULL).

But they may require another type of change. They use list_lru,
so they may need to have SHRINKER_MEMCG_AWARE flag. This is depends
on how objects linked to xfs_buftarg::bt_lru and xfs_quotainfo::qi_lru
are allocated. If they are accounted to memcg (i.e., use GFP_ACCOUNT
flag in their kmalloc/slab alloc/etc), they have to have this flag.
Ideally, all user initiated allocations should be made with this flag.

If they already use GFP_ACCOUNT while shrinker is not marked as SHRINKER_MEMCG_AWARE,
it never shrinks objects related to memcgs.

> Do any filesystems associate their metadata memory
> allocations with a specific memcg?  If not, why not put this in
> super_cache_{scan,count}?

They do, since generic super_cache_{scan,count} have a deal with sb's s_dentry_lru
and s_inode_lru, and use list lru, which supports memcg accounting.
 
> --D
> 
>> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
>> ---
>>  fs/xfs/xfs_super.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 951271f57d00..124568aefa94 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1788,6 +1788,8 @@ xfs_fs_nr_cached_objects(
>>  	struct super_block	*sb,
>>  	struct shrink_control	*sc)
>>  {
>> +	if (sc->memcg)
>> +		return 0;
>>  	return xfs_reclaim_inodes_count(XFS_M(sb));
>>  }
>>  
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
