Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA72DCF61;
	Thu, 23 Jul 2026 01:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769969; cv=none; b=EyhLQkivCFtqdOCBVNSET5PXDTGjIOsk9p07E9eBoAuNgWP4x+e2qk0SUZdhEUcYDcLsiKkYDFGAgZH7LwvO0puODSHz6aF0IE9bem9L2b+0NvzOmsNjAFz1iEXhwB6QjxqZTkrDYq4qQebR0aF+9VzvDaimejr7uPzTg7QO6V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769969; c=relaxed/simple;
	bh=qsENIsk8IVpt31kC+5aUJqtQtf9uAZPzHt/Z+EJ5Ggo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uxtlFdERFVma3Z3250+PEZeD1F7oaBQbiKNqOj6SKrQqGXvKVt5CzjBv2gUhq5SjDAbnR+gVslFDu0BLN7WBNMXYb862tznSME4iTlLDFagoB9tKcBBpOP51yfv7NKSZnYPNOx0dpO9jZ8wKotuCYTcSMWubZpJcBk1QFmzJiCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h5D2L1rCWzKHMTf;
	Thu, 23 Jul 2026 09:25:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C4FA84058D;
	Thu, 23 Jul 2026 09:25:58 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nKkbWFq0nbaCA--.5388S3;
	Thu, 23 Jul 2026 09:25:58 +0800 (CST)
Message-ID: <5c5650a0-6fca-4638-b4cb-920065cd4015@huaweicloud.com>
Date: Thu, 23 Jul 2026 09:25:56 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] iomap: trivial fixes for ext4 conversion
To: brauner@kernel.org
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, djwong@kernel.org,
 hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com,
 yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
 yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
 <amDiuuX56ChS6LO0@mit.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <amDiuuX56ChS6LO0@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgDH1nKkbWFq0nbaCA--.5388S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1xJFW8CF1xCF4UWw45Wrg_yoW5WrWxpF
	Z3Ka15Kr4UWr4xAayxAa17X3WYva1fJF48W3W3Wwn5AFZ0vF18XF4xKa15uryDCrWrCFyr
	tr1UK3Z3G34qyrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UAwIDUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/22/2026 11:34 PM, Theodore Tso wrote:
> Hi Christian,
> 
> These fixes are needed for landing support for buffered writes using
> iomap in ext4.  That won't be ready to land this development cycle,
> but could we land these fixes now?
> 
> Thanks,
> 
> 						- Ted

Here's another one. Could you please take this one along too?
Thank you.

https://lore.kernel.org/linux-fsdevel/20260713074206.1768006-1-yi.zhang@huaweicloud.com/

Best Regards
Yi.

> 
> On Tue, Jul 14, 2026 at 04:23:20PM -0500, Zhang Yi wrote:
>> Hi,
>>
>> This is v4 of the trivial iomap fixes for the ext4 conversion. There are
>> no code changes relative to v3, the only update is the addition of a
>> Fixes tag in patch 03.
>>
>> Changes since v3:
>>  - Collect RVB tags from Christoph.
>>  - Add fix tag in patch patch 03 ("iomap: fix incorrect did_zero setting
>>    in iomap_zero_iter()").
>> Changes since v2:
>>  - Collect RVB tags from Darrick and Joanne.
>>  - Remove CC stable tag in patch 01 as Joanne suggested.
>> Changes since v1:
>>  - Add fix tags to patch 01 and 04.
>>  - In patch 04, change ifs_set_range_uptodate() to always fall through
>>    to ifs_is_fully_uptodate(), preventing a false-positive uptodate
>>    mask.
>>  - Add patch 05, add comments for ifs_clear/set_range_dirty().
>>
>> v3: https://lore.kernel.org/linux-fsdevel/20260713072906.1726059-1-yi.zhang@huaweicloud.com/
>> v2: https://lore.kernel.org/linux-fsdevel/20260520030357.679687-1-yi.zhang@huaweicloud.com/
>> v1: https://lore.kernel.org/linux-fsdevel/20260514062955.1183976-1-yi.zhang@huaweicloud.com/
>>
>>
>> Original Cover-letter:
>>
>> This patch series contains a few trivial iomap-related fixes in
>> preparation for converting ext4 buffered I/O to use iomap. 
>>
>> The first three patches are taken from my ext4 conversion series [1], as
>> suggested by Christoph. The fourth patch fixes a bug originally reported
>> by Sashiko during review of my series; although unrelated to the ext4
>> conversion, it is worth fixing on its own. Please see the following
>> patches for detail. The fifth patch add comments for
>> ifs_clear/set_range_dirty(), and the last patch avoids merging ioends
>> that have different private data.
>>
>> Thanks,
>> Yi.
>>
>> [1] https://lore.kernel.org/linux-ext4/20260511072344.191271-1-yi.zhang@huaweicloud.com/
>>
>> Zhang Yi (5):
>>   iomap: correct the range of a partial dirty clear
>>   iomap: support invalidating partial folios
>>   iomap: fix incorrect did_zero setting in iomap_zero_iter()
>>   iomap: fix out-of-bounds bitmap_set() with zero-length range
>>   iomap: add comments for ifs_clear/set_range_dirty()
>>
>>  fs/iomap/buffered-io.c | 58 ++++++++++++++++++++++++++++++++----------
>>  1 file changed, 44 insertions(+), 14 deletions(-)
>>
>> -- 
>> 2.52.0
>>
>>

