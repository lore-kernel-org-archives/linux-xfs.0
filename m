Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2584C96
	for <linux-xfs@vger.kernel.org>; Sun, 25 Feb 2024 04:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708836659; cv=none; b=XMMhd2V9ghvGPE5WC6v1TmKfI2mVAYwADJzMVDrQaIDL8TMymddOtDp9oUTjL8pHmM/3EmIRAfhzWB/FW8GO03eVu6whmS+7r7m90zB/+jcICzsK0FPMwGf37UZFF6DgnhuBcDLIxp+RJDIMLEcID84Ettp2vf0RVAuEYO+f6Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708836659; c=relaxed/simple;
	bh=kYm60k44TDOflCOI69MPiKPn3EEjAVAaxCL4eVJlSdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L8VCZNQWS4cI5aXBwEuszdZdoNUvc2544xMw/tjkfrrIr1Woj9xhyy00xlhrQlQZK7+0TAgSTqVD/3BEQ/BN07pGdbQlzpseFMf0yQGEjIgLVnCPPvZXGlp30urmkHLxXKwq6dWEZdjjiq2jBcw0oZR71M9t5HuDtEvocop/R7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tZdU18OU; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tZdU18OU"
Message-ID: <ed50835c-80be-491f-a5f9-9a669a84cac5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708836655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C06gSC6P/Rwm/k9Z3WJ2+aHSbmkMvV5GJOz0ep+CZ0U=;
	b=tZdU18OUvJpqWrrtwP23W9ROblmTtoli30JqKc7d/W86K18fgROGZg2F2W33mUe9hhWho7
	e1yqQSFVeRa1AWuo3e+nhc+HMnx4rqZa8H2gp39PsVngGVmEwcnBSsN+KupC3NrokvH+Vu
	wPif1tGqwZcQ7k6rOrMZNAv3myN+y4Q=
Date: Sun, 25 Feb 2024 12:50:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remove SLAB_MEM_SPREAD flag usage
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz,
 roman.gushchin@linux.dev, Xiongwei.Song@windriver.com,
 Chengming Zhou <zhouchengming@bytedance.com>
References: <20240224135323.830509-1-chengming.zhou@linux.dev>
 <20240224170306.GI616564@frogsfrogsfrogs>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20240224170306.GI616564@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/2/25 01:03, Darrick J. Wong wrote:
> On Sat, Feb 24, 2024 at 01:53:23PM +0000, chengming.zhou@linux.dev wrote:
>> From: Chengming Zhou <zhouchengming@bytedance.com>
>>
>> The SLAB_MEM_SPREAD flag is already a no-op as of 6.8-rc1, remove
>> its usage so we can delete it from slab. No functional change.
>>
>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> 
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> 
> (acked, as in "this looks right, i don't know why it wasn't removed when
> slab went away, and from the -mm list traffic this seems to be in line
> with [1] but i still had to dig for details)

Right, I think it was just forgotten when slab went away. Then Steven reported
this when he found it obsolete. As discussed in [1], we submit these patches
independently to remove its usages.

[1] https://lore.kernel.org/all/20240220-slab-cleanup-flags-v1-0-e657e373944a@suse.cz/

Thanks!

> 
> [1] https://lore.kernel.org/linux-mm/20240131172027.10f64405@gandalf.local.home/T/#u
> 
> --D
> 
>> ---
>>  fs/xfs/xfs_super.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 56006b877a5d..171a1287b296 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -2042,8 +2042,7 @@ xfs_init_caches(void)
>>  
>>  	xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
>>  					 SLAB_HWCACHE_ALIGN |
>> -					 SLAB_RECLAIM_ACCOUNT |
>> -					 SLAB_MEM_SPREAD,
>> +					 SLAB_RECLAIM_ACCOUNT,
>>  					 NULL);
>>  	if (!xfs_buf_cache)
>>  		goto out;
>> @@ -2108,14 +2107,14 @@ xfs_init_caches(void)
>>  					   sizeof(struct xfs_inode), 0,
>>  					   (SLAB_HWCACHE_ALIGN |
>>  					    SLAB_RECLAIM_ACCOUNT |
>> -					    SLAB_MEM_SPREAD | SLAB_ACCOUNT),
>> +					    SLAB_ACCOUNT),
>>  					   xfs_fs_inode_init_once);
>>  	if (!xfs_inode_cache)
>>  		goto out_destroy_efi_cache;
>>  
>>  	xfs_ili_cache = kmem_cache_create("xfs_ili",
>>  					 sizeof(struct xfs_inode_log_item), 0,
>> -					 SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
>> +					 SLAB_RECLAIM_ACCOUNT,
>>  					 NULL);
>>  	if (!xfs_ili_cache)
>>  		goto out_destroy_inode_cache;
>> -- 
>> 2.40.1
>>
>>
