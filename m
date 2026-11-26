Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700620;
	b=RhVvHQHf5TFmq/L7p9/Yq3hgua+IvkE3690JbQVscnMVrjX8Hd6rWCnJcuAp24dYSg9A
	 +EniXSzGDFUZAkEp87/DL70CIxA4X1mDPskvZM4sMXva7U3Se+1dZWoYt1NzjNhiu/CRT
	 2BOgjpIL9hcYfy+4HqI1yrgIm94ntfc4p61w33IonRM4vo+1JoBYTFZF7wNH3yiGLI2Jj
	 /yOoBt/kZpWGgE0pKowQsJ3cscLgGp59T1ENtictzXp0znaSi2oKItwydNp1ago3msXMK
	 xW7vjvet0OwQFJYtlkYY47lTZ+DBZ3R7m7CpkJCISPiohnnwTXartiVhVn33xUuUK4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700620;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=IbtZayZDgJ9Vj67NFvonwGTERyhom3D0b6to9erQstw=;
	b=XliIHuMlb/Cl7Wa7yMP6FaCW1dnp9JPx34CsEFW4p1teSaiLg5pXc/4RSsx7Z42LvdXK
	 ZLDYVmpWDu5bPlwEjIjyD/7vTOMHM8IWmfjCP6XeNApLS7KU+TSAOmk67jNVZmIWBCdbm
	 uPxSWAVUCvR3fFvd7Z23U2dJO73W9TGJILFl4vY7A2ehGm+w3vkBfc0stUxr21wcjkax5
	 ZS5anUrLRYBK4Ky/g0s+gz2Yo4ocb6hi8wIIguMAN4Xa82TE8RHG1LzF2Dxf07Ln9MO+3
	 yqmk4FUkvEIaT37NvQuQIuqulGeJm0CXcbBoS0ANMJLQcvcZZ0TxpFEFy1CUrWzGsjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26A3606A321;
	Thu, 26 Nov 2026 13:43:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E26A3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jZyRz327Qz1yQv;
	Thu, 26 Nov 2026 21:43:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DA67440574;
	Thu, 26 Nov 2026 21:43:32 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3sO+DNwhr0ziNFw--.19345S3;
	Thu, 26 Nov 2026 21:43:32 +0800 (CST)
Message-ID: <89b6062e-73c8-4a7b-8e7f-6899ac8470f6@huaweicloud.com>
Date: Thu, 26 Nov 2026 21:43:29 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: remove a few duplicated lines
To: Carlos Maiolino <cem@kernel.org>, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: dgc@kernel.org, djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, chengzhihao1@huawei.com
References: <20261126122229.2281679-1-wozizhi@huaweicloud.com>
 <awgy2d_SbrvHtvkI@cronus.toxiclabs.cc>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <awgy2d_SbrvHtvkI@cronus.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3sO+DNwhr0ziNFw--.19345S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4kJry5Ar4rurW7Kw43Awb_yoW5Cr4xpF
	Z5Ja1jkFs8tw17ur4xXw40vwn7tw1xurW8CrykAF1Sqwn8JF4IkFyv9r1rXw4rXan8ur12
	grs0grs7Za13Wa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/11/26 21:26, Carlos Maiolino 写道:
> On Thu, Nov 26, 2026 at 08:22:29PM +0800, Zizhi Wo wrote:
>> From: Zizhi Wo <wozizhi@huawei.com>
>>
>> Remove duplicated lines:
>> - xfs_alloc_read_agf() checks pagf_freeblks twice.
>> - xfs_ondisk.h checks the size of struct xfs_attrlist twice.
>> - xfs_rtgroup.h declares xfs_rtginode_irele() twice.
>>
>> No functional changes.
> 
> This patch does not apply cleanly as it conflicts with another patch
> that has been enqueued in for-next for almost a month...
> 
> Please make sure your patches apply cleanly to xfs-linux/for-next before
> submitting them.

Sorry, I sent this one too quickly. I'll make sure to rebase and test
against xfs-linux/for-next before sending patches next time.

> 
> Also add the proper "Fixes:" tags as appropriate.

I originally treated this as a pure cleanup and didn't add fixtag. I'll
include the appropriate ones in V2, and drop the xfs_alloc_read_agf
hunk.

Thanks,
Zizhi Wo

> 
>>
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   fs/xfs/libxfs/xfs_alloc.c   | 1 -
>>   fs/xfs/libxfs/xfs_ondisk.h  | 1 -
>>   fs/xfs/libxfs/xfs_rtgroup.h | 2 --
>>   3 files changed, 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index ae221a158764..2c5b73803a6b 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -3509,7 +3509,6 @@ xfs_alloc_read_agf(
>>   	if (!xfs_is_shutdown(pag_mount(pag))) {
>>   		bool	ok = true;
>>   
>> -		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>>   		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>>   		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
>>   		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
>> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
>> index 23cde1248f01..ae16b1bc2bbe 100644
>> --- a/fs/xfs/libxfs/xfs_ondisk.h
>> +++ b/fs/xfs/libxfs/xfs_ondisk.h
>> @@ -305,7 +305,6 @@ xfs_check_ondisk_structs(void)
>>   	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,	16);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
>> -	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
>> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
>> index fca2eb74908c..e505be68462b 100644
>> --- a/fs/xfs/libxfs/xfs_rtgroup.h
>> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
>> @@ -328,8 +328,6 @@ int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
>>   		bool init);
>>   void xfs_rtginode_irele(struct xfs_inode **ipp);
>>   
>> -void xfs_rtginode_irele(struct xfs_inode **ipp);
>> -
>>   static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
>>   		enum xfs_rtg_inodes type)
>>   {
>> -- 
>> 2.53.0
>>
> 
> 

