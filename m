Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr00102.outbound.protection.outlook.com ([40.107.0.102]:50493
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751414AbeCOT2z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 15:28:55 -0400
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
 <20180315174903.GM23100@dhcp22.suse.cz>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
Date: Thu, 15 Mar 2018 22:28:43 +0300
MIME-Version: 1.0
In-Reply-To: <20180315174903.GM23100@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On 15.03.2018 20:49, Michal Hocko wrote:
> On Thu 15-03-18 18:01:34, Kirill Tkhai wrote:
>> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
>> So, it's called for memcg reclaim too, e.g. this list is shrinked
>> disproportionality to another lists.
>>
>> This looks confusing, so I'm reporting about this.
>> Consider this patch as RFC.
> 
> Could you be more specific about the problem you are trying to solve?
> Because we do skip shrinkers which are not memcg aware by
> shrink_slab:
> 		/*
> 		 * If kernel memory accounting is disabled, we ignore
> 		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
> 		 * passing NULL for memcg.
> 		 */
> 		if (memcg_kmem_enabled() &&
> 		    !!memcg != !!(shrinker->flags & SHRINKER_MEMCG_AWARE))
> 			continue;
> 
> Or am I missing something?

sb->s_op->nr_cached_objects is a sub-method of generic super_cache_count().
super_cache_count() is owned and only called by superblock's shrinker,
which does have SHRINKER_MEMCG_AWARE flag.

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
> 

