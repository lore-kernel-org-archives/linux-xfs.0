Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekc7rlBw"
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E873E85
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 09:26:23 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-a00b056ca38so604511766b.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 09:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1701105982; x=1701710782; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TEU3+aCfiSmQFyVqBrrLYcYFe/sY4vb17c0SHE7wKwE=;
        b=ekc7rlBwFJAJRDepiogJXDsoOH7hkwTYqduMwpRQsRHKfWSY1DjDWwIm8iGu3VxY/O
         LTPg9nSBlM3g2Arh7fJKexaOjQAWHNkNkKNXHJhe22rys0iED93kSy5QvEZ2kI6dxm+P
         IWdK/jxkrpqyf7TmVIffpcM4z29yBUbh+IvY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701105982; x=1701710782;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TEU3+aCfiSmQFyVqBrrLYcYFe/sY4vb17c0SHE7wKwE=;
        b=SUNiJN3yjMT/Zyd56e8n8FZajWxW5NcesslRbgNcNyw2Axm/qQq6ak1bxjvOE/fv9l
         w5BVAUBnMk8dGBzicFxE4xvSpVIC7DcZYeXzeI6usB2Od261yxKBQkLr9ww00yBTTjce
         eJd2XBc/pKExG8iOLDX22iPGhvuNXNvhAMw6TEPH8MmXgQVVy6L/N4XMWyz3wTMoVoMu
         KLXl51wRnfDYFtKnzgMlMm/Vh2EVLn9BBlAqay8SpBYoe3juDrgnsUJEZGHKXjKYN5nC
         OJYX+nMppaDoGTrj8Sc500lew6gNF8pW3MhaAfOIzlYHUfNhoHQdGGWsPYCrqQJIb4Hu
         yc2A==
X-Gm-Message-State: AOJu0YyUq65a+aCkeUcMn5x0Q3o+qtB8o6eJjuP0uC4yv7EFOxZd/Wn0
	yhkbxVrf2YUIEuDS3+pdmCKdk3dBFQ8HpCXunywWnA==
X-Google-Smtp-Source: AGHT+IFDJQabIhM2hgRC+sfxBugZiQd7G3SgEvHbkeceiqo2FxM7JkpQobvBONntmhi2EHdVtTKGuw==
X-Received: by 2002:a17:906:4e57:b0:a10:b4ce:278f with SMTP id g23-20020a1709064e5700b00a10b4ce278fmr2206523ejw.20.1701105982005;
        Mon, 27 Nov 2023 09:26:22 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709067d8b00b009dddec5a96fsm5958792ejo.170.2023.11.27.09.26.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 09:26:21 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5441ba3e53cso6163738a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 09:26:21 -0800 (PST)
X-Received: by 2002:a05:6402:2b85:b0:54b:8958:3a3c with SMTP id
 fj5-20020a0564022b8500b0054b89583a3cmr1821041edb.29.1701105981089; Mon, 27
 Nov 2023 09:26:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZUxoJh7NlWw+uBlt@infradead.org> <3423b42d-fc11-4695-89cc-f1e2d625fa90@suswa.mountain>
 <ZWS+LLCggp70Eav3@infradead.org>
In-Reply-To: <ZWS+LLCggp70Eav3@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2023 09:26:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=whC6fX5U3kfG9zKxw+_G=n=Y0VJYZ-BBF7EQ1KZM2Zb2g@mail.gmail.com>
Message-ID: <CAHk-=whC6fX5U3kfG9zKxw+_G=n=Y0VJYZ-BBF7EQ1KZM2Zb2g@mail.gmail.com>
Subject: Re: sparse feature request: nocast integer types
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, linux-sparse@vger.kernel.org, 
	linux-xfs@vger.kernel.org, smatch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Nov 2023 at 08:50, Christoph Hellwig <hch@infradead.org> wrote:
>
> Yes, doing it without specific annotations seems like a pain.  I did a
> little prototype with the existing sparse __nocast for one xfs type that
> is not very heavily used, and it actually worked pretty good.
>
> The major painpoint is that 0 isn't treated special, but with that
> fixed the amount of churn is mangable.

I would suggest trying to just treat "__bitwise" as the "nocast" type.
And note that doing a

   typedef uXX __bitwise new_integer_type;

will make a *specific* new integer type that is only compatible with
itself (so not other bitwise types).

Of course, that only works if you are then willing to just use
accessor functions when you actually want to do arithmetic on the
values. If you use a *lot* of arithmetic - as opposed to just passing
values around - it is too painful.

> The next big thing is our stupid 64-bit divison helpers (do_div & co),
> which require helpers to do that case. I'm actually kinda tempted to
> propose that we drop 32-bit support for xfs to get rid of that and a
> lot of other ugly things because of do_div.  That is unless we can
> finally agree that the libgcc division helpes might not be great but
> good enough that we don't want to inflict do_div on folks unless they
> want to optize that case, which would be even better.
>
> Linus, any commens on that?

Some architectures do that, but honestly, we've had *horrendous*
numbers of cases where people did 64x64 divisions without ever
realizing what they did. Having it cause compile failures on x86 -
even if it silently works elsewhere - means that they do get caught
fairly quickly.

Just go to lore, and search for "__divdi3". You will find *tons* of
kernel test robot reports for completely idiotic cases that then never
get to me because of this.

IOW, you may not see it in the resulting kernel, but the reason you
don't see it is *exactly* because we require that do_div() dance for
64-bit divides.

The least one I see is literally from less than a week ago, when media
code tried to do this:

        i = v / (1LL << fraction_bits);

without realizing that a signed 64-bit division is truly *horrendous* here.

So you may never see this, but it's a *constant* churn, and we really
are better for it.  It's not some historical artifact, it's a "the
kernel test robot finds stuff weekly".

                 Linus
