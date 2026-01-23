Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEE42741AB
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 18:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192644; cv=pass; b=GRV9kRUAhO8TGgg6xIib8oKlpohxBnZ30Y/PcaYfFYEgAoubM1KitVzNU/z6REP/PcN4KygeSFy/fnrlWqz0/znewdPnd7aIRir+RUgpc3QYua1SnQfj9EGqkutkxWUOPHb3w8g1DOrCygrVSc1D1a3KmqYx8/SUmZF5aOIEei0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192644; c=relaxed/simple;
	bh=n4YhPse98qUd9LwH4JiO0SDXD4jOD4zJ7XyPkwTyoTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fc9nw0N9wFjuB90xwr7P22U952jWK6j2xYL5zobhnjwGzjNu2g8ImU+FLLMjhFVh866VI7376ceFHeXdmi0VEziSmkeQv9Xrv01GNZgICkdWS97MXqF8Pk9wXUpckxDT3/pz/3VW5VjQY4uzfkNHwqCrzfWe8BjhTU6nrMMdsc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4Z4jyV3; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4Z4jyV3"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9cb94ff5so3492660a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 10:24:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192640; cv=none;
        d=google.com; s=arc-20240605;
        b=c8xX94L8WTBtSlXJZJD89fJcZ2rsJX01C6y+6PCJ7uRxUsUREhhPChk1tw/ywm7j1n
         ZCYRjToyTShBlitZJ4GN9DRPAAf7T0OjGrfz5FbXq/gC1JK6NBs6tHEYdJAX3kxTAyJg
         hFe50mOnyAhTTQOKqvfbx2J/2JzrQV2dIBwRYl4PWrKqwjyXpu7TOZLwoWh+6gpHbF+A
         KyID4mTR/4cOCvuc/iQt2ZiK8gvJBiu1H9gcG1Bae6iGAD/CBIkw4K+bXg1RL11uTzwm
         v9jz5s54YEDS0BQGx5cIcGieYqp53XE8vPTyx+zZz0l5lvWKbdZBGCHjCU01cPSo9Pp2
         NcIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+wIr5X9WIZrYU1MaHy3YriH4HYquJi6PoX16TeqzI1c=;
        fh=XoQVNCVcF+9gQCmrqHdF66MGFKKzT2cnqLmjwENjoQ0=;
        b=amm0u2nl9Dyb4vLmGEDf1pMAlnXF+Q797vxFtMn/m94eHYqiq8YuOpL4ZpoRem4yYr
         GEuyJj8blwpiOn2Y27MZ4QNNYyNJr3o6tFr5iFu6VyqoBi8y9+MsVkyqS+eSEpwYS196
         CikySET1Xw1tzEHWhM50xZDtY8U2z8PS32XQOrZkvKEbmF4/AAUsKnpO+s32NPqJ/Lz0
         oeE0yon3F5qiBdVc+UFcCkMCaHwFK4TJUcvrWc1PyvzGEsqkKFuzI2kuAGIjgrPBZiMW
         irfLKA2RVgTzB5zQw6qS4vXd4mDJ8Abz4dj0TsPjlPyX8g+KfGoRxyM7T61z4oVicBu9
         REiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769192640; x=1769797440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wIr5X9WIZrYU1MaHy3YriH4HYquJi6PoX16TeqzI1c=;
        b=f4Z4jyV3RuH3LLIqsWjxtmK7+BFXMdGZUjdXdgrewhOyDs74L49h6Wd1KATx5V3/nK
         6zCajBjnHiCsTigrklCeY+gzRDLWCW9I7NzXBOuPL22KKbIS20Uj3BlV+aC95wl7K/Zo
         ByN5qK6piofRVpMEf3z2bH+rnD3p5c6/7iGEyWCha5VzqvFdnHdtGdqLhm1vChOnrNAt
         IlLkKYxq9zi6/RRYxIG/UWjpFjJI4r8N/IvlKdPchqEwnZX+c39wOd8CZBe1cWO2S3EC
         JWclgDyCynkZPqdEbf57o/GTxPLhfvVl7n8DPy5sLdLM1CCVWUOxIc+u+o0pxgD1gfLE
         dKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192640; x=1769797440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+wIr5X9WIZrYU1MaHy3YriH4HYquJi6PoX16TeqzI1c=;
        b=CR2fgURrWLsT1V5oEUD4OtM77ij8AlOeiaZmApC12hO+AKHVfQpwzb5PH5omw5C1Ye
         6VrH+/MCNHRNJvv4Vg8OFiDen74Lt0Q5z+U1LKuCXXUTZNGtJUxAO4drwGicxJp2BcBf
         j5D5pXheLLrQ/Abdkc89mH5LcKlN30E9kublMWOkwi8yK5RylIwKN1lG+5gAbUvTsNiu
         3uZNOnq9qliFpiuNT5h6GUDh9zyJvXaa0xcf/EWVaW1WH28S54LRzBNTv5nUXX+FQtvb
         Bjk4dvnB/xjsq6iS6l2fHPZXcFTSL2GnOy7hT+Mn5qv7X186VGEdC+Eh8co+SP9nfaZO
         b/NA==
X-Forwarded-Encrypted: i=1; AJvYcCW3AnzJz/XZjVVXCxQ6XHnYXJbFQw0efJ5L/if7kCSGpli5SjtfPDRfSg31QgkSUYiK1QqNcQcgVBs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk+U65STfui/bnUTnE5toMjURrqdqJKiAVaqnaamlUFm90AmpS
	2FevZyXfCftVCidTCfHZnqSxyAxWTecCFvJYMaLhDp5yOcd+/BZG8sWpEO1fcUEZj1b7YxdqBTe
	8hBR3QVm4rTb8hhOtwVZg2utBPVp2Qmc=
X-Gm-Gg: AZuq6aJiLn8LUFMH5jXkLQni0ijekqx3bTUduO9BjtqVd8IUCEhCV170b01qzRdH2I8
	qOVQSNVmUjzkjqN6sXUjpjBPy0ecPx3SK/u5fkbxNfTl0hMHrU6dY43NBAuJvt8N+B5qpUpbOC/
	xp449QNXMkL0XEHrHIXTTDcCyqP4U6AhyILjvh9hmw82vMcpQcSxnR4zq5u48Bgt8OrlpyFBGlV
	ZH/10m+aXCK7A01qNsWXWOveTqzSULnL8uQ+V1VvZrwFtGdm1GL59iXJq9kYfguXVUBgcvIL+B8
	s+mbnyibcdMbIH9QZ1Pu/FXw6gIHEGUdMAZXqOI=
X-Received: by 2002:a17:906:6a15:b0:b87:778b:89ba with SMTP id
 a640c23a62f3a-b885ae2f822mr262423966b.39.1769192639597; Fri, 23 Jan 2026
 10:23:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153740.1677852.8895419964139371863.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153740.1677852.8895419964139371863.stgit@frogsfrogsfrogs>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Sat, 24 Jan 2026 02:23:23 +0800
X-Gm-Features: AZwV_QhvSCiBKwr8rSfXJUUH6fzV-C--pFB8GgtShUXMTLgDumF6WFVBo8FabM8
Message-ID: <CANypQFZ0dhuk869-tbXBQ8-RbPHrPwMvew7NHKePqJT9sAX_yg@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfs: only call xf{array,blob}_destroy if we have a
 valid pointer
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, 
	hch@lst.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B41=E6=9C=8823=E6=
=97=A5=E5=91=A8=E4=BA=94 15:03=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Only call the xfarray and xfblob destructor if we have a valid pointer,
> and be sure to null out that pointer afterwards.  Note that this patch
> fixes a large number of commits, most of which were merged between 6.9
> and 6.10.
>
> Cc: r772577952@gmail.com
> Cc: <stable@vger.kernel.org> # v6.12
> Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/agheader_repair.c |    8 ++++++--
>  fs/xfs/scrub/attr_repair.c     |    6 ++++--
>  fs/xfs/scrub/dir_repair.c      |    8 ++++++--
>  fs/xfs/scrub/dirtree.c         |    8 ++++++--
>  fs/xfs/scrub/nlinks.c          |    3 ++-
>  5 files changed, 24 insertions(+), 9 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repai=
r.c
> index a2f6a7f71d8396..6e3fef36d6614a 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -837,8 +837,12 @@ xrep_agi_buf_cleanup(
>  {
>         struct xrep_agi *ragi =3D buf;
>
> -       xfarray_destroy(ragi->iunlink_prev);
> -       xfarray_destroy(ragi->iunlink_next);
> +       if (ragi->iunlink_prev)
> +               xfarray_destroy(ragi->iunlink_prev);
> +       ragi->iunlink_prev =3D NULL;
> +       if (ragi->iunlink_next)
> +               xfarray_destroy(ragi->iunlink_next);
> +       ragi->iunlink_next =3D NULL;
>         xagino_bitmap_destroy(&ragi->iunlink_bmp);
>  }
>
> diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
> index eded354dec11ee..dd24044c44efd3 100644
> --- a/fs/xfs/scrub/attr_repair.c
> +++ b/fs/xfs/scrub/attr_repair.c
> @@ -1516,8 +1516,10 @@ xrep_xattr_teardown(
>                 xfblob_destroy(rx->pptr_names);
>         if (rx->pptr_recs)
>                 xfarray_destroy(rx->pptr_recs);
> -       xfblob_destroy(rx->xattr_blobs);
> -       xfarray_destroy(rx->xattr_records);
> +       if (rx->xattr_blobs)
> +               xfblob_destroy(rx->xattr_blobs);
> +       if (rx->xattr_records)
> +               xfarray_destroy(rx->xattr_records);
>         mutex_destroy(&rx->lock);
>         kfree(rx);
>  }
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 7a21b688a47158..d5a55eabf68012 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -172,8 +172,12 @@ xrep_dir_teardown(
>         struct xrep_dir         *rd =3D sc->buf;
>
>         xrep_findparent_scan_teardown(&rd->pscan);
> -       xfblob_destroy(rd->dir_names);
> -       xfarray_destroy(rd->dir_entries);
> +       if (rd->dir_names)
> +               xfblob_destroy(rd->dir_names);
> +       rd->dir_names =3D NULL;
> +       if (rd->dir_entries)
> +               xfarray_destroy(rd->dir_entries);
> +       rd->dir_names =3D NULL;
>  }
>
>  /* Set up for a directory repair. */
> diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
> index f9c85b8b194fa4..3e0bbe75c44cff 100644
> --- a/fs/xfs/scrub/dirtree.c
> +++ b/fs/xfs/scrub/dirtree.c
> @@ -81,8 +81,12 @@ xchk_dirtree_buf_cleanup(
>                 kfree(path);
>         }
>
> -       xfblob_destroy(dl->path_names);
> -       xfarray_destroy(dl->path_steps);
> +       if (dl->path_names)
> +               xfblob_destroy(dl->path_names);
> +       dl->path_names =3D NULL;
> +       if (dl->path_steps)
> +               xfarray_destroy(dl->path_steps);
> +       dl->path_steps =3D NULL;
>         mutex_destroy(&dl->lock);
>  }
>
> diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
> index 2ba686e4de8bc5..dec3b9b47453ea 100644
> --- a/fs/xfs/scrub/nlinks.c
> +++ b/fs/xfs/scrub/nlinks.c
> @@ -971,7 +971,8 @@ xchk_nlinks_teardown_scan(
>
>         xfs_dir_hook_del(xnc->sc->mp, &xnc->dhook);
>
> -       xfarray_destroy(xnc->nlinks);
> +       if (xnc->nlinks)
> +               xfarray_destroy(xnc->nlinks);
>         xnc->nlinks =3D NULL;
>
>         xchk_iscan_teardown(&xnc->collect_iscan);
>

After applying patches and running the reproducer for ~10 minutes, no
issues were triggered.

Tested-by: Jiaming Zhang <r772577952@gmail.com>
