Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243F4403EA0;
	Mon, 13 Jul 2026 12:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783945842; cv=none; b=o0jPg/MOuT8dvUvLAbzaWMDc7tfe8vqJMNzUtm4lRtHpA7Iei6wFwFvCvaKDC3OWLTd8wMpsb16sZGudcZQq318gH7G2Y/Hz+sA/iKYSjWTJQXro7+U+Lb6LUpN7lY7RXlGNTAkUsW/8hB9NvQMKcqXldY7pgYrIcVHXwBmjeA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783945842; c=relaxed/simple;
	bh=GXIsG7ib8sNoo5NbLy9cdRzbscEmrUCklR6/byT03ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CXrmbBvx9bRfYyiofOGMqyWoVytC9tghPFz5WPCDUB607ape/dNZVK6fVdPiime/5vOJeizzakIa76QIh8dMRziMh0zLWVnMOqIKpbqII6cdcegESboNRCGtixkLXyLOcn5ADh+WKmlCrATZYv35kJTsfHKqGlF3KXfVgthdzJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzMG553RPzKHMR8;
	Mon, 13 Jul 2026 20:30:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id BF3FD4056B;
	Mon, 13 Jul 2026 20:30:34 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAHZHBp2lRqjB5XBA--.2795S3;
	Mon, 13 Jul 2026 20:30:34 +0800 (CST)
Message-ID: <cf1284dc-4642-4156-8501-3e2b1bf015d1@huaweicloud.com>
Date: Mon, 13 Jul 2026 20:30:33 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] iomap: fix incorrect did_zero setting in
 iomap_zero_iter()
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
 joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
 <20260713072906.1726059-4-yi.zhang@huaweicloud.com>
 <alSmTw_u7CJV9_D-@infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <alSmTw_u7CJV9_D-@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAHZHBp2lRqjB5XBA--.2795S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZF4fAF43XFy7Zw43tr47Jwb_yoWDCrgEgF
	WFvw1DC3yvqFW0vws7ZF15Ars7K3yUCryrGr47J3s3GFy3JFyxGFn5AFsYyw40qFWUtFZ8
	uF1Sqa9Ikw1IqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUb
	mii3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/13/2026 4:48 PM, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 03:29:04PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> The did_zero output parameter was unconditionally set after the loop,
>> which is incorrect. It should only be set when the zeroing operation
>> actually completes, not when IOMAP_F_STALE is set or when
>> IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
>> or when iomap_iter_advance() returns an error.
>>
>> This causes did_zero to be incorrectly set when zeroing a clean
>> unwritten extent because the loop exits early without actually zeroing
>> any data.
>>
>> Fix it by using a local variable to track whether any folio was actually
>> zeroed, and only set did_zero after the loop if zeroing happened.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Can you add a fixes tag?

Sure, will do.

Thanks,
Yi.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

