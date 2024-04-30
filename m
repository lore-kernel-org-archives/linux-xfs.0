Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AC1383A5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480836; cv=none; b=E6u9MzQ+lGFhjdM7puC1mzRlEsqbCrI9Mh8GkYz4C2IGQsH161udLFg+2p4UdU1ISUo2BlPIrBPZp5IYlPsBr8a0oO2nyX+ATssl5R5G9KhdPMs7NKnO9LlQJsFz7Kcbw1nPVyMkOfSUW1f9HhrdcZMa7uDXYCbnIsSs3MWGEig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480836; c=relaxed/simple;
	bh=4sCe6xpTgRXeWcTTMZOa0ewP8BGahl2i+YABDXi0wck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qK4irkbnBIh1OvMB3JTrO8m9ngjZqQ9Z8kdAG/jhCeVVzEC/F9t37s70QRhkgyHHvwUi3Bxcg+WYPhpNKJ9Y98/1axAE3h15DcxhKihZTVkCW9RIq8JFIec40wMpfRyc5KkZxwBwC4bCAoH6KpxNJxb1YUqJpCF6cX0TfdDzy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uenDpP5X; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uenDpP5X"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-47c56d0d9c4so827364137.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714480833; x=1715085633; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0+Q4q72Nbg6gp54lNWhs8HuPGDEdbzKcgd5WAhycZBE=;
        b=uenDpP5X1VWKQMiDOyIiEgd876HL51bGlYaI4EGEpBKQo6+MvN6dDV2SFGse3xomZg
         Eab/Kgi9esnqfNxeMdlE5Ckw5+gC4aqRMcCJbf6DmLk5bYIEbQOpZsgZ3rifCRDu5Nvw
         4FBsA010xkO2oSOjUKgy7BeEuOzt2f3lxXGU21jtOq01EZAgUPfIGFq2bdISJ8wOkr3/
         fE2XhjU6sENXWs0lL2lXokYaPPMoSExyDH0k0S7WHkp0iajWHgy+Hmxb6j6zRdfYmlfE
         tJYsLdTYwxjDj1RsmJXyQ0gelo5c5OO7Z3jFos9ikFYsPz+KKxbrXg+edGRp4A0oOZls
         5n2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714480833; x=1715085633;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0+Q4q72Nbg6gp54lNWhs8HuPGDEdbzKcgd5WAhycZBE=;
        b=U4LX81wDJra2pks1PkfvjPmHJutdLjP1t8qGGCDDtNKm/oupA5fXXVQ69y0FJ5vnC1
         L72aoBIywv7hmOtxAB9CwrLUgT2OvDAQy3ChFxc7K5B5cEY4F9vkMqaU+UHhUBFjhOZm
         1j6H4nHym2Q1VKuYnjR8VFmOO6qP+1CY8i1Gtl83uFTd33Za2bdYN2uFTWiM26PsJ2nG
         G2YkH4DkXeHBaPKy72xljhE4c6RnJ4RPhf/4f0pjteFuXlMKjXpVNC58QSSIZgaOWtXY
         VMU6hfOrMQLWF016hCCIPp04d9QPGMZAvmw3pMCf3yDjDWtiba3eiUKHqtVHS5qMye0J
         PY9A==
X-Forwarded-Encrypted: i=1; AJvYcCU0kFqJIZVTAWgbiI+ez2TgPD5WqX4xkhZKbOMOYMIFcrUEXTDkZYp545fagq3CaFIkNN4zgThAKTY7SrC3R/cHnXBQbaVJsZIF
X-Gm-Message-State: AOJu0YwxzQJw4jjm4SVgOWf295JUb6k9IBpVnop17xQjZieXMA6cSKlW
	jJkHlyYnFr7+FnnEDLe0WYAxnPaRyxvCXvGs/M2iEqGnUcFyfyZHst2QCX3DiqllPomCQ7S8mAe
	fOeMq5TgLEdxyVkpX+GfDD0zJIO6T72FAmCTu
X-Google-Smtp-Source: AGHT+IGzW5mU1Zknj5gl/Xkyux22XObZpMvXOL8LeYOFj2x376YznDKYNXCfrCktnTwMr00GjerMpKKfjtk6sLTN8BE=
X-Received: by 2002:a67:ec4f:0:b0:47a:1cd2:3d81 with SMTP id
 z15-20020a67ec4f000000b0047a1cd23d81mr13289675vso.32.1714480833297; Tue, 30
 Apr 2024 05:40:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430054604.4169568-1-david@fromorbit.com> <20240430054604.4169568-3-david@fromorbit.com>
In-Reply-To: <20240430054604.4169568-3-david@fromorbit.com>
From: Marco Elver <elver@google.com>
Date: Tue, 30 Apr 2024 14:39:57 +0200
Message-ID: <CANpmjNO5wVL79UVVw8X=v5QGYm_wZH-RMgXh1acj+9=J8jwU+w@mail.gmail.com>
Subject: Re: [PATCH 2/3] stackdepot: use gfp_nested_mask() instead of open
 coded masking
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, akpm@linux-foundation.org, 
	hch@lst.de, osalvador@suse.de, vbabka@suse.cz, andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Apr 2024 at 07:46, Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> The stackdepot code is used by KASAN and lockdep for recoding stack
> traces. Both of these track allocation context information, and so
> their internal allocations must obey the caller allocation contexts
> to avoid generating their own false positive warnings that have
> nothing to do with the code they are instrumenting/tracking.
>
> We also don't want recording stack traces to deplete emergency
> memory reserves - debug code is useless if it creates new issues
> that can't be replicated when the debug code is disabled.
>
> Switch the stackdepot allocation masking to use gfp_nested_mask()
> to address these issues. gfp_nested_mask() also strips GFP_ZONEMASK
> naturally, so that greatly simplifies this code.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  lib/stackdepot.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index 68c97387aa54..0bbae49e6177 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -624,15 +624,8 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>          * we won't be able to do that under the lock.
>          */
>         if (unlikely(can_alloc && !READ_ONCE(new_pool))) {
> -               /*
> -                * Zero out zone modifiers, as we don't have specific zone
> -                * requirements. Keep the flags related to allocation in atomic
> -                * contexts and I/O.
> -                */
> -               alloc_flags &= ~GFP_ZONEMASK;
> -               alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
> -               alloc_flags |= __GFP_NOWARN;
> -               page = alloc_pages(alloc_flags, DEPOT_POOL_ORDER);
> +               page = alloc_pages(gfp_nested_mask(alloc_flags),
> +                               DEPOT_POOL_ORDER);
>                 if (page)
>                         prealloc = page_address(page);
>         }
> --
> 2.43.0
>
