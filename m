Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24DE340D91
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 08:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207207; cv=none; b=gJEt6Cdk5ommy9IVTxEFqi7FG6ViNVQja79r21kJRkBo/JxHCxf0NKVm27AKYxt0/bd1W4gY++V7myunSioM41VBQ9JzTK9c45J4n6cXrTmugIvsx7KNRAO05Hy3UUz77uKwF3U65+NWdyvwewJnonrFujz9AaRMTswTicrbfo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207207; c=relaxed/simple;
	bh=mk1PYn9ZCos0Aodqn/zrjYsdqZ5Db1tajXBnpL1haL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HD1zF74cx6HdlYfxXbiN4kcDvEqfLdmlpFbbi/5jLOCtrxMP2A/FyrZCszCS9BLZPhovZsjA/FCIWooUWd8SXgITts1aCgX7LfPq47t8DMwxs05SJA/5YOGXXfSZlmupFI1sGdmy4qQIGHoKUiijL1rsNAvhFQBuVQ2NXjDmNe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3P7/p3w; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3P7/p3w"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-81dbc0a99d2so1315174b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 00:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768207206; x=1768812006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tU0wQjiRm2BYbqGoBRaETp4TyN4fHsJRCq3BTqCggdA=;
        b=j3P7/p3w+XHuu93H2j6gif2zbGoOomHZMyYayXHQI5/A28Mm9CGeulu3MXZrxAsiyT
         epdjIPke+vekd7GzHvlyKKYctNCbuUCzPhaDgLpHJbh4JDwvd6GS/he1Q7z6QieYuyRj
         V3c1KZaducfmZisQLq0fdS/euFCPEV1YUc18wgs676U2vo0pLFvGGhK9O0UFKeE+ahyQ
         ZJtjbWB8o208y5OjKcMVydHDMs2MkRYYc8kqI+s4zwBQDk+XRfUVySwc/Fbfj+0wyJWl
         Hsu55YKT4aMVKnBk/1nggxe0ext+TL1e6rR7jXLEkLraaROpiOQnlBT0KorRM0uXgKNF
         59cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768207206; x=1768812006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tU0wQjiRm2BYbqGoBRaETp4TyN4fHsJRCq3BTqCggdA=;
        b=n/4GAeOZ2Y7rwCeb8aBHON3ZW4eS+XsPwBMOd7RH6jGW2UI7DAsdn6aMNP2NRn094H
         cBdCKXOplHqqLGftIBd7PZy2DOs4QTvUdK7Zz5F4ZQyk1RIDa3ctXAhWsyulDPiz80/W
         SZ9wNawU8aybPvnLZdiJfrVp3WwX0f12K2CgQ/PQ9zS7udfpY5U972QDV0dgQsaU5YxF
         nIp5wKRUFgcrKHHsNt6Q6ol2i3T9dxxlnjw9BKlshQayohVcAKIvgpyqECVKo8UKcduc
         Wl+Hsfn2GB4u1X1C4Jcx0k0ybQ3ijQOYRqQv+HUH56+8NHhvfDcPPN9eUN8PfSszGZmS
         aD1Q==
X-Gm-Message-State: AOJu0Yz5QVBoN6QwvWx7GzxyJruZ1wQq2rV21hsvdQ5O2igsNDx0CWMS
	cd4I/YUrE2QcVHIT7jd8jiOqhTcoUYIOwSa3Rh9pLfwlrwfI0gJxiQGxoyzeFw==
X-Gm-Gg: AY/fxX7Cm48KoLeh6ywNUnLGwl2f3QnK42Md1zccp8kKn7vOYEZPSdJb6T7HF1MFxHF
	UTCtUQQM3Zpm1/PIaGwXtT096QG/3vbYoOF/71Q7sLs3XVdf0/+A+T819ABYws4HgbHcwOE4hFD
	AmNthHFqu6l3dw09vAcFR3jBlUBg41yEpJOq7hR7sSNRwlrwT+4L+P6H6UVs/OCusFeL8gcwnlu
	HDVbPmTKTb47dVNRnWQfj9rSqh9ZLp3meTAQEa8y5M6Kqh3j7+vY67MAWJDwcjD9qYsfDkU6yTN
	14YFPzCOdEv2aYzel4eD5LH5J47/DZgXGITKJDs9J54jd48VdOM5OI7KyRfJBccJgY2vhKhRCk1
	OAodZg/tHlhB7tVhQKY4zVSkiK/fN3SkZ+fAUcW2sLidpeloN8301dEBVKUYxtlZ6ReHcE617Ls
	2jziLvcVu/kU2SiPnpCgKdSA==
X-Google-Smtp-Source: AGHT+IFbjwhiByHe21oyRNxTDNpmOPtHu9tPrKBkyGL6O0PH958/DIrvvdl1Ov0qvU97NXLuWGX+fg==
X-Received: by 2002:a05:6a20:a11e:b0:366:14af:9bbd with SMTP id adf61e73a8af0-3898fa11762mr16153809637.71.1768207205680;
        Mon, 12 Jan 2026 00:40:05 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.254])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c50347bc321sm14533111a12.18.2026.01.12.00.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:40:05 -0800 (PST)
Message-ID: <8316699b-5ba4-402c-a0c0-17cdd0838347@gmail.com>
Date: Mon, 12 Jan 2026 14:10:01 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs: Fix the return value of xfs_rtcopy_summary()
Content-Language: en-US
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
 <aUONoL924Sw_su9J@infradead.org>
 <d9cc2f24-6c06-41ab-835e-453a4856fd0b@gmail.com>
 <aWSryrkF2_6oxU9f@nidhogg.toxiclabs.cc>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aWSryrkF2_6oxU9f@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/12/26 13:40, Carlos Maiolino wrote:
> On Mon, Jan 12, 2026 at 11:43:53AM +0530, Nirjhar Roy (IBM) wrote:
>> On 12/18/25 10:44, Christoph Hellwig wrote:
>>> On Wed, Dec 17, 2025 at 10:04:32PM +0530, Nirjhar Roy (IBM) wrote:
>>>> xfs_rtcopy_summary() should return the appropriate error code
>>>> instead of always returning 0. The caller of this function which is
>>>> xfs_growfs_rt_bmblock() is already handling the error.
>>>>
>>>> Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>>>> Cc: <stable@vger.kernel.org> # v6.7
>>> Looks good:
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Hi Carlos,
>>
>> Are this and [1] getting picked up?
>>
>> [1] https://lore.kernel.org/all/aTFWJrOYXEeFX1kY@infradead.org/
> Hello.
>
> I can't find a new version on my mbox. Christoph asked you to fix the
> commit log on the patch you mentioned.
>
> If you sent a new version and I missed it, please let me know.

Sorry, I have re-sent it now [1]. Anything about [2]?

[1] 
https://lore.kernel.org/all/9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com/

[2] https://lore.kernel.org/all/aUONoL924Sw_su9J@infradead.org/

--NR

>
> Carlos
>   
>> --NR
>>
>> -- 
>> Nirjhar Roy
>> Linux Kernel Developer
>> IBM, Bangalore
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

