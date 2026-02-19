Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCEF332EA1
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771485001; cv=none; b=RG+91ni3NGr8DFzONUQ/kM/npFqIcQrl8NyqnuwPAk4Ny1bOpR0MJ2uosjtJ1vLZm5hs0dJFdfPfc6DbRKqJoArvKqkp3X5TIsKVywWU0GSNtGxYYAPRHAUc14hFM+lnh2/6aBPUwWioCqU47SlIOZoQ5ZPDX0yjdFQu0zGNKrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771485001; c=relaxed/simple;
	bh=YEAJVE9LfzKVDMA2wzpMPjqIAmG+jJqLo1T7uRAA+EY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMii7MDEWUVnugFrPbQCIGl3SsGBomCJLqSIU+g9Q14BGeZDFX0L9/uuTYJBwDn0DF00Dx+cfQ/NQgabb2c4wC9kw8I98jxTmVYR2hpYY2ylWZdGcIl80dzkt0UV8xyVaaZJ9QNpYtVwy8Ep+KtWWCEnuRJopKtZNeNq//F+NAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhA8Mb8C; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhA8Mb8C"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c6e2355739dso196539a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 23:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771484999; x=1772089799; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uuzba7wVIP/VM5q97n0C7AOs2xCzFgaQ81bGSXrUdVw=;
        b=mhA8Mb8CBOd2hXGcrrD2SaZwdoreAi5kU2Ql59Gj/1cWnHEQE3FN4tHSdzbQ39IkUL
         N34UALYkOY30SmFbD4FOceLcp0kPJBhxHK6MLV9/Cmq9I9E7dQ0lPogUR+0L2e0qDg7y
         WeRhl5eYLPJcj8zwxFAYf5pNJ/gvEjpergLVBysox+QeYindXINqXpi9ArG/7JVjsi8k
         Eeo/wZjEaVrfQlOk0f9cOaL08A8LDaq4qAVPIxO/I9tR1fQLzYOW4GLKPtmPFj1paljm
         2iO7OaINon5iBc0Y7Jap0c1kJzvfDar92dvp34XIzVJgFN3XNBvNPrvRKqm8BvfqyI3J
         o58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771484999; x=1772089799;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uuzba7wVIP/VM5q97n0C7AOs2xCzFgaQ81bGSXrUdVw=;
        b=Vyctgqqyv9Yn8Ge71GDRbGuIWje03ThF1obdT0MeYjvEIfVFZfVxy+tcQBZVs/iYyx
         Y7NLP8zwOa4W90FCA6xWQ22uKwDLX5PkfgOxKBOxGp1fnvaNzz39eUZhiywG2RfTvc89
         m1vL3yf0Wf9lftRUALVBFlEkL/jliENKgClUfR04wQ6+nq+4OmHJwoo0xyQIO2NP4eVB
         3EJ2twzWPqeF134mT1nkDTT9uX2XfA32L6RnVG5U63zoYdBU4YeKUtW9+Q5OEacXEHxw
         HPeWRN97x2nts+oGFMkIwkbnsQLOw6/lUehTQc8ZXmGI4V0Mr3QlRHz1Is8vsfo1+9cL
         Jttw==
X-Forwarded-Encrypted: i=1; AJvYcCWIiEg61UoOtkwECXUiaDF2akVzqobgKFypGzCyNl/ZQZw5gW0HxWlyfI9MI+Q328gao2vmwkp6+9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBFxYtCjKtQGigUPCdKWNFjklakLoNu1QFFSOJ1K5K5ePOYKsb
	sqgIfiULErrV8swu8tY6z0qHV1M+26jT6/GfJOATr3IAe/w+LsyEfV93
X-Gm-Gg: AZuq6aJJwn8R8Uc0CuQlnMtPBv8csiRUWA3aQ/DP+/UliI6wwQrB89A018pEpJS4kS9
	p/YPNUg5FsnPdRpBacDRFRyjyLhaTE/i5qP2FyKtWQLfgw0VzZ4lUNGDWqjsI3DDURPyIxVFNwk
	fT+fnG8r+k0cO9Koc01pgH5pN+whAnLrBitmO3X/FkI7FzoRkQyVE/OwxfqWAdeUGTyUgiHRBWr
	5XiBCATLaEWRFEmod0t3WTiuPRfjYbqakGYcLqBRTjJ+P+F4RjaWOPutvAHsHt58h1EofWA3bJw
	SGE4yOgiXqgRxhQ/5slDQmb6RuqBWwEgt8xnE502RJUbXWuV2i6IPcydWzetLTlsMho7F+5koj3
	Fiwk/XAfxASqpPk46m7GP939xaHRFAWqIwHxozZpsAcyh6+P2Pyz9bc4JfW9ZNPiLmICtRXf6Md
	Wj+KdQTlEsyxlh18uc2loRGvL32uXQhQMZp3Le2Q6vY6Dd1pkz
X-Received: by 2002:a17:902:cf10:b0:2aa:cfee:a47f with SMTP id d9443c01a7336-2ad51002bc6mr43842085ad.59.1771484999337;
        Wed, 18 Feb 2026 23:09:59 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a7145cbsm211471205ad.30.2026.02.18.23.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 23:09:58 -0800 (PST)
Message-ID: <3d4f3369-56c5-438a-a248-6fe18ea3bf9b@gmail.com>
Date: Thu, 19 Feb 2026 12:39:54 +0530
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
 <c58134bd-5060-4335-afaa-84fabe9c101c@gmail.com>
 <aZa2z60j4_WJFOxX@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZa2z60j4_WJFOxX@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/19/26 12:37, Christoph Hellwig wrote:
> On Thu, Feb 19, 2026 at 12:35:49PM +0530, Nirjhar Roy (IBM) wrote:
>> Okay, got it. Thank you for the explanation. So I guess the reason for
>> always keeping lazy counters enabled is for performance? So that on every
>> update of the counters, we don't go to the disk and increase latency?
> Yes.  They are generally a much better scheme, but it took the XFS
> developers a while to figure that out :)

Okay. Sure, I will update these in the next revision.

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

