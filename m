Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0D9369208;
	Mon, 13 Jul 2026 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783945805; cv=none; b=CzV6BLeBljphdp+QaqLyc9hE/8nDaFn6BB8IG/ZpHn/Qg82n4XX5Cp2m47GpGgL0/g3M3T9PkdN6+N//ySbxW+7ML+O59adFv9QlmAM1PRxJ6wlWiHlYkJOQvTbIJMeCR7bhYW0xKskya5ZaaeWMcGIQETESaraHb7awfJHywoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783945805; c=relaxed/simple;
	bh=g+2CeNv0XPkFB5ugDGzJw+wyyysRYVGY7XiXNoOYp08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhQim4YvwBwbDZN+Mfpa922LaRUMs2Q/mhUNv2qqCGRpH+t+OXEf0EVOAAVWxVYHKQw5I5CJOhWPqDfAwY1sCKKqSlfHtv9Ve+qRuUbPWKRK18uKJ/5W5AOT8SyJk14xBd38XOK/lxU50c5l/IOU4viBTUQySJ40Il2B0ApjCt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzMFQ27ZPzKHMVf;
	Mon, 13 Jul 2026 20:29:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 590D440592;
	Mon, 13 Jul 2026 20:29:59 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCntnJF2lRqRRFXBA--.42884S3;
	Mon, 13 Jul 2026 20:29:59 +0800 (CST)
Message-ID: <80ed1ee9-8776-42fd-861e-f01a84d24e28@huaweicloud.com>
Date: Mon, 13 Jul 2026 20:29:56 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] iomap: support invalidating partial folios
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
 joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
 <20260713072906.1726059-3-yi.zhang@huaweicloud.com>
 <alSmLfvpehKh690P@infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <alSmLfvpehKh690P@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCntnJF2lRqRRFXBA--.42884S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKr1rCryUXr4rJryDXFWfuFg_yoWfAFcE9F
	WkZ34j934kXF9rtFs2kF4rJrn2kFWUur98Aryrtan3K348Jw1DZFn8ZrnYyr15JrW7tFy7
	CF1fXw13A3429jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AK
	xVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/13/2026 4:47 PM, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 03:29:03PM +0800, Zhang Yi wrote:
>> However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
>> the support for invalidating partial folios. When ext4 partially zeroes
>> out a dirty and unwritten folio, it does not perform a flush first like
>> XFS. Therefore, if the dirty bits of the corresponding area cannot be
>> cleared, the zeroed area after writeback remains in the written state
>> rather than reverting to the unwritten state. Fix this by supporting
>> invalidation of partial folios.
> 
> This sounds like we could use this to avoid the flush in
> zero_range/truncate in xfs as well?
> 

Theoretically yes, but XFS may have more details I haven't checked,
plus possibly other prerequisites.

> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thank you for the review!

Best Regards,
Yi.

