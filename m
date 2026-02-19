Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FCE41A8F
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512627; cv=none; b=mDXRkMmaUeflqPTM0YkH99N8UAmEjX0L0IVszaHg7Y7/fiP2G+tv+NDYsMAZXA2+9N661zlvPVk39r5E9qn6xmNJxqjHoINW7QzBc+bvePLX/VZEcuNEtwl0WBDd1Ih8HLIOoaY/fWnzi0EOazEG53y7p1QeywTYPnzNJspNfnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512627; c=relaxed/simple;
	bh=gf6E7bobh4NargGLKJiii5c/q65Olqg7xMpGfuPGWJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKx+qQ+0s9H66JMvl4/6f37ye3fcQGQMR7AqM2rtrItEi/+oJwpvRfGB/Xl3X+VexrsEcY/WVwx6anlnoXsxDGK6LzOT6D97BRp9wItdcjqJtCcfTVoqOIv20A6A7LIbqjzGQxXkHrb+XZxqiNtdCB+mKGxqvTeMlngr9iNJ0yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iwhbq1jh; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iwhbq1jh"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad617d5b80so3824115ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771512626; x=1772117426; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xiTZ2cmbtRtOUHflzI8vgvHD6jvCdgAiI9yvzuu9kAk=;
        b=Iwhbq1jh9V41maOmIhnV2neMZwZ8/xwlIkMtnCXZe+TrBaPcs7YppwOhIFXaC8TiFo
         /4C/gNhL6tyFakIif7ocHURNTklfbIseis6LJjwgHJFYJnZ3s83FQcitw+/77lyf460L
         4U4ZsuCLo/E0dPhkFS7YzL8XNULIo0iI3JPIFqWs72pYZYy9/hHR2poDtgL+L/GCCjSR
         +3ITc4JvhPCbwZT+rx+e+HBUQOYjRwQukKIr3yuq+h7lc855Igb+4aCdAvFmcDNNBGGn
         PrhH58uRptFCLDW8aK8iUzqfNUP2wkBZYWvHbaDtyUYJvmVs3EJkXkmVo9O+YYRKYHlr
         2/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771512626; x=1772117426;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xiTZ2cmbtRtOUHflzI8vgvHD6jvCdgAiI9yvzuu9kAk=;
        b=Ux+eN5LQs+X0eKORYRMLbT+tl4RTzouCFG2rmbU2dJ8jPZo1bicLZ9USmoBKUfzBDK
         VJiJf7jxjtl0yxMJ+wU+YwEFeE6l1on01hWL54oc4NdrRtvhBfpGkcWOAHTp+JVx8VJS
         7/aoC25CYcs8Y2yZBxi6ZV+euRvgsV8BpVc/QiLEhG1yEpqPtsdkHK2TOdS6A5HSc8DJ
         yPhBH1YZgrQfDi/mqxloOiQrXRvfNIox79ZMYFudOixoWJH/nUsVB49DfPCkt+EgDxoX
         NHZBFG/8eJCDa8A/yZ1jX1tgGgVjAlFhLOzGdUWijnAxwTcubSrG2vouPYGvXU6v9WZt
         VptA==
X-Forwarded-Encrypted: i=1; AJvYcCXphCVFbXHeAi2Wy+QZNxGmkBMHahEslWQd4f2dI80kMT+xP7M1+TR7DnuTgjVVeATitACVvmntr+o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk6G37S2PE6ip6a03tnq49dKQKC45BA/2zyeeoT1fnf7Q5nlRx
	DwSlpIjcHEX5oRjio2C9Ab2RpWlBmk2KxLWgbMY/xJqLUwZ4X0Ht4JkZ
X-Gm-Gg: AZuq6aJsmvAyfdvxaXGdJFBuBCtk9ki8geXpCmQfwN+/89xLtLf4CXClgRbncVVem3p
	qiLNThR3LCdk5nM5Q60FnxYlNf1WTWSL0vzkBkoLRXgpjPJPhnKs6RE+RSgoKhqfjPXNO8Hs+al
	SHzyBC47nhtbV4jS7lnCVP+w8lmnSOZHC16NvKOi4AKF619ADcK8Msd1DnIvNhqjfJXpr1cN8GK
	8y63RWavjNxwg4KVwfHI8SUgOjyaznXpUw/57GAC+hxKLTbySOiBTVBuq8IFxTXmd+vxlU0j4hH
	VVttfp/o6bqEZNraOLqxfVZLN5uEUPpethjQ4dYV83MsCg4QwXmcWjzip7GSOaRBjoSOLLuJSeE
	H5gxdPaIeZ+506pBCW1Dtbv/Tit+pu91BLIyPUZUkKVxqVnxk094DxK72M4JLkKV0ARsfi6ZsjR
	DpMIOolc3dQVYzI9x3+WMXUnod5O7WFqUjZiHfVg==
X-Received: by 2002:a17:903:2445:b0:2aa:dd98:197e with SMTP id d9443c01a7336-2ad5b16c9a6mr23717035ad.51.1771512625982;
        Thu, 19 Feb 2026 06:50:25 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm167728575ad.36.2026.02.19.06.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 06:50:25 -0800 (PST)
Message-ID: <771efc3b-43bb-4838-9f9b-47341292cf35@gmail.com>
Date: Thu, 19 Feb 2026 20:20:21 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] xfs: Misc changes to XFS realtime
Content-Language: en-US
To: Carlos Maiolino <cem@kernel.org>,
 "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
 <aZcRxYYpo-DvGxrr@nidhogg.toxiclabs.cc>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZcRxYYpo-DvGxrr@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/19/26 19:07, Carlos Maiolino wrote:
> On Thu, Feb 19, 2026 at 01:08:48PM +0530, Nirjhar Roy (IBM) wrote:
>> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>>
>> This series has a bug fix and adds some missing operations to
>> growfs code in the realtime code. Details are in the commit messages.
>>
>> [v1] -> v2
>> 1. Added RB from Christoph in patch 1 and 4.
>> 2. Updated the commit message in patch 4 ("xfs: Add comments for usages of some macros.")
>> 3. Updated the commit message and added some comments in the code explaining
>>     the change in patch 3("xfs: Update lazy counters in xfs_growfs_rt_bmblock()")
>> 4. Removed patch 2 of [v1] - instead added a comment in xfs_log_sb()
>>     explaining why we are not checking the lazy counter enablement while
>>     updating the free rtextent count (sb_frextents).
>>
>> [v1]- https://lore.kernel.org/all/cover.1770904484.git.nirjhar.roy.lists@gmail.com/
>>
>> Nirjhar Roy (IBM) (4):
>>    xfs: Fix xfs_last_rt_bmblock()
>>    xfs: Add a comment in xfs_log_sb()
>>    xfs: Update lazy counters in xfs_growfs_rt_bmblock()
>>    xfs: Add comments for usages of some macros.
>>
>>   fs/xfs/libxfs/xfs_sb.c |  3 +++
>>   fs/xfs/xfs_linux.h     |  6 ++++++
> Please rebase it on top of current xfs code (preferentially for-next
> branch). xfs_linux.h has been renamed during the merge window.

Okay, done[1]. Thank you for pointing this out.

[1] 
https://lore.kernel.org/all/ed78cfaa48058b00bc93cff93994cfbe0d4ef503.1771512159.git.nirjhar.roy.lists@gmail.com/

--NR

>
> Thanks!
>
>>   fs/xfs/xfs_rtalloc.c   | 39 +++++++++++++++++++++++++++++++++------
>>   3 files changed, 42 insertions(+), 6 deletions(-)
>>
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

