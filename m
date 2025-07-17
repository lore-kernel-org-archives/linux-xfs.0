Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E514E2FE31B;
	Thu, 17 Jul 2025 17:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773681; cv=none; b=K02YeJ1miEnh3HexW6wNiLLv1f7TAM0d7psJ0NvlGlGnHzXrwa1w+4yL4U6tcTTOOwGA9JFHZ2NFG95RGkYfxGq+eXjxow/SE0ei9Yuvuhn6TSfp8zFC9GqAH+7gYMQSs3KFNq8Pz64kP6FxjWtRW9Q3TEcFbeRb3h8Pm/4JnOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773681; c=relaxed/simple;
	bh=rzjxpZpdFlkT9ZgxfexMIxgYZeclHLDfT0xMHlABgPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=conRH7eu2DT1NEHtgAm2KWV4g/MLvw17chFH4ufmDoqAP2x0ZfX/kVoDANGBtUCrORPGq4dGySakQolmU47VPZ+OWx8OdVm4LE9p7QJAUYq8xZ7d0w6mJHI2vm6fTq3uZvd+rXVYSSXVMMXWB3Lze/ILR37q3bjbWE3iM8EnBig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwDgkP/Y; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwDgkP/Y"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-615a256240bso547536eaf.3;
        Thu, 17 Jul 2025 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752773678; x=1753378478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9z8fZ/Z4PsYW9CUMid5zcIc5+awDtRT+VcB1fcwG/Y=;
        b=hwDgkP/Y0jam3HKfXtbdTicOUr8o9gNn8+yQM1qxxWskzT4ZBUSckCUoKqNqkMV1oh
         ktEiR/w1Eo2SROK4J7YmAAjIQ0SKavSDFm17Y8U1DhVckaN7/T3Hf1JLdikh6jYEZUEU
         A4XblskH4PS8/bIdFL+uhi8K7cr7yVQWFiGyBcP+sSUjag94QKbbkHLnsTwmt/KmoXPv
         2PpyQGbyhfcgtsbXvUFghPKBhgNesMI3tw8nrFGmhf6LSAmZjdFQekde1uo38puJh7IN
         eU8PPTw3R1N9OtXYXSfL3j2gjSf0J5ytREng0oZmO06XwkcofBQYGtfMLt6jf3XdKSSE
         R1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752773678; x=1753378478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9z8fZ/Z4PsYW9CUMid5zcIc5+awDtRT+VcB1fcwG/Y=;
        b=a7fmqxVvSO54zhEEE3rp6zmz6B7oI+CWr/dntyM7eJdnn60oXed22ZrAsBFFhhmeH/
         VMw0BsCvqozsvJhtCBPWspGjnGR76vwFGz8Cwy0mYWobngwKkCuLu/iHqzyLj9fZo2Yx
         lRy156D6c+NwG0Ws/Ur0kty+tmrps86F2pwVasYXhhwGbpmdTl3MzXDg34fN5L1BkU3Y
         zXNSiRVBdPD2z6NvgmuTMTVDZUPBbUV/Dcxk6jHUMlY9o/ZOxDSIFmDQLoQ1rT+gpv/E
         jNWWI9cLnJvZ611u+0qsPRZatqouMsA/iN2abH5U0OtlQUlWKTeZPZMPCvQNrzQKanFd
         Upog==
X-Forwarded-Encrypted: i=1; AJvYcCV0R9U0+5cHgmbfRCjOMvYhDYcl6pS9Yxfc9Dki6LRMigxtq4of6SNtLOmhgW5zFiL4poLE3TXUkQ9A@vger.kernel.org, AJvYcCXJ2jSmqpdq+GzikrS9OPBLZqaiUypwHfeUHqxvQSA19ZbXdMYIzrlvTfT7i1TRpzTh2iMpQ5cdqWwqo2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJVMGCQ3LbLjkcT7QWIFx1ImUcCmmtgOGXYg77IN3atJHjnRYz
	dl15Uuye/z89MPe4ShZQ4NSF6LtX2gS83vfoPDBpPrrBB6FRug8bL25QHyOb3yJgihTW3LCUCpU
	Gn1sqIb7gdRcq+RwgWJW4U+tvjPhK5lfsaCXd7aM=
X-Gm-Gg: ASbGnctV8UL2IRjPpqQhQJuwcmF/iu3FgUQt8TQhQl3itdpCCo7wnvXrrj3DX2GgtnB
	yQqkIz3C0LsSQ4md9Xtk+yRgzKeSGlLky6X6NYPEBEWFGu1HTqh8/r0neDMcuMpzbC0z2xGA31j
	I/Uc0xub+pzV2YgTPonHow4QJyMK/0C2TXhUK2h+MLC56HtdVf523Tv6xNOJOpbkajdxKDvj6U0
	Z1GfHx036j+prCyNZM=
X-Google-Smtp-Source: AGHT+IGvMUrKXS0o8uwXJMY4nGdZk/l7ykqW8WTD1nf+Nt4owfT+6veTaykRqIANYiizVItY4C49BFj5HPpqRTlBBak=
X-Received: by 2002:a05:6820:f04:b0:611:a81d:bdf1 with SMTP id
 006d021491bc7-615ad9d97c1mr2873882eaf.6.1752773677580; Thu, 17 Jul 2025
 10:34:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716182220.203631-1-marcelomoreira1905@gmail.com> <aHg7JOY5UrOck9ck@dread.disaster.area>
In-Reply-To: <aHg7JOY5UrOck9ck@dread.disaster.area>
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Date: Thu, 17 Jul 2025 14:34:25 -0300
X-Gm-Features: Ac12FXxf-emQJTJxwfR0G22Fq24C9KGKAvFGh0x7h9jbGRxeYtkrbZb9arM8jl0
Message-ID: <CAPZ3m_gL-K1d2r1YSZhFXmy4v3xHs5uigGOmC2TdsAAoZx+Tyg@mail.gmail.com>
Subject: Re: [PATCH] xfs: Replace strncpy with strscpy
To: Dave Chinner <david@fromorbit.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em qua., 16 de jul. de 2025 =C3=A0s 20:52, Dave Chinner
<david@fromorbit.com> escreveu:
>
> On Wed, Jul 16, 2025 at 03:20:37PM -0300, Marcelo Moreira wrote:
> > The `strncpy` function is deprecated for NUL-terminated strings as
> > explained in the "strncpy() on NUL-terminated strings" section of
> > Documentation/process/deprecated.rst.
> >
> > In `xrep_symlink_salvage_inline()`, the `target_buf` (which is `sc->buf=
`)
> > is intended to hold a NUL-terminated symlink path. The original code
> > used `strncpy(target_buf, ifp->if_data, nr)`, where `nr` is the maximum
> > number of bytes to copy.
>
> Yes, this prevents source buffer overrun in the event the corrupted
> symlink data buffer is not correctly nul terminated or there is a
> length mismatch between the symlink data and the inode metadata.
>
> This patch removes the explicit source buffer overrun protection the
> code currently provides.
>
> > This approach is problematic because `strncpy()`
> > does not guarantee NUL-termination if the source string is truncated
> > exactly at `nr` bytes, which can lead to out-of-bounds read issues
> > if the buffer is later treated as a NUL-terminated string.
>
> No, that can't happen, because sc->buf is initialised to contain
> NULs and is large enough to hold a max length symlink plus the
> trailing NUL termination.  Hence it will always be NUL-terminated,
> even if the symlink length (nr) is capped at XFS_SYMLINK_MAXLEN.
>
> > Evidence from `fs/xfs/scrub/symlink.c` (e.g., `strnlen(sc->buf,
> > XFS_SYMLINK_MAXLEN)`) confirms that `sc->buf` is indeed expected to be
> > NUL-terminated.
>
> Please read the code more carefully. This is -explicitly- called out
> in a comment in xrep_symlink_salvage() before it starts to process
> the symlink data buffer that we just used strncpy() to place the
> data in:
>
>                 /*
>                  * NULL-terminate the buffer because the ondisk target do=
es not
>                  * do that for us.  If salvage didn't find the exact amou=
nt of
>                  * data that we expected to find, don't salvage anything.
>                  */
>                 target_buf[buflen] =3D 0;
>                 if (strlen(target_buf) !=3D sc->ip->i_disk_size)
>                         buflen =3D 0;
>
> Also, have a look at the remote symlink data copy above the inline
> salvage code you are changing (xrep_symlink_salvage_remote()).
>
> It uses memcpy() to reconstruct the symlink data from multiple
> source buffers. It does *not* explicitly NUL-terminate sc->buf after
> using memcpy() to copy from the on disk structures to sc->buf. The
> on-disk symlink data is *not* NUL-terminated, either.
>
> IOWs, the salvage code that reconstructs the symlink data does not
> guarantee NUL termination, so we do it explicitly before the data in
> the returned buffer is used.
>
> > Furthermore, `sc->buf` is allocated with
> > `kvzalloc(XFS_SYMLINK_MAXLEN + 1, ...)`, explicitly reserving space for
> > the NUL terminator.
>
> .... and initialising the entire buffer to contain NULs.  IOWs, we
> have multiple layers of defence against data extraction not doing
> NUL-termination of the data it extracts.
>
> > This change improves code safety and clarity by using a safer function =
for
> > string copying.
>
> I disagree. It is a bad change because it uses strscpy() incorrectly
> for the context. i.e. it removes explicit source buffer overrun
> protection whilst making the incorrect assumption that the callers
> need to be protected from unterminated strings in the destination
> buffer.
>
> This code is dealing with *corrupt structures*, so it -must not-
> make any assumptions about the validity of incoming data structures,
> nor the validity of recovered data.  It has to treat them as is they
> are always invalid, and explicitly protect against all types of
> buffer overruns.
>
> IOW, if you must replace strncpy() in xrep_symlink_salvage_inline(),
> then the correct replacement memcpy().  Using some other strcpy()
> variant is just as easy to get wrong as strncpy() if you don't
> understand why strncpy() is safe to use in the first place.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com

got it, `kvzalloc` ensures that `sc->buf` is indeed NUL-terminated
from the start, and the explicit NUL termination (I hadn't seen that)
in `xrep_symlink_salvage()` (target_buf[buflen] =3D 0;) further
clarifies that the data on disk is treated as raw, non-NUL-terminated
bytes.

Thank you very much Dave for your detailed review and for taking the
time to explain the nuances of this code. I clearly misunderstood
several critical aspects of how `strncpy()` was being used here and
the protective mechanisms already in place.

My apologies for the incorrect assumptions in my commit message.

Given that the original `strncpy()` is safe and correctly implemented
for this context, and understanding that `memcpy()` would be the
correct replacement if a change were deemed necessary for
non-NUL-terminated raw data, I have a question:

Do you still think a replacement is necessary here, or would you
prefer to keep the existing `strncpy()` given its correct and safe
usage in this context? If a replacement is preferred, I will resubmit
a V2 using `memcpy()` instead.

Thank you again for teaching me these important details. I'm learning
a lot from your feedback :D

--=20
Cheers,
Marcelo Moreira
