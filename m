Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A66B48AE20
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920647; cv=pass; b=jtJCAIKzy5Q5qkVxY1s5OeAn7/WV3pPpv8EMfx65LyzMG+rUetXAYXdG7cdjJ0c1JWgKVrT7BOgDq8Us7oBVDxK8eAjHFMY34ABV2BH61Kn1WC/eRwp51mYHBlbW8jsSnuhzIcdbJrGSku9G5uM2QaBjNxmi5zHJixmh8DoM4NE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920647; c=relaxed/simple;
	bh=CaSJxenJSmT28YCTK0WlUmpDOnHwOMdXRIXB2/4LRKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZsLwZqJEVtZY9eBzl9OE2a+zYWN/RYA53ol5MgFW3FpzPox6ooMtboWcUtHIH7s53NW2Ae/wr9k8du8dbVEmzaUf97+ewspCyVoX0jpgAIMZITfjilpuwXMRvR4sAF4/o/Cc/rT8Rzx2lKHigQn8TqhYG7J+eAj7kvBpjsAApRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lqwl4SSX; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lqwl4SSX"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c126eb4e003so63494366b.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 08:44:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782920644; cv=none;
        d=google.com; s=arc-20260327;
        b=i3hCnWy6tIRaDKtmoWYVG/Ehp3BdRpD241nV6k5kkW6jLPpq69ZwUfLAmBaG+h3XgT
         hsT0W5ENgBLPonhQmQBPt7Jg4CRgZKtD0VMoRGxYMPML+oa4xcRoiME+Wji6NeJQmCPm
         9MrdYaAmyxO5PgNi4WQuXNwgeEAKlZo0tIAjzYuZtNRLYcxzzBn4NGWJIDq0SKSFgzTn
         4owSt4O0dUtAsGvf6AzB2Bbc5//CiveQuj5prEgubcH7rdwONL//8aa1kc3Nw7M9vXxm
         Jkchp7FfxjJqdsLU/8Q9tSwSbovFvTloJD7PLSXelqdBZoZ2jcp74F7SqNGzZoLPCVUp
         /C4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eYQv4j5xeINzuX5JBtlMBdWeVqylgzJ957g/41P12i8=;
        fh=NZWBCe3qPtPAHAAxP0ecBuryYSkuQ0PV9IsSOYb4aqc=;
        b=cVp+uymJg1UGJZIn8WX7ot5VtZcbsYQsKZU1SKG8z/SZKg68rS6KUYXZd431iO7sVI
         jg5XUBV/ytjaYNPM7+3pqBTZ/x6bfkcyANdA9d/a7LYRqYEdWCo9ThunVHEPz9ES6SjN
         bfVIPavrrs2U38WIByIUoBWrcfA7t20lV54Q1xWgaVHIMkWVfKPZyX2Ut5ga10LIp28j
         X3Qpg7TQREnAb485Sx2uawaidCR9Yc6SedwAD4ixXCeSLfQre8U897Uj5BLooWykhaFU
         kAs/n8VRC2vPSk2E1HUH8Tdbcwkczyc0sw0xu/SnSjFUDKkFwI5aletZ5euY5wi1tcrf
         kOPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782920644; x=1783525444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYQv4j5xeINzuX5JBtlMBdWeVqylgzJ957g/41P12i8=;
        b=lqwl4SSXD2jBF88dkv4yFaSlZCDCIyMwkGbruuC6Md5LMTDY4BfHyOb9SZORbyCt7f
         hxbT5J7GAYdm3N6aav2yWQbUrDxD7LIsN1D3Je+yWseCkYyrVjj4Wk/9elJ41OeQoNB8
         S8M/YCpHzH/Vy/JnBAyRc+woUn45QeqrGxP3dd8/QsNNuQBIoI8HkHj8sOe7qzUcBGO0
         G6ZyQRfwO90QyFodGx9eLUs9G6FqtIneDrwp6uh6jqMkCO8KlPutOtwFdgziQZ8FF9tH
         9MhzIJji8S/gU5j6/ZHQ7B6jdOE7CuYNMrUm7WJFc/dX1C2HzWH/wbAfv29dT+AkpWvl
         Tm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920644; x=1783525444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eYQv4j5xeINzuX5JBtlMBdWeVqylgzJ957g/41P12i8=;
        b=Ep23kJZi/fE3n42M5SlaIQ2w61AQTyaTsPfIbxki2uHQr2y0FhKCy6goopI4VrKbet
         Mlb7s7N1w/4fUmlWBkT9gX//9ooGbco0351pcRwSrKxpDgstGpH21AlORpv8FsUDZZuW
         p/i7q1gCAL1zXRXX5HuunDwXuy0KcT/QNZz2/zXfOhBIlUNVwKLE+orqcEbC7TgJBpIk
         tCykSVsJZT4wqL0RvFgwZFtFJ/2NY0rSUcRoDoB4fKwI/S2dWgtne5X+QX7GKdl6RQ8J
         vaYZDHlKtRZJcrue77bzalyfOEGnVOm38Z/AVm5ghVwWDGJno3nVH/HrLTRuOBPnu0PE
         /hyA==
X-Gm-Message-State: AOJu0Yxvb7RYVpp5BQHO3eC3xXISi/izSby2M/S2TQWckFZ0H7O7EXvF
	uz+VlE0YuZQqKZLQE2D70MI4EcnYsTJ+Wxp50LY62XTdKkObSSD1NQjpEmw9HKn+wuo4lvY2U3Y
	8H+b74PWvcCqDL414ErrMP2QKSntkMF4=
X-Gm-Gg: AfdE7cmY8idF6mCypwdZJp6f124A5apcNJcqE/bv+/mAqgXwFHwvFF+5H4zXEMXpauK
	a6mmMsHj8XK3oJIRfj59CPqF7iDb7PF3gxzIAwXlco4d9mwByPvu2FJLppJejO8xYIc79KbFxPz
	lmxORm69CLh5UrjNkbQuOfRFTS1OO9xBWzKKNbWaSsnnONS+ucQHSwa26bgqgz1BXSkz2KPKH8N
	f8E9YedqJ/VUq0QoIZ7rRiOBp2pCbB4wWnG4yre31yuXsfaBzbFOCDNNgOgPpb8r0eRkTdimf7x
	4bvOapeet6+PwEVl1UgZ5gUs9Fko
X-Received: by 2002:a17:906:c106:b0:c12:add8:eae7 with SMTP id
 a640c23a62f3a-c12add8edc7mr71508266b.16.1782920644186; Wed, 01 Jul 2026
 08:44:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629162452.2566242-2-bestswngs@gmail.com> <akTzkmAwaDkAK_mM@infradead.org>
 <akT2qDLIwGHHkWIB@infradead.org>
In-Reply-To: <akT2qDLIwGHHkWIB@infradead.org>
From: Weiming Shi <bestswngs@gmail.com>
Date: Wed, 1 Jul 2026 23:43:26 +0800
X-Gm-Features: AVVi8CdqmG8lT4yvRQqbqElG1HBTADKHy504bTsOB0qkYRzC9CnTs4g09DCqBPg
Message-ID: <CANgPUi1O7b7dPQFpnV7ifDXgQ0OO7hyovFkVzs7WtY+-ycU-FQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: fail recovery on a committed log item with no regions
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2026=E5=B9=B47=E6=9C=881=E6=
=97=A5=E5=91=A8=E4=B8=89 19:14=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Jul 01, 2026 at 04:01:38AM=E4=B8=8A=E5=8D=8838=E7=82=B9 -0700, Ch=
ristoph Hellwig wrote:
> > So maybe as a prep-patch remove the existing ASSERT(0), then as
> > a second prep patch move the list splicing after the loop:
> >
> >       if (error) {
> >               /*
> >                * Return the remaining items back to the transaction ite=
m list
> >                * so they can be freed in caller.
> >                  */
> >               if (!list_empty(&sort_list))
> >                       list_splice_init(&sort_list, &trans->r_itemq);
> >       } else {
> >               ASSERT(list_empty(&sort_list));
> >       }
>
> Actually just always doing the split back might be even better:
>
>         /*
>          * Return the remaining items back to the transaction item list s=
o they
>          * can be freed in caller=E5=9C=A8=E5=91=BC=E5=8F=AB=E8=80=85=E4=
=B8=AD.  This should only happen when we encountered=E9=81=87=E5=88=B0
>          * an error.
>          */
>         if (!list_empty(&sort_list)) {
>                 ASSERT(error);
>                 list_splice_init(&sort_list, &trans->r_itemq);
>         }


Hi Christoph,

Thanks for the review. sent v2.
