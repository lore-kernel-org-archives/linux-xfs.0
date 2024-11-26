Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBE2C2C6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584601; cv=none; b=qm4EwxDHCPPdXjfOE8kpwqZqe0NpulUvHq/YwaGoD4aJ1hTctJ5GsKLe80KqZdfPtnyMv8i4IUFJscv7CnZMrjDVGsPIABjEzdCIQ0HQkyB+FBBkP9TK2An9cLk+m+I/12fS5tZ7yclXtAVoBsy8+1/WEKk7A/ba2nrPCCgeTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584601; c=relaxed/simple;
	bh=9sV8YBHJXyrkhyZQsOTPxXHj3uD9DLHpK6RGzk0TURY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XakMlQELkzaOr4iTZ8znRr0UnYO9bL9/zJwTnKntdRd5JOMyknx/ygqztX4uM6ve2efHZUl4LJHQo/pMLhpjCvWRYXIcFTH2dMs8K98wsvAOdNQnv2aWMQDAWVs/Css7Z3joiut2s/Xhd/TZbu1BDfDawWdbK/9NFGRoIzHWuXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dIxrQJhc; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dIxrQJhc"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e3882273bc8so4670325276.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 17:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1732584598; x=1733189398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AS1vcyzPenwGSUXYgsTAdALJscT7l6zsDHUyoHaZinY=;
        b=dIxrQJhce5vcU4hRtDEhSZsMxxN/0HMlUcjJpmqzVGdZzzg5Um9exez+dMQQXerBIj
         bVdWWhue662Bn/3W18MgSXMXkBdiWnhG4YauNAwGcVZGc5VLjJUR2XinZKwtiNoaNWoH
         Wea8x+leazUlq5WtK3pqgEVQjQIL3EdJFGv0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732584598; x=1733189398;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AS1vcyzPenwGSUXYgsTAdALJscT7l6zsDHUyoHaZinY=;
        b=VU/nRFMCyfdnac/foMD/HyFNqRYUFzpQHSjMQyBUqNZjKMFImvdLjB+cLVI+EbpHJM
         BssYd6PvcC9rh5Y4NrsLqBcxiAlSNDilxqUIOm2C5CQAWCfEIEqpnlrIORtGLH2U2Px6
         LoaL7eg53AR1kiE1L6UINiuSl/xJsWkCMYqH9RXI48a8B3pBY4l3PDzjbDWZnIEEfEqm
         r/4XNIQpO8Kkpy0JDDh4L/Hr/Co+PfAK0qBW3lOAQd+Q64P65sJJVPS9UFEvZszS5EFS
         6xVohgApSklL9kBvFaY8CfTf08lnnqg/F1qzjxrk5dMQdCdzAkWz4jZ9P6yGUTSOU5V2
         b2cQ==
X-Gm-Message-State: AOJu0YzzKTImc4140E4sKqhZKSzs4/zgfZv2oECuvDjzj/mFe1/oAZZD
	zQtB0IjIKJliMF7DpNPgtLQbo58cmfZjpZYgnc0ipDgt2znucyzmMr7UC9dHrQ==
X-Gm-Gg: ASbGncugKMs9gs9VP2TXgSnzvzfehJeYofPAhnlurPqZcVW3kzuoSopFzIASp6Gn8nK
	9Si1h1DYRFw1oMW7DuUQfgRHBhiq0liJt0FyfbwjehvoR5z1YYwYbzTlY8sELAfr2u6y5lzooqk
	iqTYEQD8VHsapWRtwZ6w2zoRNMMik34wWNl4TWuqa88LSzuS+l/Vw3rAG8fAhDfqSxqbcVXT4Mn
	PgAZt72z8iyrXHX1pubbL+3jphuTDEVjiLzUK4W0ipJvHEYGo5AgAbWkN5v395lev/pd89D+gDd
	AhmxrECB6QIc2w==
X-Google-Smtp-Source: AGHT+IEsPx4eovYXZzLlAlpkJE8n33OnOEtntWNQIdQ/8r3YLVjlA93BLeDkxqnBfJ57KuK9hXd5ag==
X-Received: by 2002:a05:6902:18c6:b0:e29:769b:453a with SMTP id 3f1490d57ef6-e38f8bd8fb0mr12247790276.35.1732584598255;
        Mon, 25 Nov 2024 17:29:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-466a174606esm7745001cf.79.2024.11.25.17.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 17:29:56 -0800 (PST)
Message-ID: <2101455d-090f-4549-a423-81e30adf3645@broadcom.com>
Date: Mon, 25 Nov 2024 17:29:54 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_io: Avoid using __kernel_rwf_t for older kernels
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, mmayer@broadcom.com, justin.chen@broadcom.com,
 catherine.hoang@oracle.com
References: <20241125222618.1276708-1-florian.fainelli@broadcom.com>
 <20241126012224.GJ9438@frogsfrogsfrogs>
Content-Language: en-US
From: Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 xsBNBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAHNMEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPsLB
 IQQQAQgAywUCZWl41AUJI+Jo+hcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFr
 ZXktdXNhZ2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2Rp
 bmdAcGdwLmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29t
 Lm5ldAUbAwAAAAMWAgEFHgEAAAAEFQgJChYhBNXZKpfnkVze1+R8aIExtcQpvGagAAoJEIEx
 tcQpvGagWPEH/2l0DNr9QkTwJUxOoP9wgHfmVhqc0ZlDsBFv91I3BbhGKI5UATbipKNqG13Z
 TsBrJHcrnCqnTRS+8n9/myOF0ng2A4YT0EJnayzHugXm+hrkO5O9UEPJ8a+0553VqyoFhHqA
 zjxj8fUu1px5cbb4R9G4UAySqyeLLeqnYLCKb4+GklGSBGsLMYvLmIDNYlkhMdnnzsSUAS61
 WJYW6jjnzMwuKJ0ZHv7xZvSHyhIsFRiYiEs44kiYjbUUMcXor/uLEuTIazGrE3MahuGdjpT2
 IOjoMiTsbMc0yfhHp6G/2E769oDXMVxCCbMVpA+LUtVIQEA+8Zr6mX0Yk4nDS7OiBlvOwE0E
 U8AbwQEIAKxr71oqe+0+MYCc7WafWEcpQHFUwvYLcdBoOnmJPxDwDRpvU5LhqSPvk/yJdh9k
 4xUDQu3rm1qIW2I9Puk5n/Jz/lZsqGw8T13DKyu8eMcvaA/irm9lX9El27DPHy/0qsxmxVmU
 pu9y9S+BmaMb2CM9IuyxMWEl9ruWFS2jAWh/R8CrdnL6+zLk60R7XGzmSJqF09vYNlJ6Bdbs
 MWDXkYWWP5Ub1ZJGNJQ4qT7g8IN0qXxzLQsmz6tbgLMEHYBGx80bBF8AkdThd6SLhreCN7Uh
 IR/5NXGqotAZao2xlDpJLuOMQtoH9WVNuuxQQZHVd8if+yp6yRJ5DAmIUt5CCPcAEQEAAcLB
 gQQYAQIBKwUCU8AbwgUbDAAAAMBdIAQZAQgABgUCU8AbwQAKCRCTYAaomC8PVQ0VCACWk3n+
 obFABEp5Rg6Qvspi9kWXcwCcfZV41OIYWhXMoc57ssjCand5noZi8bKg0bxw4qsg+9cNgZ3P
 N/DFWcNKcAT3Z2/4fTnJqdJS//YcEhlr8uGs+ZWFcqAPbteFCM4dGDRruo69IrHfyyQGx16s
 CcFlrN8vD066RKevFepb/ml7eYEdN5SRALyEdQMKeCSf3mectdoECEqdF/MWpfWIYQ1hEfdm
 C2Kztm+h3Nkt9ZQLqc3wsPJZmbD9T0c9Rphfypgw/SfTf2/CHoYVkKqwUIzI59itl5Lze+R5
 wDByhWHx2Ud2R7SudmT9XK1e0x7W7a5z11Q6vrzuED5nQvkhAAoJEIExtcQpvGagugcIAJd5
 EYe6KM6Y6RvI6TvHp+QgbU5dxvjqSiSvam0Ms3QrLidCtantcGT2Wz/2PlbZqkoJxMQc40rb
 fXa4xQSvJYj0GWpadrDJUvUu3LEsunDCxdWrmbmwGRKqZraV2oG7YEddmDqOe0Xm/NxeSobc
 MIlnaE6V0U8f5zNHB7Y46yJjjYT/Ds1TJo3pvwevDWPvv6rdBeV07D9s43frUS6xYd1uFxHC
 7dZYWJjZmyUf5evr1W1gCgwLXG0PEi9n3qmz1lelQ8lSocmvxBKtMbX/OKhAfuP/iIwnTsww
 95A2SaPiQZA51NywV8OFgsN0ITl2PlZ4Tp9hHERDe6nQCsNI/Us=
In-Reply-To: <20241126012224.GJ9438@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 17:22, Darrick J. Wong wrote:
> On Mon, Nov 25, 2024 at 02:26:18PM -0800, Florian Fainelli wrote:
>> __kernel_rwf_t was defined with upstream Linux commit
>> ddef7ed2b5cbafae692d1d580bb5a07808926a9c ("annotate RWF_... flags")
>> which has been included in Linux v4.14 and newer. When building xfsprogs
> 
> /methinks you should upgrade your kernel, 4.14 is quite dead now, and
> you're not even running something /that/ new.

For sure, we happen to build a root filesystem against old (4.9) kernel 
headers and this is how we caught it. It was good to see that thought 
had been put into defining RWF_ATOMIC is not already defined, not having 
a type for __kernel_rwf_t was the next thing.

> 
>> against older kernel headers, this type is not defined, leading to the
>> following build error:
>>
>> pwrite.c: In function 'pwrite_f':
>> ../include/xfs/linux.h:236:22: error: '__kernel_rwf_t' undeclared (first use in this function); did you mean '__kernel_off_t'?
>>   #define RWF_ATOMIC ((__kernel_rwf_t)0x00000040)
>>                        ^~~~~~~~~~~~~~
>> pwrite.c:329:22: note: in expansion of macro 'RWF_ATOMIC'
>>      pwritev2_flags |= RWF_ATOMIC;
>>
>> Fixes: ee6c5941352a ("xfs_io: add RWF_ATOMIC support to pwrite")
>> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> That said, if this doesn't break anything with a ~2020s distro then I
> don't have any objections to this, so:
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks!
-- 
Florian
