Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DEF3A63E5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 15:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133320; cv=none; b=fxYAwWU5JeBmKjDDzavWpbrGhdKh1Eyyb1CV1EtqMaTazaQhRBLgd8BaAo3cCnLxPSNwruIA1ND6X6vBT55O0BQhBFbw6lgACu41E7mYm2Bz72WK5dyo7V8JmTTGJ5cOeWQdTNPcnAcK8Liai8O6B8Tp44M92c0LQ0vo+Vjj9/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133320; c=relaxed/simple;
	bh=zdSJsAzpXKYbFsizd7amQk9mSXkIXnToW0Aoo2ugZz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+4T8DYqGUX0iDrtSXH3KH//t4J82cUXw7NSjCOHjfi5jf+cPhyjQp5RKk7kRSAD8hgOzM2j4GlLRglBV3kgfDAbDbykuaTonDso7GrP6rQTuZ3knYAxxDoDA9ZZzq192lomiXWtYf6xjgiF3TvkGl605RQetdhCVJDvp6Dsk2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3InNGQ+; arc=none smtp.client-ip=209.85.216.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3InNGQ+"
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-3532aa9a77eso2705703a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 07:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770133319; x=1770738119; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kK65Tj9IVkrJuww9j7uGD6NOv9F1ZTbADDJa5OTbK8o=;
        b=f3InNGQ+kTQudL8sZHzPuD47Hv0pRrFGstuQ+Ai/DU1+peVXERCMENkNXC6XsDJZpx
         HlNRQqQoq1YxDqKCdapXWy2hqEeJvuSQ47T4l9wEHdXEVcxkOgXtTsfjCOrciT9aDeZX
         kmtNMmsknP53pyZYEEuvTfb5ek2SOzc9vR7y0qKR2BneqvC4ae8KZI5aFhcmhhE+4EP6
         sSy8yyrZH321TFChIYuPeepQHwTx3DWT+m1HDZd0pibY2EMUUZFSNZAH+S82LWAuZjew
         XjRaIe4Fd6AkrXMKUeqH2Xi4mY07DZdUM8o7SVKxqPmqzEg/6TImZB/rPFNmB2iZ3ZdA
         PjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770133319; x=1770738119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kK65Tj9IVkrJuww9j7uGD6NOv9F1ZTbADDJa5OTbK8o=;
        b=JD7FuUJ0Kwh2jKIRjxsCTJTWby4tZZFe4K4qxNHCnNpfFb2kVPoDMw8vMCkMpnJBje
         uPf7yYK33r536acxJWwe7Joa/9I3lbCH1DSw7fPF0+BrSy70KkltQLDXTZV7/nFbHdNi
         nQ9GbtsLNJywWwuuIXILY2LZemS0p2qGuT4YvOjFpb5OmItB3Zf2ubYEhLvkyooh2IEG
         FwCUvysFSGlHk5qc0RQA6r0o93EqJ0XBb/swE3QK61rXtupGSgbymj/RkEPatsVi19yi
         dVS6Nm3J7UyLjJN+dknXa8mvJA/75RQ2TjECu9bRluoj2wh07mrD1ORUOF0lpYcACTIG
         Rjsg==
X-Forwarded-Encrypted: i=1; AJvYcCXDjFo/3mRR9t+7wu2fkI/cSkdLI9qO3W0iNGz2OSKueCAqzPiq4zGNmfGeDSuONo/b0JM5t8Rirxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyInWlkB5c6AhGI98xZSDSCMo91oiEiXHdqEf2reyrTPBvDEscA
	c4dNU7rygqS6tNjX63T0/XoJWfmORTRtnsdERTTpdftO4mj+ItvbBAv1NLcyToox
X-Gm-Gg: AZuq6aL1yMAFbQJnIlIcD9Q35T9RZ1uBdYEsq9SCDy+ighu6i9uvvC5WfV9FXGvNdYj
	MlBUfXnEqXg4qvA0WntASlJeQf92dqhc1eHwlj22bVlZoesChnMiXTR+f8cIg/S/E1Hleb7EhxK
	QXum0VG8OJRP3pC+cV8a5N/bzKN8/bMGC3T5pREOmi2QdVmqXbYXSuM6qqlri0Ownx08Nfggbnt
	EL9975Wu3eGIAZbs8K0Ly2y0/YIWRV2Bs7NBs9RI67IEBkjk+ayJhr9MSmoJ8QFO7U9SRdbL+nd
	hNBAIaHr5oJPHUPqsZcLHv7maXVSCGHyNZt41Y4dtcZA4ApPab+rmsMKrqOeer6FJ0zfy2d2E8w
	bNZqBasVtFy8BeFXIUScUPOTyZscGFgpM8RRDrIZyp1y35g9SYS6blhc0sFNB75EmAyacuNoEZo
	nRufWqWOCsV3YJ/kYVL72wog==
X-Received: by 2002:a17:90a:c10f:b0:341:8ad7:5f7a with SMTP id 98e67ed59e1d1-3543b3b16b8mr15338767a91.18.1770133318862;
        Tue, 03 Feb 2026 07:41:58 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354860fa13csm14018a91.7.2026.02.03.07.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 07:41:58 -0800 (PST)
Message-ID: <d4941ed2-fa57-4f17-a0bb-afa4ce6d610e@gmail.com>
Date: Tue, 3 Feb 2026 21:11:53 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v3 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
 <476789408083fc88c5fc57eb3e76309439c48a80.1770121544.git.nirjhar.roy.lists@gmail.com>
 <20260203153349.GM7712@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260203153349.GM7712@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/3/26 21:03, Darrick J. Wong wrote:
> On Tue, Feb 03, 2026 at 08:24:28PM +0530, Nirjhar Roy (IBM) wrote:
>> We should ASSERT on a variable before using it, so that we
>> don't end up using an illegal value.
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/xfs_rtalloc.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index a12ffed12391..727582b98b27 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>>   			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>>   			if (error)
>>   				goto out;
>> +			if (sum < 0) {
> Oh, heh.  I never replied to your question about XFS_IS_CORRUPT.
> That's the macro helper to report metadata corruptions that aren't
> caught by the verifiers (e.g. you expected a nonzero summary counter,
> but it was zero) because verifiers only look for discrepancies within a
> block.
Okay, thank you for the explanation.
>
> IOWs, this would be fine:
>
> 			if (XFS_IS_CORRUPT(oargs->mp, sum < 0)) {
> 				error = -EFSCORRUPTED;
> 				goto out;
> 			}
>
> --D

Okay, thank you. I can make the change.

--NR

>
>> +				ASSERT(0);
>> +				error = -EFSCORRUPTED;
>> +				goto out;
>> +			}
>>   			if (sum == 0)
>>   				continue;
>>   			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
>> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>>   			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>>   			if (error)
>>   				goto out;
>> -			ASSERT(sum > 0);
>>   		}
>>   	}
>>   	error = 0;
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

