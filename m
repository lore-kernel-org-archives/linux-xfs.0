Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF7C16423
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 12:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNweRHs7"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3bd4df21f4eso97199b6e.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 04:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704976846; x=1705581646; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNTm34eTLvRHOPbrJjIlfWKXtGxK1nGFmPu9K7b02v4=;
        b=bNweRHs7J8W7hQXWQ7fJAIgSdAM/BTP9OCHTW2CMQz9aw+x6FFU0yH0iZUl2YBcw9j
         UPYUAJ2UiHYa6RNb7yY87lTsySDcuXXxjEihtI2MOcT6vIr2q3CAZf2wS0Cj2WrgRmFl
         jzEYbVlH3TFE5nfHd6qrsDLM6lGzUw+tHo3GRMtnLPCmeEaRIpHYIB18kbiKWe7oRVJN
         ZG+LEp8JLElDEweHBKo1Z8tuJTANcUpdUBIl1XxavLREelQiXNLlm9k8QMppMNpycgKB
         Fu/nG3qJNScX9QGQoeH/0bbPtITokxQ7ShRKPxdhXpW+TEaX/Xh+4kxve5OVRatYA13p
         hRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976846; x=1705581646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNTm34eTLvRHOPbrJjIlfWKXtGxK1nGFmPu9K7b02v4=;
        b=Tu/8uxO7vqCAr75rE+IVyFYjtfescS/LH83NmhGYsoBj6JaFYrmW1ZzIZS9igPyogi
         YSwc2BJnZ/tit6+ELvt55QGXTQyMkWlPFSbzwg6Y5uZgIQHl6HOJKI9Vdow5blxGaE7o
         1NvZPAXLY1qbs3duuIepoXSDN4QXbjLt+jTJuQ7j/l1/vqTPMzZjcQrUu9ShdwewwNwf
         viFm4lKWrP74mutaji/z15WxbPX+cYCKz3/65EiIU+kvUJ0uaL7UtN1mtTuC3i/FN9rD
         LJGvlP4zYNBgfy87hY+2TKqNXnN0uBNO0LlZKM7YBWQ9i8BrXB2nZIjSEq2QGjwoGmF+
         ndbA==
X-Gm-Message-State: AOJu0YwzbZ2jQNT+muM8HC9GvmiiditdeeJzU3uYfjjyeHPdOY1It+yO
	I3+fNJ4ETV3+PWSfeSiKicFV10G0CW9fdag7I2c=
X-Google-Smtp-Source: AGHT+IEWjBlCoQzELzwEg+Ob9SZZ0IJIBnnfOKkpdymPxzdQwR+3vuqMgSvxUq+5CT8MqN09X53IqxB0Jx4WGyc2P74=
X-Received: by 2002:a4a:d387:0:b0:598:94b1:1658 with SMTP id
 i7-20020a4ad387000000b0059894b11658mr2157065oos.1.1704976845950; Thu, 11 Jan
 2024 04:40:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240110071347.3711925-1-wenjian1@xiaomi.com> <20240110174501.GH722975@frogsfrogsfrogs>
In-Reply-To: <20240110174501.GH722975@frogsfrogsfrogs>
From: Jian Wen <wenjianhn@gmail.com>
Date: Thu, 11 Jan 2024 20:40:10 +0800
Message-ID: <CAMXzGWLLYy-QZZnfXbNMoHPxCHrhsd=+K6bafM4e1LENuptfOA@mail.gmail.com>
Subject: Re: [PATCH] xfs: explicitly call cond_resched in xfs_itruncate_extents_flags
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com, 
	Jian Wen <wenjian1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 11, 2024 at 1:45=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Jan 10, 2024 at 03:13:47PM +0800, Jian Wen wrote:
> > From: Jian Wen <wenjianhn@gmail.com>
> >
> > Deleting a file with lots of extents may cause a soft lockup if the
> > preemption model is none(CONFIG_PREEMPT_NONE=3Dy or preempt=3Dnone is s=
et
> > in the kernel cmdline). Alibaba cloud kernel and Oracle UEK container
> > kernel are affected by the issue, since they select CONFIG_PREEMPT_NONE=
=3Dy.
> >
> > Explicitly call cond_resched in xfs_itruncate_extents_flags avoid
> > the below softlockup warning.
> > watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:13:139]
>
> Wowwee, how many extents does this file have, anyway?
I deleted a file with 346915 extents in my test environment.
I should have mentioned lockdep was enabled: CONFIG_LOCKDEP=3Dy
Without CONFIG_LOCKDEP the scheduling latency was several seconds.

P99 latency of one of our services increased from a few ms to 280 ms
because of the issue.

Below are the steps to make a file badly fragmented.
root@xfsunlink:~/vda# uname -r
6.7.0-rc8-g610a9b8f49fb

root@xfsunlink:~/vda# img=3Dtest.raw ; qemu-img create -f raw -o
extent_size_hint=3D0 ${img} 10G && qemu-img bench -f raw -t none -n -w
${img} -c 1000000 -S 8192 -o 0 && filefrag ${img}
Formatting 'test.raw', fmt=3Draw size=3D10737418240 extent_size_hint=3D0
Sending 1000000 write requests, 4096 bytes each, 64 in parallel
(starting at offset 0, step size 8192)
Run completed in 42.506 seconds.
test.raw: 346915 extents found

>
> > CPU: 0 PID: 139 Comm: kworker/0:13 Not tainted 6.7.0-rc8-g610a9b8f49fb =
#23
> >  Workqueue: xfs-inodegc/vda1 xfs_inodegc_worker
> >  Call Trace:
> >   _raw_spin_lock+0x30/0x80
> >   ? xfs_extent_busy_trim+0x38/0x200
> >   xfs_extent_busy_trim+0x38/0x200
> >   xfs_alloc_compute_aligned+0x38/0xd0
> >   xfs_alloc_ag_vextent_size+0x1f1/0x870
> >   xfs_alloc_fix_freelist+0x58a/0x770
> >   xfs_free_extent_fix_freelist+0x60/0xa0
> >   __xfs_free_extent+0x66/0x1d0
> >   xfs_trans_free_extent+0xac/0x290
> >   xfs_extent_free_finish_item+0xf/0x40
> >   xfs_defer_finish_noroll+0x1db/0x7f0
> >   xfs_defer_finish+0x10/0xa0
> >   xfs_itruncate_extents_flags+0x169/0x4c0
> >   xfs_inactive_truncate+0xba/0x140
> >   xfs_inactive+0x239/0x2a0
> >   xfs_inodegc_worker+0xa3/0x210
> >   ? process_scheduled_works+0x273/0x550
> >   process_scheduled_works+0x2da/0x550
> >   worker_thread+0x180/0x350
> >
> > Most of the Linux distributions default to voluntary preemption,
> > might_sleep() would yield CPU if needed. Thus they are not affected.
> > kworker/0:24+xf     298 [000]  7294.810021: probe:__cond_resched:
> >   __cond_resched+0x5 ([kernel.kallsyms])
> >   __kmem_cache_alloc_node+0x17c ([kernel.kallsyms])
> >   __kmalloc+0x4d ([kernel.kallsyms])
> >   kmem_alloc+0x7a ([kernel.kallsyms])
> >   xfs_extent_busy_insert_list+0x2e ([kernel.kallsyms])
> >   __xfs_free_extent+0xd3 ([kernel.kallsyms])
> >   xfs_trans_free_extent+0x93 ([kernel.kallsyms])
> >   xfs_extent_free_finish_item+0xf ([kernel.kallsyms])
> >
> > kworker/0:24+xf     298 [000]  7294.810045: probe:__cond_resched:
> >   __cond_resched+0x5 ([kernel.kallsyms])
> >   down+0x11 ([kernel.kallsyms])
> >   xfs_buf_lock+0x2c ([kernel.kallsyms])
> >   xfs_buf_find_lock+0x62 ([kernel.kallsyms])
> >   xfs_buf_get_map+0x1fd ([kernel.kallsyms])
> >   xfs_buf_read_map+0x51 ([kernel.kallsyms])
> >   xfs_trans_read_buf_map+0x1c5 ([kernel.kallsyms])
> >   xfs_btree_read_buf_block.constprop.0+0xa1 ([kernel.kallsyms])
> >   xfs_btree_lookup_get_block+0x97 ([kernel.kallsyms])
> >   xfs_btree_lookup+0xc5 ([kernel.kallsyms])
> >   xfs_alloc_lookup_eq+0x18 ([kernel.kallsyms])
> >   xfs_free_ag_extent+0x63f ([kernel.kallsyms])
> >   __xfs_free_extent+0xa7 ([kernel.kallsyms])
> >   xfs_trans_free_extent+0x93 ([kernel.kallsyms])
> >   xfs_extent_free_finish_item+0xf ([kernel.kallsyms])
> >
> > Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> > ---
> >  fs/xfs/xfs_inode.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c0f1c89786c2..194381e10472 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -4,6 +4,7 @@
> >   * All Rights Reserved.
> >   */
> >  #include <linux/iversion.h>
> > +#include <linux/sched.h>
> >
> >  #include "xfs.h"
> >  #include "xfs_fs.h"
> > @@ -1383,6 +1384,8 @@ xfs_itruncate_extents_flags(
> >               error =3D xfs_defer_finish(&tp);
> >               if (error)
> >                       goto out;
> > +
> > +             cond_resched();
>
> Is there a particular reason why truncation uses a giant chained
> transaction for all extents (with xfs_defer_finish) instead of, say, one
> chain per extent?
I have no clue yet.
>
> (If you've actually studied this and know why then I guess cond_resched
> is a reasonable bandaid, but I don't want to play cond_resched
> whackamole here.)
>
> --D
>
> >       }
> >
> >       if (whichfork =3D=3D XFS_DATA_FORK) {
> > --
> > 2.25.1
> >
> >
