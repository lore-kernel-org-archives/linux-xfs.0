Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7406632;
	Fri, 31 Jan 2025 08:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738311041; cv=none; b=S1yMmKKLqUXWC6M3MtFfGYNodr9oQkBmk8F13PS28QjWr2spc9IeUjnvem94/OKXxRIm0jXTr19fnv0bPrJM03bG/08Pz740hPA9qJJiWyo2ftA+ZmJYgKRvxjgWel+2FODOn7MK63pSyJr/g8VqnZTD1SRVvJqxitCxMmKP5a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738311041; c=relaxed/simple;
	bh=azq4241KBIoteF/dlzxdcQE0ndXrUM97e5MNEw+dTgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H27MI2BL6uiZG6hRqep88kwnu9kIzwJIARvaglCVg5PJWGfhLnqiLroM2bsqF/tqhX6AIonHMFWdota70RDplz3okRkAHrACZ6eZVxvYoUgtugnkjuseWtD5nAiCoEJ7gEIZimx0zXKtNbBYqLrfhPGLaFDywWUKGigiyUaBDao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5189105c5f5so1083299e0c.0;
        Fri, 31 Jan 2025 00:10:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738311038; x=1738915838;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RkkmP4DS+2e9gLiuNJWw+nBuoXMD1/OBDb6T5snhw8g=;
        b=aRAyw7HdZXi64fXEMpvZs7pNqwlsHu7VWXcPiCu1qmMOiGzVTFl01LsJJMmJCtawN8
         LykCU2dAhba2wgwFd2UM2ym556u+l46K+4EfjxiU4dJBPi75h67UDbuewXCu7zEpWBjH
         Yc4JZ2iCP1Q15uI2UoAqVcrrIL43MFiGfnMC0ZpABF5GEyXE2XYPj966ySbfHMQiVy+Q
         wn3f88VzYTgduni4UFKOUCs3LgKQHZyRCSz7DYxP1G+tcGtV50NTuRSF6nWYUEDVFzdM
         y8el90KpErW/yjdodnhCFXhyDY+jL1t3mm6qAhmk8JdFnv2SIGsQs9lvO9Z9P1NU3yZb
         xa0g==
X-Forwarded-Encrypted: i=1; AJvYcCUG9FnDIVcvIxr0f/O11jXRGQ7VFg8NqiAHeKpry4afP/mIf7ozUjSweD1dND17oRjbhHAJpSX6MNj/@vger.kernel.org, AJvYcCWnHiDFxaeXftqTds5oMrVmfHK9PbAIue6U+w1yp0C2isvNo292vonUupmmRMYaOTnb6At77HwNc+iu6mg=@vger.kernel.org, AJvYcCXP3Fp/En5sufPwAgSxjk5jvciW93hqbj2iDluAUVeRDjoQHZkDdgYNo1G0aLrjjRTK4T0tnYLN@vger.kernel.org
X-Gm-Message-State: AOJu0YyXqxse061SwKIFh3da7BOq3N7GcGwPNnpMczyDc7zjnCePX/v4
	h81+Zy+zYDUd2ooAmcpW/pJTqvYu4eKpdUKMtG7IcxBFdYd+9ss44da2QidzPZU=
X-Gm-Gg: ASbGnctHNN5OH7w/NLxVCSz9LRtlcernHHnbI+xTm/gwWmmv9v7M7k6fYuQZtUecyaE
	vOHGPYRGCWbaT42kUGSQZzJDYrBj4Vs+yZxp4jmr3Pznda3KSMogR1pQ7x73OR5YmpLGzNDGZ+y
	S8sgj1uwCH4V5boHops0GOBt/4H5skzIv+WrpB46Rs4wvdWR5iIrlMcVTt+vPTTys+d6j1+KtyR
	lpd+dD6n750HUNXfk9vSV/3HY+KD5OsdCZBqzXjrkNyHQIvkNYhfoXU3HTFIBs6ZYD7SgfVJf+T
	JEtfol0OPSSX4f3LhnUsqW1P2Feku68ITLHEEv9nK4XwnXC3xeNOKA==
X-Google-Smtp-Source: AGHT+IFMZCxCdyeODfF2pSSnn44P6r7PsL7s8v/YCMrMP5AVrRyqrwQjVcKiAaXGjo91fUKWtMqRGw==
X-Received: by 2002:a05:6122:54b:b0:518:91b3:5e37 with SMTP id 71dfb90a1353d-51e9e43e687mr9303547e0c.5.1738311037901;
        Fri, 31 Jan 2025 00:10:37 -0800 (PST)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-51eb1c3ca03sm448209e0c.24.2025.01.31.00.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 00:10:37 -0800 (PST)
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4b2c0a7ef74so1002723137.2;
        Fri, 31 Jan 2025 00:10:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVTHtbP/FU3qSJBYnhwFb7Dm2zm9xq4ndvQJDSXLAd5HCQfw/yk8rLQrrlrFLsOAnGqUAtBYclWU0r/@vger.kernel.org, AJvYcCXLOJOy9SdeKbeEHry2DziPNCYvgS2ovzQ/ai2362DQ1Uhx+T07cEH8KIrP4nDADccJVKF0qpjX@vger.kernel.org, AJvYcCXNmoYxGirwpenDyOl4drn9nPS3Yp6gDOgb3E5S9lugO9yVhnuU8YSfkq0j7aP+wjPCW+5ytmLFJQPIGgA=@vger.kernel.org
X-Received: by 2002:a05:6102:4bc7:b0:4b1:1eb5:8ee5 with SMTP id
 ada2fe7eead31-4b9a5300df8mr8729115137.25.1738311037486; Fri, 31 Jan 2025
 00:10:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250130184320.69553-1-eahariha@linux.microsoft.com>
 <20250130201417.32b0a86f@pumpkin> <9ae171e2-1a36-4fe1-8a9f-b2b776e427a0@kernel.org>
In-Reply-To: <9ae171e2-1a36-4fe1-8a9f-b2b776e427a0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 31 Jan 2025 09:10:25 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNjKJ0CFw+i1qgVsHO2LU6uOqkAq5iGL0EZyCtrfzM=A@mail.gmail.com>
X-Gm-Features: AWEUYZnzRpnttETHOvwV06xiq0h3GhjNbcJkQ7hh1AEarCDsz4Oe4dyjuIMFsLU
Message-ID: <CAMuHMdUNjKJ0CFw+i1qgVsHO2LU6uOqkAq5iGL0EZyCtrfzM=A@mail.gmail.com>
Subject: Re: [PATCH] jiffies: Cast to unsigned long for secs_to_jiffies() conversion
To: Jiri Slaby <jirislaby@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
	Easwar Hariharan <eahariha@linux.microsoft.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, kernel test robot <lkp@intel.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Jiri,

CC linux-xfs

On Fri, 31 Jan 2025 at 08:05, Jiri Slaby <jirislaby@kernel.org> wrote:
> On 30. 01. 25, 21:14, David Laight wrote:
> > On Thu, 30 Jan 2025 18:43:17 +0000
> > Easwar Hariharan <eahariha@linux.microsoft.com> wrote:
> >
> >> While converting users of msecs_to_jiffies(), lkp reported that some
> >> range checks would always be true because of the mismatch between the
> >> implied int value of secs_to_jiffies() vs the unsigned long
> >> return value of the msecs_to_jiffies() calls it was replacing. Fix this
> >> by casting secs_to_jiffies() values as unsigned long.
> >
> > Surely 'unsigned long' can't be the right type ?
> > It changes between 32bit and 64bit systems.
> > Either it is allowed to wrap - so should be 32bit on both,
> > or wrapping is unexpected and it needs to be 64bit on both.
>
> But jiffies are really ulong.

That's a good reason to make the change.
E.g. msecs_to_jiffies() does return unsigned long.

Note that this change may cause fall-out, e.g.

    int val = 5.

    pr_debug("timeout = %u jiffies\n", secs_to_jiffies(val));
                        ^^
                        must be changed to %lu

More importantly, I doubt this change is guaranteed to fix the
reported issue.  The code[*] in retry_timeout_seconds_store() does:

    int val;
    ...
    if (val < -1 || val > 86400)
            return -EINVAL;
    ...
    if (val != -1)
            ASSERT(secs_to_jiffies(val) < LONG_MAX);

As HZ is a known (rather small) constant, and val is range-checked
before, the compiler can still devise that the condition is always true.
So I think that assertion should just be removed.

[*] Before commit b524e0335da22473 ("xfs: convert timeouts to
    secs_to_jiffies()"), which was applied to the MM tree only 3
    days ago, the code used msecs_to_jiffies() * MSEC_PER_SEC,
    which is more complex than a simple multiplication, and harder for
    the compiler to analyze statically, thus not triggering the warning
    that easily...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
