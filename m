Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF003A8756;
	Tue,  7 Jul 2026 06:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406331; cv=none; b=eY1b8VaHZtDaxpkdIUJFpwtVoBn+tlwUz0MRblKMCAyoVoCQmUfv8WKI7bhQkXWstsr8zEot3gSwchGpSZ1uEQ96uiBcVCoA4sVu7Ypw3l+16pNNacGcFqD5hhPRDBn/ZizMKydq6p1lQLkkBUeNn7vR+i+GIG6IXFjJVWfLl+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406331; c=relaxed/simple;
	bh=gQMfSphXY+HaWYL82dtpdNarciLitspOJu0jQms0pA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OOi44MYAmeC2KkLW2HCl3KNtEukqXUGEYxaDGiX0MUASST1IjXA6vxOqWSW9+g8tnuzY/5GnEXMphiuruvg2fx9x+7+M7Vzn7RgvF0FpDb5KAdIIDypUcas3x8aouz4FInUDeGn88yYvLpsVw7K30ApikTzHrtICtc9Hv0eKqZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gvWlN0SpXzYQtl7;
	Tue,  7 Jul 2026 14:38:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EC22940561;
	Tue,  7 Jul 2026 14:38:42 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgD3B3TxnkxqSL1mAQ--.64179S3;
	Tue, 07 Jul 2026 14:38:42 +0800 (CST)
Message-ID: <e52af771-da66-48e3-a6a0-b0c31dc8b3a9@huaweicloud.com>
Date: Tue, 7 Jul 2026 14:38:40 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
To: Christoph Hellwig <hch@lst.de>
Cc: Pankaj Raghav <p.raghav@samsung.com>, zlang@redhat.com,
 fstests@vger.kernel.org, djwong@kernel.org, yi.zhang@huawei.com,
 pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
References: <20260703125422.3110429-1-p.raghav@samsung.com>
 <ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com>
 <20260707051015.GA13010@lst.de>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260707051015.GA13010@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgD3B3TxnkxqSL1mAQ--.64179S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFykuw43CrW8WF15Kr18uFg_yoW8AFy5pa
	y7Wa4Utr4kGw47A3s3JF4jqr1FvrWfWrW7XrWqq3yjv3Z8CF17Kr1ag3y0vF1jgrWrG3WY
	vF40q3s8AanxZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/7/2026 1:10 PM, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 11:08:39AM +0800, Zhang Yi wrote:
>>> +# WRITE_ZEROES must leave the whole requested range backed by *written*
>>> +# (zeroed) extents while preserving the out-of-range bytes of the partial
>>> +# boundary units. The possible scenarios are: written_edges, hole_edges,
>>> +# unwritten_edges and delalloc_edges.
>>
>> unwritten_edges needs to distinguish between dirty and clean scenarios.
>> The expected result for clean should be tmp.zero, while the expected
>> result for dirty should be tmp.pattern.
> 
> Does it?  I'd expect everything in the range to be zeroed, and everything
> outside to be left alone, as the dirty state is just an imlementation
> detail not visible to the user.

Yes, although this detail is not perceptible to the user, the final
results of these two scenarios are different.

For clean unwritten extents, the portion beyond the range up to the
aligned block boundary should be zeroed; otherwise, stale data may be
exposed after unwritten-to-written conversion. So the result should
be tmp.zero.

For dirty unwritten extents, all data outside the inode boundary
should be left untouched, so the result should be tmp.pattern.

> Similar to other falloc operations,
> I'd expect the file system to write back any boundary block first
> to make the dirty state difference moot.
> 

In fact, in ext4, for dirty extents (including both dirty delalloc and
dirty unwritten extents), they are not written back first. Instead, the
unaligned boundary blocks are zeroed out directly, followed by a
synchronous write-back before the syscall returns, ensuring the extents
are converted to the written state. This point differs from the behavior
of XFS.

Thanks,
Yi.

