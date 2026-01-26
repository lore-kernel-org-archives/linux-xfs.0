Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8640B32E724
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 10:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424885; cv=pass; b=NUN2P/jIfUe4lRsvo/MExlYghwje84UEi5npgZyRiu7D2+rtYKoGKjtVh6yY6oSRiHGmtWeUke8jigthb8iF8VtGWWu7Mch19k34M8iVoBEwJqaSU+J3ghpt9RG7FVpt715ZLGfmSS9hGdBfEAgU8j6gffyBIixBnPfGzdo0ODc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424885; c=relaxed/simple;
	bh=3omMcSnzzBOB/jU4R6Db7fut+Zs1dL68KtxqM98Cvg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AEody1VUP3TKpwCJwlJLu2Ak0jMns0rvOaTNkLOuO8XXc/Bry7U4AP5G1+0wjp+0q+27kVI+nqzgVqZDlHYXSA9Hc3sFSp02s3kLjE3ojyK7V3cqfW6guBct9yby2dMNwH5TrzajdQGjw7kYeBDJkG3rNglVNxGD3+tmkhmy2vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDwcCI1z; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDwcCI1z"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso7695232a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 02:54:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769424882; cv=none;
        d=google.com; s=arc-20240605;
        b=HwtK351SAFNWWTJb8n7N0WuRueFOHVN0tEeIS1Cxn6dwim1XgZqTKFkqcVsYZllI2y
         9f/JjiEKi+5mqFCZGaaQmcJ3O7pC6NjtTb/rC4watPBz1Vm4kSP83BwzLtnJwd6JZrhm
         +lV0TS76mo26+B4ue4M4aBc9FeivKHkds7p0m4fB1tZP44JNHXIm7qF80S0R8fdim19k
         1TAhFdHAGMUvDTEOnenOdN+RLLsq7+tmDIJKldkrudlQqULg7zjLUfxVuJc7CgBo/Vgj
         /k6vy+CC2wViHUS8GzRhhmErIUk3uOd06TU8nxK2SIgOJ8G0KpVoyX9cfRuEFaX/Sja1
         MyGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yNBCh+MzIZqXXtP5FXW5pr/v9SaMB3DIQFyJVa5+MmY=;
        fh=PRmuCHFci+Jv1cJ35Q4//x+MnoAVFW4wqsqT3ub2QWE=;
        b=auSJeK1YtoBrfP3ZLbV8oLVTbMRvyzU01Zwxy8hUPAW7btuMRtDMDQqZDBJJM4Pg3p
         Ca5KSGgmtqIeDnkd4Nucq/rk/WI6e9rWZRzcgkJ+Wwwele9ZxB87ZbvcKbyToD9mDkmZ
         3G66kmr+H4lqmE2sv9LQYUE7EusI9xZUW5/cMh0sjJNi9SP3EVR3iie4mJ1l3WhbxJYN
         yu9vomgPhQNzrAzIkJPf0L/cLsXhLHzIcvN9hvaVjOlKuoq4tMYSWmRTBECfvRjzNtnB
         RgjvRVMQXDFJrdHQ0UQqaqFko/GuY3V6/WUMuWgUq1UV2xzoxWps1ekR2XjSvAhbmH87
         S0jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769424882; x=1770029682; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yNBCh+MzIZqXXtP5FXW5pr/v9SaMB3DIQFyJVa5+MmY=;
        b=BDwcCI1zcwMS1r+JBTzVcAgOhhCyKy0iK3KjR7cl4JIukj3SmH85AXv9o9B8g1qctg
         k7izeFCcTtPCcQtECVeXoH+n24rzuwNk8c9uqRbQNFhOjscE+kr1BAy4gEqD7omZkb2y
         dactuQd5KyDLfPA1OEwNuUMSZ9eRk39Jh+Q/gCPk2LrC9aAEAoMY562w82OB/4q4YB6g
         ol38PUksbxt0njqtUvypKopW88GmE/q9XXJ3pWhOzN3l8DKqd0UCXlHY/CMu2WImU2ul
         E5MDdkm1+mUS25rqM+9YDj3y0VXgB+ZMpT8mE23DvKrUub13/KaHHX6oli1RGkl0eUl7
         qyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424882; x=1770029682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNBCh+MzIZqXXtP5FXW5pr/v9SaMB3DIQFyJVa5+MmY=;
        b=Ogf62lRmQ/FPqPrKo3XAi+BzCqeG9w3YHvCFuMarlg9wtSmi+7vCnKk/KPwkWjWwpm
         t4w3oaD09sO30OO+avoxRcXdSUbAhIWzOh0fBU267f5Dz7VKzSVfiwz9X0i7366xqo+q
         tEAPb4rVxOsZhRv1YY77NVFRe6Z5Bj4dH/xHAD407tAdPsEsHOgZncmtLxQ8M9Vuyr91
         gYMLGzzVId+XEp8gwXgt64Ou//+OvT34eWowmHtj4N5hgu2xB6Jr8HShsjh0wGwG6Xj+
         aikDo49SVNJ8oNen61bw5cQ9KizIF0OllF9FMxK4gYb7nlJxATYstqwC/zFEJNlGXJcQ
         6RYg==
X-Forwarded-Encrypted: i=1; AJvYcCXl8Ow/XlsEFuRx+sU9Dtvu16JR044SPAzbol//SyXZSk3mAtjggVct47fB87dk9NiKt5+TNO7o8p4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpMB9DjxrPFOlZEjmdZtCqqLFNCGSBgYJdyXpqgiSerTMdgl8G
	P05NuNPj+voSUdz7obfHjCNXs7ab8fxz1AJVYcz+nfWnbTlLikHyKmDvl+vUyrKEiIpDUfyjg29
	td2w7LTY1oSJswFJQspPmFKsczp1E8w==
X-Gm-Gg: AZuq6aJWOdj1PbjqMr6wR/ZpyxD5TUNGua5qjKwfoRC7PKyXvl/6V/3aAjsnvoSl0GF
	PDa1WBjT13uc5jS6DhSlXPbeNdZK0gz1fKDNlk6Bu3vz7bnmsoKuq0xlBItk8Focf7EaJnxx7xl
	9WzT6dwKTGW6796eQB5pbweGShl7v1hHWqhbmwy8IuDOJxcPhv6t/fdQWJGBZ3QKU68OawJ86qv
	UXHJkme505NCM8Nigd2P/t6YosHbCf/MIc8GbHYkZetg+SMMDPbBsM5GzN51d0wpWXXTgBh1RWt
	xBR5tCIDQYDI1csDswmy5qtq/OtgrH4/NVT9IGp//J1yGAUGwfwd4FpeBA==
X-Received: by 2002:a05:6402:4306:b0:658:1224:3d5b with SMTP id
 4fb4d7f45d1cf-658709c0267mr3007632a12.1.1769424881479; Mon, 26 Jan 2026
 02:54:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126055406.1421026-1-hch@lst.de>
In-Reply-To: <20260126055406.1421026-1-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 26 Jan 2026 16:24:03 +0530
X-Gm-Features: AZwV_QgJvnXLJlNIFnJC-x5vJYhiyLLjRUKN4n8q42zV9yyRDXraubp27mNNc8w
Message-ID: <CACzX3At3fS19fmp8wOq29rHK-yw0KFp1bAvTdo9NC9eQj4E=pw@mail.gmail.com>
Subject: Re: bounce buffer direct I/O when stable pages are required v3
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

As Keith suggested, here are the QD1 latency numbers (in usec)

Intel Optane:

Sequential write
  | size | zero copy  |  bounce   |
  +------+------------+-----------+
  |   4k |    8.91    |    9.09   |
  |  64K |    35.98   |    39.9   |
  |   1M |    341.96  |    531.51 |
  +------+-------------------------+

Sequential read
  | size | zero copy  |  bounce   |
  +------+------------+-----------+
  |   4k |    7.18    |    14.28  |
  |  64K |    36.4    |    95.61  |
  |   1M |    206.38  |    258.66 |
  +------+-------------------------+
