Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D3722AE65
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768198439; cv=none; b=hqDzGChtzDB53717SzPUHwFPa4lQgf8Oq78fJ6KS8dIUzSVdbIM/x8xjNFWfO9e2BK6AEBJQ/jtAAqIfyAR+GYuUJaKxnlWlsTWXRWeiRy9CVHJnyoxkpyZF2umfoXTkwBiepsrkJvPTWKtfEo/wS6gEu40uiNYQX4wUUc1+T/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768198439; c=relaxed/simple;
	bh=PF5vp/hsdm0ROKPAv0eltKL2bWReUj9QgtHHkCKO/E0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNSUjnybKxtyKYj1/xNSXih/g9lSbAQzglDdNVhhRBObN2yNRflfuurY2OhNELKBH7gydDIC9Xyb7pq4+94AdVOHVsNQ95XTsB48aatZzmTyxyq50DsjaT29tR0nPOePgcG5e0wmZs/qlzOWemQ8sFNW0XQ0KuGKaFg/NE22tlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFUnviN9; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFUnviN9"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-81ef4b87291so811602b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jan 2026 22:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768198438; x=1768803238; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PHtZBvdEEODCk02OScdRAPWrC3R+qMe8cwBuuBnEPAs=;
        b=bFUnviN9+JEhWbVtFeXK+EUKqeEyWwqAr/XNbXCmOAPnFwf8wyUfnlH4mCN55Igdi1
         L5l7R2XbEWR5U/+JkMJMkr+Q90CAqArPEXuamMqTmblW0oCCSKcExAPh0ySl0Lp8Zpcz
         oQ5tTunTrraBODGJSAiA7b7OJ/rMW5MX58jWNno0o/6M9zFWM7KFSFSjAPEo/WhRzIRW
         EBHaDytFusOrGOKnFgM5ttMMUsE8LS3C77GN94Qphj4tHm3Q7kvpHSDrZAx2SXOtvpCZ
         Baa3JdIEkxt6a15KhSoVwNQwhIIpSTqXqBo4GL9poaFE6nsBDmFVzTp807p3iM6pfy3Y
         yBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768198438; x=1768803238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PHtZBvdEEODCk02OScdRAPWrC3R+qMe8cwBuuBnEPAs=;
        b=j+RWExkZFDjwaX4MOLpfh+mpneMuypUH9vz9QXOeF3lbiI0+snnA232gCtsvDWTjQi
         bP+rZ580yTyeNmNMaOqSR16cs2opMo2iK1ZzW87ntyAgxFTJtjBBNjcshwqTaDBHfVrs
         rr809p7cQFnKt3huSAGmX9I+HcGJqFmurNB4kkrrAnT4mE4z8Jw5rSHrJMUYHSDgwDmF
         4QTuU9cRdS23qDHSCFexdGzJl+jXcBtYbiKQMoxmFuMN5Awc1oMTfPSa6JNMrmsGITkt
         GzTKEljzIDzZGUO+/Do3HSCx1EA3YU/vner/ywff+B9pmWkKqSf35STjrZNjJwAStlzh
         J41Q==
X-Gm-Message-State: AOJu0Yz/GaPupmbj9v7MkNqLtz1mU4Bz4AnD9azFVDNzqa1Ae8KTeLLF
	Ax+GZHmmbE2kuc5AlU0zw7crkuBf/OvcIbePDHmgrzPCUChAk/asQBilNRshqQ==
X-Gm-Gg: AY/fxX5eScHcuTYqq+3F/jnA5AEqUCVxuLqPc5FS3WSIT2OFzESTtfwMhbdlyX8/Gu8
	SuS15XeNhWcx1rOSedmkISKBpNc+PzmUJKpqAc9pwrM3faMk9WTyM21lIabMvHnak1Nbmoddsjr
	f4Uj7Gyl/kwLmaEZprkbvidl0/Mnpq1FqC9Wx60UgvZQdXxdfC8LrCxeftP4zdmo6ua0qKrO7tK
	tCNhVBVBg5s2cgUYf7Jhnwi7c00gvHqAIrcSB2bAoJjsWh7IC+TiQBGgl4pzC2LfhA4bWvAwCEN
	1cr4TbX2TMY58F+sxYo+NJ1QzE0VrCphsxIYS7DANfqUxfzwy9xA/wghUPdC7IMqFyYuQ+wbLtj
	PkUCBvFQu7XSMrMz9h+sblvU+zIzjYkG1qAGErRQDm5r3NC8+r3yX7JtasjmEjyOzp2muMhG4QF
	lSd5JLa2IUdGpmWOLr
X-Google-Smtp-Source: AGHT+IE98i0eduPXy5U9XdFNbvIwIjRYJENcVvu0Pjz0xDnF5yOWiwsv4Aj2cCm3eUOEhekhiVaItg==
X-Received: by 2002:a05:6a00:1a1b:b0:81c:4a92:2594 with SMTP id d2e1a72fcca58-81c4a92285fmr11115745b3a.40.1768198438055;
        Sun, 11 Jan 2026 22:13:58 -0800 (PST)
Received: from [9.109.246.38] ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81ec1b5f927sm7114871b3a.46.2026.01.11.22.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 22:13:57 -0800 (PST)
Message-ID: <d9cc2f24-6c06-41ab-835e-453a4856fd0b@gmail.com>
Date: Mon, 12 Jan 2026 11:43:53 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs: Fix the return value of xfs_rtcopy_summary()
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org
References: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
 <aUONoL924Sw_su9J@infradead.org>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aUONoL924Sw_su9J@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/18/25 10:44, Christoph Hellwig wrote:
> On Wed, Dec 17, 2025 at 10:04:32PM +0530, Nirjhar Roy (IBM) wrote:
>> xfs_rtcopy_summary() should return the appropriate error code
>> instead of always returning 0. The caller of this function which is
>> xfs_growfs_rt_bmblock() is already handling the error.
>>
>> Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> Cc: <stable@vger.kernel.org> # v6.7
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Hi Carlos,

Are this and [1] getting picked up?

[1] https://lore.kernel.org/all/aTFWJrOYXEeFX1kY@infradead.org/

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

