Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600661A6838;
	Thu,  9 Jul 2026 02:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783564586; cv=none; b=rQeZi9avQmkB+I8Q/xraqTP/lCX9MprG2efwszkVU4ZIayJgbv3sTHWHH6392QnQqAJ/7EI+HYxpqEX2ArKvYMqO3aT2eCeArmvQZG1OgTq4XjYsF0LHopFYW6y4ZpLAoHr4GGBw7VMFMFg9gNeNWxdKQPEH2bW8Qp77rhCT1HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783564586; c=relaxed/simple;
	bh=pQua1rgmO+pUoHXl6YJ3/236qm8RFRHERcfTNJlG7bU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ye26T6dpik2gYTzZjX09+3yTl17iGJZDGNwn7OS2nL+ZwKGOXpOW0eLHknkz3FllS6XDs6NBWsf9z0RhBRsQercPyqUaoSM7CtQzr8hY1AuiQabkkbs3gbIuIlM/+g3d8LR3iSdjMWt6JYoa6JAHS49WyP2xsGrbd/zT7i3KIcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gwfGh4nn7zYQtjp;
	Thu,  9 Jul 2026 10:36:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A130B4058D;
	Thu,  9 Jul 2026 10:36:18 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCXpnIfCU9qGSdDAg--.32610S3;
	Thu, 09 Jul 2026 10:36:16 +0800 (CST)
Message-ID: <51d7e89d-2e9e-43dd-8aed-8fad924d7c6f@huaweicloud.com>
Date: Thu, 9 Jul 2026 10:36:15 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] iomap: correct the range of a partial dirty clear
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
 hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com>
 <20260520030357.679687-2-yi.zhang@huaweicloud.com>
 <CAJnrk1ZnO50z7C_e0y-0SVUXtd5S39VMsWfzuwD4LEHmuZw_wg@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <CAJnrk1ZnO50z7C_e0y-0SVUXtd5S39VMsWfzuwD4LEHmuZw_wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXpnIfCU9qGSdDAg--.32610S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw4rJFWfKFW5AFyDtF4Dtwb_yoW8Gr45pF
	W7Gay7t3yDGw18G3Z7WFWfZFy0ga1fGayfWr45Gw1fGr45CFy2kF9Fga1DWa4vkr92kFWS
	qF4ag34SkF4jyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UQ6p9UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/9/2026 4:57 AM, Joanne Koong wrote:
> On Tue, May 19, 2026 at 8:09 PM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>>
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> The block range calculation in ifs_clear_range_dirty() is incorrect when
>> partially clearing a range in a folio. We cannot clear the dirty bit of
>> the first block or the last block if the start or end offset is not
>> blocksize-aligned. This has not yet caused any issues since we always
>> clear a whole folio in iomap_writeback_folio().
> 
> If this isn't currently reachable, does this still need the stable@
> tag? My understanding from the stable document [1] is that "it must
> either fix a real bug that bothers people or just add a device ID"?
> [1]
> 

Indeed, I will drop it. Thank you for the reminder.

Thanks,
Yi

>>
>> Fix this by rounding up the first block to blocksize alignment, and
>> calculate the last block by rounding down (using truncation). Correct
>> the nr_blks calculation accordingly.
>>
>> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
>> Cc: <stable@vger.kernel.org> # v6.6
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> 
> Thanks,
> Joanne
> 
> [1] https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst

