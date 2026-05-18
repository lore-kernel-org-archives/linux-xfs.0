Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE6B3F58D0
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779105261; cv=none; b=Y5grnSisV3Kv+nYo3Cdcx/bOHd+Z0pitTUOrNdxdCn8kOjgHKqlNoGAjkuf/I1Zu6ESfKTSRVtm3PsNaOXrxM36o5nxks7Wnuu2kINCN/Cn2CiVxJ1si2iVmeuNpahvS720IqcbguuNkDwGuYJdiNIblhkbtbN7ThlYikGw9Ksk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779105261; c=relaxed/simple;
	bh=kdOW9viti1nUPSWuqTTntTNAuJc5As3HhRJutVJkgPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPQYfefFfv+vjAG9Q7EHhwfU2l+Joa2OqRUg8thPa+Avd+2oFwQYO7ZjSZ2yliqJISVp6zvHCyGoon2GDgERQDXLoTvWkklP6DoO3u0WcP4jDerMQXxcsEY+9vlNXM7JPruxKwKi2Eo0HTDI3dki5Dg3Jjkl8Q6tLUiEcm5axOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TgsQnn1G; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TgsQnn1G"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36931e4f5e8so1868173a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 04:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779105259; x=1779710059; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtAIX5qS5/GkaznlRplOFzDhgrO1jA4rd2kz+1iiksw=;
        b=TgsQnn1GwtsYY8o/8uD/0bhQudgWA2O1PWaIM959R5CyDTzfbtIqjny8ejBDNXXL9L
         LHWzcdXhs6Ds4BpyaUKs2Gt8xNk8TD2Eo9MBxd2dBNiskx22zBNccsi8+CaoWnmCb/MC
         KFAC6WH723ia/0toogRZgslOKZui34GG8+rjDEXJSAfabNUmO2qgAog3WcBY+4joMvcI
         qVR3rnmnNuPJHXKpvJWjJNRlaXoYnHAj8iCRRlaSe5VWLGMUiEwRg5Y4MNftlCaUBBEx
         YLHFsKGQn3AHa/2wd25oICQmyA2fHOnRravezB/gf8GKNIFCp8HJUMKbnOrxgnunLMH3
         cjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779105259; x=1779710059;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DtAIX5qS5/GkaznlRplOFzDhgrO1jA4rd2kz+1iiksw=;
        b=nPS/tzzlAQkrIYniXdK7G9Zgx9x5FD6O05TjC81o9Z9ZumqyDNsruvMEjHpTdWVrNw
         +GCLwZqx5++JYJKZ28S6hD0XjEJlxVkdnzZQQ+zMX9wJ4QCPgBxqjMAsx5Jh1T9Xdhq9
         AI/mryBgxlTiF7WgdQxWnRvr6Xg2VBPNm57Kf7wyPVYO3+f1jTgpBqVsBA/Gne0JbOYL
         A0zd18iMF11Me2qt25Awwoo8ElYiRRRgTZrj9lyiTcpYOQex85tjZWb86xeFCPZZciah
         pfCWp+swZaffzuCW4rmBGeSNNlnITCj1/imX5c20qBV3QPhZx7zuAQXknkxkRPKa9hKH
         WZzQ==
X-Gm-Message-State: AOJu0Yw+Yi6qhfYdEEQIdY040YOphTjrBPKfsQ/hRgtrqfbbgn4ENx7Z
	VWe8gsNmJKWhmg61roCwFL3jsYlOdt9I6y/5069JPbrbg6WT6JVFcEGI
X-Gm-Gg: Acq92OHrzSPt7aqBQIfrnzCfAMD8h0cWYwxUTXB9q35HjsKv+gtFkJACRab6jDetTtQ
	qqW2ol6pePF0nN85wcfaVUzAnwsOlhBVDx+9JJT4Uw6WyiJFtqg+OJwmrkcTc0UWkKh+hyRPf/7
	RZCh/0R82dQH+i41Z/n6xYHid0CMEWN2r2RHI/oscVblgqQIwaixuSammhoizQC0YAvCp35WF2m
	y8FUPMfPck0sOKWPFysEh8D/1abl4nvA8YULDokeWelTobanyrcyFOePhjMjCE2WoTqLe7IQC7r
	EGAmKvWmxVycKvgZOlr3DiRXCJ0oC1dYl3/T+OhYGVV98lTAu5UWkr8yxDncqZnzrJolWjOgKS+
	JE+fTwPLK6lkpYKi84VPWkVbDrNDEVDUUfYO6k5Wn1mGloXpWUOqo+mG6TKKeze7YbQTd444/9t
	gFSBqg6QnutIAl/FLD7X6aOwgZfzQuKVMtFxWP8181oLAtYh2INQo+G/mCU5ZpJHAPQP4zd8yvH
	a1dk8dFwLJg6booTVr3amfGRn7iI9kME90=
X-Received: by 2002:a17:902:f64c:b0:2ba:fed:7891 with SMTP id d9443c01a7336-2bd7e92c24amr169888065ad.30.1779105259395;
        Mon, 18 May 2026 04:54:19 -0700 (PDT)
Received: from ?IPV6:2409:8a28:f37:7f74:ec28:1731:e3d9:441e? ([2409:8a28:f37:7f74:ec28:1731:e3d9:441e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d23b085sm147195625ad.84.2026.05.18.04.54.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 04:54:18 -0700 (PDT)
Message-ID: <11e8c058-abc7-43cb-a8ea-8aaae9d03451@gmail.com>
Date: Mon, 18 May 2026 19:54:15 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Should we hook up sashiko.dev?
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
 <83e6b930-2705-4719-80cc-71987092f1b7@sandeen.net> <aeiydeH-zDYw3yCK@bfoster>
From: Fengnan Chang <fengnanchang@gmail.com>
In-Reply-To: <aeiydeH-zDYw3yCK@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/22 19:35, Brian Foster 写道:
> On Tue, Apr 21, 2026 at 06:47:01PM -0500, Eric Sandeen wrote:
>> On 4/15/26 11:49 AM, Eric Sandeen wrote:
>>> Hi all -
>>>
>>> "Sashiko is an agentic Linux kernel code review system. It monitors public mailing lists to thoroughly evaluate proposed Linux kernel changes. The system acts like a team of specialized reviewers covering domains from high-level architecture verification and security audits to low-level resource management and concurrency analysis."
>>>
>>> This is something built by Chris Mason and others, with Google providing the LLM and tokens.
>>>
>>> The website sashiko.dev shows these review results for mailing lists it is subscribed to, so you can browse around and see how it works. I've heard reasonably positive feedback from some who've used it already.
>>>
>>> We could send a PR to request adding linux-xfs, and I think we should try it.
>> Ok, we're connected: https://sashiko.dev/#/?list=org.kernel.vger.linux-xfs
>>
>> for now it is not sending any emails; it's web-only. Depending on the
>> usefulness and accuracy of the reviews, we could consider more than web-only.
>>
>> I'd like to set up some xfs-specific review prompts, but apparently we need
>> to be somewhat sparse on that due to token usage for a large set of prompts.
>>
>> LMK what you think of the review quality!
>>
> I just took a quick look at this one and it seems like it's accurate:
>
> https://sashiko.dev/#/patchset/20260420061630.62077-1-changfengnan%40bytedance.com
>
> The flaw isn't actually with the patch, but rather the surrounding code
> it touches. It also feels a little weird to me to have a tool that tries
> to communicate like a person, but maybe that's just something to get
> used to I guess. ;)
>
> Fengnan,
>
> Any chance you want to try to fix that up in your patch, since it's
> outstanding and you've created the helper to facilitate it? ;) If not
> nbd we can fix it up separately. I don't think it's a pressing issue.
Hi Brian:

sorry for missed this, IMO,  it's a fix patch,  it's better fix it 
separately.
> Brian
>

