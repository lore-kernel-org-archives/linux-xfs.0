Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F201048F008;
	Mon, 12 Oct 2026 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815922; cv=none; b=PL1GXu+G1MZpysgHfcASE8mLUSEupPAxfILqVYpOalLDPx4gWahwTieWUEYCBzCgdz6hUSGYSgzySglVSKT+EpSnLj+J3D+J/Bw8EQxK7krowZEqPOKibRAk5qwwA3mtC/ZrrxIR5Fn4miEif9MEkbpjgDmv1Sstgtm5BuXXH30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815922; c=relaxed/simple;
	bh=Dt8K8iYDUZ5wRDlnj6zx1zyn/o+f55u1f6XYhRPpR/w=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=IkO7KGXyzToQFj9sypd96BFxg2bDBoEd0jGuf5OCoYfhZYsgP7bJ9vYfNBm/OxE+DIjQfD01CrUhCPcjTY+vON1PYSs0gDUu5LkQO20ytYHElEDoPD+9+IB8VGMX9Jwi52OTPmlAWYscQFwjJ4euGwoxIbRIKyj5oQ3sAMoykOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 5B823180F2D2;
	Mon, 12 Oct 2026 16:38:26 +0200 (CEST)
Received: from mail.herbolt.com ([172.16.31.10])
	by mx0.herbolt.com with ESMTPSA
	id PmEOEeLwzGoLBgcAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 12 Oct 2026 16:38:26 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 16:38:26 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/random.c fix undefined behavior on signed integer
 overflow.
In-Reply-To: <asziOW5xK-ALJC2T@zlang-mailbox>
References: <20261006135205.400485-1-lukas@herbolt.com>
 <20261006135205.400485-2-lukas@herbolt.com> <asziOW5xK-ALJC2T@zlang-mailbox>
Message-ID: <77a91ff8f43794433376c3af4362bbdd@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

On 2026-10-12 15:44, Zorro Lang wrote:
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
> 
> I'll explicitly change it to unsigned int when applying the patch.
> 
> Reviewed-by: Zorro Lang <zlang@kernel.org>
> 
>> +	if (apply_mask) it ^= MASK;
> 
> Ahaha, this .c program is quite legacy. I'm not sure it's worth pulling 
> in
> <stdint.h> and <stdbool.h> just to use *bool apply_mask* and 
> *(uint32_t)*.
> 
Yeah, I did't want to pull anything else into it.
I will send v2 cleaning up the dead code.

-- 
-lhe
