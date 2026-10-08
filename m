Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18C2448B8E;
	Thu,  8 Oct 2026 08:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447850; cv=none; b=Qi9iSNu2zhR/p5End+MG8tGBFBovrxMXPyXLZPJMcXE27b6IBVJRohZY9YIewaCyvcraC/bIBgZtbYahWhAQ3y3G1dHRqEBr0OfAToC/1PLyFfCvXvto5Seo5dbtYlSFmw1Dj4tq2VLmVDLYOAIK6vublDnnr31kdx4qQUR+EZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447850; c=relaxed/simple;
	bh=3KVjqPfNdvKqT82rfogBtYTs+jN0HvXqg3ghXsZ7m+E=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=o8akSgGW1gR5/5E1LXA9pbAIXPoFwlTzlROVAHf95U9CGQO0l5kwlCj00myDSrUnEXFa4tjut6zfUqvF6Qa7yW5SghTTLSKdzcNwbAk2DiQ0a3P8PSfDx0l2S27Hsm6wmoX8pCgguwisGYZHdN8gUO8+yvqoCywDaHvkGv9Kx40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id BA3A2180F2D2;
	Thu, 08 Oct 2026 10:23:59 +0200 (CEST)
Received: from mail.herbolt.com ([172.16.31.10])
	by mx0.herbolt.com with ESMTPSA
	id NF/GKB9Tx2omegMAKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 08 Oct 2026 10:23:59 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 08 Oct 2026 10:23:59 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/random.c fix undefined behavior on signed integer
 overflow.
In-Reply-To: <20261007170058.GG2705364@frogsfrogsfrogs>
References: <20261006135205.400485-1-lukas@herbolt.com>
 <20261006135205.400485-2-lukas@herbolt.com>
 <20261007170058.GG2705364@frogsfrogsfrogs>
Message-ID: <d000ae8abba884b0a58be93e6e63f486@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

On 2026-10-07 19:00, Darrick J. Wong wrote:
> On Tue, Oct 06, 2026 at 03:51:52PM +0200, Lukas Herbolt wrote:
>> The random.c now expects that signed integer to overflow and
>> triggers the  ^MASK branch. But signed int overflow is undefined
>> behavior and GCC can optimize this branch out with certain
>> CFLAGS/LDFLAGS.
>> 
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> ---
>>  lib/random.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>> 
>> diff --git a/lib/random.c b/lib/random.c
>> index d5c81be817c8..f767ed1d1337 100644
>> --- a/lib/random.c
>> +++ b/lib/random.c
>> @@ -186,14 +186,15 @@ _random (int32_t is [2])
>>  int32_t
>>  _irandm (int32_t is [2])
>>  {
>> -	int32_t it, leh, nit;
>> -
>> +	int32_t it, leh, nit, apply_mask;
>>  	it = is [0];
>>  	leh = is [1];
>> -	if (it <= 0)
>> -		it = (it + it) ^ MASK;
>> -	else
>> -		it = it + it;
>> +
>> +/* 	evaluate on original value — no UB here */
>> +	apply_mask = (it <= 0);
>> +/*	double via unsigned shift — well-defined */
>> +	it = (unsigned)it << 1;
>> +	if (apply_mask) it ^= MASK;
> 
> Doesn't _random suffer the same flaw?
> 
> Oh.  It's dead code, maybe it should go away?
Good point.
> 
> Also, what about converting all the variables to unsigned?

It would break two signed checks: `it <= 0` (LFSR feedback -
only fires at zero instead of when MSB set) and `leh < 0`
(output folding — never fires). The `it` register degenerates
to 33 repeating values after 64 calls. Reducing the pool of
random numbers.

-- 
-lhe
