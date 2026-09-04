Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3E1157487;
	Fri,  4 Sep 2026 00:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482503; cv=none; b=saRtZNBB2fMHpUNyAdGsbbtZsnswUarTgGEe28/Np9CjvzrVokN0esbG8zEmE0cj3LHaF/YiyLXWxTWXDEF4nfl4c+EhYYHrQonLdJAwyXb/PFsWg3zEGZUykOmIuK4lByr1EcVHWtH/8wkwcm4WF9sKFmLInb4mksmUYXcPwcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482503; c=relaxed/simple;
	bh=6ibX29HqF8Rzv+1AUMabNMdMaf5ohc237U8b1DUWcXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KAxZXsJGFP6OqEIF0JQzmNpF6TlWu4cF4qZo2KuA18yP8/ygqkraO1+uIj+zZcA11a7dp2LyKrO2y84YhdPJqoNbSc9jdXgfUe4eW1YPOLBnt2b2SRip1btC9vpNIlFqeWAMRu926QiA68j/i2qKzjY2jwGgkyDg6eRjFsfxuV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ICElzZeO; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ICElzZeO"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3YK94SrrP/vItYLu0yuChfSeE7HGX/g9ss7iDjP+W/0=;
	b=ICElzZeOv+DVZa16XDC103N2kHZ60MA3ETG79mvIQYQqCeUK0/6slyujbQnm37mvwhbaQKUz0
	Z0w5bGkxGfDmetQGKazZ6Icwv4W8F3G/VQGnivrCSa+YU0kGj8vMf7+o1zWQzUQAaJEolgMJ9vh
	kss0kI5ab3y7zhIO1l0/Z9M=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hbcnX2nLjzRhWS;
	Fri,  4 Sep 2026 08:30:40 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EF1240579;
	Fri,  4 Sep 2026 08:41:29 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 08:41:27 +0800
Message-ID: <62729d59-198d-4ed2-b1e1-b18384e73b98@huawei.com>
Date: Fri, 4 Sep 2026 08:41:26 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
To: Brian Foster <bfoster@redhat.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <apl7hNnt0lR5HFXA@bfoster>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <apl7hNnt0lR5HFXA@bfoster>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 9/3/2026 9:52 PM, Brian Foster wrote:
> On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
>> xfs_btree_split_worker() calls xfs_trans_set_context() and
>> xfs_trans_clear_context() on the caller's transaction, overwriting
>> tp->t_pflags with the worker's NOFS state. When the caller already has
>> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
>> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
>> the caller's NOFS protection.
>>
>> Use memalloc_nofs_save/restore with a local variable instead so
>> tp->t_pflags is never touched.
>>
>> Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
>> Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
> 
> I agree that the Sashiko analysis looks correct. The only thing I wonder
> is whether it might be a bit cleaner to have the set_context() helper
> return the context instead of hardcode the assignment to ->t_pflags so
> it can be used in both places. The reasoning is just that the current
> arrangement kind of makes it easy to repeat this mistake in the future.
> 
> Then again, it's a single line helper so maybe another option could be
> to just remove and open code it. I suppose the pro of keeping the helper
> is that it's a decent spot to document the concern and why it returns a
> value, etc. *shrug* Thoughts?


I personally tend to remove the helper functions, but let's see what 
others think.

> 
> (Please don't change this patch just on my comments alone. Let's see if
> others have input first..).
> 
> Brian
> 
>>   fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index 6738d9d1511b..8ae4b94e6995 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
>>   {
>>   	struct xfs_btree_split_args	*args = container_of(work,
>>   						struct xfs_btree_split_args, work);
>> -	xfs_trans_set_context(args->cur->bc_tp);
>> +	unsigned int			nofs_flags;
>> +
>> +	/*
>> +	 * Don't use xfs_trans_set_context() here: it would overwrite the
>> +	 * caller's saved NOFS state in tp->t_pflags.  Use a local scope.
>> +	 */
>> +	nofs_flags = memalloc_nofs_save();
>>   
>>   	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>>   					 args->key, args->curp, args->stat);
>>   
>> -	xfs_trans_clear_context(args->cur->bc_tp);
>> +	memalloc_nofs_restore(nofs_flags);
>>   
>>   	/*
>>   	 * Do not access args after complete() has run here. We don't own args
>> -- 
>> 2.55.0
>>
>>
> 
> 

