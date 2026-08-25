Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB02402B8C
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 12:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661411; cv=none; b=qjB0lbnN8P38HOyu9z4Veq70+gZmRaPE1lgEtof8oxaRTgfXQsQusODs8yIBCTlg99ShQvt6BcAZhA5Dw1sBgIc27B8eThOGZtWy9QT3MU/HSw8OjLRn8P9CeZSwVOlSGKaUJGb136wSHGiUraH8eV//sbfpXMqW8ySJ5XhoUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661411; c=relaxed/simple;
	bh=Y/0VVikxXPwE+F2NpSNJiR8hBCexEo38Mdge52QNjvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhKYC2QTaUCmSGNiaqWDVrmNq7153KjqU8KBmIffIHYjl3yj5CiXpyj6f55Hoy+vamzEg6pXDIV3GsAwZ1sTJ/hDYFm0h+ml7IKwo7OasElRHried1jnVN9wDPPBRwCtlhgbmpyq+JFESt3q9rOzaLiInN2EIfCRhrjUHZXvhdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=cobFvoyQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lemy3c8A; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="cobFvoyQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lemy3c8A"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id D7E94EC016D;
	Tue, 25 Aug 2026 08:36:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 25 Aug 2026 08:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1787661399;
	 x=1787747799; bh=04qAs737+9kTGHKnSSQnF+3D9kN3S2mNA5IX9j+ytzs=; b=
	cobFvoyQtct44kmJzsxcxdBWxf49G3KF2U3CLhiACJllvwBle1W/Tgb6qACQhr7z
	kVS1j7Xlh1gR7w7ne3dkSw+YRDDTZQ8q9P5EJRTcFNyDElv77NPGWsheQWdYpo5X
	fDWoIdMWeHGq244hOx5FpzZN8nMGvmdIOJ4vy4QuEfcXCSxcsqLGZ6PpQCm4W2X6
	vVgP15hQtw0Q9b3+Vig0SUOqd4+2wMIOuhxV6O0Nn8dLhyQqexvVfouN0Qcivglr
	lKBBHT1MeqJqWzthH6RBoxrQ1v40I879Ghqbq2c13svk/JzmS6rRD/xy+F3NggRN
	jnQrZBqPKM5o16lGqmaEOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787661399; x=
	1787747799; bh=04qAs737+9kTGHKnSSQnF+3D9kN3S2mNA5IX9j+ytzs=; b=l
	emy3c8A1zSdfbN5h8JYDEUxr83alAplEWZ8nx7p+VNAtU84CPjAz8GGvhrs4rwT4
	kY57zQOxsYjeeMlPPSsFlv5l8ACwCArhmAlSaHxyQLUhKGc6Zs4EZuO2ekZtFVGx
	PFt7ofO4hJciScGTTsYbtlUceZmQNm6k75zpVNl7g7/hHhLErxWfoyXmL3ymDBJR
	/xbx05v6jmajtPWuJHPe3cNx7THXfAjfKESdii7vl8O4HiEHakNhmN3r6CLj0Scg
	w+UMR4mSeA2k/mWyeUs41IV4FB+QlAXudCmecX1ZdPyVdqo+GniZah8MMW5nUCv/
	I0416H7RQXD5pOMOY324g==
X-ME-Sender: <xms:V4yNauTJ0yn0JpqgqdHbsUl_KQ9HafWCMtCpZwFMSV42goiGcrY97g>
    <xme:V4yNarPFkZ5LciAUxcC2Tt99tz2lL8LlENW9iVFuIVwQ1F1P7qRy7eO1XG6aGJ3yR
    xGILpWcXHDfjlQeCDJLd1SRWApjmiZfcib0QD7PG9zfBm3r6PkyCoEC>
X-ME-Received: <xmr:V4yNapMHMiu4LvRVGK40DRK7Hgtw79fguLf9xko3BcVMrQqftGtZV9NruoEN3dlpqNABLCjJVd54Hkthy3rD-Ioo>
X-ME-Proxy-Cause: dmFkZTE6FBeP/JBWzeRASgk5BtKoqO8LQccFaK37x3UGLLGtgS+8C9uFEKScbTAiM33boC
    ASW9Ln4zsylQuxCURWjGimhglL6YVBBFpfWwDv6kq8XiMAGUR4vYhgClCr9wGXnGIJwufO
    T5hq/XoUs2/zrB9xN8gypeUlO2MR0sE1amyx7WXYlmhbnwX1PE9y3C8beWWyUg5tNb0Ayu
    3iNjjiUW+QawCm+8H0+UFnvFKir+c5OExvoPlL/t18SJ8l/vrkvIB8T1DCR81s+mPQ/JJN
    1eJP1i0V+R7/8qnunYRUKqSICTpx+q2vprEV08X1QCqL2zSFfy2K9SZS2heki8CnSEDMZz
    dcmJ1GSUBW7gGwt8SxkGjFmgyswzm2kzT7G9lSl7bOhbPEtz9bICsJ0vrKQasA5/TsMaUI
    VnhQVRexuqvEGtlgOubwgvEKFim12Y+BXPDdn/ylHOy1Kc68x42nOkk1TQkLM7uAU9KsvC
    p0nIq8BPONAyv1/8/R+gbq/T8QdeBaUjBXlhAkAK/Me9njIWCejbkBbZ2Qb3Tqw5zvzKPu
    uYlH9qmOeseweCS4NseJN6n8xF6kPaBnbao144Ph1UlV4Q6Wuh7Az8FaQR5fzUk8uU6M0b
    yFMOOe9jkQ4CKpvRcLqWjXPINZEr/tK54HTvo9FvHx5FvN5/UZgfQpkD8NEA
X-ME-Proxy: <xmx:V4yNajvPabW3xyCbDW-j2E4IigZermPGMmSuikGwKsC3YHGz08FtSg>
    <xmx:V4yNarW5Ae0Zf_5nVVja8IucNGs4dKrqUbK2_JqA5zoMJgGbMBN0NQ>
    <xmx:V4yNajsxAqqlSUuaNB4N6eH5ZILGePgj2ewr67PaUkaU-2ubY6U-0g>
    <xmx:V4yNavUBYVV4Tznv-gpns09LTRKLSwy_jDiqRzIIxUVjWsMYWxyFOQ>
    <xmx:V4yNau91zJcULRi95M4DgwsuRkVY_4nLjOCaV-5jHdblvw4O8rGlnmd8>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Aug 2026 08:36:39 -0400 (EDT)
Message-ID: <f9a93847-4dad-4b1f-81fe-434117aea313@sandeen.net>
Date: Tue, 25 Aug 2026 07:36:38 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs_repair: do not allow cache growth to overflow
To: "Darrick J. Wong" <djwong@kernel.org>, "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
References: <20260824214056.400740-1-sandeen@redhat.com>
 <20260824214056.400740-2-sandeen@redhat.com>
 <20260825031708.GG6110@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260825031708.GG6110@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/24/26 10:17 PM, Darrick J. Wong wrote:
> On Mon, Aug 24, 2026 at 02:58:59PM -0500, user.mail wrote:
>> Nothing stops cache_expand() from growing c_maxcount (via *2)
>> repeatedly until it overflows.
>>
>> Add a bounds check here and return failure if for any reason we try to
>> grow too much.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: user.mail <sandeen@redhat.com>
>> ---
>>  libxfs/cache.c | 20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/libxfs/cache.c b/libxfs/cache.c
>> index d5d9ba56..f8be9b89 100644
>> --- a/libxfs/cache.c
>> +++ b/libxfs/cache.c
>> @@ -79,16 +79,23 @@ cache_init(
>>  	return cache;
>>  }
>>  
>> -static void
>> +static int
>>  cache_expand(
>>  	struct cache *		cache)
>>  {
>> +	int			success = 1;
>>  	pthread_mutex_lock(&cache->c_mutex);
>> +	if (cache->c_maxcount <= UINT_MAX/2) {
>>  #ifdef CACHE_DEBUG
>> -	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
>> +		fprintf(stderr, "doubling cache size to %u\n",
>> +			2 * cache->c_maxcount);
>>  #endif
>> -	cache->c_maxcount *= 2;
>> +		cache->c_maxcount *= 2;
> 
> I agree that it's useful not to overflow c_maxcount, but how did you end
> up with that many cached buffers?  Or is this LLM-inspired bugfixes?

See the cover letter (sorta) ;) An ENOMEM from lower layers is indistinguishable
from "cache too small" so when we ran out of memory it rapidly doubled
its way to overflow.

In a quaint throwback to simpler times, this was actually observed by a user.

I think it was actually a low max_map_count in a small vm and a large
filesystem, though I don't recall the exact details now.

> Either way I'm ok with this part, so...
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
>> +	} else
>> +		success = 0;
>>  	pthread_mutex_unlock(&cache->c_mutex);
>> +
>> +	return success;
>>  }
>>  
>>  void
>> @@ -468,7 +475,8 @@ next_object:
>>  		 */
>>  		if (priority > CACHE_MAX_PRIORITY) {
>>  			priority = 0;
>> -			cache_expand(cache);
>> +			if (!cache_expand(cache))
>> +				goto fail;
>>  		}
>>  	}
>>  
>> @@ -488,6 +496,10 @@ next_object:
>>  
>>  	*nodep = node;
>>  	return 1;
>> +
>> +fail:
>> +	*nodep = NULL;
>> +	return -1;
> 
> ...but a general comment about this patch and the next one: it seems
> reasonable to make cache_node_get return a null nodep and -1 to indicate
> error, but AFAICT the only caller is __cache_lookup (aka the buffer
> cache), which doesn't check the return value at all, only the value of
> *nodep.

Uh, I guess that was a leftover, I thought "I should return something
different on error!" before I realized nobody was checking return val
and then didn't go back.

> I don't see a change in this series to change __cache_lookup.  Did that
> get lost somewhere?
Not really, I just changed cache_expand before I realized __cache_lookup
didn't care. We could make it a void function, I suppose, or start checking
return val instead ...

-Eric
