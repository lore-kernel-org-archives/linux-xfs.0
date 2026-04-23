Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B7B330B3A
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776961266; cv=pass; b=ZOCWFWxqz+g/RRPM605PPpR/3XdbvdwGV3S+skqzHpd/FdEHzgMEvzqFFWqwQb2Kj1oVavhrPJufEfCXwoDs5oU06b2MncUlORqhbEQb1rtdHHG2cI7/gwyXyjsvBHDK2hKNbIzFddOzSw6iteWI1959Qv+u/BYNrS9hGba7f8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776961266; c=relaxed/simple;
	bh=ZoSklbGcCkdQVQ7cKRrY2OEl2h0RV+ReTOxDyHsdoxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i1RAuVQ1lEL/w09H0N/jxEN8SpQNHEG2x0PJSJiwsykrt2TknFOt9ZnMaMSOSJjVPe9BhetUeb+I11JEQTOAfr14+Yno6YYurDYLvRuQuHCsdI/xIYB7mxNaxHFvYW/IB9Gzq7s1kbcwGnGk/Y5aps1Bw9anQji8tPfL6tD7rWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openresty.com; spf=pass smtp.mailfrom=openresty.com; dkim=pass (2048-bit key) header.d=openresty.com header.i=@openresty.com header.b=kHL9FjDx; arc=pass smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openresty.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openresty.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openresty.com header.i=@openresty.com header.b="kHL9FjDx"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ab232cc803so33347555ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 09:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776961265; cv=none;
        d=google.com; s=arc-20240605;
        b=eIIYglIERVz29o0Y80DkMXUwCXj7f613P4FWatyp8dbwm8e9HDhW2O9q4jqYK1X73b
         t2CJxK12laaC1hrtkXKqrFyeq1CjoXlXZx6YyCge7GP4iJ/o5K3mZqntpi/YhcR7GA/x
         +H8GaeIf3QNRKrWe8W6RzjZJkDwe+Ay4u1QfdR7tpou0cUZqMiBlIzMoQwrF4cEZ08wX
         v6x3S7uIMNPMhxBo4CzFCslAIBp9aOPLbKIfOCsScP9bKX5d8SyVt+ncDNMgb68atMMz
         S2PogVBcsM//UeNJkUdsLg6TjIdVA3gEqtYM7zYTSP3Tv9wd+/5ySTKTjOnIiaD+yaLa
         v/Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZoSklbGcCkdQVQ7cKRrY2OEl2h0RV+ReTOxDyHsdoxg=;
        fh=rJ7CpnQeBCJffdlfMeUDrWtRGsyvDaFwQ3auGj0W5lc=;
        b=Lms13+8CGSzkBXeE2CO/glK+GCk2NHqnJCrNoOk6D/Zo5eOJXIcO3oiVBFJRWupYmE
         bLbk+5tN9kC7n3zZ+WaD0TtftMUO6+tOL4YD/U2TVMx3yuhzA8AObA7vLcR0LcP3hvcn
         zQjYLwfqXfcNb8TDP4yDt07ve6c2JNOrWRHMRDmCEK3zQIKGYxg9zNhfifyFbQ1Ir/aj
         qx8vkK57XvQFJPiPSPFMHswU2CY7l/XuUNQ5s6yKuEHbBe3MZJtt2Q05ohuwr3GRmMIF
         MY/ijOEW1DfV+kjLkZaG7hIdmAtqOYXyBQhD8dIIz6q+XkM6N2RG0+xQGSFOdWzULPSg
         +hOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openresty.com; s=google; t=1776961265; x=1777566065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZoSklbGcCkdQVQ7cKRrY2OEl2h0RV+ReTOxDyHsdoxg=;
        b=kHL9FjDxdOmwo2TuAhfEN+aL8G0frLPMdQT/gR1+ot3vRR0D+gvfMpbOY75NxFbcQj
         WFrMWlba8UxF9iHzYsuu+aUc68D5fGlgXY22IqGfd7JFnng9Jdba1mIvg7xjBiFa37P3
         vo48IM/4nj93g9l32XwsCgViCXIfTRqxIa8hJ7Jbsam55DdLM6cEVG1IXOC+A5G6nC0v
         Kiyn2nSJwaP9VzqkE9WnJmDFBQ7FGolLgtp1+QPH7WrdBSqKpWqPRllTFMCQ6DtVvGcx
         xtZVVTFwcw9w/cQCeOTHNPD6RacoVLU38JZtmRGm+pAHosL4DCRdHT9CukQpPKlGTT5D
         ZSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776961265; x=1777566065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZoSklbGcCkdQVQ7cKRrY2OEl2h0RV+ReTOxDyHsdoxg=;
        b=gnveawL170QUxS1q3A42pqSk/debkYJRRRX8QVygNW3WqgGZ5NVtSL44nB+K20SLIV
         FRNjam0yMx23niEIkgrUV4YBQxNcsbQzPSyBuCAPRExYwjnh0ep52HtoFN8oJs+EILHX
         NQFDbAM79CBG4bKUcTcIF3qs5vqDh7Vm835ejO2PMecWQYf4JUTEdVxr9rX2jgQ0Idhg
         6oF0T2oI5abjukruy2m+H4WHOWFI8CKgFSuXb8l++Ifk4D38qOoH4qdliDn8uLt8MXyJ
         EtmnDcG6xKXH7VsL2kL9f8iyNv3OO/mCduAYDk0lZaLlJEOB75XtxV1tHz/eTNWlZ9xg
         nt4Q==
X-Gm-Message-State: AOJu0YxdR37NNJ5OPDTQ+CZIPyObaEktzbBJ6P7T5ZsaXSYMjn1plY69
	k8On6poOtGgGjEygWnubmmF88/Mvoc3FJLQWUM6iVmEZ1zz5ev6IDdXNMDcYMpmwaxqZLYHi3ig
	AL/IHrmDabiNQ8qPmG8h2LRw2csCYX6w4eBJzQT4YkdjRDK1y/5yVyN4=
X-Gm-Gg: AeBDieujoKy8Yl8ZXe8UNpUd/ddTrhWpHUAS6XlvU22RRPKa/ePOMzBCgqdq0Bd1WRn
	y13m2Slv9N0Y3Y9e2ftbDQMZEHwFtUVlA9o25v1SsxbJ8U+km30/EIOQFdFxZ5M0XbBH0KDGx30
	04fKwcrVA8fj6toCExNUsvBeWezXKREKVcnU/ttqFbcOBfMvDYXzDKKq9Il47Cown27TiW43n3o
	yv5jxS5lwFLrvNq1tht8diupmCvX0QTb8I6DIaFo+Be8UuXa6zOn5f00PN0+yrqDb2LDvPNjOF6
	TZHHagrGnx3tVX0msFf2ZRyhPgnZrrfNwT4zPq63gqSsvC2z8QYz
X-Received: by 2002:a17:902:74c2:b0:2b0:6d33:e7c0 with SMTP id
 d9443c01a7336-2b5f9ecaea6mr223243735ad.1.1776961264697; Thu, 23 Apr 2026
 09:21:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422152505.818254-1-ammarfaizi2@openresty.com> <aek0-rq8zX-ta6aW@dread>
In-Reply-To: <aek0-rq8zX-ta6aW@dread>
From: Ammar Faizi <ammarfaizi2@openresty.com>
Date: Thu, 23 Apr 2026 23:20:53 +0700
X-Gm-Features: AQROBzAi2UsI-20jfUWrIvnJZC15-HYlrcUx6dTprYVhDUiwBCsh8jbvltFHGwU
Message-ID: <CA+KFgX5vp4L-NrHKDBCy+FaVEO-p-D1ReSKDv_1_hk+5cEnFhQ@mail.gmail.com>
Subject: Re: XFS Deadlock on Linux 6.12.82
To: Dave Chinner <dgc@kernel.org>
Cc: Linux XFS Mailing List <linux-xfs@vger.kernel.org>, 
	Linux FSdevel Mailing List <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yichun Zhang <yichun@openresty.com>, 
	Junlong Li <lijunlong@openresty.com>, 
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>, gwml@gnuweeb.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 3:52=E2=80=AFAM Dave Chinner wrote:
> Well known false positive.
>
> Lockdep knows nothing about inode reference counts and how they
> interact with memory reclaim. i.e. A referenced locked inode doing
> memory allocation cannot be found by memory reclaim processing
> unreferenced inodes, so reclaim cannot deadlock on inode locks held
> by referenced inodes when doing memory allocation.

I see, understandable. Thanks for the clarification!

--=20
Ammar Faizi
