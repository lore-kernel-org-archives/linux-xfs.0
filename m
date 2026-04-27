Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8070927603C
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777284985; cv=none; b=dGd4cAkKmwE5E6K2iIZpFK/lYWMfUAAZrYqUmBnp7NcEqRxDDGMO5drZQFPPvHhCL2HWmfb6nwiK1jH2WGq72wWXdq3zclLs7SomKi/0+i/ryuwSQ3Gxub9IJiGA9Kfq1VP2cEJk4Dje/PrqCFhQSit058NEE/9e1dUDCh2x8FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777284985; c=relaxed/simple;
	bh=MVzRp4OGUxMMdWcsFlN4qWeIX4Qazp+n6VnfWzrAamk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QN6bP5zw9wFosFhyZkc/YJJYkpmEgzr4wYifGPEkq4xwHmpg7TN9FuWrj6iCSfI9dzGNV7evRqi3FMryt/XdaYQzBPrjIRci68vW1iLwhrpBUOgdL8SZqkYBnu8B4snGQDRnNZbgD8cdjmdmN4iOu+1xvSYeshbE39Buehv5PM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ipf/P+mJ; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipf/P+mJ"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so6000849a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 03:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777284984; x=1777889784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pdggqY40OkypkTlyFCDPbQJ5t8fWVIZTWFDYfO2J5OM=;
        b=ipf/P+mJXMFbjUJOYSs6xDia98wvHxaAjL40BuOuATATeYYLy8jD4ZwaXBY/oAKIdh
         zjaj0NamCDeLhyrr5M+LMwmeI1uVFnx7/08SowVtFlhKSBTVTWKKTUEZ8KNcgBmPROTy
         ldoe5bO5NygjFrhfyuf2aOV3hoTanFTK7pfmuMrUReOGmcZqGSEvIWFtMZ7VqCcRlYfB
         buyXAsmV20TiqYI8RdE1yjWNDGSbd43ejYakfLlhhqPXZC++Uo8JY1+ZvmYBGf+W9W40
         2w0mh6cOUOWUVi9x/Ds2eWSE+fyZdBjt2mFX+6raVVEnv6+VfUyLQ163UOJ3LRyDC0qz
         dleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777284984; x=1777889784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pdggqY40OkypkTlyFCDPbQJ5t8fWVIZTWFDYfO2J5OM=;
        b=stwP3yKQbEtmV9YPFOoBt0yrIYvTqlC3KjJ5mWHXoryblSw1O2I/FgbeOwVX9rkNu+
         yonqkmcWL7GMj0nFuJEQ7ABOcIFN0OGqHGMTwBBBdig8Z3/HeSWhMiVWecC+JSavXt5J
         sADEQZfaSstvNJft3kOIANBSNwbnjObrGvm6fU91KSHazAtLziRCgCRXl+9SWBYQkE/3
         7LGRCVd+UPhmP2gyO1viWFXOX5Ce/9g9RUHR+52Nrl2z0FmPldzTRxpsveBZgC614iKv
         O2VosZRtHt1plZyOjA9s5QEoaf3msWGyvJ3epMbB83aZhhs4Sj96yboHfumqxgOesDcY
         Wd4A==
X-Forwarded-Encrypted: i=1; AFNElJ/X31kGCMuh8qaylAkdjVP0YjLrSAEkbzldZusEMFEFDHBvAJ+oqqdFQoQBExNWYjlnDWFngxCrxjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKWYlMwWLzPDTV+OaEPbTn5PUnpZQeJxT0p3tlHG/8OuhA3ExG
	a1qWR0NoLWGTuqOA9c9n/kL3yu+gwi2JC6YUs52yyO2l50dZGJTQNZ+U
X-Gm-Gg: AeBDiesGtHS4+fzg0eVRa4qj4FAhpe2mpk8MPvGbk83askkPQbeYRSXGpsjX1WfP344
	a5GBJnTRgjfuTNvy6f2R3JAJ1uIgyz4RWmzCgA1s2W4nfFA5423RUWpyLWXVgLrs6NpdJJvbbdC
	RaZG3pflI7MQ62S0LGMq2F6HoreuZS8OyMnet8XBNwCbaY0MGCKKFRMOfu/Eyp/PgKVgSEuA/02
	wbZsRQl3XbFhtNjdY7ys3HyroO6y+/xPf6MRG+Ioxu1ZBRKdGpjz5sAmCOiW52N/6V5/3rYYgOo
	/0V5OJUzVReneU0OwFEoJ8G0o35x5lx8MAKstBczv86WL+JwlqMRdKzFnw+6v8nx0XNOrv5DcPm
	U/AJt499ti4k2gQ9jq6kSLLhP02rLqMw1m6VY8pEt33FRQX83WH+K2iNWrSnMGT3aefEucZFgcJ
	jokrtMeWx5T61vJhVjbleQ7Hw7Y8K/9TmS9bFTzA==
X-Received: by 2002:a17:90b:5544:b0:35b:90e7:c44f with SMTP id 98e67ed59e1d1-361403e1016mr40055142a91.7.1777284983849;
        Mon, 27 Apr 2026 03:16:23 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613f56ecbesm11872541a91.0.2026.04.27.03.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 03:16:23 -0700 (PDT)
Message-ID: <a7df722a-834a-44f0-87ad-d0da5a813e6b@gmail.com>
Date: Mon, 27 Apr 2026 18:16:19 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Anand Jain <asj@kernel.org>, dsterba@suse.com
References: <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
 <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
 <aeHikJwRmFdDg5FW@infradead.org>
 <cd9c0147-18cf-464d-86e2-12342a992ebc@gmail.com>
 <aempTb5TyKG0vPL0@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <aempTb5TyKG0vPL0@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 23/4/26 13:08, Christoph Hellwig wrote:
> On Wed, Apr 22, 2026 at 07:39:57PM +0800, Anand Jain wrote:
>>> No, T10 does not actually mandate unique identifiers, NVMe does, but the
>>> implementations are often totally broken.
>>
>> Right. Newer SPC-3 (and above) compliant devices must support
>> the Inquiry CDB EVPD flag and provide page 0x83 for identification,
>> which is what we typically use for multipathing.
> 
> But there is no requirement for it to contain something useful.
> 
>> These are globally unique. And, we can overlook legacy
>> drives, as they've probably been past their EOSL for a while now.
> 
> We have absolutely no useful identifiers for most USB devices.
> NVMe devices have broken identifiers all the time as well.
> 
> So no, you can't.
 Agreed. I have dropped the plan to rely on hardware identifiers;
 the lack of consistency in USB/NVMe firmware makes them a
 non-starter for a stable identifier.

 The updated patch set, excluding the ext4 changes, has been
 submitted to the mailing list. Fstests test case updated as well.

Thanks, Anand
