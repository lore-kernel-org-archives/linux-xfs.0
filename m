Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D687A38F9C
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 06:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761804376; cv=none; b=saPat6hNgePKardtZaf6yhuO6oRnSm8V3dcK+ljw/OJZpeecKWXUTjVOLRcq65ra7oPUFRNnHc0OAaP7N2jRYQkHyG8nGaZGI4l/i+Py62pRbZ+G1bP+am4dzyhMqV67tfoU1IETHnFnUa49o6vsrfOMEJCSCJkcL1EkqkkS8Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761804376; c=relaxed/simple;
	bh=Co3WduJmqlj6a0WZcptz89GyjqkyLxdrimTPL+I1MAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K82/OHowzFXorHl0pllmDwENE2+eLsF9BK9NsOPUfxG+Tb49xA/R0R4TwjGIFQg07oLmDS6nP+cLRKLjtn0FVe28QcWYRFrnCB1D4vfKkiAKVXVF5m3Qzs2aelnnFMkT0XON/KVHAlNcr8YQCdtDvrtsLx7lUzDvfblaJAtOsGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lf3GLsr5; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf3GLsr5"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2907948c1d2so6295355ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 23:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761804374; x=1762409174; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ISgU+Z7qOynGfo6kODX9mwTLmFFt+24ch6KXTkD9/fA=;
        b=Lf3GLsr5fYUUqaPYXWy3Z9GFRGe3+3qM2/LCKeAB+Pe61HXg7Lf1VfJuuwgr577ifV
         NRUsj0AP/9bKp2cwE/mzvCoQ0qfbwV/OK0WGm0LJoS2ucJORuyJA24HDkUK99Ijxtt40
         DZE64H0/2vbehZB06ZPgcHRBtwprDvLMOrI9nbfgGj5AyNWdrP2mRAOZ5Mgd09f8QNvB
         L0lmobg3eLXSHfwe8zEtggw8AUJoA6N6+fIHHsVJAg26GKUE72ZSUbwJHLU5n6G6rcb6
         rYoYe8qnPTd3pGpYKXNou8q5++R2C9udv/YbJ7nZDgAH3Ee393NhLxqsRqDEOYz1upKs
         CF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761804374; x=1762409174;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISgU+Z7qOynGfo6kODX9mwTLmFFt+24ch6KXTkD9/fA=;
        b=ZkmdGySlggr8qXWtgevjx5mXO/wbQZt10mtC3QB/3MzLg2wqErp/7aSHSbcvsuVifY
         kbezxSJzNFP5EZSgKcFLpfxyzgKtA+Kx+wrHbceQu0kN+bX9exVQ+57rYVRdsDEapS6F
         IDdMvnwFmOhzxe5iaJM/VtRxnPzXxKh/PV5KbDoRuIG480B9D5UBfKQb8zNwDtMqxWU7
         aiZFdED+XgSr6FYXPXRiCnw5GiytZRm/d5IVqYS+a57C4SLFTNut+QbcT/OTIZi3VZu5
         fShF3wii7QUAO9b4wCxZXkXhBdkUNN2PUzz7F2CJ1DfiC0tmI3Gig9AXPgHtlcGr/xvC
         dXxg==
X-Forwarded-Encrypted: i=1; AJvYcCU2sxcX1PvNpqrklz+d+eCaw6/TywVcmspisO/VzkC2F25XPcrySsFO5Af22p6miprVYWLHX+yMOEo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwoKaP9GPyDeHtBSk6UUm3TapUZegGAkaKUpbfk3kRF9kHJ/DN
	PdlmP73dHrlJfcmvXnwuHGpIFSTtnhJaPn0y56/Vyt6mFcT7Ao46h2Mg
X-Gm-Gg: ASbGnct+VTnThCOWwjXLte4TEJ2c3mY292vnrOeyp95tnEMry0XUdQj97QYFJqHit/I
	/uyNFlNsOn/r7yyfoKW0z8H6TtQPxerk36ScVD2MkfiHYyF2leI6pgJyabsfFHup4W1Hatx4yql
	FUB9/OLtoJA9z720gDW9z5crZcTpV5JFXvHLQvdUDXrxDNrANSbEQbecd1+Z4ILtXo7cIOIsqFC
	6qKWSj8wEHg+86r6FQ3mwTqEpM1nh/ZElf0ijaMZUujVhbJjuriIFH+JOl0SCy2pfKqOKKAJn+J
	nPUBS+rdcuaAGBU7rD099GrAbP9lR4wYvAKWabVFQ1hRPvPkkIY7AxcqbvYnRFlq13BYlJBfiDZ
	gtyVvn5ExxU1/jgbjsySwbc/iix6JsKIkSvWHd5bu219zdBin+utN/e1WiboRvWiaHJ8g3hj5Pu
	jCXJ8ESy3aY2vYlI0HrIIu
X-Google-Smtp-Source: AGHT+IH26giF2tZf1kqYCHLQA1wMtSI83utEVy295P8Jg8Hax8faMFl3TNMp1FYAIfc+LrhyF+phNg==
X-Received: by 2002:a17:903:2f88:b0:269:7c21:f3f8 with SMTP id d9443c01a7336-294deedaf68mr69542345ad.39.1761804373986;
        Wed, 29 Oct 2025 23:06:13 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d09855sm172524915ad.30.2025.10.29.23.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 23:06:13 -0700 (PDT)
Message-ID: <29bde62f-344e-4f5e-bfa7-43daaa8d5c49@gmail.com>
Date: Thu, 30 Oct 2025 11:35:33 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
 <68e2839c0a7848a95fa5b2b8f6107b1e941636a4.camel@gmail.com>
 <20251024221047.GU6178@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251024221047.GU6178@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/25/25 03:40, Darrick J. Wong wrote:
> On Fri, Oct 24, 2025 at 01:14:29PM +0530, Nirjhar Roy (IBM) wrote:
>> On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> On XFS in 6.17, this test fails with:
>>>
>>>   --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
>>>   +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
>>>   @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
>>>    Can not set fsxattr on ./foo: Invalid argument
>>>    Initial attributes state
>>>    ----------------- SCRATCH_MNT/prj
>>>   ------------------ ./fifo
>>>   ------------------ ./chardev
>>>   ------------------ ./blockdev
>>>   ------------------ ./socket
>>>   ------------------ ./foo
>>>   ------------------ ./symlink
>>>   +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
>>>   +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
>>>   +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
>>>   +Can not get fsxattr on ./socket: Inappropriate ioctl for device
>>>
>>> This is a result of XFS' file_getattr implementation rejecting special
>>> files prior to 6.18.  Therefore, skip this new test on old kernels.
>>>
>>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>>> ---
>>>   tests/generic/772 |    3 +++
>>>   tests/xfs/648     |    3 +++
>>>   2 files changed, 6 insertions(+)
>>>
>>>
>>> diff --git a/tests/generic/772 b/tests/generic/772
>>> index cc1a1bb5bf655c..e68a6724654450 100755
>>> --- a/tests/generic/772
>>> +++ b/tests/generic/772
>>> @@ -43,6 +43,9 @@ touch $projectdir/bar
>>>   ln -s $projectdir/bar $projectdir/broken-symlink
>>>   rm -f $projectdir/bar
>>>   
>>> +file_attr --get $projectdir ./fifo &>/dev/null || \
>>> +	_notrun "file_getattr not supported on $FSTYP"
>>> +
>> Shouldn't we use $here/src/file_attr like we have done later (maybe just for consistency)?
> Probably, but this test has (for now) a wrapper so I used that.

Sorry, which wrapper are you referring to?

>
>> Also, I am wondering if we can have something like
>> _require_get_attr_for_special_files() helper kind of a thing?
> Andrey's working on that.

Okay, thanks.

--NR

>
> --D
>
>> --NR
>>>   echo "Error codes"
>>>   # wrong AT_ flags
>>>   file_attr --get --invalid-at $projectdir ./foo
>>> diff --git a/tests/xfs/648 b/tests/xfs/648
>>> index 215c809887b609..e3c2fbe00b666a 100755
>>> --- a/tests/xfs/648
>>> +++ b/tests/xfs/648
>>> @@ -47,6 +47,9 @@ touch $projectdir/bar
>>>   ln -s $projectdir/bar $projectdir/broken-symlink
>>>   rm -f $projectdir/bar
>>>   
>>> +$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
>>> +	_notrun "file_getattr not supported on $FSTYP"
>>> +
>>>   $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>>>   	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
>>>   $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

