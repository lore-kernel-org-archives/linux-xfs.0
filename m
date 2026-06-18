Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F75395ADD;
	Thu, 18 Jun 2026 10:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781778387; cv=none; b=PY2mnmcdH2WcpaT4BQ4Twe6KwQPMFU3lBjoR0aObtNp3btN7GjUgJsvYZzdmmGtJJRzSEzjfex6+H7b8ZPG+orhlY1sEHA6wqwRhZB7+MCIYCf4DvdIo1EWn18LThX1IuJRmK/xj5Mp9AZIoeBI2pSXwDHfpLvS0/E3sQUjdxqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781778387; c=relaxed/simple;
	bh=LcOEICqj+UPKe0K9jPnu41OS3Khr0nTZMdknKHL4Jq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cHl7Ed9T4yyZ84i8QR0pwZ2sExswAm1tzWOJzAWPFbJAMSbDV3ih0j6g1lJhTbzkikGOGj+75FFRy05APk0CT8lJuR6EYNYAD2Nol9PBlpRL6v60qeQTHhklUaTt/2HIkT8BT0Y6fYGXfMf92lSr93X4mnKRUVHGE0PHeJksuO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ggxgm57VSzKHMWT;
	Thu, 18 Jun 2026 18:25:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8C57D4058F;
	Thu, 18 Jun 2026 18:26:14 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgA3OT7ExzNqzkfqCA--.37094S3;
	Thu, 18 Jun 2026 18:26:14 +0800 (CST)
Message-ID: <58578df9-9004-4693-85b0-cf0533399643@huaweicloud.com>
Date: Thu, 18 Jun 2026 18:26:12 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
To: Christoph Hellwig <hch@infradead.org>
Cc: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>,
 Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 bfoster@redhat.com, lukas@herbolt.com, "Darrick J . Wong"
 <djwong@kernel.org>, dgc@kernel.org, gost.dev@samsung.com,
 andres@anarazel.de, kundan.kumar@samsung.com, cem@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
References: <20260611114029.176200-4-p.raghav@samsung.com>
 <ajFQPANpajmFuKpi@infradead.org>
 <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
 <557b2e5c-7c65-48de-87a9-6fba21eca99f@huaweicloud.com>
 <ajOzZv7407w_hodk@infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ajOzZv7407w_hodk@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3OT7ExzNqzkfqCA--.37094S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ArW5Cr1rZrWrWrW3JFW3trb_yoW8Gw4Dpr
	ZxK3WrtFs7K347WF97Za1Igw18A3yfWa98urn8Wr4UA398XF1fGw4qgrWqgFWUuw18Za4F
	qF4YyFy8Z3ZrZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/18/2026 4:59 PM, Christoph Hellwig wrote:
> On Thu, Jun 18, 2026 at 11:22:45AM +0800, Zhang Yi wrote:
>> 1) if the two blocks straddling the boundaries have not yet been allocated,
>>    or allocated as unwritten, we should round outward the allocation range
>>    and zero out all allocated blocks, including those two boundary blocks.
>> 2) if the blocks at the boundaries are already in the written state — which
>>    can occur when we call FALLOC_FL_WRITE_ZEROES within the file size. We
>>    should be careful here: we should only zero the ranges [offset, offset_ru)
>>    and [end_rd, end) for the boundary blocks, leaving the already-written
>>    portions of the boundary blocks intact.
>>
>> Thoughs?
> 
> Yes.
> 
>> Regarding the second point, the current ext4 implementation has an issue —
>> it zeroes out the entire boundary blocks. I overlooked this previously, and
>> I appreciate you pointing it out.
> 
> Which means we're missing test coverage for this as well..
> 

Ha, I just re-checked the ext4 implementation and found that scenario 2 is
actually fine, Sorry I misread the code earlier. Fortunately, no data
corruption occurred. :-)

The real issue is in scenario 1, where the boundary blocks are not correctly
converted to written-type extents.

As for testing the unaligned case, I also agree that we should explicitly add
a dedicated test for it. Relying on existing fsstress and fsx is not reliable
enough in this regard.

Thanks,
Yi.


