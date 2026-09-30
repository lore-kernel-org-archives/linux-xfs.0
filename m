Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB100438490
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 08:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790757764; cv=none; b=R3RkQcr1XcwvnNhnzTuDcalkljfroefX9DQUB4VlrRMbLt+2YYAeU4laQCMsGaeJAWd5qC15bAtu7NeKY/s+8+7zw2gSOVV2pv+maxVMhQe4RKcwCslHIJlW2PQe+t3a3vgNrmsmIgAIAdPV/j2ORgHt4ld3KX6OPkh2/FV62Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790757764; c=relaxed/simple;
	bh=i1uEsvgICh0DhCFYrmgloUbKJNENOBFuqjKtshnFzJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z8Q4okE583FCJBYbqCkNRW1J9D0awcCtIZt8frwktnUsHAhW0wZG3DexeWfUyYoxtS5BXH3gOU9oPLbXDCekrHOKv9LCCbgUljWNNc4FT9tNvqy1KTnvFp69lYYd3nlcJJaMd3AEhc2zNxMQ5YLP6ucPiDzh5ROJjhhMhIFjm5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OFx0gwwK; arc=none smtp.client-ip=91.218.175.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OFx0gwwK"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=i1uEsvgICh0DhCFYrmgloUbKJNENOBFuqjKtshnFzJE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790757759; v=1; x=1791362559;
 b=OFx0gwwKcjPyTLi5Ajr7FGIyko98bIFpQue6mXKWBOHsKJpXPmeFqnUjQn7W2LIX0HFO7GtT
 UVvtnKoJhyrIsV1QX69HG2Y0GAx5D9aq8wbBQt/DSY3ObtH/cvLnEAvM9Qc7XK3RqASV7jrzgC3
 s1LYj2zXXZ4W1Fn1qMli1TUo=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 4d978d09c79ff881;
	Wed, 30 Sep 2026 08:42:39 +0000
X-Mizu-Trace-ID: 4d978d09c79ff881
X-Migadu-Flow: FLOW_OUT
Message-ID: <29380cd8-19f5-4ae7-bdb7-b7908decb474@linux.dev>
Date: Wed, 30 Sep 2026 09:42:34 +0100
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
 linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
 <050f7a77-9c0e-4cab-8ddb-6932b885e12f@linux.dev>
 <jwtdhhbo7ukt5cynhdfrxu3xjwyk3wwg66uxhtnkokvabbokge@b6b4pk3yja24>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <jwtdhhbo7ukt5cynhdfrxu3xjwyk3wwg66uxhtnkokvabbokge@b6b4pk3yja24>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/30/26 06:10, Pankaj Raghav (Samsung) wrote:
>>> Just to give more context:
>>>
>>> Trace of calc_atomic_write_unit_max:
>>>
>>>    mount-696   [010]   449.230543: xfs_calc_atomic_write_unit_max: dev
>>> 259:0 ag max_write 262144 max_ioend 512 max_gsize 134217728 awu_max 512
>>>
>>> 2097152 comes from awumax being 512 fsblocks.
>>>
>>> root@debian:~# xfs_info /dev/nvme0n1
>>> meta-data=/dev/nvme0n1           isize=512    agcount=8,
>>> agsize=268435455 blks
>>
>> Well max power-of-2 factor of this is going to be 1.
>>
> 
> Exactly. I get that we should restrict max_opt to be 1 because the AG's
> will not be aligned and the best we can do is one fsblock for HW based
> atomics. Why should we restrict the max (SW atomics limit) to 1 fsblock?
> 

Maybe in this case we don't need to restrict CoW-based atomics to 1 
fsblock. But why care? I mean, you have HW support, which is so much 
better to use than CoW-based atomics, so better to config your FS to 
avail of them.
