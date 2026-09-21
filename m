Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE1F3515EA
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789972062; cv=none; b=sNm24QV2H22SWTCLcg/d/MwYUCBIlVhowvM/xFDUY3S6nfyoE9xJmClj4eP/HJPYgLU9TooiEUTOrkTdoVicfLwRBDHoLxelHlicWma3ga6QB+r4BEDyWJPg2PAAHkXbKoATlI0Vv//37GmXY1BOLDHuRocUN80/0NTvUdWNqpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789972062; c=relaxed/simple;
	bh=+cSQzEBaybkA8svB1SQUHH4d2wUtxhaAMOJIcmFAZAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gwoOuwF3qbwwUTw8EqSK5oaXzDMZj931aC1FmeLaC3iKHpBmdvvWmIBIuEsSRNCFKNgjgtcN+790mxT6Pr3G6+CzZBIDn+MUBQy8/16vi8Ue77uq1qXZD+vq2Yq4RvCvNfS5MuMn62ymWYz7Bmb5Vw9F4e5vfskec+hia2vq+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PYbJ6oHI; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PYbJ6oHI"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oj7vD1JgBzeWaIUyWPLFmckYPzK7ehSwxmh+czUmu14=;
	b=PYbJ6oHIf3xrNBfMAr8gTRYnyUt46P6ShWiCydLlJLMYJ7ViQvQ0xqpAWyCHUKolMR5NU0iKe
	CX4pBP0tWoQgAHhPMkraYnECKaajz87Ysbv/SEiDh950GQPTQQveq1dcu6bl1+V8CakS241RAIg
	W63co4UqHY8nYFj7+P8I1tQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hpCdX5SLKzRhXL;
	Mon, 21 Sep 2026 14:15:28 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 5E56340561;
	Mon, 21 Sep 2026 14:27:29 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 21 Sep 2026 14:27:28 +0800
Message-ID: <5d99324d-da7a-4937-8b22-180938ceb5a6@huawei.com>
Date: Mon, 21 Sep 2026 14:27:26 +0800
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
 <c781e564-dc88-42a3-9457-f197d5ad83a1@huawei.com>
 <20260921051136.GJ2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260921051136.GJ2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 9/21/2026 1:11 PM, Darrick J. Wong wrote:
> On Mon, Sep 21, 2026 at 12:50:37PM +0800, Kefeng Wang wrote:
>>
>>
>> On 9/21/2026 11:48 AM, Darrick J. Wong wrote:
>>> On Sun, Sep 20, 2026 at 03:30:14PM +0800, Kefeng Wang wrote:
>>>> xfs_btree_split_worker() calls xfs_trans_set_context() and
>>>> xfs_trans_clear_context() on the caller's transaction, overwriting
>>>> tp->t_pflags with the worker's NOFS state. When the caller already has
>>>> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
>>>> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
>>>> the caller's NOFS protection.
>>>>
>>>> Use memalloc_nofs_save/restore with a local variable instead so
>>>> tp->t_pflags is never touched.
>>>>
>>>> Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
>>>> Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> ---
>>>> v2:
>>>> - Send bugfix only based on xfs-linux/for-next, suggested by Carlos[1]
>>>>     https://lore.kernel.org/linux-xfs/aqqGiu9W0G7dquoY@nidhogg.toxiclabs.cc/
>>>> v1:
>>>> - https://lore.kernel.org/linux-xfs/20260911104227.2028941-1-wangkefeng.wang@huawei.com/
>>>>
>>>>    fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
>>>>    1 file changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>>>> index 60ef7f08b1d3..239741132914 100644
>>>> --- a/fs/xfs/libxfs/xfs_btree.c
>>>> +++ b/fs/xfs/libxfs/xfs_btree.c
>>>> @@ -3010,6 +3010,7 @@ xfs_btree_split_worker(
>>>>    						struct xfs_btree_split_args, work);
>>>>    	unsigned long		pflags;
>>>>    	unsigned long		new_pflags = 0;
>>>> +	unsigned long		nofs_flags;
>>>
>>> Might want to call this old_pflags?  We're adding NOFS, which means that
>>> this variable is just the old value.
>>
>> $ git grep -w "= memalloc_nofs_save" fs/xfs/
>> fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
>> fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
>> fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
>> fs/xfs/xfs_aops.c:              nofs_flag = memalloc_nofs_save();
>> fs/xfs/xfs_dquot.c:     nofs_flags = memalloc_nofs_save();
>> fs/xfs/xfs_file.c:      nofs_flag = memalloc_nofs_save();
>> fs/xfs/xfs_file.c:      nofs_flag = memalloc_nofs_save();
>> fs/xfs/xfs_icache.c:    nofs_flag = memalloc_nofs_save();
>> fs/xfs/xfs_ioend.c:     nofs_flag = memalloc_nofs_save();
>> fs/xfs/xfs_log_cil.c:   unsigned int            nofs_flags =
>> memalloc_nofs_save();
>> fs/xfs/xfs_log_recover.c:       unsigned int    nofs_flags =
>> memalloc_nofs_save();
>> fs/xfs/xfs_super.c:     flags = memalloc_nofs_save();
>> fs/xfs/xfs_trans.h:     tp->t_pflags = memalloc_nofs_save();
>> fs/xfs/xfs_zone_gc.c:   nofs_flag = memalloc_nofs_save();
>>
>> The most places are using the nofs flag, I could change it
>> to old_pflags if needed.>
>>> Also, doesn't memalloc_nofs_save return an unsigned int?
>>>
>>
>> Sorry, I fixed the conflict but missed the type change.
>> Should I resend a new version with the renaming(nofs_flag -> old_pflags)?
> 
> Eh, I suppose we're not at all consistent, so pflags/nofs_flag is fine.

I will retain the naming of nofs_flag,

> But we should still use the correct type to avoid wasting stack space.

and fix the type in v3. Thank you for your careful review.

> 
> --D

