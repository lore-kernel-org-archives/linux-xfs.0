Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA9F3612F1
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 07:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791270397; cv=none; b=OYTKuVWJ2Z0P8ynbdUUE+8pg+lFWcP9jaVLCQJUteZUoPXrU6A0Rza66392DDHzukmG342Y3kcYDI3oIwY+BcSlXZeXvKeFYnMGPqohhKk1ZQ/E9mkoHqPLHU0+Yqfsitr1o3RtTpUFbJe24IQfmxaSAElBb5aS2CMuoRg2b0Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791270397; c=relaxed/simple;
	bh=H35pPDVM8dak/wygsek+wfCl091PWWl4eQYh/SVmYRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YemPG0DEuXO9Y+FJY9dJIyIVbUmiKz5N24BNaGPr5oqRtarYHCp/mqiwdLQUSnIpDLTKe4hHuoggMNNsyJf8kZw4WEAC5/EmqF/xl30QawYJAuhJoj45bq7nWJe7hvI6luJU7ETAcLdTJuQ7M4Rd4Xb79BjvEpv9xv2jaD2N6Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iqsN7XvU; arc=none smtp.client-ip=91.218.175.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iqsN7XvU"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H35pPDVM8dak/wygsek+wfCl091PWWl4eQYh/SVmYRE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791270392; v=1; x=1791875192;
 b=iqsN7XvUoaao9BfXaAJ5+cK3VsRsa/WQoIvPtIyVvOlWCga3KF6lIy+eb5+ergPanUQZeWY/
 XVMiayb7ogULGP2tTt3X2ZS3zRrnjzRp4X5TdDmR9M5+NY3fpMiPOt+Snll0ofENeixP676s9mn
 /xvuokjvZjIGLAO6HzFht5dU=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id e358d5ed63516766;
	Tue, 06 Oct 2026 07:06:32 +0000
X-Mizu-Trace-ID: e358d5ed63516766
X-Migadu-Flow: FLOW_OUT
Message-ID: <ad7d42d3-114e-4506-89c3-9d60d1bdf659@linux.dev>
Date: Tue, 6 Oct 2026 08:06:31 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 gost.dev@samsung.com
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <8d9babb0-5d36-427d-b4a2-5a3e9664a796@linux.dev> <asOpaPuHF072GJwt@quentin>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <asOpaPuHF072GJwt@quentin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 17:24, Pankaj Raghav (Samsung) wrote:
>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>> index d1306e723899..8c8b14f94ede 100644
>>> --- a/fs/xfs/xfs_iops.c
>>> +++ b/fs/xfs/xfs_iops.c
>>> @@ -620,6 +620,12 @@ xfs_get_atomic_write_min(
>>>    	return 0;
>>>    }
>>> +static inline enum xfs_group_type
>>> +xfs_inode_group_type(struct xfs_inode *ip)
>>> +{
>>> +	return XFS_IS_REALTIME_INODE(ip) ? XG_TYPE_RTG : XG_TYPE_AG;
>>> +}
>>
>> would this be better is a common location (so that it could be reused)?
>>
> 
> Probably to xfs_mount.h?
> 

I'm not sure. Darrick may be able to give a good suggestion.

>>> +
>>>    unsigned int
>>>    xfs_get_atomic_write_max(
>>>    	struct xfs_inode	*ip)
>>> @@ -642,19 +648,20 @@ xfs_get_atomic_write_max(
>>>    	 * then advertise a maximum size of whatever we can complete through
>>>    	 * that means.  Hardware support is reported via max_opt, not here.
>>>    	 */
>>> -	if (XFS_IS_REALTIME_INODE(ip))
>>> -		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
>>> -	return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
>>> +	return XFS_FSB_TO_B(mp, mp->m_groups[xfs_inode_group_type(ip)].awu_max);
>>>    }
>>>    unsigned int
>>>    xfs_get_atomic_write_max_opt(
>>>    	struct xfs_inode	*ip)
>>>    {
>>> +	struct xfs_mount	*mp = ip->i_mount;
>>>    	unsigned int		awu_max = xfs_get_atomic_write_max(ip);
>>
>> xfs_get_atomic_write_max() value is calculated based on HW atomic support. I
>> am wondering if we should add a function to just give the max CoW-based
>> atomic, and have it called here and from xfs_get_atomic_write_max(). Not a
>> big deal, though.
> 
> Could you elaborate this comment?
> 
> I do remove any HW dependency in xfs_get_atomic_write_max() calculation
> as a part of this patch.

xfs_get_atomic_write_max() does still have a 
xfs_inode_can_hw_atomic_write() call.

It just seems a bit awkward that xfs_get_atomic_write_max_opt() calls 
xfs_get_atomic_write_max(), when it should be able to do the full 
calculation itself.

This is not a deal deal which I am mentioning.

> 
>>
>>> +	xfs_extlen_t		align_max_fsb;
>>> +	unsigned int		opt;
>>>    	/* if the max is 1x block, then just keep behaviour that opt is 0 */
>>> -	if (awu_max <= ip->i_mount->m_sb.sb_blocksize)
>>> +	if (awu_max <= mp->m_sb.sb_blocksize)
>>>    		return 0;
>>>    	/*
>>> @@ -663,7 +670,17 @@ xfs_get_atomic_write_max_opt(
>>>    	 * less than our out of place write limit, but we don't want to exceed
>>>    	 * the awu_max.
>>>    	 */
>>> -	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
>>> +	opt = min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
>>> +
>>> +	/*
>>> +	 * REQ_ATOMIC writes also have to be naturally aligned on disk, so we
>>> +	 * cannot promise more than the largest extent that the allocator is
>>> +	 * able to align within a group.
>>> +	 */
>>> +	align_max_fsb = xfs_calc_group_awu_align_max(mp,
>>> +						xfs_inode_group_type(ip));
>>> +
>>> +	return min_t(xfs_fsize_t, opt, XFS_FSB_TO_B(mp, align_max_fsb));
>>
>> unsigned int? But is there a possibility that the value in XFS_FSB_TO_B(mp,
>> align_max_fsb) can exceed an unsigned int?
> 
> We are limited by `opt` length which is an unsigned int. I do use
> min_t(xfs_fsize_t, ..) for calculation to avoid any truncation error.
> 

ok, fine

BTW, maybe call the variable max_opt, and not just opt.

