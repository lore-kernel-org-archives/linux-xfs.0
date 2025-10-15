Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8D513C8EA
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 06:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760508522; cv=none; b=gLJts6tYdhkMTX+HS1wh4hFvgsXvMNDePRWh/cAyfTbw/Lccgc8CeeNB1grCEz6St0FP1Sz3gp3VxCcJR8k1JPWAN1HXqvlqAay6nZh3GQ9PmsModDXDY9YbjvsqyGuwHcIFFJVDvTli2f4xrATu2Pvam9uSkjPjcFlcWEbInZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760508522; c=relaxed/simple;
	bh=dIrVMYq5TN4gHEJkMBJxF0TNy0TogOgJQMSnyZoD7Ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4R6u5d4lP7rEkiRYevZ0PJz08xjPaNNFdJTMpLS6Hl9y3+nyfTC+x/iZGwssXy9X0gjYTb15YvxNHi/HIRxkG3bNiZb3pZvNcpnlLfNltTpAKinqf6LRaPVzKA9rEvO6AjTUmqkxpWNEMJCGo7vNtLGZiDfK0Q8NIl8iBWPcEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHqb5JUY; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHqb5JUY"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27ee41e0798so97820975ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 23:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760508520; x=1761113320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FhHWDh3MMQ/n/APNYeMvvD3s08r1n3cRjBu4QKVV7pE=;
        b=BHqb5JUYiq4Iax9NTBDz9a7BcoLY1Hfy8Z2BgDG4nmpS+n235RUZfK5exbSXtyAsrU
         /VYinK8mkTdQHLPkqjlJ1zCsVf1LHcSlWzAabzVb65EJP+piqCXWuGJ5TqlMsMpk0rQz
         bb5tDEXTNrJLPzfBeSnjwz/zVeI3GZJToBsQt6Rusc6VQ6T1b40rxNcpqQ3vz0cNxUBx
         UNdP9VuWFleu4g8yXSB+bPFx1n8s9r+cgsdZnrbL8kwtQVTAFq6IUL/RMkUoKsfF7mTg
         IgFJVRmP9UScyOqp1Rhq3wzw1irZdcTXJiCgyuRlFLy3C+8GkEvSefk6aORz4aFqw5jO
         pMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760508520; x=1761113320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FhHWDh3MMQ/n/APNYeMvvD3s08r1n3cRjBu4QKVV7pE=;
        b=SRWFOT73sy32gSAbj1RJAfT8e1riqpeUE76eFfZ/OEI+x/T/S6Wul8wceWB3BMmmTW
         N6Iz2qyPdkSoHoGZbjKOdsuOXySo3TkYftAAzKpfjLmW5Uw+H9SI3LyGeDZbQjhlvF1J
         3Sr1+b/19HsaC4eF/RrZf4wTzIpdMFfSS/8kRnvg6SARNQMEtmkPd0Kre3Jh5+zQQiAK
         PHgfeWqELRV1wmT8t8u1oCMvituJPD8n4wwsop4WDsRtB7lbw8hKYOqME0LVXd+O2Lp6
         rRMtXiqSnrkQzJWc4Ydt1CUEQHpg1pJVWnhs+HIkwz1bOOaNPi+PpQnwdw4DS4DSZ9qw
         C67w==
X-Forwarded-Encrypted: i=1; AJvYcCWbxc/qjVJ1Nm8gDBBwS5NW0elA1t4k0/P148wAgk2BZTy7dkSoaRO+gCTRTQAH+azexV8waXqHJxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVfA9n7TpD3CRi4cRe1NnJntIo49FUh6hPwgeRp92yCca38Bah
	deQq8DUFYmXvNN/k3xSEV8oNNXJG12HbUdP1OZP9jBzEtqH/oG6M3PSbJgEn8Q==
X-Gm-Gg: ASbGnctQeQgaFSe6O1jp6gXTJ6mHjYctavbb5RKzj0nzgMkGFB0zx3/VNj4Ka6fynZ0
	MrGk55VWIukJtcjpqbRLCFtOAusb4ZcY9OqbAHD5shes55stsrQBj8JDV9j1lhCoMbMu1oOJ4PM
	JLvvEG5LS9VnxfFCunHpvOVyLIVj6Xtehi5XEH8tSWTkrjDcnEXv7Vo+VdHuduJcum2Tejrc/kB
	utqatBh7/cL7ZuWsCfICSOHdv2tfdr6+54NKZXsVOh8Yqm9AljLaEElDyU6g+yHz/k18U6uz+v9
	cNx7d0wt4ca9o37eH2rXm+uBZu/vkvgE5aoAITXEF8YRh+MB7bwWkcEQkiTMk+5HqMpUtLpLnhJ
	+5vE5BivhfRFYCSRHt+g9nIb2ZXbSYpCfilTnljPNxKQdK0JxYyFG/JjFQQ==
X-Google-Smtp-Source: AGHT+IG3fZ0zy19BJmwTfAzC/dBuxFdmHNHW2pvg5TF5nPDM5kKiNeMud0I3g7VnW+G0N9yblQ260w==
X-Received: by 2002:a17:903:3c4d:b0:267:44e6:11d3 with SMTP id d9443c01a7336-29027379986mr352436645ad.21.1760508520039;
        Tue, 14 Oct 2025 23:08:40 -0700 (PDT)
Received: from [9.109.246.38] ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61ac812csm17848553a91.18.2025.10.14.23.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 23:08:39 -0700 (PDT)
Message-ID: <5be76a46-c711-45dd-b2a3-0c9e9b5f2b88@gmail.com>
Date: Wed, 15 Oct 2025 11:38:35 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't set bt_nr_sectors to a negative number
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
 xfs <linux-xfs@vger.kernel.org>
References: <20251013163310.GM6188@frogsfrogsfrogs>
 <ec2bc94bc73a42ab61019b8de5951359d383247d.camel@gmail.com>
 <20251014182058.GX6188@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251014182058.GX6188@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/14/25 23:50, Darrick J. Wong wrote:
> On Tue, Oct 14, 2025 at 12:17:30PM +0530, Nirjhar Roy (IBM) wrote:
>> On Mon, 2025-10-13 at 09:33 -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> xfs_daddr_t is a signed type, which means that xfs_buf_map_verify is
>>> using a signed comparison.  This causes problems if bt_nr_sectors is
>>> never overridden (e.g. in the case of an xfbtree for rmap btree repairs)
>>> because even daddr 0 can't pass the verifier test in that case.
>> Okay so the check "if (map->bm_bn < 0 || map->bm_bn >= btp->bt_nr_sectors) {" will be true of the
>> default value of btp->bt_nr_sectors = -1 and the verifier will fail(incorrectly), right?
>> Why would we not want to override bt_nr_sectors? If there is device, then shouldn't it always have a
>> buffer target with a certain number of bt_nr_sectors?
> Online repair creates tmpfs files in which to stage repairs, and uses
> the xfbtree buftarg so that it can build a replacement rmapbt in a tmpfs
> file.  I guess xfbtree should be setting bt_nr_sectors to (max pagecache
> size / 512) but in practicality nobody should ever have a 16TB rmap
> btree on 32-bit or an 8EB rmap btree on 64-bit.

Okay, that makes sense. Thank you for the explanation.

--NR

> --D
>
>> --NR
>>> Define an explicit max constant and set the initial bt_nr_sectors to a
>>> positive value.
>>>
>>> Found by xfs/422.
>>>
>>> Cc: <stable@vger.kernel.org> # v6.18-rc1
>>> Fixes: 42852fe57c6d2a ("xfs: track the number of blocks in each buftarg")
>>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>>> ---
>>>   fs/xfs/xfs_buf.h |    1 +
>>>   fs/xfs/xfs_buf.c |    2 +-
>>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
>>> index 8fa7bdf59c9110..e25cd2a160f31c 100644
>>> --- a/fs/xfs/xfs_buf.h
>>> +++ b/fs/xfs/xfs_buf.h
>>> @@ -22,6 +22,7 @@ extern struct kmem_cache *xfs_buf_cache;
>>>    */
>>>   struct xfs_buf;
>>>   
>>> +#define XFS_BUF_DADDR_MAX	((xfs_daddr_t) S64_MAX)
>>>   #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
>>>   
>>>   #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
>>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>>> index 773d959965dc29..47edf3041631bb 100644
>>> --- a/fs/xfs/xfs_buf.c
>>> +++ b/fs/xfs/xfs_buf.c
>>> @@ -1751,7 +1751,7 @@ xfs_init_buftarg(
>>>   	const char			*descr)
>>>   {
>>>   	/* The maximum size of the buftarg is only known once the sb is read. */
>>> -	btp->bt_nr_sectors = (xfs_daddr_t)-1;
>>> +	btp->bt_nr_sectors = XFS_BUF_DADDR_MAX;
>>>   
>>>   	/* Set up device logical sector size mask */
>>>   	btp->bt_logical_sectorsize = logical_sectorsize;
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

