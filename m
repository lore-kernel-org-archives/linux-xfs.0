Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4367831E846;
	Thu, 10 Sep 2026 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789043193; cv=none; b=cjfr/Yxfde89PxPyRW6h8V6IPGN3fRq20uQ6MbC19i323scAFBT2FjMzxf6SccFQ7rif8PPJLUkx7nZ3np2Gg0x/ZeshCWUxFZu+CgqsvD8iyRHPo/McII6QU2MdsAO4Yy+W1OwAiKTdwIBcTosnyanThwJB+rkpqypMfukRdFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789043193; c=relaxed/simple;
	bh=4ISDWe51Es/1d2oVJGz4RMaeW8HL0f6nEIuav8YUDNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IvU/4nWKd6SWSXciVyVcaEIYEw/HLJVm4h2cxT38IFRnD8KoMj+Wk8v2gpWvWiGtFmDS0Msv+PkM2a7Ote5hED2Dj7Pa4aP5kHl7P4bHZ0QwAWeZmUs26Q4F4Fo88uasJwa5A6S6E1eseR4jM1cNzLt6RWJLVBxQLU/eeIw+y+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hgcMZ3jY0zYQttH;
	Thu, 10 Sep 2026 20:25:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6A22A40561;
	Thu, 10 Sep 2026 20:26:25 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAX_gjvoaJqOdXPBQ--.24973S3;
	Thu, 10 Sep 2026 20:26:25 +0800 (CST)
Message-ID: <5d02e7dd-fa9e-497b-b1f6-9cc0f2a45c8f@huaweicloud.com>
Date: Thu, 10 Sep 2026 20:26:23 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] man/man2/fallocate.2: Add doc for
 FALLOC_FL_WRITE_ZEROES
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, Alejandro Colomar <alx@kernel.org>,
 pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
 linux-ext4@vger.kernel.org, hch@lst.de, "Darrick J . Wong"
 <djwong@kernel.org>
References: <20260910112023.2591987-1-p.raghav@samsung.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260910112023.2591987-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAX_gjvoaJqOdXPBQ--.24973S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCw1fXr1kCw18ZryrZF43KFg_yoW5Ar1UpF
	95ZF4Y9rWUWF1fK3s3u3y0kFyrZ3ykGw45ur4Ig3s5ZrZ8Zr1xKFsF9F1YvasrJry8Aay0
	qF1IgFy293srAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOBMKDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/10/2026 7:20 PM, Pankaj Raghav wrote:
> This flag was added to the kernel in v6.17.  As of now, only ext4 and
> block device nodes support this flag.
> 
> Cc: Zhang Yi <yi.zhang@huaweicloud.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: gost.dev@samsung.com
> Cc: linux-ext4@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
> Changes since v2:
> - Changed the commit format based on Alejandro's feedback.
> - I have retained "preallocated" term based on Zhang Yi's feedback[1]
> 
> 
> Note:
> This feature was recently added to XFS and it is expected to land in
> v7.3. I will update this man page again once v7.3 is released.
> 
> [1] https://lore.kernel.org/linux-man/3f17d214-f69c-47b6-abf6-4437cc5840c0@huaweicloud.com/
> 
>  man/man2/fallocate.2 | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
> index ef6586c77..48a8c3468 100644
> --- a/man/man2/fallocate.2
> +++ b/man/man2/fallocate.2
> @@ -244,6 +244,43 @@ SMB3 (since Linux 3.17)
>  .IP \[bu]
>  Btrfs (since Linux 4.16)
>  .\" commit f27451f229966874a8793995b8e6b74326d125df
> +.SS Writing zeroes in file space
> +Specifying the
> +.B FALLOC_FL_WRITE_ZEROES
> +flag (available since Linux 6.17)
> +.\" commit 7bd43cc79cab3850f34da0a31d5b042b701590ef
> +in
> +.I mode
> +physically zeros space in the byte range starting at
> +.I offset
> +and continuing for
> +.I size
> +bytes.
> +Within the specified range,
> +blocks are preallocated for the regions that span the holes
> +in the file.
> +After a successful call,
> +subsequent reads from this range will return zeros and
> +subsequent writes to that range do not require further
> +changes to the file mapping metadata.
> +.P
> +Zeroing is done within the filesystem.
> +The filesystem may use a hardware-accelerated zeroing command
> +or may submit regular writes.
> +The behavior depends on the filesystem design and the
> +available hardware.
> +.P
> +No other flags may be specified in
> +.I mode
> +in conjunction with
> +.BR FALLOC_FL_WRITE_ZEROES .
> +.P
> +Not all filesystems support
> +.BR FALLOC_FL_WRITE_ZEROES ;
> +if a filesystem doesn't support the operation, an error is returned.
> +The operation is supported only in ext4 (only for extent-based files)
> +since Linux 6.17.
> +.\" commit f4265b8d32c49ff95711e6fef7d05245a2905b30
>  .SS Increasing file space
>  Specifying the
>  .B FALLOC_FL_INSERT_RANGE
> @@ -385,6 +422,7 @@ or
>  is
>  .BR FALLOC_FL_COLLAPSE_RANGE ,
>  .BR FALLOC_FL_ZERO_RANGE ,
> +.BR FALLOC_FL_WRITE_ZEROES ,
>  or
>  .BR FALLOC_FL_INSERT_RANGE ,
>  but the file referred to by
> 
> base-commit: d926b42e0ea0406d5c2556e18205eced92d053f1

