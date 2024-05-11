Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097AD1078B
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 09:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715419634; cv=none; b=sFC/5k1mMh2hU//vdaKWq6oZg+kgYRcfbzscpneOAlU4vomSFo/Hng7uuG3YjhdIMn5rLnRLImYwTC6F6KlkaflWnt9WXKxn57g2oPGAbq8TuMrcYBCgwL2DhcwVaDqsCxZqueBh6gTf3KtzfXIt60D36GFcrRp6MIncLAq0ArM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715419634; c=relaxed/simple;
	bh=8DELsgrX1P8LnietO+pnjUjZMUU8tK1JmdnD0/E2aU8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=o1o6dn3fWmrQbEhMTP3S7JGfvTcK0KTvEIt2NW5J52QDQq0ZJ1nSEQVMraCrF0QbWDj97j+Xo1AG86NeCAVvXmtdyWlfSRkoPi9hrfROMg270Qz3T5FbdrgapCAbnefTqIWmW0pCOsAKjrRDYwhPNDsADsyPWz7nw+E2HTTJ2ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vc0kp3KNGz4f3jdH
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 17:26:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id E3E5C1A0568
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 17:27:06 +0800 (CST)
Received: from [10.174.179.80] (unknown [10.174.179.80])
	by APP2 (Coremail) with SMTP id Syh0CgAnmAvpOT9m6pGgMg--.9116S3;
	Sat, 11 May 2024 17:27:06 +0800 (CST)
Subject: Re: [BUG REPORT] generic/561 fails when testing xfs on next-20240506
 kernel
To: Dave Chinner <david@fromorbit.com>
Cc: Chandan Babu R <chandanbabu@kernel.org>, djwong@kernel.org,
 Christoph Hellwig <hch@infradead.org>, brauner@kernel.org,
 Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <87ttj8ircu.fsf@debian-BULLSEYE-live-builder-AMD64>
 <6c2c5235-d19e-202c-67cf-2609db932d5a@huaweicloud.com>
 <Zj7pzTR7QOSpEXEi@dread.disaster.area>
 <966892ef-9b47-3891-e2d2-48889d46223d@huaweicloud.com>
 <Zj8qDHJBL5igjVrJ@destitution>
From: Zhang Yi <yi.zhang@huaweicloud.com>
Message-ID: <0b92a215-9d9b-3788-4504-a520778953c2@huaweicloud.com>
Date: Sat, 11 May 2024 17:27:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zj8qDHJBL5igjVrJ@destitution>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgAnmAvpOT9m6pGgMg--.9116S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF1kCry8Xw47Wr43CrWruFg_yoW5Gr1xpF
	y7CFW5Ga1kGry0qF97Za4xZrWFkw15JFW0yryFvrnxZr9rXryftF17t34F9a9F9r1xAr4j
	va1YqFWxZFn5A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 2024/5/11 16:19, Dave Chinner wrote:
> On Sat, May 11, 2024 at 03:43:17PM +0800, Zhang Yi wrote:
>> On 2024/5/11 11:45, Dave Chinner wrote:
>>> On Sat, May 11, 2024 at 11:11:32AM +0800, Zhang Yi wrote:
>>>> On 2024/5/8 17:01, Chandan Babu R wrote:
>>> It might actually be easiest to pass the block size for zeroing into
>>> iomap_truncate_page() rather than relying on being able to extract
>>> the zeroing range from the inode via i_blocksize(). We can't use
>>> i_blocksize() for RT files, because inode->i_blkbits and hence
>>> i_blocksize() only supports power of 2 block sizes. Changing that is
>>> a *much* bigger job, so fixing xfs_truncate_page() is likely the
>>> best thing to do right now...
>>>
>>
>> Thanks for the explanation and suggestion, I agree with you. However,
>> why do you recommend to pass block size for zeroing in to
>> iomap_truncate_page()? It's looks like we could fix xfs_truncate_page()
>> by using iomap_zero_range() and dax_zero_range() instead and don't use
>> iomap_truncate_page() and dax_truncate_page().
> 
> Fair question. Yes, we could just fix it in XFS.
> 
> But then any other filesystem that uses iomap might have the same
> problem where the allocation block size (and hence the range that
> needs zeroing) is different to the filesystem block size (e.g. ext4
> with bigalloc?). At that point, those filesystem developers need to:
> 
> 	a) be aware of the issue; and
> 	b) implement their own iomap_zero_range() wrapper for the
> 	same function.
> 
> If the iomap infrastructure doesn't assume block sizes are always
> i_blocksize() (which is clearly a bad assumption!), then the API
> itself informs the filesystem developers of the fact they really
> have to care about using the correct allocation block sizes during
> EOF zeroing.
> 
> At the moment, only XFS uses iomap_truncate_page(), and only ext2
> and XFS use dax_truncate_page(). It seems pretty simple to change
> the infrastructure and document why we don't use i_blocksize() at
> this point. Especially considering we have forced alignment stuff in
> XFS coming up which further decouples allocation unit (and hence
> zeroing range) from the filesystem block size....
> 

ext4 with bigalloc still use block size (not cluster size) to manage
allocation extents, so it aligned to the block size when truncate and
doesn't have this problem now. But it doesn't matter, your suggestion
make sense to me, pass block size to iomap_truncate_page() and
dax_truncate_page() could make them to have better compatibility.

Thanks,
Yi.

