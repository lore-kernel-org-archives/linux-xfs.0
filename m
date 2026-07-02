Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946B35F610
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 10:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988668; cv=none; b=BMXIgH4ZNkT6mdMnhghGSP5Ev/rmDuSRmGhx7kzA7sBH6+AfX0hk+WpA4HH/ISmiA7wCeqgnkJPrI0KZB78A62aIRbIoRdS4+sLX7aeCqzjkOL84SnQdOMwnitiIdxYWoE7bPGwnsOuj8710QJ2bF28FaXpFtlu9KivUPuilJoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988668; c=relaxed/simple;
	bh=yzZFN+fdSbN4xfBvyVcnL7hmKtjudN9hONIFfEAXnvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hwo+svgQZwTWwo/4+6ncOwXm0ycj4u8QwT+FujV/Jn7aC8VcRF/mWoPAwawZeWhiTEKvoQMAgzns/53V2AxC7HBxOdQRCtpcrZZw/vV+wroY8vqxOIK8wVa9h8MN2XMDjd37krZPHkx+s6zcXBcL3/A5ngZxEf7PVIQ8s3GF5jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BDhIYf1j; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BDhIYf1j"
Message-ID: <75dd0085-e847-47de-aa67-a4f714d3d417@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782988661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iA91pMYB0u4d9WdiM9KcyXVOGL1xKMAEVO3IEVGe3Vs=;
	b=BDhIYf1jiv4UR8OJxa1gtWr5dCjQfRJY0n/0wBGNg9OYgR/l/YhqDjPKU5MhAJq/FyH90O
	gfCQ9wVXLVNEDPcSmvXYo3LqXjZGFqymwNTlBA+chKWBiep26MesVqi2s3aa+zrzQOjwNF
	xgJr44vxN+Zod6v5tzzmngXTMTDKjgc=
Date: Thu, 2 Jul 2026 12:37:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
 dgc@kernel.org, gost.dev@samsung.com, Zhang Yi <yi.zhang@huaweicloud.com>,
 andres@anarazel.de, kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
 hch@infradead.org, Pankaj Raghav <p.raghav@samsung.com>
References: <20260625114550.4109104-1-p.raghav@samsung.com>
 <20260625114550.4109104-3-p.raghav@samsung.com>
 <20260625172006.GC6078@frogsfrogsfrogs>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260625172006.GC6078@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


>> +	/*
>> +	 * Allocate written, zeroed extents across the range.  xfs_alloc_file_space()
>> +	 * rounds outward to block granularity:
>> +	 *  - holes (the punched interior and any unallocated edge block) are
>> +	 *    allocated and zeroed;
>> +	 *  - unwritten extents (including unwritten edge blocks) are converted to
>> +	 *    written and zeroed;
>> +	 *  - Already written edge blocks are skipped. The out-of-range bytes of
>> +	 *    a written edge block keep their data (offset_rd -> offset and
>> +	 *    end -> end_rd); their in-range bytes (offset -> offset_ru and
>> +	 *    end_ru -> end were already zeroed by xfs_free_file_space().
>> +	 */
>> +	return xfs_alloc_file_space(ip, offset, len,
>> +			XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
> 
> ...and now we can just do an accelerated "write zeroes to disk" which is
> conveniently always within EOF now.  I /think/ this looks ok to me now,
> though I'm curious how extensively the new fallocate mode has been
> tested with fsx and unaligned file ranges?  And rt volumes with rt
> extent size > 1 fsblock.
> 

I am running into an issue with rtvol.

Ran generic/363 (fsx) on rt, rextsize=2 (4k block / 8k rt extent). First I ran into this:

xfs_bmap_rtalloc: ASSERT(xfs_extlen_to_rtxmod == 0). WRITE_ZEROES uses
XFS_BMAPI_CONVERT, and xfs_bmap_extsize_align() bails early on convert, so the
rt-unaligned range becomes a sub-rt-extent allocation. I fixed it by rounding the alloc range
out to whole rt extents, like xfs_free_file_space() does for rt extents.

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 855602cb35e8..e52ad4c25b66 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -710,6 +710,13 @@ xfs_alloc_file_space(
        imapp = &imaps[0];
        startoffset_fsb = XFS_B_TO_FSBT(mp, offset);
        endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
+
+       if (mode == XFS_ALLOC_FILE_SPACE_WRITE_ZEROES &&
+           xfs_inode_has_bigrtalloc(ip)) {
+               startoffset_fsb = xfs_fileoff_rounddown_rtx(mp, startoffset_fsb);
+               endoffset_fsb = xfs_fileoff_roundup_rtx(mp, endoffset_fsb);
+       }
+
        allocatesize_fsb = endoffset_fsb - startoffset_fsb;

        /*

With that "fixed", I ran into WARN_ON_ONCE(folio_pos > i_size) in iomap_zero_iter,
via xfs_falloc_setsize -> xfs_setattr_size -> xfs_zero_range. The
rt-aligned alloc now leaves written zeroed blocks past a non-rt-aligned
EOF. So WRITE_ZEROES on rtvol breaks "no written blocks past EOF".

I am not sure what would be the most clean way of solving this issue for rtvol.

Let me know your thoughts!

@Zhang yi: did you test this on bigalloc configurations? Maybe you run into a similar problem
when cluster size (extsize for XFS) > block size?

--
Pankaj
