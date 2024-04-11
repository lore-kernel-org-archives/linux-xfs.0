Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2626A3CF65
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 20:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868242; cv=none; b=CAixu2Oh+0F1IJ6qPBypJMYZwvZCZG7InoyWNymxzJAPiy2NXZm9NGNaI8nBpka595mF++1hqX65PZw+ivHIGgD0uvPTp0Q99TxWfiTgRc9bPYAC+5cZagoCGqH5Epq8qIFDfpbC85NUEtpPPPdOH9mAm3iG9vlmIu3fh3+bG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868242; c=relaxed/simple;
	bh=1oKO/DSGB6QxWrMeBikX0/BTArAEtOeGqruzQMjkkWU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ky3e6kOUoNu6YtomACdqbr+hdrEProoOLeCXqU6SbrkUSKhtUFEWtkXWPsJFhI58exmV5VilN6xumJyZtLyJAumjXrTMDc4db44je4LFg8HRK9mycdpRukvPazzz28ZIhCLsfcJH2yRQStvhIWWA/+74Q5sFNft0HPbE1MpV0/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ngUPaO8j; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ngUPaO8j"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4B1104CDD5E;
	Thu, 11 Apr 2024 15:34:16 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 4B1104CDD5E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1712867656;
	bh=1oKO/DSGB6QxWrMeBikX0/BTArAEtOeGqruzQMjkkWU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ngUPaO8jOGnPDjkMAm2hS++SbHwAQIgru15fXR7GGfTVC3xrshDFdJnAdijIG7jq3
	 k4Xt/cCPXLNfcAeFmKw9sSW4RAHwLUAgOpmUszKPrMGE0FNqWcstQ46tosL6Mw1GPt
	 YkpOd7QQ55rKJZ2Y3ZzWmEKxXxLti2XceYKmS3E1/6V+eXHgJDJfqdZDkOVo3WlqIG
	 cf14ysm7np2F+nd42iSSScbGhljJdoeHwfCm7xL+0/CGAq2oa4pdnG1YITJDI21iLZ
	 +EYuu1sQnrzdR2g+wkBy/ySbLE1khq6hVJvLqzBXP6IOwflEoaTxNzuiau+rQJSv9q
	 vlgCrzbwpqmbA==
Message-ID: <24467239-e3a3-46db-aa1d-e876abe03cdd@sandeen.net>
Date: Thu, 11 Apr 2024 15:34:15 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: A bug was found in Linux Kernel 5.15.148 and 5.15.150: KASAN:
 use-after-free in xfs_allocbt_init_key_from_rec (with POC)
From: Eric Sandeen <sandeen@sandeen.net>
To: =?UTF-8?B?5YiY6YCa?= <lyutoon@gmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com>
 <32f02757-70e0-41ed-a0d0-23190a28dad3@sandeen.net>
 <CAEJPjCvK-LATJ5B9-=KXa3oMZwT-zQyFqMNU9EgcfsRD12AWWA@mail.gmail.com>
 <e5ca2146-8d39-4af5-80fb-0bd5ab9ed304@sandeen.net>
 <CAEJPjCsXGHWzek7AQ1g3byUZe1Uq7KuUxJ0GY2fac3J8y+LFZQ@mail.gmail.com>
 <d1d4df97-307c-4c61-86bc-c83b8f10a745@sandeen.net>
Content-Language: en-US
In-Reply-To: <d1d4df97-307c-4c61-86bc-c83b8f10a745@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/24 12:55 PM, Eric Sandeen wrote:
>> # Step to reproduce:
>> 1. download the zip file
>> 2. unzip it
>> 3. compile the kernel (5.15.148, 5.15.150) with kernel_config
>> 4. start the kernel with qemu vm
>> 5. scp repro.c to the vm
>> 6. compile the repro.c and run it: gcc repro.c -o exp && ./exp
>> 7. you will see the KASAN error

> AFAICT you won't. I did exactly this, and got no KASAN error.
> Did you, after following these steps on a fresh boot of the kernel?

Any follow up here? Do you actually hit a KASAN error after following these
exact steps?

-Eric
