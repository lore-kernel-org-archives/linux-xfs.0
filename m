Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029B83E0247
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773686569; cv=pass; b=FcplmChzlMol+OPaV+Y9xPTbexCfCxgcxSuVzRo8a9fz0OFhDS7sBaJaRyax1t8YSLIADvWZLXuXa7mOL88Y83R9QWSHDnhug7w4WZrvDr92122aWDz+zcDAPG9cFIsVWnnfErwv8FHCweuDlVziVRhQhfBgqJcm6HSDrM1CZZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773686569; c=relaxed/simple;
	bh=T0QKJaV94bh9nTonDr12UMWAzm5y/yKAeIdsAJRuH5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SEjfWtdrxxHKwu3U8ZLYCja2sjMliaXbZJWK3JwE4PAQ4rAAYQdZRtDn0xFjcZYE7NKRP8whrwnKDdokB6U/NO9BbTqm/XIXQSZeNdOIw27tTL1wE7Se6dQCC4wecKiOQXN2kahHzA5yiFXQYX35EnJx2aYreGrSM0NiZ3AlOfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HtNIFFem; arc=pass smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HtNIFFem"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-94e2ad66abcso1245173241.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:42:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773686567; cv=none;
        d=google.com; s=arc-20240605;
        b=emsYwR1FkxelZ2Zj6mKyeH3zQ1ibN6pzC22zxg5PIY3hsGFf/2MwqIn6uTW3iC4NR5
         TJKCqQi6BmoVq8Mn4J63LRM6VXcFTCDCdWca0y7Qwz+JDQ0Gv4fvpuSeYh8eAUXzi4Pb
         Czf3zO8wWE2foIXfY47ROUpHpj0Ua+8B2Jx8pz43gkJfjacIxdQrrj3PZME8coCq6uab
         LucX+M/GWKKghodaPMNYcTTlgfbt4oG9tHHRu0psqEEheifDcwLqWUmc5XjZQpW/LjiP
         ewRX7ClMhPRP9vT8qv4Q7FswnVN0+dO2/0pwTHf9iA7kQdhk3mjHGDHJkSAxpPs/Ahro
         8TLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9NfNLKlSE1zi/KG4JCS/I/z8kud9vlQVptECf+KUTI=;
        fh=rV9hn4j9i3gd8UUAs3PeBElNPXRy7zMqBni2EMP4gXg=;
        b=lPqWSsosPFqmTi3bVJHu/pDF6QT5uXrtrlENHspjzzXJCEbHQ6nEDl9KMz1DzJX3M0
         ylyDSPop3Q8qwFxbFQnEBAish0hP1tKqfwldm7UiTYwxnREy5V12NjtDwMzLYrOpzmn1
         mtr7OQ5iWOojnSIVBjtw6Ie60sCKJlwYNIiy6l+mtVu3KjQRcZY6XwXykiH6KxX7/b/m
         HiPz8AesUBeHwfjStQThOjWkqXu+VquXxHovhLWXxxbYA9MXFYO/l6AGWf9W+jWqoned
         nS2ACUSQzXxr69wVGNUyHOI+ZIEzu37eXRpjGeaMdyj5f2TDkhA19ynwCqKcj4V6FlH3
         AUMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773686567; x=1774291367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9NfNLKlSE1zi/KG4JCS/I/z8kud9vlQVptECf+KUTI=;
        b=HtNIFFemKR59GrThl0cIOclK4NmU8vtNZmrfjKpfd0Mppqw69I/5yLxPtlolfDnhEo
         5/89t+pzxBUgMFUJJp8TzskJOzlfVoWEnlGPzrGXS1Xs4BaZtA+OBuVXveRogwKpU40M
         1dbDq0jyUx2qBTIz+DEYSAqmhEczmAOKC5WW7F08BdtMBWxlsfY9shiOSqFn3xV7xgSj
         mW+i/UymGzwCsHYT77HI/jmCNRrTGxk5niXDwZpEorYojPYztIli2W7FG1beVkGSX4xt
         dlWsPN3oQ7f9r1eDpBFzqPi+J0Uf039BM4REoC3oVwak4D4QqnCP9j4KIFpYZs6Wvzgz
         n2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773686567; x=1774291367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H9NfNLKlSE1zi/KG4JCS/I/z8kud9vlQVptECf+KUTI=;
        b=o+cCawy6E7TRNutE3aFMi4vdefnWriMrTokpE/vQ+m9j0rNtnCLo8uifsWIV7jb5kY
         WTGkD+OXadKVA/LdhocgiC6bKdzQwDV68FR1VHxxYVm4OwymhCNAQU11QUDkXTvi1RYA
         byYMpMHqcXpPLmux31jMBVK+zAZWtWl7eDo7KCXL55cWnvbxCGLJY2zvhHQxoWkH6uwF
         Mc/vbGsm0Yc5RK7fH2Br98aefLWo/olRvY15dvT0NeFy3108PygArMxOpYRRFUm7tRZH
         t08CnunI7GuWx1UxYJ3/DpI07AH2tHSWUEsXYzuiz8Ulr7gvJVITpQFEhWGeixjsnrN4
         aqBA==
X-Forwarded-Encrypted: i=1; AJvYcCUh5rMixL8jvb5Re2et0fmquv5vMDnt8UXUc/2Jit9Nme7fb39chQgKN1vZqcOmzBvsTWX4J8tYaps=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtawwGeWk//cEQMu+8a+5bt0dgcWQG413eRfEctRUVOFdRm1xf
	ZZt+AVhJrg91DByv6BO//ZT8OUdzSHTVWdmnusXxS6J9Vupuq/FsRXUtP0cCxGZRgW/iD8/H2yl
	/tD3PRFTrKlXShTtvLLBnUSPmXmdC2hhdJFYowjI=
X-Gm-Gg: ATEYQzwErJOhIZ0sNDdBEHGW0RywVdMD3rFl+BaZsWnI/tY2qKf7M255gA9fngd7TLz
	URQJkJDi072sIumPDZxStxgsvOomocYS8yM2GjnqohTNuv9MKj71Ck+XbNzPwlVQGjAfpBBKUwh
	i4tqlCFrzZBv0KZQZEuazGX0EQhMTwUF5+s2Sgvsz1AtR3WP6fpaZ9rr1F2cuwMKjS288eSg9l7
	J0Ezw1wfLI810sE6n1Q2t45H8zyCXWj/FBZtWaDGUsOlWsioZyzBWUNocfjau/Dbuy8JsdMl7Ba
	u/shGT/MBcfyx7wWcCmVUTcII+plxZu0LyETtqRsbAi8142N+v5QValnPDo=
X-Received: by 2002:a05:6102:c50:b0:5ef:a8cb:857b with SMTP id
 ada2fe7eead31-6020e58621dmr5046795137.23.1773686566485; Mon, 16 Mar 2026
 11:42:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303015646.2796170-1-morbo@google.com> <aaby5V0TDMlahSj0@infradead.org>
In-Reply-To: <aaby5V0TDMlahSj0@infradead.org>
From: Bill Wendling <morbo@google.com>
Date: Mon, 16 Mar 2026 11:42:30 -0700
X-Gm-Features: AaiRm53hWRgSh7Shh2bVd9Q1Zs-dMrPjW64SSnx1dcHqHMaCo01kLAOvuU6O_kE
Message-ID: <CAGG=3QWSDXmjn4Jy9K45oyDo4Uu7ZyLOuhnGMsgBwa+APt9vFQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Gogul Balakrishnan <bgogul@google.com>, 
	Arman Hasanzadeh <armanihm@google.com>, Kees Cook <kees@kernel.org>, linux-xfs@vger.kernel.org, 
	codemender-patching+linux@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 6:40=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> > -     void                    *buffer;        /* output buffer */
> > +     void                    *buffer __counted_by_ptr(bufsize);      /=
* output buffer */
>
> Please split this up somehow to keep the line readable, e.g.
>
>         /* output buffer: */
>         void                    *buffer __counted_by_ptr(bufsize);
>
> Otherwise looks good.

Done. Sorry for the delay. I was on vacation.

-bw
