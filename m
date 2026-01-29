Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A152BEC5E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 07:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769672833; cv=none; b=hovdjNprCuqd8qD/9TMb6EH0l0oN53CeBL+9pMoa/GrK3Sp68BqD0D25jmiyM0YqWv6r0owfcn1Gr9pltKEzTR36dSM3OsQ39HAjZqin1Tw54FAVwVUEldcn6kc/LEVPhTeoa6fxWn4ulHR3lwxHNM22Z/cgLQp8ZghPwFkmTw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769672833; c=relaxed/simple;
	bh=znNEZFl+QCGMWR25GIxtO4LyCqFGhNPIZwuOn+AO3wM=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=fgPA0NJ+T72hFAfF8ANSUVH/dlS1BQ1UJbjDMiZexDUcunOzwuhzI8AWzlv5tonMXSZZTNr8Eyp5g13ZnzBPytg61RFTPlIE7ow/AqSVeJVeZnJ968a+h4Ia/jjM3iRFOdBD7AfnDEddDk7N8khSyZDcuLXSxNGGR1kbv5SFCPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 9281D180F2C3;
	Thu, 29 Jan 2026 08:39:48 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id wFHhHsQOe2k0KxgAKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 29 Jan 2026 08:39:48 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Jan 2026 08:39:48 +0100
From: lukas@herbolt.com
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v7] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
In-Reply-To: <20260121065645.GA11349@lst.de>
References: <20260120132056.534646-2-cem@kernel.org>
 <20260121065645.GA11349@lst.de>
Message-ID: <b08c37b0aa6afe8c8096d01ba095a920@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-01-21 07:56, Christoph Hellwig wrote:
> On Tue, Jan 20, 2026 at 02:20:50PM +0100, cem@kernel.org wrote:
>> From: Lukas Herbolt <lukas@herbolt.com>
>> 
>> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
>> the unmap write zeroes operation.
>> 
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> [cem: rewrite xfs_falloc_zero_range() bits]
> 
> Nit: once you modify something substantially and add your marker
> you also need to sign off on it.
> 
>> ---
>> 
>> Christoph, Darrick, could you please review/ack this patch again? I
>> needed to rewrite the xfs_falloc_zero_range() bits, because it
>> conflicted with 66d78a11479c and 8dc15b7a6e59. This version aims 
>> mostly
>> to remove one of the if-else nested levels to keep it a bit cleaner.
> 
> Maybe mention the "merge conflict" in the above note?
> 
>> index d36a9aafa8ab..b23f1373116e 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1302,16 +1302,29 @@ xfs_falloc_zero_range(
>> 
>>  	if (xfs_falloc_force_zero(ip, ac)) {
>>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
>> +		goto out;
>> +	}
>> 
>> +	error = xfs_free_file_space(ip, offset, len, ac);
>> +	if (error)
>> +		return error;
>> +
>> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
>> +	offset = round_down(offset, blksize);
>> +
>> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
>> +		if (xfs_is_always_cow_inode(ip) ||
>> +		    !bdev_write_zeroes_unmap_sectors(
>> +				xfs_inode_buftarg(ip)->bt_bdev))
>> +			return -EOPNOTSUPP;
>> +		error = xfs_alloc_file_space(ip, offset, len,
>> +					     XFS_BMAPI_ZERO);
> 
> Darrick made a good point that we should check the not supported cases
> earlier, even if that is an issue in the original version.  Also I 
> don't
> think we should hit the force zero case for FALLOC_FL_WRITE_ZEROES.
> I.e., this should probably become something like:
> 
> 	if (mode & FALLOC_FL_WRITE_ZEROES) {
> 		if (xfs_is_always_cow_inode(ip) ||
> 		    !bdev_write_zeroes_unmap_sectors(
> 				xfs_inode_buftarg(ip)->bt_bdev))
> 			return -EOPNOTSUPP;
> 		bmapi_flags = XFS_BMAPI_ZERO;
> 	} else {
> 	  	if (xfs_falloc_force_zero(ip, ac)) {
> 	  		error = xfs_zero_range(ip, offset, len, ac, NULL);
> 			goto set_filesize;
> 		}
> 		bmapi_flags = XFS_BMAPI_PREALLOC;
> 	}
> 
> 	< free file space, round, etc.. >
> 
> 	error = xfs_alloc_file_space(ip, offset, len, bmapi_flags);
ugh I missed this one, I will add the Darrick/Christoph earlier check
and rebase to more recent version.
