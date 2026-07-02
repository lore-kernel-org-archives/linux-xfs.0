Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5887030C608
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783021503; cv=none; b=sR4kSrOHn9y/K/vRzQC9EfrC0pGQbNXYTQhyhkTZUGzTnN4i5chCpanqShtsy4qEikDkPldDRGv76mfFpCeLAbac3/LzoJMJmy1mBUSFKWo2vxtwrrewrZ6/XZv7OBkqUd+X7VfLmXTobHdsG+tHXYGMb+xisRZ9K0pegrzk4yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783021503; c=relaxed/simple;
	bh=+ule5aRWH4S9kMA5WRda1NWMKLxW98JyPqTDZOdNASA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P+xqiv58PLlvgkg9PFeMzis+zeVUP3o/whfb2wawWa3pogi/VEo7skvNHZPJm+Bpj6HI74PNmnMZA4kDXBv8gEfrLjJNZzf5kkVSbKz9Wnd0zw6B8GHC3sVR6iUft7QIDVZJyAgnKNjRoSodi2NdA8iUaf0dN4af8Vwc95iSvJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cBQ62xVI; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cBQ62xVI"
Message-ID: <39a10f9a-351d-4ea7-9eb9-dae7d4d8a799@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783021497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1bZ+szqE2G75pbZtHLhRnqpixyaF5e0mR5sKWyGp+w=;
	b=cBQ62xVI1acAiDAx6+3/k/KFGlc+WPykU/CWBJ+Xk5PzHmFi5QafJvHK5txbJK7q5zRDLA
	MxYaCutbeu0FyUS3yzsd7w/cm5ayvmswksVLGLULAE3pUvBg3DaD/qenorNabEpEji25Pv
	2V6otM+RouJtUWjBTJqzKCg5trRIHPU=
Date: Thu, 2 Jul 2026 21:44:54 +0200
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
 <75dd0085-e847-47de-aa67-a4f714d3d417@linux.dev>
 <20260702160335.GG9392@frogsfrogsfrogs>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260702160335.GG9392@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 855602cb35e8..e52ad4c25b66 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -710,6 +710,13 @@ xfs_alloc_file_space(
>>         imapp = &imaps[0];
>>         startoffset_fsb = XFS_B_TO_FSBT(mp, offset);
>>         endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
>> +
>> +       if (mode == XFS_ALLOC_FILE_SPACE_WRITE_ZEROES &&
>> +           xfs_inode_has_bigrtalloc(ip)) {
>> +               startoffset_fsb = xfs_fileoff_rounddown_rtx(mp, startoffset_fsb);
>> +               endoffset_fsb = xfs_fileoff_roundup_rtx(mp, endoffset_fsb);
>> +       }
>> +
>>         allocatesize_fsb = endoffset_fsb - startoffset_fsb;
>>
>>         /*
>>
>> With that "fixed", I ran into WARN_ON_ONCE(folio_pos > i_size) in iomap_zero_iter,
>> via xfs_falloc_setsize -> xfs_setattr_size -> xfs_zero_range. The
>> rt-aligned alloc now leaves written zeroed blocks past a non-rt-aligned
>> EOF. So WRITE_ZEROES on rtvol breaks "no written blocks past EOF".
> 
> Ah, right, because you can't have a dirty folio totally beyond EOF.
> I think you have to leave the blocks beyond EOF unwritten, then.
> 

Yeah. I was thinking something along those lines. In the xfs_alloc_file_space,
do a written->unwritten conversion at the end for bigrtalloc configurations.

>> I am not sure what would be the most clean way of solving this issue for rtvol.
> 
> Or I guess you could EOPNOTSUPP :P
> 

I can honestly do this for now and add a TODO for bigrtalloc so that we can add
it later. At least we can get the base patches upstream for FALLOC_FL_WRITE_ZEROES.

I will also send the generic test I have added to test these boundary conditions, so that
when we do add bigrtalloc support, there is already a test for this edge case (even though
generic/363 also triggers this edge case almost all the time).

Let me know what you think.

--
Pankaj
