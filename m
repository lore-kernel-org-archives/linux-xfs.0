Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FFE3E5599
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 18:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772734159; cv=pass; b=N1Vd2vtsrfZgAglCHwnHEm/eX1o//h2BRD/3qWmNkAMFJ0YEoD2dgryHUnqz7P7idLfVI1t/uznR9sl0M9h0UydAboXm9lRBNRVr5fm5uaZbRhRA+CTnJeDzeyS+XDHWyitoMBOqw5y3+HG2s8iqXKqYv7iuq5YKgbwY21aJFUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772734159; c=relaxed/simple;
	bh=K8d7s0uUkWV0mikkidM9J7TJqCdWToG6lGeDo1nhb0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Li8mVKhWqnzMjeRavXIBfHq/9dwTGBDmD0u1EDKpcmIVAxDJalsjO5D0TiNzJDWZxV6pdeWEv4LT4wx2NTsWt5Ur+1Wb4dU7tqhHH/56bUNXu4UluRFJ9rEpmzVLToDWmkcEHZiXVNlxqU7Cd0T/WJ41RSXpANzpfnA60kZNaI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SM0pU0Z0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SiXp9w1g; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SM0pU0Z0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SiXp9w1g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772734156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SqGtqLHbTGwZgftYa0+hnsOXPB7VgfAKlsWNEW582FQ=;
	b=SM0pU0Z0qg+dXbRPZi1DK/LMXSG2eD2QjWq8n0VbLGvYf0GF9QpHsbPk1fhv8eZ52XlH/B
	AW6rudhE+YYr7umXLnXKJ/c+kRSPbKIoQX/hrg2Jy9raxqRjYOYYpg1K2pCuWe8CrQ0Dam
	gyiRqsfxura+GZdH/CUYrtOH64/KvFg=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-Y1NiDKUsPyW_V0W2KxoByw-1; Thu, 05 Mar 2026 13:09:15 -0500
X-MC-Unique: Y1NiDKUsPyW_V0W2KxoByw-1
X-Mimecast-MFC-AGG-ID: Y1NiDKUsPyW_V0W2KxoByw_1772734155
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7986dd1b9e1so158860167b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Mar 2026 10:09:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772734155; cv=none;
        d=google.com; s=arc-20240605;
        b=cxJLKlCB7AAr9+SHGzuf3YKXaQGVZLBhXZ8yOEl9CJ3W6aSV4PEHTbnskSiE6YW4JM
         1CtKgnxdYirHNYtYWC62ljnOD9sZsNcxJ1SI28Y5ZYWO7w1YPKjCBGKK2yoCziWjJ034
         1S/05JT337X7sbH+OgeO5cmcW5d3nMNp7gRpRIULuUiw4IIXIUXJCwtxyOuYwdKbqdUT
         WuYo6rQy1E8r4F0OZQGptdWFJb4aBbFM+EBOncQfemaUckqw0FecJuP6qT1290xJjKp0
         VjUSpDTRzBn1GTLx28nH2MV3m1qY1hXpTuUbCxNKpEh4+dzemlHjFo3dsmSfvbi9cq1C
         niXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SqGtqLHbTGwZgftYa0+hnsOXPB7VgfAKlsWNEW582FQ=;
        fh=eH1a94H1BiobLaeDzrWnPvXCH5jwFX/zeTohgdipIt0=;
        b=gS8QS/DKiUoTyl3jDq+k1glkETBjN/+KPyK6OtCOdbKc7gURLt10efGJv7IgkUyTWQ
         LdC3sxiezpy6rvGNKZhobLwIwUyKSCA7pRiYwuV8M2HuPW7ulGtgKZqlKEE6Ah/rOtpB
         3GByVpvGS/UUY+8buq3zvOparPVGn1gOUJzCCPVXM019yIUvQzMv66AK5BzV0lpF9sDk
         Twi8AYROpESTvgTlJ3NBmdj92+LLcs904NuOtLZxXxk7KeICGWqYFX9wR/NulMOci0nT
         lUl+5Zh/vUIJPlaVa179cnPuIlUB7AioYtxn1huc0BSmpfeOz9uNxaFcSOM8UAvMhEB+
         7fnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772734155; x=1773338955; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqGtqLHbTGwZgftYa0+hnsOXPB7VgfAKlsWNEW582FQ=;
        b=SiXp9w1gA1l+zJ8vfOJFR8xvX6YpGoYglM13i2OTNlCUKBSwD8+qK3Xw16OmA5kMlb
         hoM9Ep3DWKkSNR8Lwl8sVLWLgu4ZX6j4V9Ju6bxA6OznifI7t4B7fbiEZIT7iFMP0Wpr
         VmQDs9xsgz+6MkYZiTrsmHiHzAzpz866S1PpwOsm5R7i69JFBkQAWAIJAPt1zYyw2ZbI
         dF4OCscI359XwhUitbnuK8Qj8Oos0irKmgAMfVu7bLqsjRIULWQemhlbPR+lhJpKPdZM
         kkCufDO/ifS8AsUJWm8EhCcoEfRXpgXZUdu/O32aNmXYeqknacegW1BGoWb621IwPpu/
         gtew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772734155; x=1773338955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SqGtqLHbTGwZgftYa0+hnsOXPB7VgfAKlsWNEW582FQ=;
        b=IMEnKPhnb09ftyx97EXFmK0ZFbnBQQEyP6e2D3ze80aY1yZkWfeiFM5Q2INOJslpks
         Tx+/eAZNawEX2pML2SQKx+Gcw/otJfr2ckElv5t2s9YI8tR7U/25b8kkZxp50ImVAVp8
         Z5Q8gHfLIu74md4xuJaE7crELtQ3VRfpK2lcdptR6h0p34r+6Vl7WELDzWM3t6UuSHTY
         0wsk5IyK3QV8Xkk8D9YTroBSFdEJgh1FSuZXFWLNTIzGa6X4wwt0M+5+WgvjUFi30hTr
         nv0ixdDpmXSmdEiaSa9Bls6tEdpha/oGm3OBIJ1KDV8vga6f/1meNLqCbD6jjjNKjNf1
         nrdA==
X-Forwarded-Encrypted: i=1; AJvYcCUePYcb5H4HgS1a+td37mxYH12jiorLKwU0iNR58cWIMpdL2fxVW/h3Iku3b45SikEpQzLmrCqRs30=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq7AcKT8jYcK9XFz+Fb3eh1uM3O/gXNbdUGX7eZ2Mf+jgrPZA7
	hwrDIldJFKPGJGY5XIpDMLadfljTv0BMDuYne9OadNPehd8jLozaOQfMBhFB/74NkcNLb9UgP8T
	ULFxfZWa6F4ANXV/CzlDC2N1P0m0+4g4+GEpJ8z9dV1pY05o9SxmOKmhcDYn5eP7iQHUvnWy6KC
	StqjIXROdMQS8x5MYE9tTCojkiEmfXhZ6ObvoD
X-Gm-Gg: ATEYQzze9pNngWMZvruGF88/zuIzHIe0Nkec+vX4ETR7yRVV09ykNu15gC2K8s8B1w/
	WTi+20iPC8BbD29Qh6PQqosrz4Vbks8oO2bpBvlnuKXYarl/i1vyTpwX/72pYIsNKxvVHiKE5dP
	x0BHonPM1maqGjw8Gyc+mFlqjvnI5djNjm7An7x0TW2Xl2yyIh5p+Mp62YWNfhnm+FJITnswWQG
	QZ73BMOSUajJ+F1jlEU7+O0dpfxf3Z6Z55/H7sDsP+eL9uiLK4kUmhlZYISUacovA==
X-Received: by 2002:a05:690c:d91:b0:798:cab4:5579 with SMTP id 00721157ae682-798da402ea4mr8231377b3.13.1772734155069;
        Thu, 05 Mar 2026 10:09:15 -0800 (PST)
X-Received: by 2002:a05:690c:d91:b0:798:cab4:5579 with SMTP id
 00721157ae682-798da402ea4mr8230967b3.13.1772734154707; Thu, 05 Mar 2026
 10:09:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304185923.291592-1-agruenba@redhat.com> <aamNC9JwxBNBBTmW@infradead.org>
In-Reply-To: <aamNC9JwxBNBBTmW@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 5 Mar 2026 19:09:03 +0100
X-Gm-Features: AaiRm53ZqpD4A9U0TspJOT1md7f-wU1SDs7H6FWyiF861vW8ig4bOEz4hSaERDQ
Message-ID: <CAHc6FU7PZ1mDBH7C8UQKorRZLTxcG0q8CPCgeGExVKu=178n6g@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 5, 2026 at 5:34=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
> On Wed, Mar 04, 2026 at 07:59:20PM +0100, Andreas Gruenbacher wrote:
> > Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> > calls bio_io_error() which overwrites that value again.  Fix that by
> > completing the bio separately after setting bio->bi_status.
>
> Looks good, but can you drop the pointless goto label renaming?
> I'd also be tempted to just open code the split error case instead
> of adding a label for it.

Feel free to adjust things as you see fit.

Andreas

