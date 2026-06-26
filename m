Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506583E1D14
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487881; cv=pass; b=seex7NstL5vGZQjkmT0+xM8PDNKnNJt6L228hRwryJXLgz+uNRTDwNjxsLWlR0KcwydD+P+Eo1peQh/ft69nEdAhkYobS6QdyW0O/Mn/AlVGpVZ4B+//C6ZovEi7ZhYRr5HHrRTpvX8JsOcEXWOM6IMS5Nc5KqwzT0379IqlAjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487881; c=relaxed/simple;
	bh=wqSHr1EWMYBXrlSAKcagfIVqRtNYI8IHYjPj6F5FHLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a61ab04zTn0kQlX+penX6Ju0+LkenJM99qA9wrlpHGD8HhAh1jrev4r50q+3O+iQ8H+1CP/bf3tTbKxbILQWlgU5wdGXif+pAWBqx0jmhc88hbWaFibQn0bEkhrjk69tksi7QD9T9sQq8h5vzo/znvs+QhFwXFXyvJvopRZzm0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=WwfMYccq; arc=pass smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="WwfMYccq"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c6c57c5bcfso11960545ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 08:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782487878; cv=none;
        d=google.com; s=arc-20260327;
        b=dQgNtaVF1s9LFnzcaSMZe/yFQbh2Yuzq9/fNJfda/igwvYVvv1H7sXHLjQGIuZgwv1
         JpcwOUFr1cWSBD3YCyythygsbP3f9qIaWYhf6Buf+iSDv1Ctzx4MNw/vi9U8iJfeezT8
         P56wKJ2qLWpzFcdneuqDXnJTRa00Gl9tIw8m9WyEV4T8+FhJsgueQm13pjtAagdnChGw
         6OcEZLRK7vsLu8wZQMzV8SNJMrK+mVFW/ENh5EVWzbXMLUDU77Yayyma4h7hx9NiEavO
         WFOfNvPbTcWLxskprYO3pebLTy7fkGky5XMpujBoqW0bcMJhe8qPRJCubytIbjw5Z8Nm
         iZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M3UX0w5EKmMEqjBcGu53wO3BCmqVyWzVn/8cvHr+BeY=;
        fh=YFo/XqcQq2y6uZOrWkb5kK/GMU4lhAiKg2qjGzOF2fw=;
        b=VvwOdEIu42hrfyQ1tDYYGoN2ip10tbhdb/bHoXPy11H/RlGobm/yMVI1kTBIldVV5a
         n6VB9cs5LM1AJMOw3F1iKeTsQZV9KMWtgW5RHGDYVaRMkNoSDBWzkFNhQvuS89re+e9k
         9gp39KDTN1lt0zXsZJkdXFRStK6FpiPfbJPCuzS6wEiGj6JMJ3mcDTz7Ntfyv6HwOmVC
         DIqXZXlF/6dmxHQHgy09nRuzJBJD7E91KH4XXdBHbseQSo0x87FWafe0fQSZohx0Gugl
         jqXdsC/5Wi4eJSdetD4pMBbvgTDV1TqqUcoaabIlXcFDBkjZ2b65ThgXIiEW1AotOj54
         A3sQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1782487878; x=1783092678; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3UX0w5EKmMEqjBcGu53wO3BCmqVyWzVn/8cvHr+BeY=;
        b=WwfMYccqsBUm52y+juQmzKEuofwm83E6WcDoFZNUzyJe0gmz4JB7GEVKXZw041gsMV
         uc8FpKgARxiBJaydTkAoB7nahiyicI6V/fSCwGPhcuWYVWXEWURzLc/vkASlYt+73GHA
         suEC6Lhnvm2rtiTG3Hrtg3RrTR+wwTxasPIxIciVuUcAi839yxU0NG5TrTTjLklazc5T
         AJZ0Wnz2y6Zh/h00p/GmVmCW35Wz/C/sJoidyWn8qM/Ty86vGK5zfcGv1uIE6dSlaxkY
         k/H6FRuNTpIFkz3h0OmTD2O7aJ87rQBiQMZ/SauMUpkQ9zyhHaWCOTDNCWJEQ7BR7Tly
         K86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487878; x=1783092678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M3UX0w5EKmMEqjBcGu53wO3BCmqVyWzVn/8cvHr+BeY=;
        b=cKyfRnU7RNwMuFycs5I758esMy4nWvx+4o2e4vZlVkl9diEmGq/kEHVxpiTETkKKdn
         G8/8gdYMMa3iKlDw+FFHWx8eLsg4Cf9zoWExruPHDwfWtOkBdbKtlV38ZdXOoiLE89dZ
         0FDKyDnatjne85MYND7Belxa7dNIH/NEdjBKcu+NVNNdMTimarBl68GkzjpRmYMjUr2k
         PNs5zXdGNjovAfdm/hI9IpZ/1jyE1g94uRAhStOjSCkxHH4/ksIGmH7U6zCxP0NgVPqq
         aoGocNJIHI0seBS2ABGf+ySQVxjxb0SoM57/2+DjJTWm+9Ut07QqUZ4XwFdOHaxBLZAu
         +QQA==
X-Forwarded-Encrypted: i=1; AHgh+RrnDO/je1rk9VxazrOEFphLhEQfxGjzy5bWE9gzeEUbX72gBbgL4MtDk06gEWoNSlOXT4l6DSN44CY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJh/y9ikVyNZZQ5QCq2KJ7OF38ziIy9HOO5+KspoxmgSIEXEfQ
	d/7RnLtONyWhdDZFRe/wTF38zBAqPGlW3PawrCT0jdP4SM6Ukd96/whFJRaRYPKx7cXX6kRtpyd
	a9zeWSqqvsKROGFcW0YfZoPdWEg1YowLxt2pTUYVr
X-Gm-Gg: AfdE7clQbVuXFsyZoNBNTtgaxyyNOzR0UfwH9u8+N23aq5I45T8PZCK26lK9yMjoE22
	8u4RiwFUDv+QGDLZR/Pw3iSTSnVtWL5aJI7xmUBvqqhNgU6Bd62UxQ/ZaGs2pbgVkIl4R59ZLuZ
	1DgThRNQZP6dsyv/u63ceCcFE9mBwNy5VxxX5x662FAM0KPiYqX1JfVy2MQHOu7xPhYMcOI+8zn
	WNvLNl0DfoKki0x0AtoxYRMUzRASySItcyrjyXsK+mJIvmQTBirCCIy1oswM93f/yx9tHqh
X-Received: by 2002:a17:903:19eb:b0:2c2:62ee:5a0d with SMTP id
 d9443c01a7336-2c7fc74ed9bmr77478525ad.14.1782487878522; Fri, 26 Jun 2026
 08:31:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626114533.102138-1-cem@kernel.org> <20260626114533.102138-2-cem@kernel.org>
In-Reply-To: <20260626114533.102138-2-cem@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 26 Jun 2026 11:31:06 -0400
X-Gm-Features: AVVi8CcEZMeN8u2CIiqk4TLj89kobhoxWYGuWAl5i77ATSryI4gp2OXB1rc_eGY
Message-ID: <CAHC9VhQNURc=d4AOVDF-z29fjLasCiLf120Y-N3txEBccpkfSA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] capabily: Add new capable_noaudit
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org, hch@lst.de, 
	serge@hallyn.com, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 7:49=E2=80=AFAM <cem@kernel.org> wrote:
>
> From: Carlos Maiolino <cem@kernel.org>
>
> In some situations (quota enforcement bypass in this case) we'd like to
> check for a specific capability without triggering spurious audit
> messages from security modules like selinux.
>
> Add a new helper so we don't need to use ns_capable_noaudit() directly.
>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  include/linux/capability.h |  5 +++++
>  kernel/capability.c        | 17 +++++++++++++++++
>  2 files changed, 22 insertions(+)

This is Serge's call, not mine, but FWIW, I somewhat prefer to see
code use the ns_capable_XXX() variants directly as I like to think it
means some thought went into ensuring the capability check is being
done in the right namespace.  Yes, we all know that capable() just
uses the init namespace, but I like to think that having to type that
out in the parameter list might be a good double check ;)

--=20
paul-moore.com
