Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11EA472F8A
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 11:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790940304; cv=none; b=sGaF7mJ2jKQ5KltITT3/yHeWBPch4DW3xaaUHcxqsfgNMdMa2T7/Ud52hXxH/s6otPZuKSmThzIYtDJr453RARHlsSZykdy8iSaJ/8CnmZ6zabqQU1tw9ZGqllRTzkvh00XxrHjusbU4YGE4pHy3nRIp2MTVBWE734Q5q6vMpdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790940304; c=relaxed/simple;
	bh=GZWQhbuT6QP+0cEQ0hh34H7ZgJtczjiEcd6MpxA5l6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nw79ZU3MRwNjJxzOJlcyHJ03zRAvknBzpyMjsPNqVF/sXWqkLJ9jYt55sCvsUfKAcEcohu3AfCEYv/xwyL0jxYM+ZH2Xg37TBlIbjagG+uMFGNp+Z7OkQsJrDZX0J5Wt4lN9RK9VnJZQQhZfL/k7wuIHew7jNw7zKF/hPMjUdIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fA6rF4gy; arc=none smtp.client-ip=95.215.58.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fA6rF4gy"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GZWQhbuT6QP+0cEQ0hh34H7ZgJtczjiEcd6MpxA5l6Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790940299; v=1; x=1791545099;
 b=fA6rF4gySbv8vvj5DUh5PdGL8SGP/pPrBq3TYiOv+SoJNdpxWFXvlDAfufo1nRTT+QLMssfy
 eK4kByu0IZS3C3rBOXZU3ZMD+eaSeboB4U4P4XeBmcoGAQta/ina6XOQLYb53A43kia98DcV8fa
 hFKj8AvY7bTxJBRXrUWei6Us=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 702e018ff385379b;
	Fri, 02 Oct 2026 11:24:59 +0000
X-Mizu-Trace-ID: 702e018ff385379b
X-Migadu-Flow: FLOW_OUT
Message-ID: <750c7d6d-c4f2-47ed-8f09-5a35236a3458@linux.dev>
Date: Fri, 2 Oct 2026 13:24:57 +0200
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
 <9723ca61-faed-412e-bef4-e6841393b8a8@linux.dev>
 <ecdac500-12ea-4a27-a8ef-b85fbfaef469@linux.dev>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <ecdac500-12ea-4a27-a8ef-b85fbfaef469@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/2/2026 10:45 AM, John Garry wrote:
> On 10/1/26 17:30, Pankaj Raghav wrote:
>>>
>>> ----->8-----
>>>
>>> --- a/fs/xfs/xfs_mount.c
>>> +++ b/fs/xfs/xfs_mount.c
>>> @@ -694,7 +694,7 @@ xfs_calc_group_awu_max(
>>>
>>>          if (g->blocks == 0)
>>>                  return 0;
>>> -       if (btp && btp->bt_awu_min > 0)
>>> +       if (btp && btp->bt_awu_max > mp->m_sb.sb_blocksize)
>>>                  return max_pow_of_two_factor(g->blocks);
>>>          return rounddown_pow_of_two(g->blocks);
>>> }
>>>
>>> -----8<-----
>>>
>>>
>>> You are advocating something like this (to solve the issue below), right?
>>>
>>
>> Hmm, this might fix the issue but I still don't understand why we have 
>> hardware atomics check while determining SW atomics limit. Am I missing 
>> something?
> 
> ok, I suppose that it (i.e. whether bt_awu_max > sb_blocksize) should not 
> determine CoW-based atomics limits, but it should determine HW limits (in opt max).
> 

Could you take a look the patches again and see if it makes sense? We already 
take into account the HW limits while calculating opt. So the new function 
xfs_calc_group_awu_align_max() checks for alignment constraints because of agsize.

Without patches:
[nix-shell:~]# trace-cmd report
cpus=16
mount-617   [009]  1184.719159: xfs_calc_atomic_write_unit_max: dev 259:2 ag 
max_write 131072 max_ioend 4096 max_gsize 2 awu_max 2


[nix-shell:~]# ./statx /media/test/hello.txt
/media/test/hello.txt:
   stx_atomic_write_unit_min:            16384
   stx_atomic_write_unit_max:            32768
   stx_atomic_write_unit_max_opt:        16384
   stx_atomic_write_segments_max:        1

With patches:

[nix-shell:~]# trace-cmd report
cpus=16
mount-598   [005]   319.692000: xfs_calc_atomic_write_unit_max: dev 259:2 ag 
max_write 131072 max_ioend 4096 max_gsize 33554432 awu_max 4096

[nix-shell:~]# ./statx /media/test/hello.txt
/media/test/hello.txt:
   stx_atomic_write_unit_min:            16384
   stx_atomic_write_unit_max:            67108864
   stx_atomic_write_unit_max_opt:        16384
   stx_atomic_write_segments_max:        1
>>
>>> note: that we still need to ensure that bt_awu_min <= sb_blocksize to get HW 
>>> atomics at all (so should keep a check for bt_awu_min in 
>>> xfs_calc_group_awu_max() or similar) 
> 

