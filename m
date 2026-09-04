Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EAA3B47DF
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 16:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539390; cv=none; b=KqNhdDWPzeRb3wI0Equp1HXNiSnSS5+r18vdwm0mkSKLQshZyOwXYuKr64o0x3x/qsY9b7U6L75JRkC3r2TpCJV3Bc02nx5wU3/bFAC462XxF391JbVYXO5hi9SE5wUG0R0mwPYXp11Ink5Fpw/6m0YAWDb7lJEZyOpNAU2k1ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539390; c=relaxed/simple;
	bh=BC5GrjMNpYwRLnEL3Tw9Ts9s9hBNGQ/N+o2C9RDxqag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vcp7pUeQsw2AjvmJm08NOtGQHFRPcFkP4AIFbN5MdZIICImoM9HuAL6s2YL2nlxRDshfcJfgy3PaCvvR9f1IBU9BHWyUnRx+PJs2d2Cdwv9beMyAgBNIXN3Mnx6vMZw+v7TlPiDztydtzYL5zTioR38wwd4uvQ9cPp1tjD+x4jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jJSGywuz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PCfvsGGz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jJSGywuz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCfvsGGz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788539387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DPb0pZA9V7TQB8DMWkUjF3uTzQplHevy4rPmbhoX/oQ=;
	b=jJSGywuzlj/Gjtp35ikSkyYi5Qodpc3T00ceNFvw3IfVkjqky+TgvlncyfGoRdBTJG9ZtK
	53ojPZG6MTbRESaG5oJMwdp6T8IGrdD+zBYc5eQIgyIKYLJF9imrpJs6SG7Q11I3tG3KqU
	m71ZKIv2U3EaFVpyE7MDnXrp4Ft9EOw=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-SntzsRvKMky0d7uQDyM29g-1; Fri, 04 Sep 2026 12:29:46 -0400
X-MC-Unique: SntzsRvKMky0d7uQDyM29g-1
X-Mimecast-MFC-AGG-ID: SntzsRvKMky0d7uQDyM29g_1788539386
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c385784778so163744e0c.0
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2026 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788539386; x=1789144186; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DPb0pZA9V7TQB8DMWkUjF3uTzQplHevy4rPmbhoX/oQ=;
        b=PCfvsGGzra9unhZHS7BxEw1rerkTNhy95I5Kj4tBiyeKfyLiN/6Q79xoMWw/0ctctN
         /JHLefIL87mFtln35eRwdUYGY6mhgJ50Ve0Y2oGZ47+KhP0wI43ev9/CFAV+TIKlFi2w
         HiRLXkw4Md12g1uL/6D/4pourjs84LZ/D5w9LhUeI/6BKmCdWU5PABjZi4xjlWseDSaq
         U9hwyJKaM1IZjX8C/cBAZRrza+6ykaqWzW6XIFUSPUzx3jiSCDy73gsoixiKM5NNvihk
         quMZd5Sl2IOlFfBGPZVgEaTglF3sNELzy7JUnfX9Pd4vWlg1k3UvcRmouJNUk4YryJAW
         PPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788539386; x=1789144186;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DPb0pZA9V7TQB8DMWkUjF3uTzQplHevy4rPmbhoX/oQ=;
        b=jnMnw+qNcWz5FiBIQcmCSSBTMFT5L/QYaLBjBAfx1YSOEDMDviclEBcMuL5Knhz2o0
         nZEHhR88Pl50POPFOBqDsQD6ar7KbSlI7MdWnjE2olnee8JobvpK5ws6QmKA+GvNhxQ8
         8ZfEbYH52jeg8GWbvyc0V8tGliu/2Bu3hdKndrzrTyCDmEOGwwyBE0Qk01635nYaKD/E
         LKZmiC29uJYZm/bz0G/C5U348WiZQ1EMl8o0+sh3AA816nsw3KJp3rFbc4PianTDSuT0
         lByYPWRO5D4lS5lSmEVFEnYxIGouprQIIEJUw8PYSIbhJnZeZVc7kJNAV1BSPbCZUnRB
         LBjA==
X-Gm-Message-State: AFuF++m8PKpuYTxT7jJzsslYGilxKKc4ANytqHNFOMZjfJKWurMDwust
	jubQB1MWhKLswHDkbE6LvO8KZKOgZY1plxbzUa6nIGOPUduQDCaUdcm3MEchxEdLCF4/Du2/xib
	JuU8kFKr7GweX25jMxXXVpl2YqZfTX8mGM/nSHVuk/H1B51veDw92IJ5p82UXzqPGCq30Dg==
X-Gm-Gg: AYBFou23Yri5HlXAD8clVvzYkfspLIxmGm3MFQkEpqZWSP+DBWgp82UGXfOd68aOKq3
	tYUBoJSsqgpuD/27m0OO8d/uV8IelmApgRTsWkCN1qAn1fOezclVCE/+gZ1jeXGa2ZZ5Pou0FFg
	L+hug8c+yOBgC5+ukIWxZZNJv7futeiwj4CAU3c0ON9r035PJxG8csK3U+QamsOgWXMq5GhtAa6
	GaDECPKiHpRaI44FGixzdxfEOB4iVOszmHzoKUhVWct8HR6XRVVLxOLMZ7MNykSgmAfDHzjUUkN
	FsVRiKQdP5ZPWArwBc+kyMkyD+OKKcoNFOVu5//mHOyz1KAem+PQz475NN1drutRJD1DtGa9B3w
	O2Sxu72YKQVl1XgqXKEMBGXJd3LjZjJCfWQ6lN9IGWA==
X-Received: by 2002:a05:6122:6092:b0:573:a779:62cf with SMTP id 71dfb90a1353d-5c7ed83b793mr2843308e0c.7.1788539385704;
        Fri, 04 Sep 2026 09:29:45 -0700 (PDT)
X-Received: by 2002:a05:6122:6092:b0:573:a779:62cf with SMTP id 71dfb90a1353d-5c7ed83b793mr2843286e0c.7.1788539385227;
        Fri, 04 Sep 2026 09:29:45 -0700 (PDT)
Received: from [10.0.4.228] (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c7ec21302bsm2420639e0c.7.2026.09.04.09.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 09:29:44 -0700 (PDT)
Message-ID: <02b9eed6-4bfb-41e0-a98a-0f5aa4ca7307@redhat.com>
Date: Fri, 4 Sep 2026 11:29:43 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs_repair: distinguish true ENOMEM from "not found"
 in cache_node_get
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20260903203638.1094907-1-sandeen@redhat.com>
 <20260903203638.1094907-2-sandeen@redhat.com>
 <20260904162038.GD1933798@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20260904162038.GD1933798@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 11:20 AM, Darrick J. Wong wrote:
> On Thu, Sep 03, 2026 at 01:42:43PM -0500, Eric Sandeen wrote:
>> When cache_node_get() needs a new node it calls cache_node_allocate(),
>> which returns NULL for two very different reasons:
>>
>>  - the cache is already full (c_count has reached c_maxcount), or
>>  - an underlying allocation actually failed with ENOMEM.
>>
>> These require different responses. A full cache should be shaken to free
>> slots and, failing that, expanded. An actual ENOMEM should be returned
>> to the caller to deal with.
>>
>> To achieve this, make cache_node_allocate() say which case occurred via
>> a new *enomem parameter, set true only for a real allocation failure.
>> Cache shaking still happens before returning ENOMEM, as this may actually
>> free memory and allow new allocations to succeed.
>>
>> Also fix the stale return-value comment, which had the hit/new-node
>> cases backwards.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  libxfs/cache.c | 39 ++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/libxfs/cache.c b/libxfs/cache.c
>> index d5d9ba56..21e4c0c0 100644
>> --- a/libxfs/cache.c
>> +++ b/libxfs/cache.c
>> @@ -284,15 +284,26 @@ cache_shake(
>>  /*
>>   * Allocate a new hash node (updating atomic counter in the process),
>>   * unless doing so will push us over the maximum cache size.
>> + *
>> + * Returns NULL on failure.  A NULL return can mean two different things:
>> + * either the cache is already full (c_count has reached c_maxcount), or
>> + * the underlying allocation genuinely failed with ENOMEM.  These call for
>> + * very different responses from the caller, so report which one happened
>> + * via *enomem: it is set true only for a real allocation failure, and
>> + * left false when we cannot allocate another node in the current cache
>> + * size.
>>   */
>>  static struct cache_node *
>>  cache_node_allocate(
>>  	struct cache *		cache,
>> -	cache_key_t		key)
>> +	cache_key_t		key,
>> +	bool			*enomem)
> 
> Hrmm.  Having ENOMEM as an outparam is a little weird, but I suppose we
> can't do the ERR_PTR stuff that the kernel does.

yeah I looked for ERR_PTR and we don't really do that.

> OTOH I guess you could set errno here and redefine the return value as:
> 
> "This function returns a pointer to a cache object in the case of a hit.
> For a miss, it returns NULL with errno set to 0.  For any other runtime
> error, it returns NULL with errno set to a nonzero value."
> 
> Hrm?

As you wish :)

...

> I think I'd almost rather we change cache_node_allocate to return int
> and the cache node as an outparam since we do that elsewhere, but
> <shrug> I'll defer to Andrey.
OK, I can see how that looks. Dragged into some other work for a while
now, though. :(

-Eric

