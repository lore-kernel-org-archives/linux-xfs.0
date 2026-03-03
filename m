Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D51D27E1C5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 07:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523354; cv=pass; b=LZEzb/BBsuxP9QAsvRKdBQlTtTa4bmBrfkp8NcJ07DcsV0jsrXrBAPcC0qJYtQNRsYTtZyT8PVpVV+MZ5nxI1ipef+IW1UsoqwDfD14M7+3Lakx27Ol24kpOh3xAZgVMzNa1ooshEv3A50/se3z+C8xQ2HxDoQ+sc6llEK+pZS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523354; c=relaxed/simple;
	bh=zgZmrqF57sIWcIa034uvjAlzCMcTAuz+eMRN4h89fic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nZ2AtIV+Z07vcSgGhA5nvI14GYEw6TlwWrsiZGEDl3Ml5NmjV289BAxsXnG7PF74OX+HaeUWGzmPLjcJ+E3CJiBULtZ9XvH8H9MERGdHQpxnaPNxkNgMrFU7rvY4MmHLnnUE9lnPmlp8rGBHjUdexBVCSRgEGSuzrGIfYIBCA08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=osbx7sA+; arc=pass smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="osbx7sA+"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-94de6081c1cso3405450241.1
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2026 23:35:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772523351; cv=none;
        d=google.com; s=arc-20240605;
        b=UkZ7zg+Fde0wnLh5WeZHSi/qgYLPQaodit+FUUbV3dpmLTY+AIS9tXfgfRPOH/zcnD
         uXwjrcK6fMXooLfIJvslJjC8gCCC2/aKpR2F4UTE4rfjAXUdWHy+Cn/7FOAuI7b2LVxb
         RJNohmYYK1PY3DazMs2skdJGn0iNG4qPFL+YkHLxQuT3zNxRNjxVQP2EA34YNINV6B7z
         X+uvyx1KdB3jULrtW9NnHgyC7ZIaDQU2fAU1o9E6+L69WT07Pbif0sLEwkN8uuFx4rdu
         f62wZu3TaqaD7x3TsKflew48hhtenENy9zhpxr5J13xTozB0kGmSf7mKSCqQL6i1vzbh
         fa2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lt2O1U4QyboglAO2yLzVlOi3dxrdTjnMuLUtlpidD1o=;
        fh=eSR46TvxAUUbNT60uQWkdSCrTQ3y3MyFXyhUT0RZAyY=;
        b=VBwckoUBKIfpipPkAjEMcRbqMzMLPTjSgm0UExX4usaiOS6/MnNU02hJHpI2gteQV0
         71vwZF2Z8kf6I4Fs842/8lI3KGACPlsf1ZJue9SwimXYn5a3CiCU4/gh8zFWhzkG5ZZu
         jTONKvENMf4QQjEJ1NMyocGn+Eu4f7laIviVgpNAXyaOPXXZUd4z0K2deDbkxhvoFSSB
         bjzF8sVisLVmHhs5HV3fEpENbOPiXgY7xliL2mZClkC7SRMBp41aC1ezSid3oedreJdG
         6cVcBHpdidzHM2crsR8b+kz3JvxFGwEpg6MBFqdNhRrFueTpQ1P6zwprC8sOUKmgcmPT
         oicw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772523351; x=1773128151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lt2O1U4QyboglAO2yLzVlOi3dxrdTjnMuLUtlpidD1o=;
        b=osbx7sA+OAX1eedWGxTbDbRqFmu6WYeGBSrThet5HgpB/ACJ4wCe2EMggoy+dey75g
         5EzISouZuDD0Jl4RvknfjqandYCHJ/scGcR9RjhEQwzLKsjL8SOCOG78SPLFyJyLOJqf
         9ZNyvV7WOKIL6K1dst6O9q22pag2aZd2JMUKWDALNHQUqFS+jMrKbur6pz0nTB1e3+4O
         /1SsdCHIGRsfuMwUwgnIimPw5czKl/ZixOSh5kWWxB7KvbqPJV2mbxULUpiFuVAN3Wav
         f3BVYtlSvMIW5qKM8hvReDntlBbiWgEOh6UZGEuSwtSV3W6r5XYs7Zueh/wDDSJbYDxb
         jcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772523351; x=1773128151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lt2O1U4QyboglAO2yLzVlOi3dxrdTjnMuLUtlpidD1o=;
        b=KFNIbNYs8iFu7q1OkBBhGduIUdg6fmbCcBxD0aiHqfSon+/63z4+5IC8mWE331Yj2f
         MlWvC70qLeDZ+pnzC88C72YcM8wgnrf2rgPLnvHUn5jlxUrbrlWIpdU64v2CuTHhf1Z8
         MNuRM+PJ3HYh73qDYR/v45eylXmlUCHjjJm4WcF9WEDXckSSZWNsEiR9HKIkeDylkyTs
         1sO+ILcNyqf5hfolas3qZB2A/sseZ1Xibc6bD8btdIbGnKJlCutodDMODQcE27AcdV/r
         R548HxwruFn8GhTURaqyEqizVuBu/6LrHts4G9mHgAp7AI68Fvun6IZJscrN2qzhw1sp
         DfJQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6Wcoknk9jnf3mtc1p58yEHfJamXF/gSkfseJ1WvL7p8luzGH72Rz388ChXFjtmY3ffXqt2pF7KUA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo4bLK2O0/Xf0kP7/1zbfItt8kBgqTBA8IhKRqhRDGO+kX3Fhn
	AEtsiH/zKOPBEk12xBbLHwaecopbyXFHFYa61nspSqMH6N2/TKDtZQbWElFjeFwltNgLzJCt8n6
	QueoPokIq+I0OYTj86mCUNo9XWxX17Orc3FASwe8=
X-Gm-Gg: ATEYQzz3HIwCM7mPN6GCC/FwAKa6/Ku8/9CErX9Vg+WuQgVQq9gq9m4GK2Eb9ab2lDc
	iqMAyMaEwEMus8UmkwukfRYv17m6EM8NyC1lEsnFOCUo7/PboFFJ7AUBJDhhj0OQo9l+htTrTxt
	icH5ZIExpPzhFKUz+xH1OaKpenLjV2jrfj4nxmH4pwSXi38asBh5vxL0r3PF6ADbjhim6nbGSxR
	octz/L2c2OGhSB+lOqKGHiU6i509bbLV3LuvW8YC1Cl0QcQ7RQ98Ho3xPEqvpFOlukTuIMIJSRq
	Z5T0NCUrKTv/J2H5G18RCzP8z8vzbtEiKP772xIzuTx5e5ezWq5BA6/eQ3Y=
X-Received: by 2002:a05:6102:3747:b0:5fd:efb0:8562 with SMTP id
 ada2fe7eead31-5ff325a3a36mr6781527137.39.1772523351040; Mon, 02 Mar 2026
 23:35:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303015646.2796170-1-morbo@google.com> <20260303051419.GD57948@frogsfrogsfrogs>
In-Reply-To: <20260303051419.GD57948@frogsfrogsfrogs>
From: Bill Wendling <morbo@google.com>
Date: Mon, 2 Mar 2026 23:35:35 -0800
X-Gm-Features: AaiRm536S064yiNI-5nK8lVd51En-2-5MBZyMPoDT6E1lWDqWbEr-lDnIgSWVgU
Message-ID: <CAGG=3QXpNVzmG7W-NxbvviVbTM2CDXO4BNj56_pv+1PjY0nKBA@mail.gmail.com>
Subject: Re: [PATCH] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-kernel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	Gogul Balakrishnan <bgogul@google.com>, Arman Hasanzadeh <armanihm@google.com>, Kees Cook <kees@kernel.org>, 
	linux-xfs@vger.kernel.org, codemender-patching+linux@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 2, 2026 at 9:14=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Tue, Mar 03, 2026 at 01:56:35AM +0000, Bill Wendling wrote:
> > Add the `__counted_by_ptr` attribute to the `buffer` field of `struct
> > xfs_attr_list_context`. This field is used to point to a buffer of
> > size `bufsize`.
> >
> > The `buffer` field is assigned in:
> > 1. `xfs_ioc_attr_list` in `fs/xfs/xfs_handle.c`
> > 2. `xfs_xattr_list` in `fs/xfs/xfs_xattr.c`
> > 3. `xfs_getparents` in `fs/xfs/xfs_handle.c` (implicitly initialized to=
 NULL)
> >
> > In `xfs_ioc_attr_list`, `buffer` was assigned before `bufsize`. Reorder
> > them to ensure `bufsize` is set before `buffer` is assigned, although
> > no access happens between them.
> >
> > In `xfs_xattr_list`, `buffer` was assigned before `bufsize`. Reorder
> > them to ensure `bufsize` is set before `buffer` is assigned.
> >
> > In `xfs_getparents`, `buffer` is NULL (from zero initialization) and
> > remains NULL. `bufsize` is set to a non-zero value, but since `buffer`
> > is NULL, no access occurs.
> >
> > In all cases, the pointer `buffer` is not accessed before `bufsize` is
> > set.
> >
> > This patch was generated by CodeMender and reviewed by Bill Wendling.
> > Tested by running xfstests.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> > Cc: Carlos Maiolino <cem@kernel.org>
> > Cc: "Darrick J. Wong" <djwong@kernel.org>
> > Cc: Gogul Balakrishnan <bgogul@google.com>
> > Cc: Arman Hasanzadeh <armanihm@google.com>
> > Cc: Kees Cook <kees@kernel.org>
> > Cc: linux-xfs@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: codemender-patching+linux@google.com
> > ---
> >  fs/xfs/libxfs/xfs_attr.h | 2 +-
> >  fs/xfs/xfs_handle.c      | 2 +-
> >  fs/xfs/xfs_xattr.c       | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index 8244305949de..4cd161905288 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -55,7 +55,7 @@ struct xfs_attr_list_context {
> >       struct xfs_trans        *tp;
> >       struct xfs_inode        *dp;            /* inode */
> >       struct xfs_attrlist_cursor_kern cursor; /* position in list */
> > -     void                    *buffer;        /* output buffer */
> > +     void                    *buffer __counted_by_ptr(bufsize);      /=
* output buffer */
>
> Looks reasonable, but ... how hard will it be to port __counted_by_ptr
> to userspace?  Files in fs/xfs/libxfs/ get ported to userspace xfs.  I
> see that it maps to an __attribute__.  Does that get us any new gcc
> typechecking magic?
>
I'm not familiar with how the files are ported to user space. There
are #defines in include/uapi/linux/stddef.h that turn this attribute
(and other similarly named attributes) off. Please let me know if
that's not sufficient, as it will most likely apply to other APIs.

As for new typechecking magic, Clang and GCC check to ensure that the
"counter" has an integral type. Otherwise, nothing earth shattering.
:-)

-bw

> --D
>
> >
> >       /*
> >        * Abort attribute list iteration if non-zero.  Can be used to pa=
ss
> > diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
> > index d1291ca15239..2b8617ae7ec2 100644
> > --- a/fs/xfs/xfs_handle.c
> > +++ b/fs/xfs/xfs_handle.c
> > @@ -443,8 +443,8 @@ xfs_ioc_attr_list(
> >       context.dp =3D dp;
> >       context.resynch =3D 1;
> >       context.attr_filter =3D xfs_attr_filter(flags);
> > -     context.buffer =3D buffer;
> >       context.bufsize =3D round_down(bufsize, sizeof(uint32_t));
> > +     context.buffer =3D buffer;
> >       context.firstu =3D context.bufsize;
> >       context.put_listent =3D xfs_ioc_attr_put_listent;
> >
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index a735f16d9cd8..544213067d59 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -332,8 +332,8 @@ xfs_vn_listxattr(
> >       memset(&context, 0, sizeof(context));
> >       context.dp =3D XFS_I(inode);
> >       context.resynch =3D 1;
> > -     context.buffer =3D size ? data : NULL;
> >       context.bufsize =3D size;
> > +     context.buffer =3D size ? data : NULL;
> >       context.firstu =3D context.bufsize;
> >       context.put_listent =3D xfs_xattr_put_listent;
> >
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
> >
