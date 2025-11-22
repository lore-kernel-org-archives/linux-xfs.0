Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C7527A12B
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 09:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763804524; cv=none; b=C/zhZVEUNHadlW+xGr5FKGjndYLyXlJczV0yMHydcEnWwxpTZE+AY4YVU5QYYckUN1GJLJZyHsP5bU4SfacMd8kLLHb0bSq04iMZYwnmBpd/gqn6a8mvmBLrSzb/TJw4yc+vbNnjYwEY5/FAelcfDdE7eTziWcTPQK44wnyyB+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763804524; c=relaxed/simple;
	bh=3YQgvYMtZvcyTlvXkIp04oAH/AMO8dXo0NAiibjPXy8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jw0yppYbX8YijQ5/Zk69a7kwj2RpTzmrB9ZwssTZO2ZIYBJjiP2eUVOde7gr4pGP/wZIQg74OiAJuaq5YAQrv+o7m21VrHSS9kEpT0r42NX86ZJdOPBlz34gbaFfe89IkqWtZZE1gwynZCPP1DYYq7eC+XUCAsKwpxfa36GFEHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z+Jm2mZD; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+Jm2mZD"
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso4265582a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 01:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763804521; x=1764409321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VraqRiW+TcUOXtKCYeJfwojEREVPpKsk9aXSr0pbaZU=;
        b=Z+Jm2mZDvvvMweu82eTJLkI2WaE3V5eDIu+EzrBMh7zREZBEhZ+LslziyBnEmXGEzl
         Tf1qCzpBWx77EoqdZS05Em4OZ2lBdaALHgt2mSGkOvkEtRapfNrR5rC7ZWC5688Uzxff
         mEACO/QZzucvpAx6YPzQt+3H2V/gnW7FZejJ/4Po5V4qEC/UZjFhMmScHj59pcvgD/vf
         Cw0xqyMVN19kw4nlHleEoz7tfsSQmxfXzu+0YjS16XWzElmWTtJ7+BlUlluwMdMtBwX9
         6seLjxQrdCmBF8y61zow3oJyma6OxgsKbAyyiP3K2GiLFCjoAxiF4+Utbj0OduNj6Pmi
         Ckpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763804521; x=1764409321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VraqRiW+TcUOXtKCYeJfwojEREVPpKsk9aXSr0pbaZU=;
        b=vH9aIvBWxja9kDovD4aR6Y7YxVbg08Ue3dLNQqapFcB1MeooVmRPqkHupd5AilP3iY
         nLRx7YZfB78cNeadhr3AuviHXyszRFhCn7s1AYNnrgXc3Qs9gfEWu27JVQk4JMq/BUB7
         su7lyUwBJdlkhJomIgOf+vy+JzjPr6yT+o/GOWC+kbxMj4P712k6B+Bu9OfUcNw+S0zU
         DjUKAc+36aht6XMMIRhJnFr/rjq1ReVWd4ebjmw2PYYN7bNzU7SRsHTDfZH3GbtcbLdr
         TyJF+Kg4ffCDzvSWRUFws7P4phqZ7GLEzw/evx9SfamErT172dMlZ0bWCQ0PXGa8fQRc
         EqRw==
X-Forwarded-Encrypted: i=1; AJvYcCXA8f3Tjg/bnS7BWf7MW518dazBTJ8f5tnYXMRkc9CnPlQb3ZZbpK2KGBudw8ejpOJl7QuitAd26Zk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfSXQh6iT6OHqhgYGfZk8CSsTfQegqnqrpb3jtuB/FuLj4NF4/
	Hd2s1Hb7eZS4odJxbZrPxaUNksudZTm6CmdGj6k8+Agez6nejPA/R+THwOp2ffumYe5oCbqVlCr
	VVKy8BveV/b6AcTpOWkjsFRt2aogBTS4=
X-Gm-Gg: ASbGncuwarft8uvTTwWPwoUPyg+JRoAOo0AnX84twgwPmWvc28XufwqCn3xMt3wkVm4
	BXzjJN3Oyh6TdT8VCEwiruueGJBwk4I2pvdbC4ChE6bKZEEmkwCWNpsW58fwP+/STg3AO+drl/B
	WGvIRZc6sX8IVdiLAjEGKI2Wcecsjq8d334Ooiffd0gOZyhCGocCksOpbeJYFSYp6Ymr8yhsIQF
	3t8imhUAG4NWRYiOpLNf4rKvqiANE/UJ5DuhoGZXTCO8E16ej87r8yCj7WSL4DKnj/MDFVVPR0F
	OyFxCA==
X-Google-Smtp-Source: AGHT+IGW0icuqa/61J8riraAee8yoDf5AfHeS5boydG7jyYd3FZvfFFJ/Sg7u2f8roxpHOp2NlYS4gcTu8x3Ryp3jD8=
X-Received: by 2002:a05:6402:90c:b0:63b:f67b:3782 with SMTP id
 4fb4d7f45d1cf-64554692891mr4275862a12.27.1763804520865; Sat, 22 Nov 2025
 01:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114152147.66688-1-haoqinhuang7@gmail.com> <aRnLqK_N25LvkSZQ@dread.disaster.area>
In-Reply-To: <aRnLqK_N25LvkSZQ@dread.disaster.area>
From: haoqin huang <haoqinhuang7@gmail.com>
Date: Sat, 22 Nov 2025 17:41:49 +0800
X-Gm-Features: AWmQ_bkLPPxenl4Y3nm7JwJzyyc1de85ry9tWLoTAKtyncIDNWvbGL-1YFDN4dE
Message-ID: <CAEjiKSkcLrkpzxUadKCyGEzHV503Q_htisU=rANk_zHoj9U04g@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix deadlock between busy flushing and t_busy
To: Dave Chinner <david@fromorbit.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org, 
	Haoqin Huang <haoqinhuang@tencent.com>, Rongwei Wang <zigiwang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Thanks for your reviews, and sorry for response lately.

I=E2=80=99m very agree that deferred frees largely resolved the deadlock is=
sue.

Maybe I should split two parts of this patch to show my idea:
Part 1. fix fallback of xfs_refcount_split_extent()
It seems better to  fix a logic bug in xfs_refcount_split_extent().
When splitting an extent, we update the existing record before
inserting the new one. If the insertion fails, we currently return
without restoring the original record, leaving the btree in an
inconsistent state.

This part does not seem to be necessarily related to the
aforementioned deadlock.
Part 2. Robustify the rollback path to prevent deadlocks
The change to xfs_extent_busy_flush() is just added as a secondary
hardening measure for edge cases.
I=E2=80=99m not sure, but theoretically, the alloc_flag to be zero, then
entering a cycle with a high probability of deadlock.

I can post v2 if you agree, and any comments are welcome.

Thanks.

On Sun, Nov 16, 2025 at 9:03=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Fri, Nov 14, 2025 at 11:21:47PM +0800, Haoqin Huang wrote:
> > From: Haoqin Huang <haoqinhuang@tencent.com>
> >
> > In case of insufficient disk space, the newly released blocks can be
> > allocated from free list. And in this scenario, file system will
> > search ag->pagb_tree (busy tree), and trim busy node if hits.
> > Immediately afterwards, xfs_extent_busy_flush() will be called to
> > flush logbuf to clear busy tree.
> >
> > But a deadlock could be triggered by xfs_extent_busy_flush() if
> > current tp->t_busy and flush AG meet:
> >
> > The current trans which t_busy is non-empty, and:
> >   1. The block B1, B2 all belong to AG A, and have inserted into
> >      current tp->t_busy;
> >   2. and AG A's busy tree (pagb_tree) only has the blocks coincidentall=
y.
> >   2. xfs_extent_busy_flush() is flushing AG A.
> >
> > In a short word, The trans flushing AG A, and also waiting AG A
> > to clear busy tree, but the only blocks of busy tree also in
> > this trans's t_busy. A deadlock appeared.
> >
> > The detailed process of this deadlock:
> >
> > xfs_reflink_end_cow()
> > xfs_trans_commit()
> > xfs_defer_finish_noroll()
> >   xfs_defer_finish_one()
> >     xfs_refcount_update_finish_item()    <=3D=3D step1. cow alloc (tp1)
> >       __xfs_refcount_cow_alloc()
> >         xfs_refcountbt_free_block()
> >           xfs_extent_busy_insert()       <-- step2. x1 x2 insert tp1->t=
_busy
>
> We haven't done that for quite some time. See commit b742d7b4f0e0
> ("xfs: use deferred frees for btree block freeing").
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
