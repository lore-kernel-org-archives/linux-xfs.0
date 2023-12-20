Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A2E1F60A
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 08:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Sw6fF17YZz1Q6sb;
	Wed, 20 Dec 2023 16:48:21 +0800 (CST)
Received: from dggpemd100005.china.huawei.com (unknown [7.185.36.102])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D7391404F7;
	Wed, 20 Dec 2023 16:48:37 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemd100005.china.huawei.com (7.185.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Wed, 20 Dec 2023 16:48:37 +0800
Message-ID: <6abc40a8-8049-6c1a-37e4-d459b73b3d5e@huawei.com>
Date: Wed, 20 Dec 2023 16:48:36 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH]: mkfs.xfs: correct the error prompt in usage()
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <shikemeng@huawei.com>,
	<louhongxiang@huawei.com>
References: <2a51a8b8-a993-7b15-d86f-8244d1bfce44@huawei.com>
 <20231220024313.GN361584@frogsfrogsfrogs>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20231220024313.GN361584@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemd100005.china.huawei.com (7.185.36.102)



在 2023/12/20 10:43, Darrick J. Wong 写道:
> On Wed, Dec 20, 2023 at 09:59:04AM +0800, Wu Guanghao wrote:
>> According to the man page description, su=value and sunit=value are both
>> used to specify the unit for a RAID device/logical volume. And swidth and
>> sw are both used to specify the stripe width.
>>
>> So in the prompt we need to associate su with sunit and sw with swidth.
>>
>> Signed-by-off: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>  mkfs/xfs_mkfs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index dd3360dc..c667b904 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -993,7 +993,7 @@ usage( void )
>>  /* metadata */         [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
>>                             inobtcount=0|1,bigtime=0|1]\n\
>>  /* data subvol */      [-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>> -                           (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>> +                           (sunit=value|su=num,swidth=value|sw=num,noalign),\n\
> 
> Doesn't mkfs require sunit/swidth or su/sw to be used together, but not
> intermixed?
> 
> --D
> 

I think the '|' in usage() should be related to the modification of the same feature,
so there is also 'sunit|su' in the -l parameter. There are already other prompts for
mixed use of su/sw, and I don’t think there is a need to remind it in usage().
The current 'swidth=value|su=num' prompt makes me think that the two modifications
are the same. There may be other people who think so too, so I suggest changing
the description.

>>                             sectsize=num\n\
>>  /* force overwrite */  [-f]\n\
>>  /* inode size */       [-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
>> --
>> 2.27.0
>>
> 
> .
> 
