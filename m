Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236280;
	b=ozg8HruM0l9Y5u6ROs7mdsEI5+qLNn1JKB3Bi70xZKmsjdDU7YBJjksHMiDn4B2J97eI
	 IZ8PBIVsUgX1p5vZ/3KJVnG5NBl5xkywtfQT7/L+pqx52c0MbjjYhio71LT4mfQrQi+8t
	 P8ZCtl/T1Ame1xgM7PkZT4+7e67B/wrCnrZq3YakMJORjCQa+RyITEuojNmK+zCKgjH/t
	 WvO+VN9zovbG2Mpb12uQk8mKvzaZ0oltNuD3pH48Q07WbSjp0rDFfG1Yt9yVsPL4Y/Znl
	 1kbpNu3oBU8W7sSQyo68deRETRi1j1yS8v2BRrPsMHaymwyqF3dBsBxKizFtyUHZACA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236280;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=4e7+fJeFI5gvAAOFS1tMRNXFdpnPWB+xaPAqWxEodDU=;
	b=QnEspM/M+6PpyVgc9e4jDzyEjQMedH33pRH4sd50oD6Lf23kK+uKKVIL5V01KF9Z2Stl
	 +AVTxbJywM2QEX9Y6odml7hSwwNPHt5l9rkE1cOAMXkfUZjmmQtdx0tnJQNNmi4lSBu0B
	 c4b8h++EPvD0L/cY9MKdQIgpzyEzWyt+QW7Qn0i7v/3pb8eOROtcnC2xG9yxBJvtoSXvF
	 6sVxeRcb665ZKLsuXaH+CU8ih28WZS9DsubvTEKCC1TMRDZeJ8cvNsrCXYKsg7Gzfc1Ev
	 3omyKdnEhOlFB2gSrlVi5DImJA3u6nOWQCJj1idNAQRukfFfm+Mdn0oRkvQtIg+WmxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=Y5V2r+L1;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=tlwPRN4F;
	arc=none smtp.remote-ip=103.168.172.144
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED31606A323
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 14:57:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CED31606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=Y5V2r+L1;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=tlwPRN4F
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 01375EC06E3
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 09:57:59 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 09 Nov 2026 09:57:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1794236278;
	 x=1794322678; bh=4e7+fJeFI5gvAAOFS1tMRNXFdpnPWB+xaPAqWxEodDU=; b=
	Y5V2r+L1mDgmfJcNzdaHlFxtoIy5hJLaLqLqzoUAtad97sVzlPiQR7TurN2KnaAx
	9OxWjDNhs6F9w6bVCs4iTQuhXR2ugFKfSF8SoBOzfixxZQzDW7tlKd13HYznTdYo
	sg2MOcu9Jx4MVr4FTrNR/zPlKZF215Qfmz967vGMCPgA2JNShOQ8VbJ0DoV9l+QP
	28JTTMlHrYIpwJw6FkNPh8eAvPuW4Af7dAgvkeBZyQ3eC7oamzJXllTCmmKcOGhW
	Rv+QbSgxWLnjlz9PAFfLHN1wqrUdkEFrLydWNJtNQGWDfEoFJpg6SlsGJHCsc9WW
	tunpFnoEwLX59JcvHVGEVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794236278; x=1794322678; bh=4
	e7+fJeFI5gvAAOFS1tMRNXFdpnPWB+xaPAqWxEodDU=; b=tlwPRN4FMGRWwTOK4
	LiyDHSFNkdPjBZuiWGQR876KRykOtlqyOJnaIXlVVYXTpBwpt4hXXtjQTQAJt75Y
	YRzHbveLN8w+lLeJGj4CNVnLA2Tawc1+Ui+uLHUHh5ryIqVXc5/lZy6qdEhNZCjv
	dv+nDbF9pLv6AtOTDOVyJrhIEn07Ug7dUU4zmmsXXptuhqeXLM0NnvKyI/X6NLCZ
	M6Q7KPwtGdR1cMNL6cfu4SDVDujI9zIrhMgRu7jeTrrd+weXaUIy4fYro9ho652p
	WSi0cvUqDrf/1JCtPMOSQuP7N4W2MJ5g3RCaKEEWvUqwaGxVZ23dO4QjDLNNSP9L
	uSd+Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794236278; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:CCmqe+j8iNC/J9hrLixm1ru4bTn59gOg1fi4V2aaJFZpDpA
	J7jBJ0At8DI93Ge7tPgl8nt92uTzP+RX6WScV7Nbm70tVRMyuLAXHHb+jTjApOL/
	JzGU2MIBN4/sUFhn7wSZnxaBpcqLcDy+D324I9+tlK6x9/zdtwRneeIHDI2eKHgx
	xkvg+rvvdXnpKmWJREct0RHt7UUoxG90tSOnUIMgrRidD5KPmbbMLe1e8NZe2PGo
	8QW7VmNxCMuVfbTIVXem44FU6Gbd2Sw4eUMQwKMS5xgoBc4ycu/c91vEEjPNKMK/
	8fUylhBUXRuyG4AMNM7yxAHU7Q3nuz6Z39LwNfA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:TTW9QmpcPpQb2/Ls5ArjxdDUsVV7psm0X9Gcd0wyhng=:IIe8ClKvx2Cgydxgmxwfi0jeSi756F5SwkVRuY1wKDg=;
X-ME-Sender: <xms:dt_xahzwmI8hDIivr-TClP0ZN7U0f3cAdUZWG6gMv8qVnq4zeoQ9-g>
    <xme:dt_xaoN4R9SkRLviKuPwRE19-DnSS5RYqDn5YerHZ9bwnGXqaazqWvBHz8Pe2KCq3
    mxQkVEmdgZJj9XmvriPh_MDGPOKwn-_gZqXhJrPR3zC7k5QA7ZfNukr>
X-ME-Received: <xmr:dt_xag9tmsfhHgN8pT09mkfOCDsbwQun2xkrH94m6PZB9kvcE9ysNUon3fmOkfG9yF8U3JhNwdkhIDb_PtwWDg>
X-ME-Proxy-Cause: dmFkZTGX5oWxgchjuENLzYnJTGmCUyEPeXXL6HAPFktRuUbjWmCjd5Sht7AwtWL01/BA9Z
    HKbvldBIUWjUQkTSNvOhU3+HM6/1W/8G7hfEYXrRtnNkqK4tQi7oGgRR8xh4jZB7sP3HxQ
    eb9L8s563mPacyeLwoh0vRZ0pfrH7Yv1jro/vHBL6B/8ixROFJ3z4sNobEontByG7OdNrQ
    rhFp/rFl2WxuxqZd04rcPCAGMiTQy6Sef0m+6G47EHvew79SWJ6lmYH+IyJh9HSdEE7h0E
    n1Lfd/JINDeYoEo7lCGZ8bCtujsHgZavEx5tkOIvuFODGIZdyGT6ejs+6Dtw1VzkOAlTlY
    PNkAxRtOFzH2mboK7vZg9BwNQIQ0izFhlCbmUByu3HpkR6PoTPbRB2h/5TBRsp7GuTd/0S
    IwF+JdeicBksPJbqRf5hd9s+a+KJi8c+UdVQboCcZoQIZsJ6v6S7IFgVfbW8DNLW2vNSoI
    P8qdWOZJ6xT6GDPw+HUF33d0Ro3r78P5yYulenN9oLUSwwv83AqxCaVHsqHPwHY1+JjYlN
    5vYfD4YiwQKxcQJjAYvW707ltxTear29J02YoW7x91zT2gWbKuHtUCCdEqyIPh+Gj8ALfy
    2BLFG+2DVmm0ZfBYGGs1rEdrjuhUL5oRTdrbx8wC9jrGbaJ0f+id7VgYpp4g
X-ME-Proxy: <xmx:dt_xaopqBa-5luz_rM-PeMUeVZyw1ny6NgrGyqm_sp-QsbdcaZXbcQ>
    <xmx:dt_xai5OY-fH2g8CZFohoK-S0ye3WXuInSgC6iLqeS8K3hZNDxHvsA>
    <xmx:dt_xaoOKmHUNpT7hodX9KJEg1cNFe_QB-wEmK-GueWi7tc6LnFFC2A>
    <xmx:dt_xakO1J3iBSufRRZTPjqIbIWJCxOfAayu4mm5KaIFGThK6ik6vQA>
    <xmx:dt_xanxwseP4lFsAtQ0B0jW7EThYaysAyp3F1qwQe4rE1L2k8d89sIpW>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Mon, 9 Nov 2026 09:57:58 -0500 (EST)
Message-ID: <d5579930-931f-4c14-85a3-fa3e513a2c0f@sandeen.net>
Date: Mon, 9 Nov 2026 08:57:58 -0600
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
Subject: Re: [PATCH] libxfs: capture error return of cache_node_allocate()
To: linux-xfs@vger.kernel.org
References: <20261106211129.3042825-1-sandeen@redhat.com>
 <avGwBNlcTtV9kbF0@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <avGwBNlcTtV9kbF0@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/9/26 5:39 AM, Andrey Albershteyn wrote:
> On 2026-11-06 15:11:29, Eric Sandeen wrote:
>> I guess during the revisions of this series I managed to lose the
>> actual error return of the cache node allocation failure
> 
> nope, that's me, I dropped the hunk with if (error > 0) based on the
> review, while applying. Didn't noticed the 'error =' is actually
> what matters here, sorry :(

hehe ok :) In that case we might want to change the commit log here?

Thanks,
-Eric

>> , which pretty
>> much defeated the purpose of the change. Fix that.
>>
>> Fixes: 92d45f83 ("libxfs: Return -ENOMEM on actual cache node allocation failures")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  libxfs/cache.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/libxfs/cache.c b/libxfs/cache.c
>> index 5cf6bef1..81509cee 100644
>> --- a/libxfs/cache.c
>> +++ b/libxfs/cache.c
>> @@ -475,7 +475,7 @@ next_object:
>>  		/*
>>  		 * not found, allocate a new entry
>>  		 */
>> -		cache_node_allocate(cache, key, &node);
>> +		error = cache_node_allocate(cache, key, &node);
>>  		if (node)
>>  			break;
>>  
>> -- 
>> 2.56.0
>>
>>
> 
> Looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
> 

