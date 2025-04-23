Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C0F17BED0;
	Wed, 23 Apr 2025 06:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745390428; cv=none; b=VD2s0Uiytd7OKuDbpJ9frfLUVwK9ci/4KCpZgQWg6CqsxfPhx1hg9LQsPwISFoNrDuh+2zG7P9goPtM/oBA+R/AD4c2r0L0zgpVwp0XutH5i1cfh3cS/s/bBU8zcGPaYG14SZXGEKv3xn4bDMqow++px0qp0JLI84hLY2zHmMy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745390428; c=relaxed/simple;
	bh=3HuTyXhJkl/yTOit/a2M9L4/0zusi54xYyhWG2QCJpM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aA7r0BZnKMwgw7lGMlGxek+vLzy/PyCJmrXrDDaB2tXOuGnxRVWU6lOVmLnhPzQN+QRqliKMur3/mJuFGjJQ6iBrx0UuZDcC9daYotEpoPFtnvoiaZ3YNeY5OZxR43vdX3JoLUG5MBj6bQS4kNYEy5F/4mXBgukbazake0/nEUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5290be1aedcso717034e0c.1;
        Tue, 22 Apr 2025 23:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745390424; x=1745995224;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Ba6tmlAbCMQPw4GSQHNs/ApOFK/gml2sfoYUe2vXaM=;
        b=ogGSxiwtyoqrLhcdzAptRDitjKguXY/oeR1bA60b7AmUTlgD3Gvzll+AsR4vrgWH2Y
         EwHqHAEdQVu02QNsoHe19mw3jcLvrU0L3xb1jQumd147Oop90v+Zhv3RE/0j/78MBz7y
         oVRv3vn0fJ9+pksOvDA25zTL48q6ClAa0nJ4TM5tZwK8b0BVkH8bwCVzz9UtDn9K2Qhd
         h7Nz64kgfnNS7brrVuFix9eJ9Tp+JtuFpjZZe757u4g1R3QiSSP8tC5elsR60Se9CoSs
         YLrqG56A4NjJW2kve71XD8bKiCA7KN0T2LDmAtnLdn4G1zcHjlQUPkefFk+ExeNR0sMP
         Aguw==
X-Forwarded-Encrypted: i=1; AJvYcCWcf+T7lsM1TE5o06ts6xNs5AYyBnWqISXCpUi0C5IDeDJzSd0LwZ0i1bDBvORwQe7EZFbAK+/oLrQr@vger.kernel.org, AJvYcCXAVDJ7+MeS91hVEpXlODNfSgC5hJiZls4MxhGcdOvv5m1XEWkziy0waOJzasSUzS3f4wFj5ChpUsqty6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOMLFKJq2iAXqrtVdC9pNc3o7pZF6FtkwFg6OoN5W9xSUPGxJq
	33dRJuGsFJt59LssOPsawZz3ULD1y0C1F1fXD1+tH8Op1ozZIWFYuUy0pG71
X-Gm-Gg: ASbGncvaCRdwLX5fSoxOcEavcjUybgFwGllzzk3Kis97TTT5oSwYjX0Q0v6Hr1aw4ap
	0bvIRgUWeJMYtq2CFv17hdL+6/o6YdkmDbb3YM23uY0pwZ9e2v6F6jMyXaHAABGAw0sNPMoT+Jx
	CSFRaxGw82cV2fwJ29eucp2t60kzwcL3QM6HPdlhkvqAoX2p7FaT4B29lCVFDOXc/xE6sKUXO6A
	mfWDJb7AGqGP4f8bmXP8q4ueoWxUyz5ZOOaZHqF9L7SHmEskXmCPjdM5OWV+CCHRT9Ms2mfi3zb
	orWTvN41kTW9oAv/losumBqum7ti3O8ZCZMMqNDdaagQw9VpJuADDs8TH2bxV1srZXzc9Q7mYwk
	9UzkTwyXg7VDDKgYAQg==
X-Google-Smtp-Source: AGHT+IGkOQS6KwEV/82Ot42E9pmhSyvr6ClKKExYlDs07kEFlRYt5anAucsORyAln1oIolMiL2MoUw==
X-Received: by 2002:ac5:c244:0:b0:524:2fe0:3898 with SMTP id 71dfb90a1353d-52a6a18683dmr801496e0c.5.1745390424551;
        Tue, 22 Apr 2025 23:40:24 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-8776468cd5fsm2608595241.20.2025.04.22.23.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 23:40:24 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5240a432462so636686e0c.1;
        Tue, 22 Apr 2025 23:40:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUA2VPCCNRaAejawxUoF/tqX+w538bGcPqOWSm1wChBv2uDwNyuygAWPsgN43UNNZjLWCRlR4eD9jbt9s4=@vger.kernel.org, AJvYcCVVfF5+g2jNkQLn1A5rD1QULIJlwuKZ8jUk9JowWyGitactN1h6N97VEjOsanIUzjgW2tMo3wNwgbYJ@vger.kernel.org
X-Received: by 2002:a05:6122:d9c:b0:520:4806:a422 with SMTP id
 71dfb90a1353d-52a6a053f6bmr1128149e0c.3.1745390424170; Tue, 22 Apr 2025
 23:40:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325091007.24070-1-hans.holmberg@wdc.com> <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net> <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
 <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
In-Reply-To: <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 23 Apr 2025 08:40:12 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVXh+9htop6R=1gn5AmX0YJtqtAB9iFmZm6DweyyG-k3w@mail.gmail.com>
X-Gm-Features: ATxdqUEM8b8nkIhMlBvzC9FFlRhWR9t_hxBPLVk7olyTZGn4yR9E9kXDjILDzD8
Message-ID: <CAMuHMdVXh+9htop6R=1gn5AmX0YJtqtAB9iFmZm6DweyyG-k3w@mail.gmail.com>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone GC
To: Guenter Roeck <linux@roeck-us.net>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>, 
	Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Apr 2025 at 19:43, Guenter Roeck <linux@roeck-us.net> wrote:
> On 4/20/25 03:53, Carlos Maiolino wrote:
> > On Sun, Apr 20, 2025 at 02:47:02AM -0700, Guenter Roeck wrote:
> >> On Tue, Mar 25, 2025 at 09:10:49AM +0000, Hans Holmberg wrote:
> >>> Presently we start garbage collection late - when we start running
> >>> out of free zones to backfill max_open_zones. This is a reasonable
> >>> default as it minimizes write amplification. The longer we wait,
> >>> the more blocks are invalidated and reclaim cost less in terms
> >>> of blocks to relocate.
> >>>
> >>> Starting this late however introduces a risk of GC being outcompeted
> >>> by user writes. If GC can't keep up, user writes will be forced to
> >>> wait for free zones with high tail latencies as a result.
> >>>
> >>> This is not a problem under normal circumstances, but if fragmentation
> >>> is bad and user write pressure is high (multiple full-throttle
> >>> writers) we will "bottom out" of free zones.
> >>>
> >>> To mitigate this, introduce a zonegc_low_space tunable that lets the
> >>> user specify a percentage of how much of the unused space that GC
> >>> should keep available for writing. A high value will reclaim more of
> >>> the space occupied by unused blocks, creating a larger buffer against
> >>> write bursts.
> >>>
> >>> This comes at a cost as write amplification is increased. To
> >>> illustrate this using a sample workload, setting zonegc_low_space to
> >>> 60% avoids high (500ms) max latencies while increasing write
> >>> amplification by 15%.
> >>>
> >> ...
> >>>   bool
> >>>   xfs_zoned_need_gc(
> >>>     struct xfs_mount        *mp)
> >>>   {
> >>> +   s64                     available, free;
> >>> +
> >> ...
> >>> +
> >>> +   free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> >>> +   if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> >>> +           return true;
> >>> +
> >>
> >> With some 32-bit builds (parisc, openrisc so far):
> >>
> >> Error log:
> >> ERROR: modpost: "__divdi3" [fs/xfs/xfs.ko] undefined!
> >> ERROR: modpost: "__umoddi3" [fs/xfs/xfs.ko] undefined!
> >> ERROR: modpost: "__moddi3" [fs/xfs/xfs.ko] undefined!
> >> ERROR: modpost: "__udivdi3" [fs/xfs/xfs.ko] undefined!
> >>
> >
> > I opened a discussion about this:
> >
> > https://lore.kernel.org/lkml/20250419115157.567249-1-cem@kernel.org/
>
> A possible local solution is below. Note the variable type change from s64 to u64.
>
> Guenter
> ---
>
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 8c541ca71872..6dde2a680e75 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -170,7 +170,7 @@ bool
>   xfs_zoned_need_gc(
>          struct xfs_mount        *mp)
>   {
> -       s64                     available, free;
> +       u64                     available, free, rem;
>
>          if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
>                  return false;
> @@ -183,7 +183,12 @@ xfs_zoned_need_gc(
>                  return true;
>
>          free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> -       if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> +
> +       rem = do_div(free, 100);
> +       free = free * mp->m_zonegc_low_space +
> +               div_u64(rem * mp->m_zonegc_low_space, 100);
> +
> +       if (available < free)
>                  return true;
>
>          return false;

There's also mul_u64_u32_div():

    static inline u64 mul_u64_u32_div(u64 a, u32 mul, u32 divisor)
    ...

Unsigned, too.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
