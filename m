Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.165
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434863;
	b=qbGTdc0KQuTkR8IxpkIowlE3Yn0d7CeNKd5pGbvnv+zTaDm/PnqCfjmmtkl1DEMeCoh1
	 gtN7zhux1buKxLM2NQTjxMYXAYsiyNr3XasZi26spC5kEhrzcNOGKSbUcJ9QHzmQwYRDW
	 zqvEOIaUloSgat6ZKwnPEFxWWAMOH0Tav84Ck3j1F4ypsLkrh5q9q4hhQfqyuD2xqNTl4
	 AGcmXeeK4+ulljCJAHmXv4HHQ130sVnFKMnWsmymaEcrQvKmtX7/l+416BN7PHG0sSZQp
	 K6zab8OuaCLcDuR5hxckw5fYtqZuTfeLnjlGDtv8Sr1hNdkjqkmTyKswcfxnxGk/qmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434863;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Y1jh/Oxwyk+2xMZ2O3R12iIX6dVTPJcfpFTxyoXkPx4=;
	b=YRqtLdzQ5KMD9/Jg/hdZ1ImpWCzcSBqs9BQnExQwAUkJeLAhGB4eGyjFSxS30k1y/iPa
	 fl3r5ouF1tCrvMdW9mQuCACc5qtan+YL1naz1SypzUJfjTlVPK/W5ZS6RhSSLgUmew2wT
	 jQjzsOaiJfrDRINKQ0s5Im3wYHTR+wR0mskykppWqYSb+UzI1rHW9Cz8WQU8bvBcSU3ra
	 vz+tBMH3YfQsKdlyvgmGt8okTCbsEI4AxIIX3Jgi5RnImqA9QRT9qLA/cY/+tkGxQ2Wjy
	 zALjd4CeFv5pIl1/mloqEBQCuv6jly+98D+0y497n91BZYDIkrX893c9CD5gvZEEhqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DwNOrPeR;
	arc=none smtp.remote-ip=91.218.175.165
Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AF1606A31E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 11:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4AF1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DwNOrPeR
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AU4GFuJOVO7rz0c/PwI/1MbPU5Ne+RNdFr+PZu8dfF8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795434861; v=1; x=1796039661;
 b=DwNOrPeRh3ekYeh5SHZX+CqA7VmRz+WNLzJJiRdPtzmzCW8G1IgJzbPLvU8fM4BFjE5fJ9Y8
 MPoeujTPtuPAcgAAp/qF4IOyHbBhZJTPcXPAxZSMWWsw4YpwL+dfhMrvZ4XHu/5papUpdlgu0dk
 Nd5uYg00gcDGZJpuktffenBQ=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 1fcc7e47682d9b69;
	Mon, 23 Nov 2026 11:54:20 +0000
X-Mizu-Trace-ID: 1fcc7e47682d9b69
X-Migadu-Flow: FLOW_OUT
Message-ID: <2d016a87-2424-401d-930c-9cf1fa91ea8e@linux.dev>
Date: Mon, 23 Nov 2026 11:54:20 +0000
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
Subject: Re: [PATCH 10/59] xfs: check the atomic write reservation against the
 current log size
From: John Garry <john.garry@linux.dev>
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-11-dgc@kernel.org> <awB3cl3D4MKNfXak@infradead.org>
 <00615772-859f-4948-bd21-6a70c714e01d@linux.dev>
Content-Language: en-US
In-Reply-To: <00615772-859f-4948-bd21-6a70c714e01d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/26 11:49, John Garry wrote:

+ Shin'ichiro

> On 11/20/26 16:38, Christoph Hellwig wrote:
>> Please split this out to a standalone patch and include John and
>> the folks have the other atomic reservation patches out right now.
> 
> thanks
> 
> And @Dave, just to check, does this address the following:
> https://lore.kernel.org/linux-xfs/avtmYUPn6BMB56AX@dread/
> 
> I doubt it since it "fixes" a different commit.
> 
BTW, AFAICT, we still have this issue:

https://lore.kernel.org/linux-xfs/atnvvalMNn2iAAI0@shinmob/#t

For which no consensus could be found earlier. @Dave, please also check 
Darrick's suggestion.

Thanks,
John
