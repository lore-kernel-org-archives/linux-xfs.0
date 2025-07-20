Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D7817A31C;
	Sun, 20 Jul 2025 22:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753050272; cv=none; b=mVE5IYg1RUApwsSseQSNylt+egLS9rv/rA/Iskv4HDn9voQJywjll/6luXG9W8MwhjYm65Ggq/2Fk0yUGnGWkwST4ikRMpdzRUU+DXtHdrsf1qCcd9g8M/3zOMK9+tWGDSzNPciaw+Wy27m4avGLV4A7VJmzZ2k4Dq+bNdREJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753050272; c=relaxed/simple;
	bh=y5LC0CbSuFl9NodbMROjJOIBUBjEQ6RAAWf2BUXgy1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JDOPfqBlETGW3uXlP/ObNPYeINnt1cOpcuthUcXQ/gASBjcNd0KxJRlfUQCPZ6T7cjE2ol+CS64ATmfqFLLTFTKi8vJ0BDU6wSsH9XbvVrB8/7/lpNatqQBxl5+GdbEApqqBYxStikGGwWFE54C1YB6ziQvEdU1ssP/r1woyKow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bc5HUuyY; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bc5HUuyY"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-60efc773b5fso2428718eaf.3;
        Sun, 20 Jul 2025 15:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753050270; x=1753655070; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5LC0CbSuFl9NodbMROjJOIBUBjEQ6RAAWf2BUXgy1g=;
        b=Bc5HUuyYOv7+pJvQv34bcV0EcLgYuQDNttnAg/p8CgvJIpq0MthW5C7jrnqZJnqloH
         jcllWdPmxX0yPa6azk2I2tmo7/MwsXResItrTYLUzPwZMxVztrFBzccCJb06jwXlP3SH
         gZgEFzQ82wOM+Vz+ngn1exRud/XwSefj+JK+yq5/9NsXePDSUqyRyfMAJ7KiWKTdPDe7
         KPsKQZ0Hk0Gh+22pu0phLaFZc2XhhKl2mfAALGn8eCtm/8r3FHJ4cRolCWiU5Baa4XJ/
         WsVmJJM35Rt1jxHrGRUox388QoKVAHMcioxcANN7a4ZUQQfLzcMDtuBCKyE/NN4/9sWj
         HIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753050270; x=1753655070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5LC0CbSuFl9NodbMROjJOIBUBjEQ6RAAWf2BUXgy1g=;
        b=sf5FKdBf5kd9vYZTcxBE2nba2Lhl/LrO8GQQgNfn7u83Ut7wYYaG3INmQf9sEcZ6Oa
         5PILiSK9suX9PWkglE3UeG2Tltf1VCUIwGgi92DLHo2iAZxr4V1qbQfMrd/Zf0GeLzUr
         D8QZuSk8+jsA0dQ68R6CwglUzB1BK+WRIzSCJwX7NXpMneAPzrMNO3087w9iwRv6ws6T
         28EZ62EXdmxNgh4bkeKIKDr3Gyu4svP71eP1J5yuQKpNhuMNBHNmfOzLb+fFOqbbGCUo
         XVZWLS784fKj94/+20scfut7fKG9Eibpkvhp3jJ7gm5WSE1JmG8lMKA54B8Pp2odeARY
         LZ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUG8bf+mWv6bvuF0I+wKv8d3TEKfscU7Dde7QLpGgTQnlLw6c59NZTpFkGqWeGNQaO9aASXrHVZ9vLJX90=@vger.kernel.org, AJvYcCXA+v+CFMVOX7yBqx9/b5mtwsdwUVZXJ0JWy/yX7xSqp5lS+A+Vxki0AK4K+KYfxzLCwfHFWJef7PGz@vger.kernel.org
X-Gm-Message-State: AOJu0YyMl8G4enFjl9o/N0ByIN67zSdykdBFyjBDpdiF8pDeJnOIUeuV
	CGx5DeL74413IPXRQqXI8Mhsemsfkz9k+3VhKmW6oKerVWfpYFtwe808ubQcqfZi+f6m0JBi6P8
	BM04JVV5Un8HTyCyK+TJhbcbB+LpnW6cRNA8TQKo=
X-Gm-Gg: ASbGnct7LTZLbOV+au+v7DgZrGb0lC0oWjzlKI6bLnkjKprppy7B8UVeZThmkz+qMyr
	f+kjT5XEMK+4qAoA50C41U/h5Wc0jb3OA7RRb0O06vXZwBImhwi5Qn3J1VwhzT1uy6HabkwNvE5
	5YPzktg7ywBimavQsa5qEYfH3i50SZLMEW8w4Fgx3Gs+fpe28OPeaqtdJ0ySWCIs3P4GbpeLi9X
	ecF2sYkIQ+CXO7ma7Q=
X-Google-Smtp-Source: AGHT+IEu+Tyy3FXrvYGcFIgMlqQYp3QRC3L8qXq57cmPH0GQIpPVuedeeNR9BNNjTO8mDFmQ468D3yWuUk+Bt0j5n54=
X-Received: by 2002:a05:6808:11ca:b0:404:dad4:f971 with SMTP id
 5614622812f47-41cf06d2173mr12335744b6e.33.1753050269971; Sun, 20 Jul 2025
 15:24:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716182220.203631-1-marcelomoreira1905@gmail.com>
 <aHg7JOY5UrOck9ck@dread.disaster.area> <CAPZ3m_gL-K1d2r1YSZhFXmy4v3xHs5uigGOmC2TdsAAoZx+Tyg@mail.gmail.com>
 <aHos-A3d0T6qcL0o@dread.disaster.area> <trCbtX-saKueJEbdl8AzWARJReyojMKsRC0LGW1Wb72CJsztLYdHNDFrGndVe0KMtU82iSTw2zcsZi4OZhZOlA==@protonmail.internalid>
 <CAPZ3m_iwS6EOogN0gN51JcweYH0zuHmrgVvD7yTXTi1AoDA7hQ@mail.gmail.com> <w5zac6jzwncscbhnihlfonbp7ac4jsf7d4ge7uo4fpsqcloeil@ylxill2zypfn>
In-Reply-To: <w5zac6jzwncscbhnihlfonbp7ac4jsf7d4ge7uo4fpsqcloeil@ylxill2zypfn>
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Date: Sun, 20 Jul 2025 19:24:18 -0300
X-Gm-Features: Ac12FXz69GwbXld9XQpO0U3jThNU9FWgKF0MZf-FZqTtSuOTgWkXnWulPEr1LFw
Message-ID: <CAPZ3m_gFwBr1eWH_g6j8H8hBgeDM+KN0HGO-KzRTT1dMFx1RYw@mail.gmail.com>
Subject: Re: [PATCH] xfs: Replace strncpy with strscpy
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em dom., 20 de jul. de 2025 =C3=A0s 10:35, Carlos Maiolino <cem@kernel.org>=
 escreveu:
>
> On Fri, Jul 18, 2025 at 04:10:39PM -0300, Marcelo Moreira wrote:
> > Em sex., 18 de jul. de 2025 =C3=A0s 08:16, Dave Chinner
> > <david@fromorbit.com> escreveu:
> > >
> > > On Thu, Jul 17, 2025 at 02:34:25PM -0300, Marcelo Moreira wrote:
> > > > Given that the original `strncpy()` is safe and correctly implement=
ed
> > > > for this context, and understanding that `memcpy()` would be the
> > > > correct replacement if a change were deemed necessary for
> > > > non-NUL-terminated raw data, I have a question:
> > > >
> > > > Do you still think a replacement is necessary here, or would you
> > > > prefer to keep the existing `strncpy()` given its correct and safe
> > > > usage in this context? If a replacement is preferred, I will resubm=
it
> > > > a V2 using `memcpy()` instead.
> > >
> > > IMO: if it isn't broken, don't try to fix it. Hence I -personally-
> > > wouldn't change it.
> > >
> > > However, modernisation and cleaning up of the code base to be
> > > consistent is a useful endeavour. So from this perspective replacing
> > > strncpy with memcpy() would be something I'd consider an acceptible
> > > change.
> > >
> > > Largely it is up to the maintainer to decide.....
> >
> > Hmm ok, thanks for the teaching :)
> >
> > So, I'll prepare v2 replacing `strncpy` with `memcpy` aiming for that
> > modernization and cleanup you mentioned, but it's clear that the
> > intention is to focus on changes that cause real bugs.
> > Thanks!
> >
>
> I'm ok with cleanups, code refactoring, etc, when they are
> aiming to improve something.
>
> I'm not against the strncpy -> memcpy change itself, but my biggest
> concern is that I'm almost sure you are not testing it. I really do
> wish to be wrong here though, so...
> Did you test this patch before sending?
>
> I'm not talking about build and boot. Even for a 'small' change like
> this, you should at least be running xfstests and ensure no tests are
> failing because of this change, otherwise you are essentially sending
> to the list an untested patch.
>
> Even experienced developers falls into the "I'm sure this patch is
> correct", just to get caught by some testing system - just to emphasize
> how important it's to test the patches you craft.


I actually only tested build and boot, sorry. I wasn't aware of
xfstests, thanks for letting me know. I'll research how to use
xfstests. Thanks, Carlos :)

--=20
Cheers,
Marcelo Moreira
