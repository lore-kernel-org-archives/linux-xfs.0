Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A38A31D754
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 06:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761804219; cv=none; b=D80980zSNTZVAcIH1xqNTqd+WF85SQCpPsLmZ2eJZ873IZnTdFVfjdtvXsfqUy41i3F7mShggbjlE1ZMCpDp1kJdrSQ8uGXUVJXA43r+FJgdxKyPyQrHNZOmfNoc0SDaK09IEpz7uEQ6oIF47T3Dx5ZvBsnu/MSkpxko6daSchM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761804219; c=relaxed/simple;
	bh=GAVB6pA0v8cqvOFccYTuPJTOi2NUjQzyWVe6Vgc/THM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aN8687Py75exOVyFHKQEQ2raDp22BCyy5X7o2/gcXqkIhOpvVB98IsfOIGDfu7J5I2iMMEgmYTrpxCE2p7w+T7yELRDzdMhSOPiihNcbdGo6HHhlITg2tr1edJjMrB64ebNyAbSMA8CmoWEJQC49bZHhKa7fNQTSZe4lMI69ebE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnf3piuL; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnf3piuL"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7a683385ad8so206490b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 23:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761804217; x=1762409017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8OpBe/rFPygHuP3aSytGmsROXrHOD9mRD7CnBgIfX6E=;
        b=cnf3piuLZMW/OI7Z/MuHSTjxryyRtpqi7tUNgmqovWDGpRMjSzy2roRrcw1orl9Js1
         GUZcRvDRPzIGMGDHC7G9XeQQEQOF6/BflV3Su97ZcssZMjHn1783hJr2a7YitHlq6C4T
         eByrtVoxoqyobeOjjK10CXQbT8dpnotX3RyuFSeGpSYd7G78pPWm1FPAx8oP1X+hcJyG
         oChOZTeAopMV7i80nFIs1Q+B29rqe0ZYb1z3EUFHMLLVWcrTGC4kWYjSPSt3sMtLAQb7
         7HBDMaFe2Iv2S0BxiQK7B42ehkv9bKUX89Julcg1HWnj3f5QlQ05iXMPl6uP3mzQSpjf
         ey2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761804217; x=1762409017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8OpBe/rFPygHuP3aSytGmsROXrHOD9mRD7CnBgIfX6E=;
        b=Uxt2WGBD9TrFoljWrNO5XvQT9t9S3VLcOwmzg8Jd5Q8Zz6eJoWvHPQEtHD9DHghgsV
         WbUGRcMzyLyP5YKGMLJtFzXbV77DO+bv6Ewa6+1FUB9/tL0rW+wJVVcPbb9hgq4YG29n
         rGQH2d+xUu3e5AEpFTgQ2ejA70aPelbPbOz47/JYvRUwnu8Ao8e47LUnGAaLIOD/8Lxz
         jIpxFNjahSBqnQgX6ZcVmbyLwRH05u2mQ2EQTTDmLii5mWDyTIQ7xdZ+wcZTOHuox2Lv
         QnjC5eewKOO2HAd2HnMoJK+1Z2Ug6o69m156F5OTONrzIkSJNRAR5JBjaQD//Y0fFKxe
         A1iA==
X-Forwarded-Encrypted: i=1; AJvYcCWVbbNnY87fU4aLBqymlUpWvjOKBHa9Eb9QqP7fNDT1UBW5AT9RxuCRi62G2UcQ89iuYsyLFmzU+t0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj62XCHgHEhLEBP++EU0T6wQ+DLVU1LOXl6RNSCWJwrEaLBUaj
	dBBxxh0HnlS/FSF1U/0EprEQlOZkGPlgfucIYr0sFyb5VaT9I/TJwj48zjWKPQ==
X-Gm-Gg: ASbGncs5TfWMlOVTqyZablRJXDYBxNDBIGneXp1MQ3mj+292f0Ey5AgPe1e6qlImuwz
	giWWTR8zsIqi3RYWLyGl6TamfYkFGtu+YYuILWc+JbeIiUMvuBp6C9Zn1eAVHc7rYddUmGk86sO
	SyrT4OyJir++QuSL4JWJ+j+VYfdyCvsh+LRljrVthL6gapZyB9ALLV+LqARnIbj393oIWqW2ZM9
	C2+9XYYJhyfAP0PCqKZhIETdePNM7/CHZr846287QzsPdfspcPPD7VfX4FayJr6ZouMR7X3tCUR
	+U+zdzOdWrT/6R6Q5yWm54riO6vsFeXqyEfdz6V0qZOv0YXPSjimmninuyc/IzUaAfLGUHQ7c58
	f9sFF9cjy4x7Fr38P9x/67MsDzHRuz6KlwkSOQPXNjakahoCeHcrHR8GGEOM2qDU+sN+xv00uZj
	gn6DY3Td7juI14WooTfG+jVq+FNthYgZM=
X-Google-Smtp-Source: AGHT+IEiHwjtemye0bI8yUw2E+gyDPsJBan1udi5daHQQaAhbn3NSp5A5uW7pytNPQquxV57mFLZiw==
X-Received: by 2002:a05:6a20:3ca6:b0:2d5:e559:d230 with SMTP id adf61e73a8af0-34787d94214mr2588702637.57.1761804217313;
        Wed, 29 Oct 2025 23:03:37 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a4140168f7sm17196888b3a.11.2025.10.29.23.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 23:03:36 -0700 (PDT)
Message-ID: <bc7d0963-69ac-4b64-a0e4-2aa09ff6d0cf@gmail.com>
Date: Thu, 30 Oct 2025 11:32:48 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
 <95366976c8fee19ab2901c4b11fe5925042fdc95.camel@gmail.com>
 <20251024221503.GV6178@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251024221503.GV6178@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/25/25 03:45, Darrick J. Wong wrote:
> On Fri, Oct 24, 2025 at 02:31:16PM +0530, Nirjhar Roy (IBM) wrote:
>> On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> attr2/noattr2 doesn't do anything anymore and aren't reported in
>>> /proc/mounts, so we need to check /proc/mounts and _notrun as a result.
>>>
>>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>>> ---
>>>   common/attr |    4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>>
>>> diff --git a/common/attr b/common/attr
>>> index 1c1de63e9d5465..35e0bee4e3aa53 100644
>>> --- a/common/attr
>>> +++ b/common/attr
>>> @@ -241,7 +241,11 @@ _require_noattr2()
>>>   		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
>>>   	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
>>>   		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
>>> +	grep -w "$SCRATCH_MNT" /proc/mounts | awk '{print $4}' | grep -q -w noattr2
>> If noatrr2 doesn't do anything, then in that case _try_scratch_mount will ignore noattr2 and mount
>> will succeed. With the above change, we are just checking if noattr2 appears in /proc/mounts(after
>> the mount), if yes then the preconditions returns true, else the test using this precondition is
>> notrun. Right?
> Right.
>
> On a pre-6.18 kernel where noattr2 did something, the following will
> happen:
>
> a) V4 filesystem, noattr2 actually matters for the mount, and it should
> show up in /proc/mounts.  If it doesn't, then the test should not run.
>
> b) V5 filesystem, noattr2 is impossible so the mount fails.  Test will
> not run.
>
> With 6.18 the behavior changes:
>
> a) V4 filesystem, noattr2 doesn't do anything, the mount succeeds, but
> noattr2 does not show up in /proc/mounts.  The test should not run.
>
> b) V5 filesystem, noattr2 now no longer fails the mount but it doesn't
> show up in /proc/mounts either.  The test still should not run.

Okay, makes sense. Thank you for the explanation.

--NR

>
>> This looks okay to me.
>> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Thanks!
>
> --D
>
>> --NR
>>> +	local res=${PIPESTATUS[2]}
>>>   	_scratch_unmount
>>> +	test $res -eq 0 \
>>> +		|| _notrun "noattr2 mount option no longer functional"
>>>   }
>>>   
>>>   # getfattr -R returns info in readdir order which varies from fs to fs.
>>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

