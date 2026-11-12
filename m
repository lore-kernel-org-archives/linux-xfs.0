Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794472191;
	b=2oxxEeWrgWv3DWb7jED9dVyS1TH6Ll6WsoihUFfPWkJIaoBG7YlKSnU80LtQqMwx4h8n
	 KurNeeXAU8C0KPMtKBR42sVEYX2Bn/LKJgAMKacOWObV7Cf/I7SoTqDPbJlgZsQbqGxqv
	 yNp14SxIHX/nhEeUzGDzZRzsM3xW5l0rgWjOK9IN7HqWXOPWhq8YqeLPgKXgHuKkhyQas
	 uM4HjAh+8zzLuyniH6kFjHAEpUgFZ1Dajz2bzJjM7aSXI5y7Aez3CE76XnvaWoXHjA9ad
	 c4AV/nJSAfXTD9tpoZQK9o3JJvCYCSv+KIrV9KenAJU5E1HmixVzRTy/Z+W9TyXX4eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794472191;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=gc7aRKi1OTN38gZF0iB1g/aVZMHfRfxSo8k9cS0cF6U=;
	b=dJCnU53a/y40vH8HKVDD4GvOkzSOZO9AjjdIYq+q2JUchjSAPBQs/Q/NmwwQZKILObtK
	 KAXyXW2IZrZw5EKmTbV7a15HAyDO+Pt4z2+gKweD5TMJgiLtAQOsg0mcLmGBqtt/BI4+8
	 a+rDubXyCdFVsoxROSvwKfZ5D9mAbqk3NL9XE7IV0uU82N4zs6SMJYvNW6nvB6o6G7Xxm
	 t4M3MiCeQkFjMjt5j2bwdhvXOfo7YVEqaYaGppkc6VSDp+trjfICEqR2c6TmdQD8vJ0kA
	 L6JS72E550qXxZsBSqVc8yWWmViOKN/h9ZDjFH1eLZB+YvnxJMrXOHYonbZBShjlhRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=le10vfeh;
	arc=none smtp.remote-ip=95.215.58.120
Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512A1606A321
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 08:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 512A1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=le10vfeh
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j0RJG2N4IABZ2jiB6Vune71gW/eL62u62prLnDIf4is=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794472187; v=1; x=1795076987;
 b=le10vfehYmTwx5d6lbPFDp/FYTliOrxj6gxM6Eu4je1+TIRVL8e5/jEZY73hXY/bcHTtJmIW
 /ictlRFd8ubj4dK3EU2t/KY5O2GB1XO5A/3M9dWsBECzukJgLhkpfI6SopsSyYj8kc2AzHOLEAF
 mgBSeLJ0b+D2njpiWdIcV270=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 796e21b03d4ff1c1;
	Thu, 12 Nov 2026 08:29:47 +0000
X-Mizu-Trace-ID: 796e21b03d4ff1c1
X-Migadu-Flow: FLOW_OUT
Message-ID: <b1fba95d-97c8-44ae-a5be-6d2fba7e7e78@linux.dev>
Date: Thu, 12 Nov 2026 08:29:42 +0000
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: check the disk address for hardware atomic writes
To: daejun7.park@samsung.com, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org
Cc: Pankaj Raghav <p.raghav@samsung.com>,
 Pankaj Raghav <pankaj.raghav@linux.dev>, "Darrick J. Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
References: <20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/26 00:41, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_bmap_hw_atomic_write_possible() checks the alignment of the encoded
> br_startblock, not of the disk address. This was harmless while atomic
> writes were capped at the greatest power-of-two factor of the group
> size.
> 
> Commit ec8f62cc109a ("xfs: don't limit software atomic writes by the
> group alignment") lifted that cap. The block layer can now fail a
> misaligned write with -EINVAL, 

It's a good thing that we have those block layer checks...

> and XFS does not fall back to COW.
> Unaligned AGs, such as those made by mkfs.xfs before 6.16, and rtgroups
> made by any version can hit this.
> 
> Check the disk address instead.
> 
> Fixes: ec8f62cc109a ("xfs: don't limit software atomic writes by the group alignment")
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> The bug needs a group size that is not a multiple of the device's
> atomic write unit max. mkfs.xfs 6.16+ rounds agsize to a multiple
> of it if the device reports one at mkfs time, but never rounds
> rgsize. Before 6.16, a single device of 4 TB or more got an odd
> agsize.
> 
> Tested on emulated NVMe with a 64 KiB atomic unit and boundary.
> 64 KiB atomic overwrites in AG 1-3 (mkfs.xfs 6.6.0 -d agsize=262142b)
> and rtgroups 1-7 (xfsprogs 7ebfc20eb88e -r rgsize=65534b) failed with
> EINVAL before and used COW after. fstests -g atomicwrites and xfs/838
> (rt) give the same results before and after (generic/773 fails with
> ENOSPC on both).
> 
> Changes in v2:
> - Explain why the check was harmless before ec8f62cc109a and which
>    filesystems are affected (Pankaj).
> - Reword the comment: an fsbno is not always a linear disk address
>    (Pankaj).
> ---
>   fs/xfs/xfs_iomap.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c3465204b8d..119ff8e4c95 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -848,8 +848,10 @@ xfs_bmap_hw_atomic_write_possible(
>   	 * atomic writes are required to be naturally aligned for disk blocks,
>   	 * which ensures that we adhere to block layer rules that we won't
>   	 * straddle any boundary or violate write alignment requirement.
> +	 * Check the disk address: an fsbno is not always a linear disk address.
>   	 */
> -	if (!IS_ALIGNED(imap->br_startblock, imap->br_blockcount))

Is there anywhere else in which we do an alignment check on 
br_startblock that relies on the group size to be a multiple of the HW 
awu max?

> +	if (!IS_ALIGNED(xfs_fsb_to_db(ip, imap->br_startblock),
> +			XFS_FSB_TO_BB(mp, imap->br_blockcount)))
>   		return false;
>   
>   	/*
> 
> ---
> base-commit: 48326a2382d80715475d10ce98734ac65d2d2150
> change-id: 20261110-xfs-hw-atomic-align-0eab6833447a
> 
> Best regards,

