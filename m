Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5196A2116F4;
	Sat,  5 Sep 2026 00:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788567869; cv=none; b=l5pew0cX+2MfW+MPv7W/re0aCRQWibsBOZ8TUVEsgoF7+/60Vw9wMZ3MMBnvxJZsbD4RgOaC5hc1DK42uay/xJL3tvkgcb1fCD4/NnvLzRRT9QFhTP2fKXH6pQIONBrhcqFNBwCXDxeyzRJwkZ1zmLvuMYW1vyTiIXQJDr/Hgnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788567869; c=relaxed/simple;
	bh=iwNzIiHTJADI6zpjxWyjOrUKMVt6XIVPWWxV/zzsqgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oVByzY+ajgt2w0ZWTr38YblXnd0sHHvA6x3IAh2t5l4AqBuv3jclcxelI+stXMj9LQZahZIQS0KptJ0tPnf3sYMKm5MoBWnIHW3xe2a0QdV68+c2+KKJAlFeNhv2JxnKDQb38GInK6fjojb400HZG4J/OOoQocFWbPooqL0rPwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hcDZb6ZVZzKHMRG;
	Sat,  5 Sep 2026 08:23:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 0843D4056D;
	Sat,  5 Sep 2026 08:24:16 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBHMAsuYZtqzgYjAw--.63215S3;
	Sat, 05 Sep 2026 08:24:15 +0800 (CST)
Message-ID: <1e6efb44-3b7d-4687-a1b8-25767ae1e1dd@huaweicloud.com>
Date: Sat, 5 Sep 2026 08:24:13 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] xfs: remove leftover dead declarations in headers
To: Carlos Maiolino <cem@kernel.org>, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: dgc@kernel.org, djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, chengzhihao1@huawei.com
References: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
 <aprh7OnJPCL-iIIK@andromeda.toxiclabs.cc>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <aprh7OnJPCL-iIIK@andromeda.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHMAsuYZtqzgYjAw--.63215S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45ZF1xAr4UGw4fKw4DJwb_yoW5Jr1rp3
	yrW3Wqka1DJry29Fn2q3Z7JFy2q3yxJrW7JFn5Zw1I9w1DArnFgryakFsY9F98GrZayw4Y
	q3yjqF98u3WUZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/9/4 23:24, Carlos Maiolino 写道:
> On Fri, Sep 04, 2026 at 02:06:43PM +0800, Zizhi Wo wrote:
>> While reading the XFS log code I noticed that the implementation of
>> xlog_assign_tail_lsn() had already been removed, but its declaration was
>> left behind in the header. Such orphaned declarations (implementation gone,
>> no callers) can simply be dropped.
>>
>> Suspecting more of these existed, I scanned the XFS headers (using GLM-5.2
>> to help, then verified each by hand) and this series removes the leftover
>> declarations I could confirm. Some of these have been stale for a long time
>> -- the oldest dates back to 2006.
>>
>> Note that scrub still has a fair number of functions that do have
>> implementations but no callers (e.g. xchk_process_rt_error). I'm not sure
>> removing those is appropriate, since they may be intended for future use,
>> so they are not touched here.
>>
>> Cleanup only, no functional change.
>>
>> Zizhi Wo (5):
>>    xfs: remove unused xlog_assign_tail_lsn declarations
>>    xfs: remove unused xfs_iext_realloc declaration
>>    xfs: remove unused xfs_buf_iodone declaration
>>    xfs: remove unused kmem_to_page helper
>>    xfs: remove never-implemented scrub declarations
> 

Hi Carlos,

Thanks a lot for the review.

> Honestly this all could have been a single patch, I don't believe the
> 'when the last user was gone' matters at least for me as I could find if
> through a quick `git log` scan. Darrick was fine with it so I won't
> enforce it to be a single cleanup patch.
> 

My original intent behind splitting was to keep each removal in its own
commit, so that during review one could tell directly from the commit
message why each symbol was left behind, without having to dig through
the history separately -- even though every change is tiny.

But I agree that a quick `git log` scan serves the same purpose, so I'll
fold them into a single cleanup patch in v2.


> At least get rid of the "Assisted-By: <model>" thing and send a new
> version as we don't accept models discrimination anymore.
> 
> Carlos
> 

Sure, I'll drop the "Assisted-By:" tag as well.
Will send v2 shortly.

Thanks,
Zizhi Wo

>>
>>   fs/xfs/scrub/common.h   |  1 -
>>   fs/xfs/scrub/scrub.h    |  1 -
>>   fs/xfs/scrub/tempfile.h |  4 ----
>>   fs/xfs/xfs_buf_item.h   |  1 -
>>   fs/xfs/xfs_inode.h      |  1 -
>>   fs/xfs/xfs_log.h        |  2 --
>>   fs/xfs/xfs_platform.h   | 11 -----------
>>   7 files changed, 21 deletions(-)
>>
>> -- 
>> 2.52.0
>>
>>

