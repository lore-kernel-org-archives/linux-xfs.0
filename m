Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C0D33EB1A;
	Mon, 12 Oct 2026 08:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791792574; cv=none; b=Ro4WVDlme+VaT9BVDYqY2cbhzaJLA6c6R2DPluCzx/bwtN2Su5OGkwwpsIaYB3JFuX8aci9W5QZXcx4bxHKWFCiWn6F/poY+2bG0Qlir2dQOZJTpD3obd+UFhJdBCLBayaHE/vXweoVqdJcztY6t7s6c1CqOkku5yxPE/iEJyF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791792574; c=relaxed/simple;
	bh=ARh6NKT+8R2X+3TZEQb1VvyZhQ+yeWDdBwCgtw+YuOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H2j4k1XM696gY5cuQ5edWJoGWVX0q65J4P/zJ4CKxgy2Cfu5riQI3VkCB5485/AD2/q/0X1AsNojF+gZWnWwL9Nn0xowlY9g1chk7/ZGzU2BAF4LZc2r8Ce4/VG1ql1CGDnQoJXuDNVaOwUsQ6GVoBFgvDNaeOqn2gzvd9liQG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MphZnbl3; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MphZnbl3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791792568; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LhgXUpaVt4ziKTndJMvqkS/akgmr1orGNN0wap58/Ek=;
	b=MphZnbl3nAzhAcNt5PMPxPqmyTdyy3m6PMwyLxirlTUmQRZiIi6j1XBEefHKm3rki4PQfTChwAxhNCe8gVOuZA6tZmhyIxTNVPgDMoSRDz0fgHHR0+2MU8TkqTawmaASotIu+gA53vpkFbwOo7/SGH6PmEpSz9Ne82yWSio8z64=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XCclHtq_1791792566;
Received: from 30.221.130.114(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCclHtq_1791792566 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 16:09:26 +0800
Message-ID: <8c8a81b5-bde0-45c2-b673-ddd3daf7b6ce@linux.alibaba.com>
Date: Mon, 12 Oct 2026 16:09:25 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] block: don't require data unit aligned bio_vecs for
 encrypted bios
To: sashiko-reviews@lists.linux.dev, David Sterba <dsterba@suse.com>,
 mason@kernel.org, linux-btrfs@vger.kernel.org
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 ebiggers@kernel.org, jaegeuk@kernel.org, axboe@kernel.dk, hch@lst.de,
 djwong@kernel.org, brauner@kernel.org, tytso@mit.edu, berto@igalia.com,
 adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
 <20261011170958.1759230-11-libaokun@linux.alibaba.com>
 <sashiko-outbox-167346@kernel.org>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-167346@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Added David, Chris and the btrfs list.


On 2026/10/12 01:24, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] btrfs: infinite loop and double submission in btrfs_submit_bbio() due to unhandled negative error from bio_split_rw_at()
> --
>
> [Severity: Critical]
> Since bio_split_io_at() (and functions wrapping it like bio_split_rw_at())
> returns negative error codes such as -EINVAL, can this lead to an infinite
> loop in btrfs callers?
>
> In fs/btrfs/bio.c:btrfs_append_map_length(), the return value is not
> checked for negative error codes:
>
> 	sector_offset = bio_split_rw_at(&bbio->bio, &fs_info->limits,
> 					&nr_segs, map_length);
> 	if (sector_offset) {
> 		/* ... */
> 		return ALIGN_DOWN(sector_offset << SECTOR_SHIFT,
> 				  fs_info->sectorsize);
> 	}
>
> If bio_split_rw_at() returns a negative error code (such as -EINVAL or
> -EAGAIN), ALIGN_DOWN() will operate on a negative value and return a massive
> u64.
>
> This huge value is then returned as map_length to btrfs_submit_chunk(),
> where it causes the bio split to be skipped since map_length < length is
> false.
>
> Because btrfs_submit_chunk() returns false, it causes its caller
> btrfs_submit_bbio() to enter an infinite loop:
>
> 	while (!btrfs_submit_chunk(bbio, mirror_num))
> 		;
>
> Do the btrfs callers need to be updated to handle these negative return
> values, or does this patch change the conditions under which
> bio_split_io_at() returns an error for encrypted bios?
>

This patch doesn't change when bio_split_io_at() returns an error.
For bios without a crypto context start_align_mask was already
lim->dma_alignment, and the data unit masks were only added inside
the "if (bc)" branch, so the bvec checks are byte-for-byte identical
before and after this patch.

For encrypted bios the patch only drops the data unit alignment
requirement, so it can make -EINVAL less likely, never more.

The missing negative check in btrfs_append_map_length() is thus a
pre-existing btrfs issue.  It came with fec2e705729d ("block: check
for valid bio while splitting"), which added the -EINVAL returns but
didn't update the btrfs caller, and it is only reachable on the
zoned append path.

The fix should check for a negative return and fail the bio, as
bio_submit_split() does.


Regards,
Baokun


