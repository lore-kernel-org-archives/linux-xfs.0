Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FCD33ADA8
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777013855; cv=pass; b=WgXSpgzOsTvOy2wrEqC6LyhpjvR5ElDNXT3bb7HrL+QIj2xVZBoxmFXCUXp67/WA4/mEHppfYKNKFt+LkOQoMegUyNUIeSVZN30U83G4OGBZOs4DiPytmZL6LeoN+A14sozoC1f0Vij7C9cpog8zD2H892/Habhxy9/wycew3/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777013855; c=relaxed/simple;
	bh=4GwIzdJUx2Kcw3exRRGxOr0HKxo9w+nymN/e/RTmPds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tcd/25K0PR+juigrGyJNt29jaAg7OaSq7AlVbIWhC70QaU2GhwYJfshfC2C3+VKsw2TwJ7FzNefe1qPzoat/Kn8T/XBJzcGQGHDzIo9J1CLI9l0xDiMaR0rqPK9IJf8b9z8XL6+NR2YCG06nUNULCSuMTM6YYDYiQXQqtBRgHug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vceu4Ny8; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vceu4Ny8"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9c3e2cf3c0so1333655766b.1
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 23:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777013852; cv=none;
        d=google.com; s=arc-20240605;
        b=KfVOrqgOd7yDU97tXSUZ2umlOS7qFjY5k6aTkXss35UAQqgL+Et/sbFXnvpOW7hxFp
         1dn3BGmYKMOScmb8Dt/UBfESxODvwjQ822caGlYPzyDcViv8rRz5ira5a17easlkTZOR
         K2EzYax1qRMHCoI6ZE92D/Jnn1S9U7A4bki/N+WjKBUf4qXaZLodXwofJC+4lurT7V+m
         Pp3LRLChSkyf/2j/OKEMWViI9dIRfchKGKCj/Rrpp7EvphSDu/Djq24OxCsmpWs9yYER
         m4uby4f8r6sBtc6GM7YuhyKgjHJhYFXz/NYmdgG5K5B7CtI/QBeePfBrsxaQnlRdqFw6
         c6uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1xbLIQ5Fuluw6Mpoy6KL9m+Q4rOLvVceUe/0sWgR12M=;
        fh=hFwdn3wpCOgyaVutAhdzfHwpUKhKiOkw2e4/18a01v0=;
        b=bahHe/6TI4kJx7jz/kXcFDih7d61am6CcAJwcUx8xbfYzYjoHUv988ujYi87J1u7qA
         qVCVos1TOWOuDc313Cdu5T0sBe98VTLDh2L3r8qc9t0sq8HPWGQMDDKRorgMtC1w0Pn6
         TlH1L7V8N+gqjzItA6emHgZif7k6bsnZQ2jA+irO+GFZPklaLDvuWhCzqXbfqRnK+dGR
         rX99QZ74QLisWHrwAi3Wq3cJJRI5IDs4QMZEsZd24PLhKm3MwuFx4UZuZveDJqbDFpis
         Z1jhS82q0gmjA4z2cmcpes2e1gSTBz/MIQmNRAohseYPcc80/HZugKdbWUjfxzZ/D8xQ
         OcGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777013852; x=1777618652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xbLIQ5Fuluw6Mpoy6KL9m+Q4rOLvVceUe/0sWgR12M=;
        b=Vceu4Ny8UZu8PbfbIEgniftLgcdI2HzgBkg9IeOIuXmIHPnIteJYqtKU4sQV0jmLiz
         lC3GOlIwWtYDlCQ7l6L1o9uAWFpkoVaDOAarneBeRRJjhajystXP17BP9/0KYxc+ssZz
         iTnyzlt27dNoBBys2Mhh+4BqWUpl0x/k7Sa74ADLZEoP0WEZChfL4RrOw6T6o71qnAtA
         S5wyo3h+OOYkD1G73vqyf1AzL2709mN0PKIccT6j8b2XcluVMuSYmdY/4S3B9viK3Hu8
         9FUbmj1z7KG+Cq391gWwBmy3ctuLf2P3jqNZ0yiM9MpBXo/gSTLjeXFTveh6hpoKaLI/
         +7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777013852; x=1777618652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1xbLIQ5Fuluw6Mpoy6KL9m+Q4rOLvVceUe/0sWgR12M=;
        b=oEmiCeYK+1uAclgVax5ahdnJz+dnJZB+setWpTYWp0wyHsyjGDP0zTfsQaHuwC6YjU
         IwQxep6Ht1LTSFwa6r++u3x3G/0wNcSdi4fpYQRrYGzVB7CMjmErBqetFSItxab0CUgh
         29ZSD/JcBasumJtcTbhDvDuEavnQweAKeTXbb6GMg7QghrOJBI39/9uWT1y0tBLGXayE
         MSr/JPEt0jnUE+AehgPXGYPFJmLA+ddQxGS6k6dfdI9+sCA876piFwvlyE7BzvTBR+Ih
         xhpA57RmoRw2eGqJpr1WOS6b3pAocQ8Z+ylvILUKfUuxQbxKt8v3rYRfDSR4DGYWW7vw
         mkng==
X-Forwarded-Encrypted: i=1; AFNElJ9AUYN+KwopF+vUFkMs4t04MwU56mHkdFoW0FPiVP2Cb/Lq9HEVqLeWiMIgpTQmhcDxKtOff3VswZw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+AugpR7/gxczq79JYjkOZODrGuvrt4tZy6TN2uQ9cUS19GIMj
	PJk0jEdHRtjR2m4WXhjB9lxr+eZ68XChYWqE/xlCOaHHyWjpkrzCtjg1l7QcJ7Yg2X36gPpiiMD
	SLwHRdWLrmVewVust8jhBUgM2LDNdeUY=
X-Gm-Gg: AeBDieux7YdkIzr8Na8EnxI6govFg/r/+LQzCIQ9BkqZ3evakfkn6Az4oxnJvu+ax9i
	2YWbPmpHpSx6TGFmrStGDe0PFsQ76LDxyXplheFiuiinfvJPDI//w1Lkz6Wn3kRqBgYUHIvfJ3G
	0miSb6qE4Eeea9xOm1Uyz2YxkHT2aXHDPsMD5YRmoJYnN2MvmyL19w3Vo4sDD7CbTZ7Jg3tszw5
	uTd3cCgAKUbJj3S890WYUa3/lZNPQJ4CWFwwlmVvchKewH2UJeSn1fV7IPvk0qiW130YODf6sdL
	+hrPZwzv6xrsQ48w6Dn9+ft3idpMCt+4iHIv4OSZUIqZnkEAnmKsb0+fBSmiW0c=
X-Received: by 2002:a17:907:97ca:b0:b9f:9e7a:bcd2 with SMTP id
 a640c23a62f3a-ba41a632e8cmr1588080466b.38.1777013852060; Thu, 23 Apr 2026
 23:57:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <wlxxrx10.ritesh.list@gmail.com> <aer0wd2Ig0hjN3R0@casper.infradead.org> <v7dhrmgc.ritesh.list@gmail.com>
In-Reply-To: <v7dhrmgc.ritesh.list@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 24 Apr 2026 08:57:18 +0200
X-Gm-Features: AQROBzA7au-Rxnv_gU_TeRNbE7y_vZ61_PUN4YtNXKiJVY5WHIMs7q432z4NtWM
Message-ID: <CAOQ4uxi0bTwj7oCWR1iOhqzPkB94cVgh=9Prh1kHxnObuLCz0g@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Ritesh Harjani <ritesh.list@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, 
	john.g.garry@oracle.com, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, 
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, 
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 7:07=E2=80=AFAM Ritesh Harjani <ritesh.list@gmail.c=
om> wrote:
>
> Matthew Wilcox <willy@infradead.org> writes:
>
> > On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
> >> We were thinking if it is possible to extend the Buffered Atomic Write
> >> session into two "continuous" halves of 30mins each (total of 60mins)?
> >
> > This is painful because you've requested me, plus both Storage and FS.
> > FS has lots of space, but I don't, and Storage is also pretty full.
>
> I see, sorry about making your (and PC) life difficult here. I know it's
> a lot of planning :(
>
> I think, both FS+IO folks will be interested to discuss both of these
> topics. Do you think breaking this into two discontiguous session help
> us plan better maybe? In case if we don't have any continuous slot, then
> maybe we can split those into two.
>

I scheduled the two sessions as you requested 9:30-10:30
for FS+IO and moved Parallel Writeback to Wednesday
across the MM CXL session.

> >
> > Do you need me for the full hour or just half of it?
>
> Although I understand buffered writethrough is an FS related area, but I
> am sure a new writethrough I/O path is an overlap for you in page cache
> as well :)  So, yes, it will be good to have your feedback on the second
> part of this discussion which is - buffered write-through for buffered
> atomic writes.
>

Matthew,

I don't know why Parallel Writeback was scheduled as an MM session,
but if you think it should include MM, could you move the CXL session
to the now free MM slot on Monday 9:30, so that we can extend
Parallel Writeback into MM?

This will allow you to participate in the atomic buffered write sessions.

Thanks,
Amir.
