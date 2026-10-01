Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1748F466B01
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 16:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872258; cv=none; b=YMB5zKfNxXRkc/hjIsnT4tIPdsyj0IFQUflb4ZIWzYBkd2ikpsPO1UtIWBkPhW83liwB1Vdg41NPgDntZg2TFQV889R/lf4Er/D0S2CjMkx/Cy4eui9jmscA8YaTzvpmt/42nDVotphYqPhpbWr2EQl/bGFSPymIgND1ftrnyMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872258; c=relaxed/simple;
	bh=EiAP0sI6i61OUgTbiiVKdgPwrsDl0Dkp9qow22KLPfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXIt2+dWX6OE1PnyqYVXF2faINscKb3L8XPFOv8Yc9kJ0r54c+vOcuMAVnbr1GXTNv4VlgKNHHioWWOV4EDIlPJbeTJAOvRxx2cq3zDOm9aNO1qhIpn9/0cZ6Ot2TFJVdFDME6LvO85UCl1ygVnEJZmI5mLVVLPhEG0UCZ/4uMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qpZSJu7r; arc=none smtp.client-ip=91.218.175.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qpZSJu7r"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EiAP0sI6i61OUgTbiiVKdgPwrsDl0Dkp9qow22KLPfw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790872253; v=1; x=1791477053;
 b=qpZSJu7revSDu/8eEQN6nGMkkhjh+UbgCKuAqNK5Twflar1cfCc4J2XDVqq2D4K1Uv2e5jnp
 x81+4j3QggTLr2F5bq98u3hFeimaMt4PGf75wphg/9hjm5Q8TjBs/Abe4ZooOVqm5WPU0FXDSLO
 b1/KTz3JGP5S6ERDu/5kih78=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 964a809f92cbc2f8;
	Thu, 01 Oct 2026 16:30:28 +0000
X-Mizu-Trace-ID: 964a809f92cbc2f8
X-Migadu-Flow: FLOW_OUT
Message-ID: <9723ca61-faed-412e-bef4-e6841393b8a8@linux.dev>
Date: Thu, 1 Oct 2026 18:30:26 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
To: John Garry <john.garry@linux.dev>, "Darrick J . Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 gost.dev@samsung.com
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
 <050f7a77-9c0e-4cab-8ddb-6932b885e12f@linux.dev>
 <jwtdhhbo7ukt5cynhdfrxu3xjwyk3wwg66uxhtnkokvabbokge@b6b4pk3yja24>
 <29380cd8-19f5-4ae7-bdb7-b7908decb474@linux.dev>
 <e96b6411-3392-480e-8cef-bdc94b8041e7@linux.dev>
 <3e6c32cc-64cd-4460-a587-b3bc04d31d9f@linux.dev>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <3e6c32cc-64cd-4460-a587-b3bc04d31d9f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/30/2026 2:48 PM, John Garry wrote:
> On 9/30/26 13:27, Pankaj Raghav wrote:
>>>
>>> Maybe in this case we don't need to restrict CoW-based atomics to 1 fsblock. 
>>> But why care? I mean, you have HW support, which is so much better to use 
>>> than CoW- based atomics, so better to config your FS to avail of them.
>>
>> That is true but it is a bit strange we expose a smaller CoW based atomics 
>> when we have HW based atomic support.
>>
>> For me the main issue is this function:
>> static xfs_extlen_t
>> xfs_calc_group_awu_max(
>>      struct xfs_mount    *mp,
>>      enum xfs_group_type    type)
>> {
>>      struct xfs_groups    *g = &mp->m_groups[type];
>>      struct xfs_buftarg    *btp = xfs_group_type_buftarg(mp, type);
>>
>>      if (g->blocks == 0)
>>          return 0;
>>      if (btp && btp->bt_awu_min > 0)
>>          return max_pow_of_two_factor(g->blocks);
>>      return rounddown_pow_of_two(g->blocks);
>> }
> 
> 
> ----->8-----
> 
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -694,7 +694,7 @@ xfs_calc_group_awu_max(
> 
>          if (g->blocks == 0)
>                  return 0;
> -       if (btp && btp->bt_awu_min > 0)
> +       if (btp && btp->bt_awu_max > mp->m_sb.sb_blocksize)
>                  return max_pow_of_two_factor(g->blocks);
>          return rounddown_pow_of_two(g->blocks);
> }
> 
> -----8<-----
> 
> 
> You are advocating something like this (to solve the issue below), right?
> 

Hmm, this might fix the issue but I still don't understand why we have hardware 
atomics check while determining SW atomics limit. Am I missing something?

> note: that we still need to ensure that bt_awu_min <= sb_blocksize to get HW 
> atomics at all (so should keep a check for bt_awu_min in 
> xfs_calc_group_awu_max() or similar)
> 
>>
--
Pankaj
