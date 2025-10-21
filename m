Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121DE800
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 00:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761005661; cv=none; b=vAxaE7yD+bNwX3ZI53UEWvTLNsGJ5Qhp1W4mpylP2xY2tknukcP28KzujTKpQ1tFZasSjFHxyYXPqAE+k74fKoiK7RGy2BShGQUU8BQYPxL3icibQ/rqueSxEvoy/sOuq6bWvZC4Pr8chRTjXx9Hw1aVc+jk5rb8i6YbJQvYHNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761005661; c=relaxed/simple;
	bh=0KpPKIXCRO/KJfg/sFIh9mEBAeWgFBH1Rwh6MpvEXXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kTUHLsH+CRu43ndpwDswlXPxruQpWWZle1RZPGWpWia6hRGb6Qhk0AHaz7rFV5b5wWBgmTr6ay2CJqjYYaCIA0ASR59UUxpkxZQLa4Pkrbn014RGAhebni/qykEjSe08ROG++QbdVUCZr0T9Q0vL62cYm3ClQuZdrUrGsftM7SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJHocsw2; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJHocsw2"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-87c1ceac7d7so76670336d6.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 17:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761005659; x=1761610459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ui8DMzsFY6zqaDaV5/75lTx0Gmwu4XTBa5L7MWqUMxQ=;
        b=fJHocsw21mCB2ZY2Vnb3RJYzgOWWxy3Tu9yLtBxKS9GNfb9Q9AByVq+N5gXrvZ4aUs
         1ENFHpzHkEpdC8GWPNqwhrofpWplJ5Docm2y3hf0+WEIX8YOak2qfWEW4sdiHWzU3SJ3
         Yr6nAkxcAeVgJ4GZrU/wjjA80fbVaz4MfLwsww38+zy4+zL1lkMUx7nt3qG925kfnXn0
         eoVR29cT+AA4wHR9FR9qQ0GBZJuzQUGXzPsfUvp1MfD4+KkvPGapTci1ZYiNNDYz0NsT
         QHov3P8zuDXRodLKod9rnCjvTLfHzX/KHDof114DMvAOxzHrQUT9aZBJfLoIYFLkdfkH
         mvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761005659; x=1761610459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ui8DMzsFY6zqaDaV5/75lTx0Gmwu4XTBa5L7MWqUMxQ=;
        b=sYXkvQ7ZVk3Ch/OEPUBfpPUnx/SJzWgvprhkrfl/ZPMzY7V9PKKslpwqrlw0+vb18R
         zjxddKH3DoqSXt7tglrHF1bqQiHiAVSgAnuKbYe/js6plh+ET5m+zPptbsdRg9TZh+Vw
         3WIgSVchSIsntq7bhMEpaBw7YRCvwqtoExnXuaYGJHVcB6R90k2fKXqgdYeeFWu2X1bC
         v4H+TE2NF5LE7UmlFSDClOr9ojDEfkJUM9b0AW3ydFOHVEgQDJdoLUYnh5qovPJjjbnv
         NiUNBtgNMzxIq+vEgmxckWEMgvmE9mrGZN/gATabIGprk7gkDUDHp2PJD7IlNThEt7nG
         0NHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuMbNXcJtP0oL2Qj8mnn4x8HKp5QhGzD9FnZxVKq9B4SQdxwmwsWCCLbTCduAE0fZelzAPJz05GIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTrS5tFQo2rhloAlrtynVBCaMXp34oxzrdJBb2IPsCQWeBFP0S
	29y/2GdFTqOValklFQViQWMUg86YR6o6jJo7ESILq5Jq9c+4YY2hRKV2SwxbPNUoAVAcgZlnWHE
	uZpBU8awd459qy6ZBpGoZDCMOBvM4rEo=
X-Gm-Gg: ASbGncshAfopAcKQbesAGbvpDAZuMzs8c2e7I5XIPmQwZB3JxgiltSYBlrSP9PhhODN
	q5lRd7ipHrKpe+LK+IpfRdvSZO6/AP2QhmoEmMZtV/6gXWlteF4X/hZzWArK43Nu6Ve8J6DfVFe
	GvE6mzPRvQZmoGnzZEYCsbG33VB4cr/4HUJXx+O3gAHxsxf5CuExkdVn5O3zjdyuD55qziij2ma
	9WQuxEPewhrzVel2OoBMxmZOpmnP7oFsdb/nP/xUBulo+NpU9VbWBhNRgtqKYrOcWqneqv8L9kq
	QjQNb+JsvW3sXrFrR8QQidLtB18=
X-Google-Smtp-Source: AGHT+IFbi7roFVVLG3VRbRv2vUoOUhhzYMKWJpmCLVGWc6aaAHXM4zeW9tJOWQsYfgHBUQ85Ghk6YK2OfSr/WKJb5FA=
X-Received: by 2002:ac8:4249:0:b0:4e8:a464:1083 with SMTP id
 d75a77b69052e-4e8a46411a5mr114717011cf.54.1761005658930; Mon, 20 Oct 2025
 17:14:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251003134642.604736-1-bfoster@redhat.com> <20251007-kittel-tiefbau-c3cc06b09439@brauner>
In-Reply-To: <20251007-kittel-tiefbau-c3cc06b09439@brauner>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 20 Oct 2025 17:14:07 -0700
X-Gm-Features: AS18NWBZPYaiU7LDy5QEDqgaPTc4fOwEctpwqOwtUrXF3pD2hGNbq7TTOushC1w
Message-ID: <CAJnrk1Yp-z8U7WjH81Eh3wrvuc5erZ2fUjZZa2urb-OhAe_nig@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] iomap: zero range folio batch support
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, hch@infradead.org, 
	djwong@kernel.org, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 7, 2025 at 4:12=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Fri, 03 Oct 2025 09:46:34 -0400, Brian Foster wrote:
> > Only minor changes in v5 to the XFS errortag patch. I've kept the R-b
> > tags because the fundamental logic is the same, but the errortag
> > mechanism has been reworked and so that one needed a rebase (which turn=
s
> > out much simpler). A second look certainly couldn't hurt, but otherwise
> > the associated fstest still works as expected.
> >
> > Note that the force zeroing fstests test has since been merged as
> > xfs/131. Otherwise I still have some followup patches to this work re:
> > the ext4 on iomap work, but it would be nice to move this along before
> > getting too far ahead with that.
> >
> > [...]
>
> Applied to the vfs-6.19.iomap branch of the vfs/vfs.git tree.
> Patches in the vfs-6.19.iomap branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-6.19.iomap
>
> [1/7] filemap: add helper to look up dirty folios in a range
>       https://git.kernel.org/vfs/vfs/c/757f5ca76903
> [2/7] iomap: remove pos+len BUG_ON() to after folio lookup
>       https://git.kernel.org/vfs/vfs/c/e027b6ecb710
> [3/7] iomap: optional zero range dirty folio processing
>       https://git.kernel.org/vfs/vfs/c/5a9a21cb7706

Hi Christian,

Thanks for all your work with managing the vfs iomap branch. I noticed
for vfs-6.19.iomap, this series was merged after a prior patch in the
branch that had changed the iomap_iter_advance() interface [1]. As
such for the merging ordering, I think this 3rd patch needs this minor
patch-up to be compatible with the change made in [1], if you're able
to fold this in:

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 72196e5021b1..36ee3290669a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -867,7 +867,8 @@ static int iomap_write_begin(struct iomap_iter *iter,
        if (folio_pos(folio) > iter->pos) {
                len =3D min_t(u64, folio_pos(folio) - iter->pos,
                                 iomap_length(iter));
-               status =3D iomap_iter_advance(iter, &len);
+               status =3D iomap_iter_advance(iter, len);
+               len =3D iomap_length(iter);
                if (status || !len)
                        goto out_unlock;
        }

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aJf1cgpzmDz0d+8K5gOFBpk5wh=
qPRFsWtQ0M3dpOOJ2Q@mail.gmail.com/T/#u

> [4/7] xfs: always trim mapping to requested range for zero range
>       https://git.kernel.org/vfs/vfs/c/50dc360fa097
> [5/7] xfs: fill dirty folios on zero range of unwritten mappings
>       https://git.kernel.org/vfs/vfs/c/492258e4508a
> [6/7] iomap: remove old partial eof zeroing optimization
>       https://git.kernel.org/vfs/vfs/c/47520b756355
> [7/7] xfs: error tag to force zeroing on debug kernels
>       https://git.kernel.org/vfs/vfs/c/87a5ca9f6c56
>
