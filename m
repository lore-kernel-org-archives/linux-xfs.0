Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2EC2C21F9
	for <linux-xfs@vger.kernel.org>; Mon,  6 Oct 2025 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759756602; cv=none; b=BaFX0IU7IrfYRrDykaVVWRqqRMQ7EeX7SXB9g7GBIHfAYxIhz4AmKk2JTYwlBr4ZLQafvstRKjagPhT1VyznhL7f/ASN93ffieqtTbiq2k4+FdUm9/fOUh4PLveX39sqt00EfQW/dg0+o+UmN2+aUM4ai8C2aONlHt+jnV/O+hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759756602; c=relaxed/simple;
	bh=9RiibcQ8hYvWrHwNJrsOBQZBaxnayLS0Ew1MmhtqWo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aggZ8D7zL0/5zKXaBUJE9Gu8PJcR5E0LwQGLGkKMNIXvXjwaGEiocq6PVc/Z64HkLSZP7FWsbtR6uPFAB1NpV+5KOj00qxs0GvTn4eBIYNNfcgxWVbrlI4zkVS3zuOzCZlZNtBE1H0xqMvOw5sHFWSIcjqeJ0gXhU0o9aJ6XhKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WADEXV5y; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WADEXV5y"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-636535e4b1aso4403014a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Oct 2025 06:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759756599; x=1760361399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yONkX6le0asFqe/FiMMLWvsxiXDZUAvFOOTqPAZxMYs=;
        b=WADEXV5yL2pC5NDHItmncaXGE0hSdlv5UmaUabVz4OMowbUupEA2eTTd1Uk3iqDpiF
         FEcLPKLKFnOS5py3TFC9kWn3ztjBCuztlFmOEfacKAQttpJJQxc/xbeAn65EotLasYzM
         sj8ai6VFZM947QQLp/mb+TyctQSb5Hchyz6+CiRLDsghMTeL5f/FpjefA3x2Ppw3oBZw
         Dp9PngFT4H8gkJp7Aa+ZXu0H2UAovDLOJlmufZsREgxIA7sA6pPxcgNTwUgwQxyKXSvn
         YJr02dz1QtQaS7yolIBlYpluGlBpvbkCcVAxyhuHgXGCdi9jTWs+D6PmvrU/3U3IxJ1b
         oqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759756599; x=1760361399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yONkX6le0asFqe/FiMMLWvsxiXDZUAvFOOTqPAZxMYs=;
        b=MqvKJyX5XQZY+5wq3TSiBpeKlehBKvdOxHwqYVdSOiSku+Ga7xeCPLRIz8EIEmoLcK
         LMyhAixOFQ1WxLgUc7yp2ZF90PeeNh9trkUhz5wTqs2ZoT4wVGq0q/Mf5HxqXWR/yG2A
         cqr1A8KjdZ9Xox/WDq338ZuSmNU42FMTNy+QpKowgQ4mwG+dCCRHhPFOyxiL12YInoPV
         JZjwDAQs8B6++5no/jFz+Kw4m+j+3wjmbbSO3EcEBTiT83r1bG0iPspapx1STxCBTBTU
         ZR4SuaxLsB+enDQC80QpKFCPkDXgIQAFSsyWxEyZQ1OofWW2qXbMk1IvUQvUVDsdBWK+
         eQJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUExODpzFINhYVw6gHr6SGz39Pu28dxJiJibXde33TtUScg9I+a+8i7phMe+AhENtEBVFaDZ0ps6vo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7iL/DoKwdkO75RAIug+QQNI//ve4FBya+pk4xLpYd4B+Es6++
	+fL3V5kVoh41EE3KKbm2re3DafwPHCuFA7CV8KXblNKmMgK5e9n5TG3mz5f59rIN+fquB3bpQUi
	+MMKS5C+6WUBNEdTDVfOfuQNmO87w3tE=
X-Gm-Gg: ASbGncs542P9b/Zhzo80rqMgYA/quZwNPlMh/HLOC9JBkXUw0E/pMVrdT5nxcNYwUC1
	HkKFx+Nx8BKuTmgzS4UtWzZAwYzXA7kM/oC1+KkiF2KlLRDaN5EspMNVhm61IK2zI8QYuQ16e+u
	BGUTUzLQOVUZ5l+cj30IIeFvFqXl08odnU7oKuVjH2qK3lEPYT48ZDQ6UaqnQFM+xmb8Khw7jsA
	lvhAho7FsF0Q6UlLphks3gi/07fOd1+PUSfX56waBfqfIFAlFyonYhlQc9zBTlZe3yM8kWlIQ==
X-Google-Smtp-Source: AGHT+IGgfaKILwiIYhOJauD31uynKvUTNQB8TM3B4u9+8sn3XNc0LxMTwvmUPPVqZHvJq+WHY2tARoUrXupUK50gMkY=
X-Received: by 2002:a17:906:37c5:b0:b4a:e7c9:84c1 with SMTP id
 a640c23a62f3a-b4ae7c98631mr906398266b.7.1759756598374; Mon, 06 Oct 2025
 06:16:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923104710.2973493-1-mjguzik@gmail.com> <20250929-samstag-unkenntlich-623abeff6085@brauner>
 <CAGudoHFm9_-AuRh52-KRCADQ8suqUMmYUUsg126kmA+N8Ah+6g@mail.gmail.com> <20251006-kernlos-etablieren-25b07b5ea9b3@brauner>
In-Reply-To: <20251006-kernlos-etablieren-25b07b5ea9b3@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 6 Oct 2025 15:16:26 +0200
X-Gm-Features: AS18NWCEM0fjjZM6zlyL8ddYZ6bYQjBB781Tu0JzfRDs6qIJETdk0ZVa55ZRAIQ
Message-ID: <CAGudoHGZreXKHGBvkEPOkf=tL69rJD0sTYAV0NJRVS2aA+B5_g@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] hide ->i_state behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 6, 2025 at 1:38=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Mon, Sep 29, 2025 at 02:56:23PM +0200, Mateusz Guzik wrote:
> > This was a stripped down version (no lockdep) in hopes of getting into
> > 6.18. It also happens to come with some renames.
>
> That was not obvious at all and I didn't read that anywhere in the
> commit messages?
>

Well I thought I made it clear in the updated cover letter, we can
chalk it up to miscommunication. Shit happens.

> Anyway, please resend on top of vfs-6.19.inode where I applied your
> other patches! Thank you!

I rebased the patchset on top of vfs-6.19.inode and got a build failure:

fs/ocfs2/super.c:132:27: error: =E2=80=98inode_just_drop=E2=80=99 undeclare=
d here (not
in a function)
  132 |         .drop_inode     =3D inode_just_drop,
      |                           ^~~~~~~~~~~~~~~

and sure enough the commit renaming that helper is missing. Can you
please rebase the branch?
