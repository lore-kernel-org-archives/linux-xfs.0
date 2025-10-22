Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0425F2F5333
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 07:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761117225; cv=none; b=dnVtkfd7BO90en+j61n1EJkZLZcCzO28fPoTrqbMkT+jLI3UiWYzdrTzc86SazPCnZoI+oIZrRNGv8VX7gkqw0IMhlRwtB0vHUl4b/ly81Ak3+4oEtZo4Je0fInQRnNMfO6CY0n0Vv4u8RFs2tbfyGtyPO98syag6xV3IdC+crU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761117225; c=relaxed/simple;
	bh=zCzio98kD5JgOyfF/7/h7UBUKm47kXI6MfLg4dSflk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GzNc2ovsPT4CIBZ0xLDVCJMiwWnCKhsrjQyHmSweoC7usBBmoKZZuWV4AOYTLOmDKNYRTMrEwmYRQXVa3gn0xECFVNy/B0dHEbXiImX8E75DGJmjFMWIeAQPgxKJ2MYw6rVG9rIjzOiNcQbVgG+fe6vVq5A1Ivta721rXo1nXrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cs0jp4fmxzYQtmb
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 15:12:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 906BE1A1070
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 15:13:40 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBXrEQihPhoAnHVBA--.13599S3;
	Wed, 22 Oct 2025 15:13:40 +0800 (CST)
Message-ID: <f90b0e3e-7734-4e86-8c73-011e71333272@huaweicloud.com>
Date: Wed, 22 Oct 2025 15:13:38 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
To: Lukas Herbolt <lukas@herbolt.com>
Cc: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
 linux-xfs@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>
References: <aPhk1O0TBOx_fl30@infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aPhk1O0TBOx_fl30@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBXrEQihPhoAnHVBA--.13599S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWkCF1rJrWxGw13Kr1UAwb_yoW8Aw17pF
	4kXF47Ka9xXry7Kr4vqw4DWF1Yg3WDGF15JrZ5ur1fZa98uF97tFyDGF95uF97Cr4kAw4F
	qF90kF1UWw1DA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7IJmUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/22/2025 1:00 PM, Christoph Hellwig wrote:
> On Tue, Oct 21, 2025 at 04:17:44PM +0200, Lukas Herbolt wrote:
>> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
>> -		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
>> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
>> -				&nimaps);
>> +		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
>> +				flags, 0, imapp, &nimaps);
> 
> Please drop the reformatting that introduces an overly long line.
> 
>> -int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
>> -		xfs_off_t len);
>> +int	xfs_alloc_file_space(struct xfs_inode *ip, uint32_t flags,
>> +		xfs_off_t offset, xfs_off_t len);
> 
> Also normal argument order in XFS would keep the flags last, I think
> it's best to stick to that.
> 
>> -	int			mode,
>> +	int				mode,
> 
> Spurious whitespace changes here.
> 
>>  	len = round_up(offset + len, blksize) - round_down(offset, blksize);
>>  	offset = round_down(offset, blksize);
>> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
>> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
>> +		if (!bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
>> +			return -EOPNOTSUPP;
> 
> Overly long line.
> 
>> +		xfs_alloc_file_space(ip, XFS_BMAPI_ZERO, offset, len);
> 
> As already mentioned, missing error return.
> 
> 
> Also how is the interaction of FALLOC_FL_WRITE_ZEROES and
> FALLOC_FL_KEEP_SIZE defined?
> 

This situation will be intercepted in vfs_fallcoate().

Besides, it seems that the comments for the xfs_falloc_zero_range() also
need to be updated. Specifically, for inodes that are always COW, there
is no difference between FALLOC_FL_WRITE_ZEROES and FALLOC_FL_ZERO_RANGE
because it does not create zeroed extents.

Best Regards,
Yi.

