Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336D02F7468
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 10:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763980941; cv=none; b=KpYzDnsPnt5LlLptemuuwQwdnSavdZoMCptl9mbRVzytitBwu0dSVugtm6+qGZySxPiRprGym8+rTMySnggw/cExtFNTELDB2cjD4qDSOcMs5bfBuVIDvwHEw1IMpBs30JgurA60cUt11VJ0Qe1BcIhnxZctPjkzHJXC89TKLys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763980941; c=relaxed/simple;
	bh=v+fcHB5jrZ0bzM+bi3iSOIc6vomIxqeHdaaw7OlhN28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z7qYtFdTV5YD/JrPTt4f9eVmj6tvaOUTPMepVFny2+xW2ZcQvjkxDfeKnwj2xqN7bx8j7M9Mg7L18Mkjx4toF6Tdu/tA7/BkOdcL5MHxufJ6dZdOgvrgpvOPNmaCNX3zP6V/gYiNKOm21MfefSFvfEUnMNEicBKKkbHtPq+EPk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mlsdW3+9; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mlsdW3+9"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-656b0bd47b8so682430eaf.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 02:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763980939; x=1764585739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etJXtf8TSdFaAFZ/8HOulbuYaN03PyaZJ2BwGX9vOeM=;
        b=mlsdW3+9iYRCMxSKYwtnjRU3Qd7AMpqL8PLSVpMp1bTQcttkXHC07ubriHsND7INoX
         tNUYY1arNy2nUBikFc7jraClvisE4xIdWlwwm4vpsP3iAolIijVLDiA55R456AEBDwcV
         xZEiDkDz0i9VY7D/UJkjL3ARochyecbrLkDTLdV0jFChTRFVbsrqwtS6aClKU68C1wrF
         PhlVqHAomhdsCWHoFTxdh770Kq5opEuEuKDder38Dehr0NhOaRP7REssdm21V1XZBHiM
         Fn4j5wDpgdp/nhmsElvgJ7+iSB9PcJ0Elv/dBB+GhReWXsKhewWWEyG+MpnmnO3RhWsq
         eP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763980939; x=1764585739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=etJXtf8TSdFaAFZ/8HOulbuYaN03PyaZJ2BwGX9vOeM=;
        b=pEuhmfDh4p1qD67ngrHsSHSIOP8+o/8jj+V4jvhn+KRztJy8GYICHuMF/D0eWC6Goh
         063nr9nuOf/7cSCoOnIFL4NOezjBDmtrK26Um0aRFsXZ1P9xupr9k4lWSkO9/d5OiKEs
         yfwEYLHExdZvfdHhvuOFpl6NRy5SqPaQDLF9IHCBxWtcBaoPvXjRjl3b+vCl3rq4p6JH
         RTZo1/d5AbucugHG6c3TRHWKf8aJYgcM6DPKVmW6q57s74hGO9pVP34Cw0LsuwJwMe2L
         YNoYalTa4X0JBThk54C+Cs26RX9tQ65etyiWzJRa8XKD8+UA4Js68aGIFWFEH4ZebCGU
         neMw==
X-Forwarded-Encrypted: i=1; AJvYcCWRXWyGouk32JCgGggiMqRz9l8m1YXwF42X9ZD267MeE3Gb/AOPBKhsi5X1acRVEiTWNRvx+mGJf6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp74uCzLl4tCwe5gW59uqZdhrB1R3h3m9E67dNII29VlAqwQlK
	zibVcomd6rXWC567+8Z4wf2n1MSJDUU0hXumxc+v8+u1qqT03fld37mUBIJgx+cDTpZrMPVaunc
	LL8v4QKMygRZoK7iriEyiIet7Aoqsshyn3PN1RbvNFZO1BFCu0Lyg3+ALEyQ=
X-Gm-Gg: ASbGncuhQ5FssodLNOWPzUK4V6LlhKLdLlCx3tMF+OEIzn0rakc0LDsOt7gdGwsPaks
	n+D3ZFLd+CryE9qPUdd8c7vdEq59TNeknUWmJudmRW9gVXayrnOJ2zCPATsP/tmgeHqmz2BZQR9
	MvFRdQBfAf9dIUvAmkxD8EKEtgzHgrGW9MefSIZJ8AqwhxWkmr7hhUIGb+hYgdqB/9/hlhdnwRL
	9PCuT30BVZdvtghpczLvbLvEf/FAjlPLWXdRaoK6EKReth5wSs/18KUHYoKxpoPAuCFx7V6+FH3
	wT3DZoifpTIo3Bk0wl0Kdr/5Br+dPbGaO+REjTuAG/ll8dEZz15oikYu7A==
X-Google-Smtp-Source: AGHT+IGdlfXGuxnyeESU3XhvnffjJNu3B3x1UiXFoimbPweGl9nsu4Ietrz7SfrfLEmkVns0+Dzuqo4jyMuh9oyG/iM=
X-Received: by 2002:a05:6820:150a:b0:656:f32c:d8e0 with SMTP id
 006d021491bc7-65792571033mr3714719eaf.3.1763980938888; Mon, 24 Nov 2025
 02:42:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <692296c8.a70a0220.d98e3.0060.GAE@google.com> <aSQE_Q6DTMIziqYV@infradead.org>
 <CANp29Y700kguy+8=9t7zG2NWZDYtgxfqkUqsRmE+C6_hFdh73g@mail.gmail.com> <aSQbYfHTBvX6cpsx@infradead.org>
In-Reply-To: <aSQbYfHTBvX6cpsx@infradead.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 24 Nov 2025 11:42:07 +0100
X-Gm-Features: AWmQ_bnXWFEKj9dCsJOoqgbcU7rt2ipZRiXzuhHi00GDdE99ZW107IwmgJ-Odj4
Message-ID: <CANp29Y4qahxvc3MDUQi6ScTK-RVnbTSL3C4TGYPZampEpXKWNA@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] WARNING: kmalloc bug in xfs_buf_alloc
To: Christoph Hellwig <hch@infradead.org>
Cc: syzbot <syzbot+3735a85c5c610415e2b6@syzkaller.appspotmail.com>, cem@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 9:46=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Mon, Nov 24, 2025 at 09:43:47AM +0100, Aleksandr Nogikh wrote:
> > On Mon, Nov 24, 2025 at 8:10=E2=80=AFAM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > >
> > > This got fixed in vmalloc by adding GFP_NOLOCKDEP to the allow vmallo=
c
> > > flags.
> > >
> > > Is syzbot now also running on linux-next?
> > >
> >
> > Linux-next has been one of the targets for a very long time already.
>
> Ok, I'm not updatodate then.  How do we deal with the fact that no
> specific commit fixed an issue, but a commit causing a problem got
> replaced with a different one in linux-next?

That's indeed a difficult question within our current bug tracking
model. For now, the best option would be to just invalidate the report
so that it does not stay open:
#syz invalid

We have a backlog issue regarding selecting a better approach:
https://github.com/google/syzkaller/issues/1878
