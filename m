Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8DE4A4EED
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789483714; cv=none; b=fiBtThCpxNkmhm3ThohMHRnO7m54Id6/4ZohQ/EDEw/ZyWvvff7xaYAvVD0h+ojgsDQhGGGnmu82DnHZbvDzsBfgDZzFgyUoSA9Jb6ltrNa4rJwXklfo6d/iH9RVnviFvfJaVU+8JMIYnLz9NLg9Hwh4XBgtunQWQxHCqbGXQ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789483714; c=relaxed/simple;
	bh=58sNhp/bc3J/r6FUCPkydNTfvMea6X+K8puzGUs7pjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JVOvJ024JCVeRtNOngLrnnRUMlfr5ViYeqik7QwfX8XFPkDFPaiY20JNoKe64iN9ZPTizuvkyPhEWGgpAM33oC6cGwBVTaTy7L24Y7/JHodTP7NFuexZNt3OEjV8lpP0wt3lyeb7u5m/GKIcG6AsrWDc8s45trEI052ppIjudcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k3I5SbGN; arc=none smtp.client-ip=91.218.175.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k3I5SbGN"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=58sNhp/bc3J/r6FUCPkydNTfvMea6X+K8puzGUs7pjA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789483709; v=1; x=1790088509;
 b=k3I5SbGNuNj0dSMdjoRKUjTDgcp0/YLmlkPW1yZfvLLp0czORhWhFzRjuu0JkKF9YPOaUOGY
 TNTN+M6ErB1cK2lvNmYfpXIcx6nzFVrKrYeDIgvBkrmjD4coNLsxlVTvaIOHW2EUAg13Ci5bzeW
 X0kw/ZQs0ZxGzUnUfRFEwRWE=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 5b23032ef28ca6da;
	Tue, 15 Sep 2026 14:48:19 +0000
X-Mizu-Trace-ID: 5b23032ef28ca6da
X-Migadu-Flow: FLOW_OUT
Message-ID: <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
Date: Tue, 15 Sep 2026 15:48:13 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang again
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev> <aqkv-2opTlWD6bzU@shinmob>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <aqkv-2opTlWD6bzU@shinmob>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/26 12:48, Shin'ichiro Kawasaki wrote:
> On Sep 15, 2026 / 11:00, John Garry wrote:
>> On 9/15/26 10:34, Shin'ichiro Kawasaki wrote:
>>> I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
>>> TCMU fileio devices. Actually I once reported this hang symptom in last October,
>>> and Darrick and John kindly took some actions [1]. Since then, the hang
>>> disappeared and I have not observed the hang almost one year. However, my test
>>> system started reporting the hang again last week.
>>>
>>> [1] https://lore.kernel.org/linux-xfs/cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2/#t
>>
>> This was the series to resolve, I think:
>> https://lore.kernel.org/fstests/176279908967.605950.2192923313361120314.stgit@frogsfrogsfrogs/T/#t
>>
>> As an experiment, can you reduce the file size further, like:
>>
>> --- a/tests/generic/774
>> +++ b/tests/generic/774
>> @@ -29,7 +29,7 @@ aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
>>   fsbsize=$(_get_block_size $SCRATCH_MNT)
>>
>>   threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
>> -filesize=$((aw_bsize * threads * 10))
>> +filesize=$((aw_bsize * threads))
>>   depth=$threads
>>   aw_io_size=$((filesize / threads))
>>   aw_io_inc=$aw_io_size
> 
> Thanks for the response. I repeated the test case 100 times with the change
> above, and I did not observe the hang. The change looks avoiding the hang.
> 
>>
>>>
>>> FYI, here I attache the kernel message [2].
>>
>> Is mainline baseline hanging, i.e. v7.3-rc2?
> 
> I will try this out tomorrow.

thanks

About the kernel code, I am wondering if using IOMAP_DIO_FORCE_WAIT for 
CoW-based atomics could help avoid this issue as we seem to be bogged 
down in lock contention.

