Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793099698;
	b=vXfWd5gATuh2qSLWt8v0zZHxZbumPdC1+E2Ay4UvjrdpCz9h95/yrYVsIJv54GX2q4KW
	 EjwDGEsTQi/CsJOTvJx2t01rQl+NJv4VcWlIldwAJPp9CSqrds8kc7YnjC/LPYeEc/zbu
	 ZCcwkYOjom1XGicIn9dDJM9NY5uW6q3snwSlltOAAxpKRE6ftnXp7brxKm2s/Z6y7eQ/F
	 TnQd2I7EAqeDVAcH/8EQmbSNxtHjrrGPQr6hfn4Da2qur8DpBC3Dh79CvelosG44/Vn64
	 hCQO56sd7Ye4zcf+a70zIEYojFG/LjTIMALFvjTBqqan5vr1FLxcZL1wt0frh64P0dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793099698;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=erC0p436ipwyI6asEt7WUOhnni2WzxvEwWVFbMmqkS0=;
	b=CGMI0J+0WYeNs2zK3kB6nWtjrQiZJYRGZeVyAaHGlgvlGNtYNrCtH54mgYhhAVNPdCgX
	 kP4J+9wxXbiUcfKMX+x2mD9YRDFNazoiNrDpaYq25nNbzGgSegZybIxZkb27S06cNB+Fu
	 dUY0Y9AgV69IZNVX829SQqxnHack1p0lu4xJHb606azdYneGgrCoWKPNeqiBdKWqKo5HF
	 3Fe0o+a0d0loLfksZNYkCnbxd6SqRLDoU+s0g2dtKLcRR8Dw/pyJjOCdLbcGPP9fz6xsg
	 Tn/OgLzUo3h3oS5DrP9GLbxysNWkjNJ1nxBWInRJp36GdUC3OEmakochMGPQWCXw2pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CBfck7VX;
	arc=none smtp.remote-ip=95.215.58.12
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF5C606A329
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 11:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FF5C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CBfck7VX
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KtPACx9uluOb4kE38HVLKkwCk631bhedpoXc64nfCOM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793099690; v=1; x=1793704490;
 b=CBfck7VXkbPtz+84PzdUCArP23RlwI/MjoPzn3kF7zRwsbYD08nN61iITlgHo4p8UHYKUa3B
 dFExtvyN8LH0WRdS47W0F2c43aTTsDYpuOqJLLTbubJNMztnFbqYsrzwOl92SM6rFrkucwqAHZz
 ry6BkY5woJ25nA7t/x/KqnLw=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cbc3ab62f1579971;
	Tue, 27 Oct 2026 11:14:50 +0000
X-Mizu-Trace-ID: cbc3ab62f1579971
X-Migadu-Flow: FLOW_OUT
Message-ID: <3048fa10-007e-41d1-9b95-5be5923e4a68@linux.dev>
Date: Tue, 27 Oct 2026 12:14:48 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: only follow dio alignment requirement if specified
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, da.gomez@kernel.org,
 gost.dev@samsung.com
References: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>
 <at-p1QXETaTvvj_r@quentin> <5f49d819-12ec-48b2-b9b2-adce264d266d@gmx.com>
 <0046bdae-1dd1-4f4b-a1e5-9eb7fe8b5fe0@linux.dev>
 <04a7e656-567d-458c-99b0-e9aa5960bd99@gmx.com>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <04a7e656-567d-458c-99b0-e9aa5960bd99@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/27/2026 11:12 AM, Qu Wenruo wrote:
> 
> 
> 在 2026/10/27 20:37, Pankaj Raghav 写道:
>>
>>
> [...]
>>>>> Cc: stable@vger.kernel.org
>>
>> FYI, your patches are not in 7.3 and only in linux-next. So we don't need to 
>> cc stable?
> 
> Unfortunately, it's already upstreamed.
> 
> The commit hash, 4025185cf953 ("iomap: follow the alignment requirement for 
> iomap_dio_hole_iter()"), is already in the upstream.
> 
Yes. My point is this was merged as a part of the current v7.4 merge window, so 
the fixes can go as a part of RCs? Does it still require a CC to stable?

--
Pankaj
