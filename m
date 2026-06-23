Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D9B35DA7B
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2026 20:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246095; cv=none; b=WDjstWCxcPHoGXbcXDCxu0z+Pf/bcFEG4gAsVTkE4q8u5xQwVgbI2pR0cLiXbuaIuowYs/kHmhy+YHZCZ6NIwnBpyofQadK87CE4/obs9LJUpizNNWfl+bREZ2e5kfrkvWMIJsPCYmm/bIFzDldmf40m0EHam7vOVrEbFG/G3Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246095; c=relaxed/simple;
	bh=JpGGdsqWvkmeDDQLgM9NjTjq2IiwTP3ul4t7rprXIuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YGuoePM9PKE5SPRcQNF1bd1l0ioBPIocdVftKQQnuYyQcraR9y4JqgltMWiREUyslPwMpIHFT7RK95QABkwTAxc4dt16qe/D14UiTlNnXJ8dPdpCYMudu79Fs92qxPUfiEfoKa77auJMksL+fSudx0dFTWGPjvjFKef70fxsX4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VTIrtM5g; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VTIrtM5g"
Message-ID: <d69477d2-f520-4b5e-bc29-95a74726e504@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782246090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BuChqlikcJwdpLRGy0RsobDM+o2WyH2+jHfEG5kzhBc=;
	b=VTIrtM5gmNJjCECPB9MHeA9RGc3vhQvJt7PUxkt/Pdf4PxiwMHQoLggWkCNdbANY7Ceb2k
	C20TahUdRHetJ8a5kxMKTQhBTcQ3WovL0CQXwJuKe4awQ1pgn1mz4YsCqJVpu9wVeF5sXP
	fvm82z8+GrXqo2uk4x1Fe1Z+TdEz7sY=
Date: Tue, 23 Jun 2026 22:21:20 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
To: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 hch@infradead.org
Cc: bfoster@redhat.com, lukas@herbolt.com,
 "Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
 gost.dev@samsung.com, andres@anarazel.de, kundan.kumar@samsung.com,
 hch@lst.de, cem@kernel.org
References: <20260622083106.2914092-1-p.raghav@samsung.com>
 <20260622083106.2914092-3-p.raghav@samsung.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260622083106.2914092-3-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

> +static int
> +xfs_falloc_write_zeroes(
> +	struct file		*file,
> +	int			mode,
> +	loff_t			offset,
> +	loff_t			len,
> +	struct xfs_zone_alloc_ctx *ac)
> +{
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	loff_t			new_size = 0;
> +	unsigned int		blksize = i_blocksize(inode);
> +	xfs_off_t		offset_aligned = round_up(offset, blksize);
> +	xfs_off_t		end_aligned = round_down(offset + len, blksize);
> +	xfs_off_t		len_aligned = end_aligned - offset_aligned;
> +	int			error;
> +
> +	if (xfs_is_always_cow_inode(ip) ||
> +	    !bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
> +		return -EOPNOTSUPP;
> +
> +	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 *
> +	 *    |----------|----------|----------|----------|----------|
> +	 *    ^     ^    ^                     ^     ^    ^
> +	 *    |     |    |                     |     |    |
> +	 *    |   offset |                     |    end   |
> +	 *    |          |                     |          |
> +	 * offset_rd   offset_ru              end_rd    end_ru
> +	 *
> +	 * xfs_free_file_space() punches inside from offset_ru -> end_rd. It also
> +	 * zeroes offset -> offset_ru and end_rd -> end.
> +	 * Only pass offset_ru -> end_rd to be zeroed via xfs_alloc_file_space().
> +	 */
> +	error = xfs_free_file_space(ip, offset, len, ac);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Publish the new size while the punched range is still a hole, then
> +	 * fill it with written zeroes.  Like the other fallocate modes we use
> +	 * xfs_falloc_setsize(), but it must run *before* we convert the range
> +	 * to written extents: xfs_setattr_size() zeroes [old EOF, new size) via
> +	 * xfs_zero_range(), which skips holes, so there is nothing to re-zero.
> +	 * It will also writeback partial EOF block before the on-disk size is
> +	 * logged.
> +	 */
> +	error = xfs_falloc_setsize(file, new_size);
> +	if (error)
> +		return error;
> +
> +	if (len_aligned > 0)
> +		error = xfs_alloc_file_space(ip, offset_aligned, len_aligned,
> +				XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
> +
> +	return error;
> +}
> +

Sashiko was not happy with this approach as there are cases where there will not be a data
corruption but we might end up not allocating an extent, therefore, getting an -ENOSPC at a later point.

I went back what Zhang yi pointed out in the previous version wrt semantics[1]. I think the correct
idea should be the following:

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0e1332ccdf79..a27862037d22 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1379,10 +1379,6 @@ xfs_falloc_write_zeroes(
        struct inode            *inode = file_inode(file);
        struct xfs_inode        *ip = XFS_I(inode);
        loff_t                  new_size = 0;
-       unsigned int            blksize = i_blocksize(inode);
-       xfs_off_t               offset_aligned = round_up(offset, blksize);
-       xfs_off_t               end_aligned = round_down(offset + len, blksize);
-       xfs_off_t               len_aligned = end_aligned - offset_aligned;
        int                     error;

        if (xfs_is_always_cow_inode(ip) ||
@@ -1402,9 +1398,11 @@ xfs_falloc_write_zeroes(
         *    |          |                     |          |
         * offset_rd   offset_ru              end_rd    end_ru
         *
-        * xfs_free_file_space() punches inside from offset_ru -> end_rd. It also
-        * zeroes offset -> offset_ru and end_rd -> end.
-        * Only pass offset_ru -> end_rd to be zeroed via xfs_alloc_file_space().
+        * xfs_free_file_space() punches the aligned interior offset_ru -> end_rd
+        * to holes and byte-zeroes the in-range parts of the partial edge blocks,
+        * offset -> offset_ru and end_rd -> end.  xfs_zero_range() only touches
+        * already-written blocks here; it skips holes and unwritten extents, so
+        * unallocated/unwritten edge blocks are left for the allocation below.
         */
        error = xfs_free_file_space(ip, offset, len, ac);
        if (error)
@@ -1423,11 +1421,19 @@ xfs_falloc_write_zeroes(
        if (error)
                return error;

-       if (len_aligned > 0)
-               error = xfs_alloc_file_space(ip, offset_aligned, len_aligned,
-                               XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
-
-       return error;
+       /*
+        * Allocate written, zeroed extents across the range.  xfs_alloc_file_space()
+        * rounds outward to block granularity:
+        *  - holes (the punched interior and any unallocated edge block) are
+        *    allocated and zeroed;
+        *  - unwritten extents (including unwritten edge blocks) are converted to
+        *    written and zeroed;
+        *  - already-written blocks are skipped, so the out-of-range bytes of a
+        *    written edge block keep their data; their in-range bytes were already
+        *    zeroed by xfs_free_file_space() above.
+        */
+       return xfs_alloc_file_space(ip, offset, len,
+                       XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
 }

 /*

We pass offset and len without rounding to xfs_alloc_file_space, and the existing behaviour
correctly handles them. I could add test cases in xfstests to test out all these edge cases so that
we don't regress.

If I don't have anymore comments, I will send a v8 with this approach.

--
Pankaj

[1] https://lore.kernel.org/linux-xfs/557b2e5c-7c65-48de-87a9-6fba21eca99f@huaweicloud.com/
