Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF3F212FB3
	for <linux-xfs@vger.kernel.org>; Sat,  4 Oct 2025 04:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759552271; cv=none; b=Ft5hm4WYixSwCKQo8Db6Wn839l0CLfHs0v0dj+PBpThIdeGYc1gqj3uYHjJq9UMUDX/gh++V85Wyl0xsfpJ5el0MlhDPWZ4fIpv0BI3+m8Kwsb1aQgh4b4yQUEBgOcrZFAOBk/ibUVjRjcHj5boVbLarZgMBo+P2dzZlF5XEQgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759552271; c=relaxed/simple;
	bh=enoINwlA9+PevoMLkOQfPIAcWmrKh+doHnEubrvsPIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=se6vBQIyGqvKGF3vQ6d/Slcye8TmNRfE6oo5cHkMWnqdA3NC7Y1i2cVsyXd1Z9yn3FEEVDnHTTspPhCbVj/IQic7i3XSyzP6KQwVk2JnKUFbMuJcDqGGY/H6r8HJ0f1r8LxwR5xO2L+B7LIAaFzW2OJgltuLgrpnnLj6lzSlKA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNluNx03; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNluNx03"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7811fa91774so2420116b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 03 Oct 2025 21:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759552268; x=1760157068; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=StwDBKa8ZRSfrd7VD6MhCNqBvOmQ/m+xhmau3mnSCHE=;
        b=nNluNx03FQ5vYhQMHrgA8/vPRPScDDajqnNVNYS0jm2ld3ie4869R/szYqKIg4i/K/
         6D60GvxXCvd+Mgebdcs2V9VIuXLGqaEwGASbNLRHMgst39FzOMCwd15sw9IjO6QgzBUb
         DLzi+mBRzyB6m6bRfnyO/O+23K4JlPsOS3FHDy6wh6ZXJZao0/H4lhzi4vxRSkfBYema
         KfjLNVY5NMtsqvagPTAVR2iKsktEj+nQZO3YvkyAFbXp9DhpCDq9Wc8OKqa8qqCeEsl5
         mVhlR5h1uul5mfBU7AsBEZX2znYqX15CcE5N7xSPnXmyH56GiSHlUBGMJiHCEccQ+wF9
         N1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759552268; x=1760157068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StwDBKa8ZRSfrd7VD6MhCNqBvOmQ/m+xhmau3mnSCHE=;
        b=Gi/pnW1r62UtsjMW/w0h+ToOt7Bn+u9gF8GeRbrEnu/+LmsY7WJmYAZS/BKKBwHFvm
         nhRiy7T6MVsvHqwHh3cYhi06UskDJ5003oDxio1njQLpYiyW07eEYYId21BN557pB9xI
         XUbx0VtSiOnpBHy8j907NekStpEe2S7mQX9N8IVxPrCyZaTJJwTSqJFycHiQe0J+rofC
         6+/+3CzYJfNm697gOKIvH8azxJ3yhR/0mIXdmrYN4kiwQs3825JY0nMfp5BCrAGgI9L8
         SxswkESB6PMaKHm2KPWziy3OjQnOuD+LWWuTmHAFSouCj/CInCpgDOqN0Omq9a1O8A3D
         JT/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVI0FiaumUWauHa4+kObgbRT+CiWA6w4+BkYfmW1uxTSs5PcBvqO2+kWj/IOi7jzGeZya1lvO+WdQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdMmOhJc8ss9CV9uikGvatvc+r4octD2SvO4wGkNUrURUGNFHq
	dVvFl3qEIwBiBrob14FQMjP6emJs0+6ajI7Olq2YJiilMSMm7V8uMTrA
X-Gm-Gg: ASbGncuWGfy0m+UOCyGTchBZanp5Q9ciZAW1+7lUELogjfRn6NTKi0gkSSA+Gt4GCcy
	EZid8Cmn4rxOPWu5DzZkky7+X2kGYwkuSSCdFtLGpyPZYXon7bjecMlzqCh6bzOFKur3lWD2cah
	re6cUYpk0/qkHNduUYM7nw6bNKwGK20z9AvilSLfxNuGCrkFaZlHCpZuRd3lJNiJYQFcmkZFBF3
	gOBGTvSr4XnopcoXrvM4w2iziusafHjOn1gJI51MgIAjGfy92l7BdZAjs9L+Xf4E1ENY5aUDn5o
	F8sMZJTaNKLF1BX07diTupBAfWzz4FffldldPZioHXFlEkIW3N0qnsjr6cMHnBaKxuGe6B3nQSh
	AlX0ga43SzIrKc4TJOVN6JiHHblFzWby0VaBHiKyaGOxiOityCnH4oVcItj8K6DAJK45ndVY=
X-Google-Smtp-Source: AGHT+IGFVdu0idHFioNc6W6G3QpB4+em7I6xbQXdwjM7auYWjIP5jrn2CpWgS3aswdOPecIYETyQ3A==
X-Received: by 2002:a05:6a20:72a8:b0:2f6:cabe:a7b3 with SMTP id adf61e73a8af0-32b62107c29mr7468985637.50.1759552267731;
        Fri, 03 Oct 2025 21:31:07 -0700 (PDT)
Received: from [10.0.2.15] ([157.50.90.152])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b01fb1b73sm6413167b3a.28.2025.10.03.21.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 21:31:07 -0700 (PDT)
Message-ID: <9a7072cb-840f-472a-9e22-a5252e52ef48@gmail.com>
Date: Sat, 4 Oct 2025 10:01:00 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: doc: Fix typos
To: Carlos Maiolino <cem@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, linux-bcachefs@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com
References: <DrG_H24-pk-ha8vkOEHoZYVXyMFA60c_g4l7cZX4Z7lnKQIM4FjdI_qS-UIpFxa-t7T_JDAOSqKjew7M0wmYYw==@protonmail.internalid>
 <20251001083931.44528-1-bhanuseshukumar@gmail.com>
 <kp4tzf7hvtorldoktxelrvway6w4v4idmu5q3egeaacs7eg2tz@dovkk323ir3b>
 <yms8llJZQiWYVxnbeWEQJ0B_S6JRxR0LQKB1FwVe0Tw66ezuA-H1qZVCyuCUDtsw7s7h4jHTwTh98XivLW3vvw==@protonmail.internalid>
 <425ef7bd-011c-4b05-99fe-2b0e3313c3ce@gmail.com>
 <6t4scagcatuba7hjy4aib5hqfgyhc4wofegr2jrl34wwa7fsyq@5uwpzmpixm7o>
Content-Language: en-US
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
In-Reply-To: <6t4scagcatuba7hjy4aib5hqfgyhc4wofegr2jrl34wwa7fsyq@5uwpzmpixm7o>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/10/25 21:22, Carlos Maiolino wrote:
> On Wed, Oct 01, 2025 at 07:19:13PM +0530, Bhanu Seshu Kumar Valluri wrote:
>> On 01/10/25 17:32, Carlos Maiolino wrote:
>>> On Wed, Oct 01, 2025 at 02:09:31PM +0530, Bhanu Seshu Kumar Valluri wrote:
>>>> Fix typos in doc comments
>>>>
>>>> Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
>>>
>>> Perhaps would be better to split this into subsystem-specific patches?
>>>
>>> This probably needs to be re-sent anyway as bcachefs was removed from
>>> mainline.
>>>
>> I just did a google search and understood about frozen state of bcachefs
>> in linux kernel since 6.17 release onward. It is going to be maintained
>> externally.
>>
>> Thanks for your comment. I will resend the patch excluding bcachefs.
> 
> It's not only bcachefs. But most of subsystems and documents you touch
> have different maintainers, so beyond removing bcachefs bits, I'd
> suggest looking at MAINTAINERS file and send specific patches targeting
> each subsystem. It makes maintainer's lives easier, at least for me.
> 
> 
>>
>> Thanks.
>>
>>
Hi,
Thank you for the suggestion. I will split it.

Regards,
Bhanu Seshu Kumar Valluri
