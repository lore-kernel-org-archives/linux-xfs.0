Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0C73E47B
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 15:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673054; cv=none; b=j6YzcoIfJMIMHvRoYM88hVtclSFNuS1qDLFqIuD2g3EKX8pf75wC7p5khyNC48aOKL23a7+FS7OUqV7rLkflue5vh3T8xLHpWpvFc2olr3dxTQlNeCXMSBgpJz4x9OlkgB4UB0e7rA6/U2hLCBZ91EMmLuS06fqa5P7FQwNhFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673054; c=relaxed/simple;
	bh=LU91G1iv7SA4zsh7Ix6zQJdSkOu/LLfAOITL/WrLqws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NwDF+OJp5WGaslYE0xl+9Owj/wgHrARGVx8H8Pon/2GK0WFlyKfuYRVcZZ7u+wOftK5yjTu8+63cFmqmr4AHE7/VBXGxvXdg+mZL4TjkdwqpRBWfh3yghQh3O3HY+HxE63pBU2SwT+s7g9XmCUogpNe8aWHDf5yQ+zARxRx7ZRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=XFu0M7Rl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=U6g3iuB4; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="XFu0M7Rl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="U6g3iuB4"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D9E431400080;
	Tue, 25 Aug 2026 11:50:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 25 Aug 2026 11:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1787673051;
	 x=1787759451; bh=mqAehQKWkzJOMppPlixsW94t55+rRezc1dAs0O2j0IA=; b=
	XFu0M7Rl1hunk3voZ2iTb57hAOuw/zz6tCMCDS48fhLTH3EljnE2Q8Vme4bxH6li
	Hn16Jsakr4P32nYtOYRBnMyhmjS9dwVuyZhkLd/sYDkBOaZa2cTxw8JwxEMmaelI
	e/Ity46jdwtcRlXFLcIK5YIMJgL66pEH0wMW6ysAVmn7j2OuTZ3pnaib27286Ah4
	R7+9tWSZYYNLda76Np69+CaRVIal6jMOxq8grrcqa91uzeZM40eoZRjcR+0pAJNC
	1A9unV5I3HhwtYLjCdGk9ss5z7+MdOfr1hbWia70aOq3IXgGldB/Nk5l5bgNfzwK
	y5xM5TL7q1IlVTcBjWKNYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787673051; x=
	1787759451; bh=mqAehQKWkzJOMppPlixsW94t55+rRezc1dAs0O2j0IA=; b=U
	6g3iuB4EyD7Z1L51BCbTKiRobigHoT79Mlrah18iwFKrUP4JLOcX+ABZpxemvHEf
	ffBt9fl9Z/+lb0Wd21C1eGFwf+9OtY6d0XB6x6pHq7+5jGQP4nsAa1qaI1h/yDBD
	CQYpirp4ZOn/7kcRW48hVBpbRYPD4PLEbx+CZ/AYiX2h2s+kS0ufjyPlSLZBE68c
	EqLee/Ndsai5dWhAFkxl6m57O6jL9R4LIB31L5Q9AwSeO9gSrZ2Rt80oY6nq7S5G
	RS+TqG3g6F0Dc35L6mTR6ZOXqxSSLPr1JEZtt+qi+kMNHV5aR9BJJtg+Axvtf0IT
	xNAqSON0qZQh/UGZYnULw==
X-ME-Sender: <xms:27mNauj_Ko1OosjCg_pic1hKXaztaQg_M9uJF1LZ-bx3Z3aMQeeeVg>
    <xme:27mNamdd64jZP2DY2k3Av2dxDtcHqMly0T3NgtOxYVJLjpL_QRHOk4eL2y4mC0St2
    UxmZk4dGQHNLL6uZzMtIRyEOfJGvzL8hyu304grkEy0Gn8DEmgOvYqS>
X-ME-Received: <xmr:27mNajdXk2N7oolhvjyGrOeTby5OzgWVm2JUYt1_6ULsj83zhgFDHyb8uDP3AD6Y_ZtLftEkz8peXfvICLTlakU5>
X-ME-Proxy-Cause: dmFkZTFNUpWcT4A5diWVCG9kvmboKCRxiiTZSNJ/FPC0WybNHDHAKMWu7PByRcGXAiang9
    acvnbn7lLvaGqmesR0xbKOe71XnXf4yrxrXqr6WxsSwrigHGNOcVOSB3wmEP+DG6Dy+NMg
    OCs7zfxuS9GdYhnOSK4mRSxdPT9Xjv4w6KHBqrWrkVYHmMQbsv7+G6MYAJeosm5e8FodkT
    UrBCxVyDbIWSiSH3QtRHarMxS5pRDU1QhZDrBg2kAYCKMh9xe6h60iMqnixcDYkPcIskeb
    K37zrRlqpiMgQ/LzZ/XjR+RqECZM6my3FDNt/hEMMS3A0SOagW/Ic5Z68rylXLSAXCQMbQ
    16rWS/Gh23igeGbPgJIhJ8bMDjQrS48p+i6DB3KbjttwjoZI/yfLVdCZppfa7myKif/FZT
    tuQ/o2lH4okTcLJPF0s0er6I6rQpaC4C5r1Vx8OHjD/LOK8eFaJ5NhCB7JAz023Tlj82Wn
    KcuHBI1lP1RGCBmcWw98YeZdKUf+Nx9kKPnUUizF1CZ9qr+8Aw2oepIYOVMExqgmubtFGv
    aqFiCvPasHCbMFq18NObX3Jh+BKyBmC+bh5iAwwdPGsJY8E7RqoOhzvvdYS12FgAzMgiHt
    pUKM1SQSVtbPAvqwKVS5JrH1E8BE/8ESL7wik9R+wJdtFC0Kd0rpXJhbYkwA
X-ME-Proxy: <xmx:27mNag8Qlsd5oGYrPleQ1lZnPUg-mBioMnGtEiyiVN8HQTw2AYhAig>
    <xmx:27mNavnLhwf-3jEO5mMv1AuPSzH2sJMJcZ9dXGEMtdb16FjowiUA1g>
    <xmx:27mNai8QMTj5oUcsLB2fNlK14VYGqHaXsd-QXzDnUeOpXMccB66RNA>
    <xmx:27mNatknlRxOxTV1bu9qJtfYaSpMB9YP5vkwkT_9U7GbsWt2I7mh5g>
    <xmx:27mNasMNQlQQ1lqLfUXliTxQsU8iHdhXvErXyTb792zXr8CzsZZnrgTj>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Aug 2026 11:50:51 -0400 (EDT)
Message-ID: <6824bd6b-7c4e-4288-bfe7-4d6ae70cd9b3@sandeen.net>
Date: Tue, 25 Aug 2026 10:50:51 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs_repair: distinguish true ENOMEM from "not found"
 in cache_node_get
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "user.mail" <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <20260824214056.400740-1-sandeen@redhat.com>
 <20260824214056.400740-3-sandeen@redhat.com>
 <20260825031810.GQ6072@frogsfrogsfrogs>
 <ec9e4908-32f9-4d54-aa1e-93dfc8a5b95c@sandeen.net>
 <20260825154902.GR6072@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260825154902.GR6072@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/25/26 10:49 AM, Darrick J. Wong wrote:
> On Tue, Aug 25, 2026 at 10:39:08AM -0500, Eric Sandeen wrote:

...

>>>  Also,
>>> maybe we should be "return -ENOMEM" here or something?
>>
>> Then have callers check, etc. Do you want me to rework things to rationalize
>> the return values (and caller checks?)
> 
> Yeah, I think __cache_lookup should do something with the new return
> codes, e.g.
> 
> 	int ret = cache_node_get(bcache, key, &cn);
> 	if (ret < 0) {
> 		fprintf(stderr,
> 			"%s occurred, go buy a real computer!\n",
> 			strerror(-ret));
> 		abort();
> 	}
> 	if (!cn)
> 		return -ENOMEM;
> 	bp = container_of(cn, struct xfs_buf, b_node);
> 
> This can be a third patch, the first two patches look good to me aside
> from having weird SoB lines.
Fair enough, I was staying in the weird "we have distinct error codes that
are never checked" world and should have fixed that up at the same time,
for tidiness.

-Eric
