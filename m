Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6014657CD
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 08:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790930752; cv=none; b=M45AXkV55mFviRYXMc0G55zgMHUUyBlee8jYe9n8qsxGz3BFat2j2gOHaqmVDgdQ8tICbjzMAvFSkq9+/vfNcTZF80xvkqyatmUK/zH8pQ5oC09GkgRTdoV1RW1ZJcun63m0BSFpfSMPYYQ32O0UKn9xSrNzv1GneFwQBii00pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790930752; c=relaxed/simple;
	bh=jE9ezcwKXtCQ1hZPBLXApyXgjedkwyCbm9yYdRXAE0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a3ymGrgAXIOFU1/oH0Qpe1lb0iwNru8T3rYmxJG4fX+jg0H8TbJA+YEoTVT54PVqvNQA0dPBqg8mLAQfyjM8/DwqbeVLsPwDXz4lO/U4O/m2tpgFKkr7Yg5ZhgrxQ18xWRv/PiCUL2dxabs4HYenjDQpYjPBkcSNY9M1K9gkEE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NCNxirR2; arc=none smtp.client-ip=95.215.58.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NCNxirR2"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jE9ezcwKXtCQ1hZPBLXApyXgjedkwyCbm9yYdRXAE0g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790930745; v=1; x=1791535545;
 b=NCNxirR212WqSG+NveoyTcErImkioUCSuMHqedX6LnjtFgPeYLDd4Sz01Fwn2f78vyqDF0XX
 hOn1069lWtXLRZESq7ysHmXB+f22Bufg+yHzNth6uwgjdHhx1P7ZQVCNulBFDOecBTQCU+spphk
 lt65ufgvt5rwSUqvRWOoScGE=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id ba72d39f898bc55e;
	Fri, 02 Oct 2026 08:45:45 +0000
X-Mizu-Trace-ID: ba72d39f898bc55e
X-Migadu-Flow: FLOW_OUT
Message-ID: <ecdac500-12ea-4a27-a8ef-b85fbfaef469@linux.dev>
Date: Fri, 2 Oct 2026 09:45:39 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
To: Pankaj Raghav <pankaj.raghav@linux.dev>,
 "Darrick J . Wong" <djwong@kernel.org>
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
 <9723ca61-faed-412e-bef4-e6841393b8a8@linux.dev>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <9723ca61-faed-412e-bef4-e6841393b8a8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/26 17:30, Pankaj Raghav wrote:
>>
>> ----->8-----
>>
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -694,7 +694,7 @@ xfs_calc_group_awu_max(
>>
>>          if (g->blocks == 0)
>>                  return 0;
>> -       if (btp && btp->bt_awu_min > 0)
>> +       if (btp && btp->bt_awu_max > mp->m_sb.sb_blocksize)
>>                  return max_pow_of_two_factor(g->blocks);
>>          return rounddown_pow_of_two(g->blocks);
>> }
>>
>> -----8<-----
>>
>>
>> You are advocating something like this (to solve the issue below), right?
>>
> 
> Hmm, this might fix the issue but I still don't understand why we have 
> hardware atomics check while determining SW atomics limit. Am I missing 
> something?

ok, I suppose that it (i.e. whether bt_awu_max > sb_blocksize) should 
not determine CoW-based atomics limits, but it should determine HW 
limits (in opt max).

> 
>> note: that we still need to ensure that bt_awu_min <= sb_blocksize to 
>> get HW atomics at all (so should keep a check for bt_awu_min in 
>> xfs_calc_group_awu_max() or similar) 

