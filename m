Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F373DE420;
	Thu, 25 Jun 2026 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782390602; cv=none; b=bRBTD+R2B1dJ6pwmTeidXCzYZ7iP3PMgSw3CMg/XKRQHJk58Qo2MVpcfpKStGZWWXhjzJXIBOINQ2Ja0ujx5cfAwqxMdipSIxZE1xxU2yvF9N8EiHtcHNyghm4/s6blpXjPix2UT0+yKReFWPfyNnspT9NJ6WEWS1gW92dfJ0/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782390602; c=relaxed/simple;
	bh=Y6SgMcU+hNo/UcbkaDgXN0zWbb1jKsseSB2cBZp/FGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k7GaWHLgrGrKGQ7hunABVL2RYeKf/Rl6L+F9oyBiJBWBrBsMzoo36o7u+wswk4ZodqX1LJZNXfUMGeuqrb6WTpDaQSnZHz4dL1K7pd90Iyk8hepYPGX9IGuCS3m8875+rJuVYID/aiJGYRc1H1Xm1vEyPlJDYiTiQfDAB8m5Jho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gmJ5N3GHqzYQtqw;
	Thu, 25 Jun 2026 20:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A3976406BC;
	Thu, 25 Jun 2026 20:29:56 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBXpzxCHz1q6vY+DA--.11772S3;
	Thu, 25 Jun 2026 20:29:56 +0800 (CST)
Message-ID: <efb80ee3-ad1a-4f62-a8d4-c3f948356a07@huaweicloud.com>
Date: Thu, 25 Jun 2026 20:29:54 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
To: Pankaj Raghav <pankaj.raghav@linux.dev>,
 Christoph Hellwig <hch@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 bfoster@redhat.com, lukas@herbolt.com, "Darrick J . Wong"
 <djwong@kernel.org>, dgc@kernel.org, gost.dev@samsung.com,
 andres@anarazel.de, kundan.kumar@samsung.com, cem@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
References: <20260611114029.176200-4-p.raghav@samsung.com>
 <ajFQPANpajmFuKpi@infradead.org>
 <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
 <557b2e5c-7c65-48de-87a9-6fba21eca99f@huaweicloud.com>
 <0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com>
 <aj0bNstaTvy3HOkh@infradead.org>
 <b86337f2-5aa5-4905-9610-35fafed2018b@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <b86337f2-5aa5-4905-9610-35fafed2018b@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXpzxCHz1q6vY+DA--.11772S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKryfAF48WFy5Ww1ktF47urg_yoWDCrcE9a
	98ur9rGwnrJayjqF43Krn5trZ7KFWjy3yrKw1rXF17W348tF97Cws3Wws5Zr15KFsrArsx
	Gr9YgFy5ZF1S9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
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

On 6/25/2026 8:16 PM, Pankaj Raghav wrote:
> 
> 
> On 6/25/2026 2:12 PM, Christoph Hellwig wrote:
>> On Thu, Jun 25, 2026 at 07:16:47PM +0800, Zhang Yi wrote:
>>> I've thought about this more and feel that we need to add one more
>>> scenario here:
>>>
>>> 3) If the blocks at the boundaries are in dirty unwritten or in delay
>>>     allocated state, it should be handled the same way as scenario 2.
>>>     Additionally, before returning, we need to flush these two boundary
>>>     blocks that have been partially zeroed, to ensure that after
>>>     FALLOC_FL_WRITE_ZEROES, all ranges are in the written state.
>>>
>>> What do you think?
>>
>> Yes.  Can you send an xfstest addition the exercises these corner
>> cases?
>>
> 
> I have already created one that does a subset of these cases. I will add more
> and send it to the list soon!
> 
> -- 
> Pankaj

Ah, thanks for working on this! I'm also fixing the corresponding
issues in ext4. After you post your test case, I'll incorporate it and
help with the review as well.

Thanks,
Yi.


