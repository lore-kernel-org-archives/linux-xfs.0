Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144E62ED848
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 04:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789966250; cv=none; b=jrx0rtNK53Q7g52CRNWyO1ao2ybiMAQG7iIxbVADaTKubHfcIQCHfieTJAtweyHbfPyoU5rXqn1y6zh63QkkRiu9F7XsYASgmAD2Yjgmx8R+RwUkcnLqC8FcYxfKjOhRSrwyizt1MKRqlXuQfB/+lj43vhf+XkqqqkQGzJzmukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789966250; c=relaxed/simple;
	bh=qE5hvQopMkRsKV2UviXva4jJ+1c3CC/bM/FmZfeYZNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kLRALUFZZBE61Y3Z40/pMeyXgvAqgi7uoGW3uONA7kc3IuGxnQl57x0psbiI8EOlJaWbcb4hgd3l4by+sHRtGEDieuj3HlT2PvrcUcJ0uX9zdHtRA7A0CVYI9SxO4mcIfo5FsfyAMV7VvHiCVpibs8UHxZOEBBO6hEdwIgqStq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=x3525E6m; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="x3525E6m"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JthgHhCnOYlmUUYHA0IXWWfi2JnKwMWgG9X9I/50bww=;
	b=x3525E6m37BI0u+bah74gJBssZ8gF/F1mH1CryiwANDMmUsyKM2xbbotzyOdi79iyzBSWHIbn
	qiqzM3GxS2TPYhfd2duKA/f03nIDbhNDORKFmcdu+1bisF8T+kkqjMdkuLyvwzQ1Y2goOq4Xpdx
	tbuixXEwZF+NuhH/KvZZqVY=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hp9Vb5Dknzcb46;
	Mon, 21 Sep 2026 12:39:19 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id F3A5240561;
	Mon, 21 Sep 2026 12:50:39 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 21 Sep 2026 12:50:39 +0800
Message-ID: <c781e564-dc88-42a3-9457-f197d5ad83a1@huawei.com>
Date: Mon, 21 Sep 2026 12:50:37 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v2] xfs: fix NOFS state corruption in btree split
 worker
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>, Shakeel
 Butt <shakeel.butt@linux.dev>, Dave Chinner <dchinner@redhat.com>, Christoph
 Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
References: <20260920073014.2843814-1-wangkefeng.wang@huawei.com>
 <20260921034842.GH2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260921034842.GH2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 9/21/2026 11:48 AM, Darrick J. Wong wrote:
> On Sun, Sep 20, 2026 at 03:30:14PM +0800, Kefeng Wang wrote:
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
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>> v2:
>> - Send bugfix only based on xfs-linux/for-next, suggested by Carlos[1]
>>    https://lore.kernel.org/linux-xfs/aqqGiu9W0G7dquoY@nidhogg.toxiclabs.cc/
>> v1:
>> - https://lore.kernel.org/linux-xfs/20260911104227.2028941-1-wangkefeng.wang@huawei.com/
>>
>>   fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index 60ef7f08b1d3..239741132914 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -3010,6 +3010,7 @@ xfs_btree_split_worker(
>>   						struct xfs_btree_split_args, work);
>>   	unsigned long		pflags;
>>   	unsigned long		new_pflags = 0;
>> +	unsigned long		nofs_flags;
> 
> Might want to call this old_pflags?  We're adding NOFS, which means that
> this variable is just the old value.

$ git grep -w "= memalloc_nofs_save" fs/xfs/
fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
fs/xfs/xfs_aops.c:              nofs_flag = memalloc_nofs_save();
fs/xfs/xfs_dquot.c:     nofs_flags = memalloc_nofs_save();
fs/xfs/xfs_file.c:      nofs_flag = memalloc_nofs_save();
fs/xfs/xfs_file.c:      nofs_flag = memalloc_nofs_save();
fs/xfs/xfs_icache.c:    nofs_flag = memalloc_nofs_save();
fs/xfs/xfs_ioend.c:     nofs_flag = memalloc_nofs_save();
fs/xfs/xfs_log_cil.c:   unsigned int            nofs_flags = 
memalloc_nofs_save();
fs/xfs/xfs_log_recover.c:       unsigned int    nofs_flags = 
memalloc_nofs_save();
fs/xfs/xfs_super.c:     flags = memalloc_nofs_save();
fs/xfs/xfs_trans.h:     tp->t_pflags = memalloc_nofs_save();
fs/xfs/xfs_zone_gc.c:   nofs_flag = memalloc_nofs_save();

The most places are using the nofs flag, I could change it
to old_pflags if needed.>
> Also, doesn't memalloc_nofs_save return an unsigned int?
> 

Sorry, I fixed the conflict but missed the type change.
Should I resend a new version with the renaming(nofs_flag -> old_pflags)?




