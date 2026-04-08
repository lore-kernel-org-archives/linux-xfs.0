Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8981338B15B
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 23:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775691378; cv=none; b=aqZWgCwzyWcYgQMYSoek6/+fkpzfH39Zfwaf7AnwYdxd8CT86jITZTcLtypDGhpcYRH9TJ/c8mmA7CRnx/kIGHe8W4zrzUu4+shRsgzy1VmkPRBaEIFqFH6IJ5etvL/PJWEjfJizNC24WKwKq6EIFKq8m5/CtSmyM5oQ0gfpoDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775691378; c=relaxed/simple;
	bh=ZBr1Zc2iGc55MrRjwjFgix/HVG1mDhH1y2K0uZueM3I=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=rIDWWfy3rF2RHgVYu1Oy/Z6As2/YV5jpdGDI5645BAZJzrNhXYwBO3wo6o+7i/5jfS6H2S07n43wpOCT4UsXJF4n26DxsWtbxUElPZSu3oiBfExvQOBpHs8rSJo/Fke5CLM8+Ye9/qEt5IPRd1J12pxbK7IkzZcZw2+hpyYLztY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0Xk0Evh/; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="0Xk0Evh/"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-470145d7df5so210128b6e.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 16:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775691375; x=1776296175; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZBr1Zc2iGc55MrRjwjFgix/HVG1mDhH1y2K0uZueM3I=;
        b=0Xk0Evh/15rcD1+KMwYreNXOfW0OhdhCIdDLyEzxmu4CDD6N2C3ZHUqgxNqj3H6Xkp
         YDBiz0ARnWrdkz7l4rj1AlouT7qqreu7O19m3AfcbBllCb1LGNoh2/EJYTpokizUl422
         NL+ALIkglo30xLRP9OkDMv6iDMaIMYAa1nS58YxhQqJgPZZ79tXMj/iMaphLdfKmjg9S
         SbC0g4JMKkDxv352//BnR07yrxqk2fxrPQ7Sgaeu2N+wW9xy6UasK1DFneO+0NqV3r9y
         YifkO4KWJkX4It8BznKrtYTyi0pYPh3CcoLcJVQZLIWds9sKcCdHJM8XrwbJRIiC1Fy4
         +eXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775691375; x=1776296175;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZBr1Zc2iGc55MrRjwjFgix/HVG1mDhH1y2K0uZueM3I=;
        b=n2cgCntPXXPjnEOI1mDYoPvzY/0C4DCo1y6/ub3w/wC7WUegYEKwlPnGV+vhuEQSkO
         XpbAablsGOXNYbKOxGy3/mZ/uzpsG+95TzGflQNum783fTEiLVrZjQT7B/KetLGHNmIz
         3ifwyjz150EVnZYBvXqQJ8boeJHrRRC3byzjQzKsSFdu9rXzNHvm1ByvU97XMiVmu7/b
         A3JOxFy/udbOeZuGJwIRGgOZJxjRHH+fb8QzWP4kxTftnFZzT+yiDfT3d4MDNE/9txIQ
         aBUBJkr5jfx8hIYaMvV/In1JX21xg3gls1lzbbrHzHEAIAbjCOehl0xpiTi+l29TKI30
         FD2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmOahTAJtRNHmIZcjqUi8N+oleUCPK/007OMTx13X9AxiVXqXsbOM5H3YmtXoPo0S30dTend2I5o8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpJXZlsdxWB3t1CNAK8YZqi4iwS1c+5ERCmXMXpLgQic3OcQDT
	eUOfdbAoO/hP0u9BWLtbHTpgQ5KCeTgowciMzvK11r2+ltiGGO4xjLmG7B2rCu7IJuM=
X-Gm-Gg: AeBDiesQn2sMtiSKsaqd52q63FJCApiPdLCm3pQ1IKCimleG9Nl9aU3n2zJ73v9gemZ
	YhJA52lPHMv6jyO/P/41L52T2Ck7qeYNK0gT0jiTfddGyoB4/zp6xL2pt2lio0BhohJkkM9YOAv
	Z5vYWDs6rSGNL14epXMqlm8ubEkEzc7lhl4WFtQYfQ6yUC9oFbFnJo1y8HJ66ftPAPi+/Jh3Q3x
	EB3mgMVuQCcE3oFctrtrQgu76i+DjWd4KoCFVJmgAXQ+dQvSHbGJ1BJDB1ghVO8fgzVe5fiBx91
	ArwVkIu2BSyw9Lhh9O40vt06yuZGtzlANeNAiNuUpivUtpS1WGbMzoB5F4oFwzzSqQrUr8ej8IF
	KWeKy4TymTXIr2uCcJufNaIRAYTmu2mpUJOd9pIasWQdxuH7RpILS7z26SJqTiLyu/Eym8lxKnJ
	Nu2YY+MjAXVJ/EIiQquXuy001AnkHM2OZlY1haevU/naNwZ4aLmU03WNwCHdIsZb/LE1KjcxaGn
	QuHVa/WZ9Cko1dRwYw7PzT68Q==
X-Received: by 2002:a05:6808:1b85:b0:467:4939:9666 with SMTP id 5614622812f47-47724c79cb3mr898927b6e.47.1775691375433;
        Wed, 08 Apr 2026 16:36:15 -0700 (PDT)
Received: from smtpclient.apple ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46d9387a763sm12681031b6e.18.2026.04.08.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 16:36:14 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jens Axboe <axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for task-context completion
Date: Wed, 8 Apr 2026 17:36:03 -0600
Message-Id: <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
Cc: Matthew Wilcox <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: iPhone Mail (23E246)

On Apr 8, 2026, at 4:51=E2=80=AFPM, Tal Zussman <tz2294@columbia.edu> wrote:=

>=20
> =EF=BB=BF
>=20
>> On 4/8/26 3:51 PM, Jens Axboe wrote:
>>> On 4/8/26 12:=E2=80=8A48 PM, Tal Zussman wrote: > On 3/25/26 4:=E2=80=8A=
14 PM, Jens Axboe wrote:
>>>=20
>>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>>> this as it seems like it'll simplify this nicely. Looks like that'll
>>> involve turning bio::bi_next into a union with a struct llist_node.
>>=20
>> Since these lists can get long, I'd keep an eye on llist reversal
>> overhead there...
>>=20
>=20
> Going to send v5 shortly -- tested with and without the llist reversal and=

> it didn't seem to make much of a difference. This was on a single-disk VM
> though, so any stress testing you could do would be very helpful.
>=20

With all due respect, a single test like that isn=E2=80=99t going to be that=
 useful. I=E2=80=99d be wary of making that change willy nilly and just thin=
king =E2=80=9Cit=E2=80=99s fine, worked fine on the one case I tested=E2=80=9D=
.

=E2=80=94=20
Jens Axboe

