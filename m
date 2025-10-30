Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7432E2765FF
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 06:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761805924; cv=none; b=PI7I6BbOMaxVLbJq4X84ioGKgFS3zXCq9dmm2Zfzo8MtZUwks+qWSZDU6j6XUrqlO64kg7Pq4GdtNkL7DxJkVf3pBKIlBoIUb0sPP4npGh02ldKSZbgwZEN6z7a+zpqHvo0Ei42Q+ZspN0fdhq1Sf6kIjufo7GuB5CbXtFYhYbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761805924; c=relaxed/simple;
	bh=dYSvFIPBFM4r0TEHOR/C/Iojck8LOaiBdpH8UiFQJ68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d92jTQGkDrgnc1I/8VDnXwDuTUTtECox8uxL77I2XZ5vSHJvgWzxd2kQWTBHAzSB+8pvcPu4VHR17rLlS29GQS4ZzSnjUjfPFPORsoyzdN/IPuEGtdjvexrEQqTN77wyqwmQseR6DApwjthSam1DX5UoLXgdxxvo1LqlJmcD6/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFUpLx+M; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFUpLx+M"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-33292adb180so812967a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 23:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761805922; x=1762410722; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XbGlIO/WqbIsS3YHDtXxQSgN2NANEnC+kk3Kx7VIlL4=;
        b=CFUpLx+MlI9fP957SS3VVZb8L5S1a2KtzUGJADroyH4LGeoF5gJ+Ha+o9B9PDKgodS
         v0BbqiJSm3flKznGZGsKgzKS9pNp+pC/yVHJIR14Z+pNx1OnDVeJtjeC8HFjrlUhUljk
         NcGmEyW+hvhZn8Q/hs3fRcPI/O4Bmb+JkrOB/6oNOfSvxi/Kc88XRMlBzkhnJ7D+gvx1
         ZXM8/eoSseDIpbnpqDDyagH7IsKweZkAtppJ4V6aXoj2drnzveXfCWkC0FdMrf/DryPO
         BnCvSS30Q6qtRlLVDd1IWdEyZMUWFWjo3fkzVNiQQ3uRdT+uBuNt9rvJU10f5xugJBRn
         SIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761805922; x=1762410722;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbGlIO/WqbIsS3YHDtXxQSgN2NANEnC+kk3Kx7VIlL4=;
        b=Ru57QroqA3YzZfp6xxYBHQDJwWaBM4g5cYnI3zt8ux/gouVQU3ZZ1i77RJlEaMXuGM
         LK/s/GZfyZfhJI0jYrIZ6+hJbI3OgcOIKVJsW8GnFrLg1hSFlwpeVAlUdPVbWx0QKcvz
         jJIKUuCQVNQFzWfTbwp/a8ndNyF4svweTZjzwooNAWzbAs1n3g+9u+RvSkD4RXo7fPny
         zCyz+7xhWpwm582V+6aP6QlqxX1y8AN8jue8ooQEvcf3QK6vwygpKlxot6ZqL39SRyoD
         rIWEyoZIXXPv/sQ7TiAMABf7khwTGf93OAbTeAT7e1L6wr+PFBSHzDYCBhjBVco/6uT6
         sPpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVVyTvte2gwSippNd8rL0OowKO3kGGwzeTwWv0azwtTYrxciIt1n4gLWwr4jrMDZ+dJ1aVU39MJ1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAqczICaCKwJFY0Tw+uT7lPVON1Qque2aZWGvRVfQUDntJzXAe
	vuRCJ0gK4F5fnhZg4D+YSxsU22KYmABEPXTH11MYeV5MMvn9Rxu0lmRLuY9XXQ==
X-Gm-Gg: ASbGncsFfAtMhsyLoeXkqIAtVe3PSTAltSvcY+MjYR8+JvUOY0BTpKGCvFTHtaFeuVh
	IKf4cYjAsVGIq7zuxFWDnP7u8lM8lu1p4JRneoBpfJcEooczeHJnYkEtd5UPxVMmLnfdoMGdxGj
	0g6SxgcLWkqd3ZNqitHDrSInNu0mLogqQp2tL0K6hC77cnlU2mk6R10t9aDTYGTI5C+WjgcaJ3B
	wKiOzEpbQGi3AphOrq4u9RgTvqQmrpM+Y2Wzqsg/DkK3+z+A72VQhWYG03/vM+p6ftCx/5AmvMp
	jEy50vdte1gmvT1/FUgkeryldzmksGhPAWq5oARC028uUGxCYpYUmTaZFqCtO23kJtcSbFNeYk5
	tPfXItEvwX6OSHPTnybBKmU5ckz6EYPbw2+siD44cq2T2PFsOJrnFLh9syrk8IxA8ZJXnsMb+1F
	EbB+1tX8UrnSHePfTmq4Fj
X-Google-Smtp-Source: AGHT+IG6TUiZ4yrrPvF+Te7+3xwc+BD5DKsHiZveco6F2AKCGhYg0qhi7ON5o7YgHoR4mKmEtOawJg==
X-Received: by 2002:a17:90b:35d2:b0:32b:94a2:b0d5 with SMTP id 98e67ed59e1d1-3404c571a7bmr2881869a91.37.1761805921527;
        Wed, 29 Oct 2025 23:32:01 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-340509801cfsm1256828a91.1.2025.10.29.23.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 23:32:01 -0700 (PDT)
Message-ID: <4b0ac18d-bf87-48d5-b3df-528fb18dad9c@gmail.com>
Date: Thu, 30 Oct 2025 12:01:57 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] common/rc: fix _require_xfs_io_shutdown
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617932.2391029.3304833304093152893.stgit@frogsfrogsfrogs>
 <ee99fc234ccfc433662975d45f24c8900428e2ea.camel@gmail.com>
 <20251024220849.GM4015566@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251024220849.GM4015566@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/25/25 03:38, Darrick J. Wong wrote:
> On Fri, Oct 24, 2025 at 01:01:50PM +0530, Nirjhar Roy (IBM) wrote:
>> On Wed, 2025-10-15 at 09:37 -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> Capturing the output of _scratch_shutdown_handle requires one to enclose
>>> the callsite with $(), otherwise you're comparing the literal string
>>> "_scratch_shutdown_handle" to $SCRATCH_MNT, which always fails.
>>>
>>> Also fix _require_xfs_io_command to handle testing the shutdown command
>>> correctly.
>>>
>>> Cc: <fstests@vger.kernel.org> # v2025.06.22
>>> Fixes: 4b1cf3df009b22 ("fstests: add helper _require_xfs_io_shutdown")
>>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>>> ---
>>>   common/rc |    7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>>
>>> diff --git a/common/rc b/common/rc
>>> index 1ec84263c917c0..1b78cd0c358bb9 100644
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -619,7 +619,7 @@ _scratch_shutdown_and_syncfs()
>>>   # requirement down to _require_scratch_shutdown.
>>>   _require_xfs_io_shutdown()
>>>   {
>>> -	if [ _scratch_shutdown_handle != $SCRATCH_MNT ]; then
>>> +	if [ $(_scratch_shutdown_handle) != $SCRATCH_MNT ]; then
>> Yeah, right. _scratch_shutdown_handle is a function call and should be placed in a $() or ``.
>>>   		# Most likely overlayfs
>>>   		_notrun "xfs_io -c shutdown not supported on $FSTYP"
>>>   	fi
>>> @@ -3073,6 +3073,11 @@ _require_xfs_io_command()
>>>   		rm -f $testfile.1
>>>   		param_checked="$param"
>>>   		;;
>>> +	"shutdown")
>>> +		testio=$($XFS_IO_PROG -f -x -c "$command $param" $testfile 2>&1)
>>> +		param_checked="$param"
>>> +		_test_cycle_mount
>>> +		;;
>> Looks good to me. Just curious, any reason why we are testing with TEST_DIR and not with
>> SCRATCH_MNT?
> $TEST_DIR is always available and mounted, whereas SCRATCH_* are
> optional.

Okay, thank you.

--NR

>
>> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Thanks!
>
> --D
>
>>>   	"utimes" )
>>>   		testio=`$XFS_IO_PROG -f -c "utimes 0 0 0 0" $testfile 2>&1`
>>>   		;;
>>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

