Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0259150981
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812129; cv=none; b=MNFFXtUGg6WSI1EOeRGvX8Fg3zsqI756rl3wVaIeiB8I5APWvxlUHhT/IeJ697FcUoP9JQbohJPE6YJv5eDU9VmZhr1riqNEvPy3vfNyl9NFiJR5AWzIj45kTdsojpTd1FZUZJHqbU+O4qwHqYusnKo1kLFOnEt851e00eXWg8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812129; c=relaxed/simple;
	bh=44tfr9Q/yxzd5k0GS5X2bOuf4cl/wNWn1fVz/zaqgb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IxRxKEIDXiira9/J9JCxL2RWtsZhgBIjmNyT/+iIncTM2mFmJU9RXdvKoqdv58fZ8shAFhBrEIUMqCtFA/c4Jh0Z4czfDjReDqWTD9Qu7yIZ8kb/dc7jtr3pB6j58otbYLslnB4DnB7rnUVPhyLxJr3CuL7skK5t1yhCJV0IqUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gUNd32TU; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gUNd32TU"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57cc1c00b97so5887426a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 08:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1718812126; x=1719416926; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z8dIFFBUj8uYaau0DmFweJKWuC0Ps3w+y7afUQaxxWc=;
        b=gUNd32TUMs1vPxcXbKaFocojq6B/mAuj7iXzO4b5V9FpOqF9P74fYSjQm8O5sWP1nf
         fFlqgzv2VxoAzu1PxZ8K7+Qh+vFdphYBGXt8XwdrSqYmFOjOGyrMD43aygO3ENicP85z
         fvioXxIT/nXYJl50SzmuVTd2+25ISzbL8cZw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718812126; x=1719416926;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z8dIFFBUj8uYaau0DmFweJKWuC0Ps3w+y7afUQaxxWc=;
        b=Yv2uUNxS3VfqH2Pt42v2X0R/nlN2AEKCiT9vbmOzgbHZtEuMvz2/KLMYSrScaqQ/xw
         6vhjbQC5vZJ0siMf6L5bwuDfgenkLcrH0yUgro6cc4/SUIKfHEIlUCC1QMbce2WDpq5F
         ai/o1qoykxuf1NHLBV2aoiWe+IxJsd4ejuzkOTwlRa3HsOjLyyM3VoBkzqoGix83ztKr
         eyaZIHa9G0C8ycPw8AP0r02T6XtNmb8/NUJczOkRj0GGq85B4FUSoBuYDumI7HdLVG1+
         VM8Arw/CIMDAFdKVBuMeykWe94AhJAk3aRfQRPzYM3mglvazwQUvuNiM3o6uRJlsyvmb
         Nd7g==
X-Forwarded-Encrypted: i=1; AJvYcCVrxRZDmxHxWC3mY7Abu8pWudc2T7pIxie1PnXFcg0QklKLG/adbgEE3TqSVnvtv0sP2bCh7eqbYwxdJRhXToE0uFeCtjESGg8H
X-Gm-Message-State: AOJu0YyuBgHD7F3wQAmnq0/Qk1pN2Wl0D1nrS8f6NwI+xCr6TMyLa9Ng
	XZcmRzqkw99qF3x9u8cHm0lLyXX/u94TigUUFBlFu1onkjF/8kDGGZ2BMtNgZkaua5W/ZkiMKJ8
	Iv3Y=
X-Google-Smtp-Source: AGHT+IEHd8pj+m5T7fn8I/dZDG3taL52BXgPWM1ZPiq4Jk86fgW/LHjKsLaei/FkiDbVAAIyCbznlQ==
X-Received: by 2002:a50:d518:0:b0:57c:5fc8:c95d with SMTP id 4fb4d7f45d1cf-57d07e5bb64mr1465913a12.18.1718812125656;
        Wed, 19 Jun 2024 08:48:45 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72ce12fsm8547361a12.7.2024.06.19.08.48.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 08:48:45 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57d044aa5beso2140142a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 08:48:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU8boNZi+wkCvucg37rt421wKC4BEwwtj1Xt+fj7bufoaAsBNkjzK2aQ0sWLUiVDNHF8XPHYSX16Q9TxXt2hQHtrRnTkxfdSDIn
X-Received: by 2002:a17:906:5590:b0:a6f:5562:167 with SMTP id
 a640c23a62f3a-a6fab648adcmr149389966b.38.1718812124564; Wed, 19 Jun 2024
 08:48:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJFLiB+J4mKGDOppp=1moMe2aNqeJhM9F2cD4KPTXoM6nzb5RA@mail.gmail.com>
 <ZRFbIJH47RkQuDid@debian.me> <ZRci1L6qneuZA4mo@casper.infradead.org>
 <91bceeda-7964-2509-a1f1-4a2be49ebc60@redhat.com> <6d3687fd-e11b-4d78-9944-536bb1d731de@redhat.com>
 <ZnLrq4vJnfSNZ0wg@casper.infradead.org>
In-Reply-To: <ZnLrq4vJnfSNZ0wg@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Jun 2024 08:48:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=who82OKiXyTiCG3rUaiicO_OB9prVvZQBzg6GDGhdp+Ew@mail.gmail.com>
Message-ID: <CAHk-=who82OKiXyTiCG3rUaiicO_OB9prVvZQBzg6GDGhdp+Ew@mail.gmail.com>
Subject: Re: Endless calls to xas_split_alloc() due to corrupted xarray entry
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, Gavin Shan <gshan@redhat.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Zhenyu Zhang <zhenyzha@redhat.com>, 
	Linux XFS <linux-xfs@vger.kernel.org>, 
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Shaoqin Huang <shahuang@redhat.com>, 
	Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Jun 2024 at 07:31, Matthew Wilcox <willy@infradead.org> wrote:
>
> Actually, it's 11.  We can't split an order-12 folio because we'd have
> to allocate two levels of radix tree, and I decided that was too much
> work.  Also, I didn't know that ARM used order-13 PMD size at the time.
>
> I think this is the best fix (modulo s/12/11/).

Can we use some more descriptive thing than the magic constant 11 that
is clearly very subtle.

Is it "XA_CHUNK_SHIFT * 2 - 1"

IOW, something like

   #define MAX_XAS_ORDER (XA_CHUNK_SHIFT * 2 - 1)
   #define MAX_PAGECACHE_ORDER min(HPAGE_PMD_ORDER,12)

except for the non-TRANSPARENT_HUGEPAGE case where it currently does

  #define MAX_PAGECACHE_ORDER    8

and I assume that "8" is just "random round value, smaller than 11"?

             Linus
