Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2821643B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 10:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138064; cv=none; b=htHndk2lSEqDxnfeCMH/elP8xA4/6oyouvkqnSJEKkaid9ElXgiTqfRNaWTTPRZfzGB01eACld70rkLPKYw3cPZ1NnwGd4bq3r5ecojC/fgmeX8svJb2QLkhe7W/sfB/31KjWper5Drw+a7oy8gxzd+rENZXLJ1/Xuopl1a/87w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138064; c=relaxed/simple;
	bh=aBAVFuL9gL8tg5TUH31RDOaYmasJ4f4HRgirCiTcVno=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=RPHixH8YAs9228rF3s30PCL8s4CGkkhu2qHy3Iwy0Rm3B6/8nZlzIm9NgMJ6NQJVx1JyafrlWFY5V2EaWt6TIgkuFhYr2NMfOlvFVdUBj4nSyPl5ngSyCLB21UuH/gZXiu/vXmju+sOTfkyBG3u61qenyTWyq2EIOjzq5ZKwAtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id CFCCE180F14A;
	Tue, 10 Mar 2026 11:20:54 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id 05ADMobwr2neth4AKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 10 Mar 2026 11:20:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 10 Mar 2026 11:20:54 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
 p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
In-Reply-To: <20260310004400.GU6033@frogsfrogsfrogs>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <20260310004400.GU6033@frogsfrogsfrogs>
Message-ID: <274965b98fee964be0cdcf4503d394b3@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-03-10 01:44, Darrick J. Wong wrote:
> On Mon, Mar 09, 2026 at 07:12:36PM +0100, Lukas Herbolt wrote:
>> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device
>> enable the unmap write zeroes operation.
>> 
>> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> 
>> ---
>>  v11 changes:
>> 	- split into 2 patches separating the bmapi_flags addition
>> 	- 2 step allocation, to avoid zeroing beyond EOF
>> 
>>  fs/xfs/xfs_file.c | 41 +++++++++++++++++++++++++++++------------
>>  1 file changed, 29 insertions(+), 12 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index fd049a1fc9c6..f8c1611e3267 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1293,29 +1293,45 @@ xfs_falloc_zero_range(
>>  	unsigned int		blksize = i_blocksize(inode);
>>  	loff_t			new_size = 0;
>>  	int			error;
>> +	bool                    need_convert = false;
>> 
>>  	trace_xfs_zero_file_space(ip);
>> 
>> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
>> +		if (xfs_is_always_cow_inode(ip) ||
>> +		    !bdev_write_zeroes_unmap_sectors(
>> +			    xfs_inode_buftarg(ip)->bt_bdev))
>> +			return -EOPNOTSUPP;
>> +		need_convert = true;
>> +	}
>> +
>>  	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
>>  	if (error)
>>  		return error;
>> 
>>  	if (xfs_falloc_force_zero(ip, ac)) {
>>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
>> -	} else {
>> -		error = xfs_free_file_space(ip, offset, len, ac);
>> -		if (error)
>> -			return error;
>> -
>> -		len = round_up(offset + len, blksize) -
>> -			round_down(offset, blksize);
>> -		offset = round_down(offset, blksize);
>> -		error = xfs_alloc_file_space(ip, offset, len,
>> -				XFS_BMAPI_PREALLOC);
>> +		goto set_filesize;
>>  	}
>> +	error = xfs_free_file_space(ip, offset, len, ac);
>>  	if (error)
>>  		return error;
>> -	return xfs_falloc_setsize(file, new_size);
>> +
>> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
>> +	offset = round_down(offset, blksize);
>> +	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
>> +
>> +set_filesize:
>> +	if (error)
>> +		return error;
>> +
>> +	error = xfs_falloc_setsize(file, new_size);
>> +	if (error)
>> +		return error;
>> +	if (need_convert)
>> +		error = xfs_alloc_file_space(ip, offset, len,
>> +				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
>> +	return error;
>>  }
> 
> I can't help but think this would be cleaner as:
> 
> static int
> xfs_falloc_write_zero_range(
> 	struct file		*file,
> 	int			mode,
> 	loff_t			offset,
> 	loff_t			len,
> 	struct xfs_zone_alloc_ctx *ac)
> {
> 	struct inode		*inode = file_inode(file);
> 	struct xfs_inode	*ip = XFS_I(inode);
> 	unsigned int		blksize = i_blocksize(inode);
> 	loff_t			new_size = 0;
> 	int			error;
> 
> 	trace_xfs_zero_file_space(ip);
> 
> 	if (xfs_is_always_cow_inode(ip) ||
> 	    !bdev_write_zeroes_unmap_sectors(
> 				xfs_inode_buftarg(ip)->bt_bdev))
> 		return -EOPNOTSUPP;
> 
> 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> 	if (error)
> 		return error;
> 
> 	if (xfs_falloc_force_zero(ip, ac)) {
> 		error = xfs_zero_range(ip, offset, len, ac, NULL);
> 		if (error)
> 			return error;
> 
> 		return xfs_falloc_setsize(file, new_size);
> 	}
> 
> 	error = xfs_free_file_space(ip, offset, len, ac);
> 	if (error)
> 		return error;
> 
> 	len = round_up(offset + len, blksize) -
> 		round_down(offset, blksize);
> 	offset = round_down(offset, blksize);
> 	error = xfs_alloc_file_space(ip, offset, len);
> 	if (error)
> 		return error;
> 
> 	error = xfs_falloc_setsize(file, new_size);
> 	if (error)
> 		return error;
> 
> 	return xfs_alloc_file_space(ip, offset, len,
> 			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> }
I didn't want to duplicate most of the xfs_falloc_zero_range, but if 
that's
fine we can go this way.

> ...assuming there's even a point to WRITE_ZEROES on a zoned file?
I think this is covered in:

if (xfs_is_always_cow_inode(ip) ||
     !bdev_write_zeroes_unmap_sectors(
		xfs_inode_buftarg(ip)->bt_bdev))
	return -EOPNOTSUPP;


-- 
-lhe
