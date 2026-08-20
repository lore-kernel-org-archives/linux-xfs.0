Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B5F302767;
	Thu, 20 Aug 2026 07:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787211390; cv=none; b=ku+XCbbSQQvo1x2xkJyLElkF051ST130gtUjaCqAXCYT88ely6kdbQbxoWql14Q82FAuB95mMl+04w1ZWy8hrUBG0PMEVJ7Th9mDjncV6R9N+VbTuCj9/Bn9qXNhxXG1A2HQ6nQhajzkoZUIPOD36Oh2VrEZHUGgZmIZtLhcJEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787211390; c=relaxed/simple;
	bh=URDIBkBm+/CC7U8utgAtod2L7ePKpRqAWC1f5q2yzu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LxV8Q8XT8Nbu5h39eb84l+w5lHb1hU9XXGwsDu2gUIfoHvYFrMh3NRDfy/CeNiYSglEUDEylwx6bWG+KgWb9U4t6m0fXNkkW3EWJQAbbjpAdjJlMwwoAu8huI6txISZUl/h6it3DBfp8k3Pm8qAqBsb1pvdJqKsoiz2U6L5Ws94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hQZxJ0L7xzYQv3W;
	Thu, 20 Aug 2026 15:36:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 69C9340590;
	Thu, 20 Aug 2026 15:36:22 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgC3pkVyroZqUcnwCw--.49743S3;
	Thu, 20 Aug 2026 15:36:20 +0800 (CST)
Message-ID: <a2939c81-a9c0-4b26-ac2c-17e3773125b5@huaweicloud.com>
Date: Thu, 20 Aug 2026 15:36:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
To: Pankaj Raghav <p.raghav@samsung.com>, linux-man@vger.kernel.org,
 Alejandro Colomar <alx@kernel.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org, gost.dev@samsung.com, hch@lst.de,
 pankaj.raghav@linux.dev
References: <20260819114022.818734-1-p.raghav@samsung.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260819114022.818734-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgC3pkVyroZqUcnwCw--.49743S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWryrCFykZr13ArWkWF47twb_yoW5ur43pF
	WF9F1Ykws8Ga43K3s3uw4vkryrZ3ykJw45ur4I9348Ars8Z3WxKFs3KF15Za47JryrAayj
	qFy0gFy7CwnrAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/19/2026 7:40 PM, Pankaj Raghav wrote:
> This flag was added to the kernel in v6.17. As of now, only ext4
> supports this flag.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Hi, Pankaj!

Thank you for supplementing the missing man page documentation. Some
suggestions below.

> ---
> Note:
> This feature was recently added to XFS and it is expected to land in
> v7.13. I will update this man page again once v7.13 is released.
> 
>  man/man2/fallocate.2 | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
> index ef6586c77..b39ca5c8d 100644
> --- a/man/man2/fallocate.2
> +++ b/man/man2/fallocate.2
> @@ -244,6 +244,41 @@ SMB3 (since Linux 3.17)
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
> +blocks are allocated with written extents for
> +the regions that span the holes in the file.
> +After a successful call,
> +subsequent reads from this range will return zeros.
> +.P
> +This
> +.I mode
> +makes use of the unmap write zeroes functionality feature that many modern
> +flash-based storage offers to efficiently zero out the hole space.

FALLOC_FL_WRITE_ZEROES itself is relatively flexible. It does not
mandate that the filesystem must implement zeroing via unmap write
zeroes. That depends on the specific implementation of each filesystem.
Currently, ext4, xfs, and block devices (bdev) support this operation
through that approach, since writing zeros directly on devices that do
not support unmap zeroes can be very slow and thus of little practical
value.

Therefore, I would suggest referring to the description in, for
example, fallocate(1):

https://man7.org/linux/man-pages/man1/fallocate.1.html

  "Zeroing is done within the filesystem. The
   filesystem may use a hardware-accelerated zeroing command or may
   submit regular writes. The behavior depends on the filesystem design
   and the available hardware."

What do you think?

> +This approach means that the specified range will be physically zeroed out
> +on the device (including partial blocks at the either end of the range).
> +.P
> +No other flags may be specified in
> +.I mode
> +in conjunction with
> +.BR FALLOC_FL_WRITE_ZEROES .
> +.P
> +Not all filesystems support
> +.BR FALLOC_FL_WRITE_ZEROES ;
> +if a filesystem doesn't support the operation, an error is returned.
> +The operation is supported only in ext4 (since Linux 6.17).
                                      ^^^^
ext4 (only for extent-based files)

Thanks,
Yi.

> +.\" commit f4265b8d32c49ff95711e6fef7d05245a2905b30
>  .SS Increasing file space
>  Specifying the
>  .B FALLOC_FL_INSERT_RANGE
> @@ -385,6 +420,7 @@ or
>  is
>  .BR FALLOC_FL_COLLAPSE_RANGE ,
>  .BR FALLOC_FL_ZERO_RANGE ,
> +.BR FALLOC_FL_WRITE_ZEROES ,
>  or
>  .BR FALLOC_FL_INSERT_RANGE ,
>  but the file referred to by
> 
> base-commit: d926b42e0ea0406d5c2556e18205eced92d053f1

