Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFAC1E0B86
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771484755; cv=none; b=Pyv0sTh2Ghf/mhN4FF6FFfge449FUWZFrQ2k44QWHeCezImD8zh5V+QuWe1QLLCQJ28bsrCaEq1/2Y3Pjtd976SoB2kZiyD1mUihABRa8+FNrAP07nr2ugYLxmuIVZsirdv21u9VA3LrJJcn6P6K9bRSYgOQT4F8bhelsXVl9mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771484755; c=relaxed/simple;
	bh=WuQmdAn1vghOmwoyosP+Gt0N65+k1k81590mRfkBVtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FrQo5kX4cJ6dKVsshmVYIcBlce8gG5pqlYw3/9oZ7h1OUMBQCkfvCPR7V9nSbCF1ssuYQj9TmPPYR4WcOw07qkEBPlO1kFh6GGvrRxwF8NHVm95OmkV+xaXyR2BbyVhX5KPUv95ptwXY3ERtdPO1rcj+USKswiqFac5geSn3A2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kqzEfzNA; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kqzEfzNA"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-824484dba4dso569296b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 23:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771484754; x=1772089554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8uA58llZY+ihHWUwhRK9pgTO+E8Yr7fW3npOOp0pD7k=;
        b=kqzEfzNAfDVUMl7b6+olngc9y/xRa/K0QLrHNdNuNc0wPEy7dYYHJVjbj81cF2BS+A
         3vphUEP6Dj20BY/bYYYs+ed9LAHykuuGshacNq0oOkXzlYHQZfh421jN0v3wj0Q/4PrS
         z4DS2cJUMl6haKUTUOvq6JmRfYcy7vWZmTh1LaXmQgOlutmsPaHN2DcdZBrPT22VrZQ0
         ZyLAyfncgdrNOC7ETCUJpQazFO5O8rqbFe7Ze6f822u1axWucue4kOS9r091Ao5k0Q/n
         AddaEwvSYJMg+fXfNMUIVm3d0bcRx0F3O1TYWfSREL0tlpoLKQy9b/3kuPrGoz06ojrT
         +aww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771484754; x=1772089554;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8uA58llZY+ihHWUwhRK9pgTO+E8Yr7fW3npOOp0pD7k=;
        b=HUqfkGd3WWxTtP2v5ImXkXon1x0W48Pqx3mTmQSYJmDu0FX7s2ltRftQhI2bKVHHdK
         Gav/MwmyzuBuE0bG2j3fZIlVXrthVyimeng5qYSr1O+rTXRDNce+x+1En2kavckBS/FG
         IjYxU+WqOGIokQBqNNE17zOF2i5oaWBInaNVF5j9l8VTKAVxuKgT+4ixhCyAstIC/CHo
         sTRt7+cXzetVOxAEx/MFwj6b6nxE4Z30j52eKKdsBmyDguJqHsk3AVWcf1jd23kPKw3o
         27Gp8LXideIniPmBBWvzSI0eANObEM1JiJPfpr+hrdlgGcrfVohh4Ag0RyjQp4GpNbAw
         3Xpw==
X-Forwarded-Encrypted: i=1; AJvYcCXxYAnTiFZ3eEVEGi4vTK3QkCe5Uwx+hTkazxriipuqXmKsW006v09yvUv/rLEE+W1gt2SYRcvrLeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YznUSrZXkzIYzXK/1s+DpJ+DdICPMVS1Xqo0nMJiVoJ3dFOpDwO
	Xl4orhEykuU+p4F/WhP6hLkacK9m8MFbtby8ovIHAaIy4G0hWtwadgJl
X-Gm-Gg: AZuq6aJ08UP9n8VPlY4mmA0TyJo05eqyUiSWVRZ0Zr4R0vz/JMYm+RWlbpwNqqTA8QD
	A+9U0Wu4zfyo2b7eeE9orpzDP0qABbBKKDY99ZtIy5aDOf2FF3ZSgLFDdx+uzEnmQYkgl7JGT+a
	RKvyOjZCSzpShj12jobRUOutDiiUer5S81XkNykYJQLqH9vfpvcdpZySwzBaDz1EvswC0atTQdM
	5qva7aiTD74vnIWFZJVPYP2016FZIWgLz5TgOhyp2IkBh+DeemCt9hVqYcksZcrfEZmHkxBxsNs
	TJecEl5fA/4WMjt3/cqkpAhSsy1fTXUwaJaPoBnSQ+M/IpP1uYpn4Ew3n3+2iYprFN/pVS1flNS
	T+hVJ786FglcAv0SDa7dhYt0GlTb5z3MdQ4BePgLgSyND2Yf0tSaZbyF1ub/p156qE6Zx71dPYS
	+Hw/6Bc8zDEjtYdi+exXLQ++p1feyRrX6JLwOlOg==
X-Received: by 2002:a05:6a00:1581:b0:823:b6b:4859 with SMTP id d2e1a72fcca58-825275ef357mr3480991b3a.49.1771484754190;
        Wed, 18 Feb 2026 23:05:54 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6bb26f9sm19684696b3a.57.2026.02.18.23.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 23:05:53 -0800 (PST)
Message-ID: <c58134bd-5060-4335-afaa-84fabe9c101c@gmail.com>
Date: Thu, 19 Feb 2026 12:35:49 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVUEKzVBn5re9JG@infradead.org>
 <91050faaf76fc895bbda97689fd7446ad8d4f278.camel@gmail.com>
 <aZav-QE1L87CKq5L@infradead.org>
 <fd8be071-55ce-484d-872b-aaf5eeab1138@gmail.com>
 <aZay6Zub8PFPrQq1@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZay6Zub8PFPrQq1@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/19/26 12:21, Christoph Hellwig wrote:
> On Thu, Feb 19, 2026 at 12:16:51PM +0530, Nirjhar Roy (IBM) wrote:
>> Okay got it. So what you are saying is that, for rtgroup support, lazy
>> counter is ALWAYS enabled and xfs_has_lazysbcount(mp) will always be true -
>> so there is no need to keep the updation of sb_frextents inside the if()
>> block. Right?
> Yes.  And given that it confused you, maybe add a comment about that
> for the next round:
>
> 	/*
> 	 * RT groups are only supported on v5 file systems, which always
> 	 * have lazy SB counters.
> 	 */

Okay, got it. Thank you for the explanation. So I guess the reason for 
always keeping lazy counters enabled is for performance? So that on 
every update of the counters, we don't go to the disk and increase latency?

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

