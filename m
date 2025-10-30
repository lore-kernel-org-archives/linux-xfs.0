Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75022A4DA
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 06:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761804264; cv=none; b=G/4DA+nXRZg9NLBg2rK0nPL+rfjrWmXosL70EoBD9xJNq0UWCL6O1Eg0FkbQDZJFCRaIhaleLkl0BxtaLbdWPIxbwSYJkNAnAg0PYvTUe62NnE4KGTCRn4BdqV2COKKwmRBVqQOpaHEz5SeYSAt8KYhf6CNhq7qq6NvY9BOPnFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761804264; c=relaxed/simple;
	bh=Ob6CN4EMxiNdZS/l5PpzQ/6WWl3DRB8FPXTi+kE3hx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZDNWLnQNGsmU4ShHGBsJc1rEWAHi9UulXkLgwWqHuI92AcWDK7WgYqw0ewjcABEDuCm+cZlQ7rTE35b9JOxncgT1ZoyiMPtd+O+wPRAtJzQGDuP9z+ObkGqDFxVibSYyvmjrUQDEJSK4ZTtlwfqAVd6ewbYfWLi4tAbFQAdA4U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3d14omI; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3d14omI"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7a213c3c3f5so1075328b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 23:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761804262; x=1762409062; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RKErskWqNUXPgWHgoTynrJXfGfE02ELTVvClulx9bYQ=;
        b=b3d14omIxedl6MzP2YMTi54himR3aKYINtlgYv4VozLqFzWYzxtuWkfE2h31Fhiyp+
         U8kB6enwK/QQPEgtlawb9yTW2/+yHbJG9woivzIPsk8umoCPw23vBbIOAe7V70kMCvZY
         z3sBmx2UH2ZQBP1gYF0azybVlXQUBa6fXv54quKCPv0VgaZ6cV2JwvK9HpAYcarykMrD
         6K3p7j+0+pRvHIkEBjQhXg5NUM7dbePAfLQhoiRFEh4tKsiWGK15spM2b8yFEJJG/LwQ
         FbDkK/NdzoHj12VcH3gshBLJVF1NChRqCIYP1xhn+rkObcFpomL3Fp1nhWvTgEOYL2Q/
         aoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761804262; x=1762409062;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKErskWqNUXPgWHgoTynrJXfGfE02ELTVvClulx9bYQ=;
        b=msP282pfPg79bh+tboteGxP6s1q3ODVwS3rM9kl/UrWqbmhnn2r5RVvjsR8lfIXi9h
         e/Bux2zSC3R9orfRc27Y/wzZ8thQjhYUefmpAa7MVm1t6xltMNrd3HVc5nIlK3WJZ7Zb
         AfEpA7JZuv6QmNhk9EDDKl0laFwLYOI86QzpODMBvwnoCh5ghJQmcF1kOAYgPf5TyIF/
         B0YzCxQvIarGO4V7iigFzTSUwcw3FdLUOBMguHZBqOuyDTx8HX0TPcweBC7CLKhOeiGW
         wXNLQv85ITVrsfotoRDBhKLgGowtxg9VxP+tusdYn9gijS85eLnPprCoAGTvdAuviSvj
         +v/A==
X-Forwarded-Encrypted: i=1; AJvYcCWZcR5x5mNtz753Y81TGMmiaCa5FfWzNSeztrwb+KiF0HIsI8G05+Kz4J32st1nVX+RvcZyAhx3gdM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw3o7sCOLccxINN268lJeRvFAFU7wg7zr6aLFsLzNJn6jri7gX
	peXAqFwuDOrn+yzNtrWfy7RUccoymSwig1p3An2gX2egfd5qK+tMd6Fi
X-Gm-Gg: ASbGncsH39s2incv4KXvVjKkx7HC4A7Rv1brmoJF68S5x1t/g6tBdZ+TDH+fDSNMnqZ
	j8bVgmWVHrWCO4KpoYOQEJDKCkw2BXfuwsFKkMXhmdhchSLLiHjSSjFWvYgHHciQG08kWyAljhP
	r10OejvOKIlSiEITzwpcsPw1M7oPa9JX3wPRy4Hov83lOJemePiDHyCZKSW0RoZU0HmcQOr/uxU
	sf9HQZgmzPs9hB+ieK/d61gUjSfBF+Fc14b3N0kl4ByeTxi1NxyHg+Oxr/dCfVIMVLlF6iqmDrZ
	6TF7OjoLHumKKq3pTL/Zgmh7B999BYwu9m1EgsmAsdF/JneR/duGdPC7FgLZJrX32RXpvIflw9p
	ZhoaK4ZmwwCtx/aUGf1b0biO5fxp3Lo+hhQampAx+Wb6zGixTLaYspE1tmBGFMeKe8/+1jxUZyh
	2ypHNAMWIPjqK52OMgu3Cd
X-Google-Smtp-Source: AGHT+IFXLeO5nh0dpewKxl5nUMCIaH6qGNwm+XqIzRneSj+4MrHfiJdfnc7SOmBhrR6C9gvWKu0yDQ==
X-Received: by 2002:a05:6a20:3d05:b0:33e:4b14:7e9 with SMTP id adf61e73a8af0-34657f5c6e6mr6326346637.22.1761804262385;
        Wed, 29 Oct 2025 23:04:22 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414072487sm17169234b3a.52.2025.10.29.23.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 23:04:21 -0700 (PDT)
Message-ID: <20ae71dc-c279-42fe-bcce-1b271f487a2e@gmail.com>
Date: Thu, 30 Oct 2025 11:33:33 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618045.2391029.13403718073912452422.stgit@frogsfrogsfrogs>
 <4e8a9b373fdfeecd3e0de2a91ecdd75fbb94e18e.camel@gmail.com>
 <20251024221647.GW6178@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251024221647.GW6178@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/25/25 03:46, Darrick J. Wong wrote:
> On Fri, Oct 24, 2025 at 02:48:00PM +0530, Nirjhar Roy (IBM) wrote:
>> On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> In this predicate, we should test an atomic write of the minimum
>>> supported size, not just 4k.  This fixes a problem where none of the
>>> atomic write tests actually run on a 32k-fsblock xfs because you can't
>>> do a sub-fsblock atomic write.
>>>
>>> Cc: <fstests@vger.kernel.org> # v2025.04.13
>>> Fixes: d90ee3b6496346 ("generic: add a test for atomic writes")
>>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>>> ---
>>>   common/rc |   14 +++++++++++---
>>>   1 file changed, 11 insertions(+), 3 deletions(-)
>>>
>>>
>>> diff --git a/common/rc b/common/rc
>>> index 1b78cd0c358bb9..dcae5bc33b19ce 100644
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -3030,16 +3030,24 @@ _require_xfs_io_command()
>>>   	"pwrite")
>>>   		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
>>>   		local pwrite_opts=" "
>>> +		local write_size="4k"
>>>   		if [ "$param" == "-N" ]; then
>>>   			opts+=" -d"
>>> -			pwrite_opts+="-V 1 -b 4k"
>>> +			pwrite_opts+="-V 1 -b $write_size"
>> Nit: We can still keep this to 4k (or any random size and not necessarily a size = fsblocksize),
>> right?
> Well, yes, the default will still be 4k on an old kernel that doesn't
> support STATX_WRITE_ATOMIC.  For kernels that do support that flag,
> write_size will now be whatever the filesystem claims is the minimum
> write unit.

Okay.

--NR

>
>>>   		fi
>>>   		if [ "$param" == "-A" ]; then
>>>   			opts+=" -d"
>>> -			pwrite_opts+="-V 1 -b 4k"
>>> +			# try to write the minimum supported atomic write size
>>> +			write_size="$($XFS_IO_PROG -f -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile 2>/dev/null | \
>>> +				grep atomic_write_unit_min | \
>>> +				grep -o '[0-9]\+')"
>>> +			if [ -z "$write_size" ] || [ "$write_size" = "0" ]; then
>>> +				write_size="0 --not-supported"
>>> +			fi
>>> +			pwrite_opts+="-V 1 -b $write_size"
>>>   		fi
>>>   		testio=`$XFS_IO_PROG -f $opts -c \
>>> -		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
>>> +		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
>> This looks good to me:
>>
>> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Thanks!
>
> --D
>
>>>   		param_checked="$pwrite_opts $param"
>>>   		;;
>>>   	"scrub"|"repair")
>>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

