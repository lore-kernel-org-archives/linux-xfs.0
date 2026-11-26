Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795733916;
	b=ZgRASXJiwc+ENtq6B0F8NU8IXnJ46oWv+msRe+NB/RvKj6DgPdkY7Qc5prYoNrLK4gT+
	 YG1DY+4IeeKZRmOCOo6mVLzSIZNOxrUZP5K9uHBGlE4CkC25D0TMHspLtyG0co5l1Gmmt
	 OlYCPGyGr4pfUMMyRZh3PTwtwDKAlA3C4ggAvZmx/MA4F2a3qvlhJRgUU67jfFnFoIZLN
	 Gga9InWThLFJdhLWeGQmzoc2U/uXibDClUs8URr3QKg6GI+k9Sw51mNpoyoHMebRIDPE/
	 JGNllE7E2vUn79njHpUrdJxom+AE0paKpEuwazNYWfDskBxAfEGu+isWS8AnFSXB0PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795733916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
	b=cDuXzhMyKVlroFCM2Ge2vZOb84boETX/bY/ZdYXHWVvag9XKWAniNAoIUezVt0NrE28B
	 RNbHPZlUwE9xdq3LWfOBpXEBtCcz7C9JSh8q6NiSSqz+eU2MwEe36S2LnQqotueRi0Yq0
	 744VSQyJudYdA4ddGt5Hvz0VaETRMaJYyeqmFWEnqcI/BJ6pIMBNueau5NQ4NdlSlX1zR
	 cUcuFKJRAwltZYQWbLY0t6qWRHRR4CYbsCBzrqKdO0+IdcWMvVeUsqTj+EWzSsMvB74Kq
	 BRdWTUHB4xPj56oX/v35GGCJ7xVV4WrGJxiy+RYEAdvuXGSxjVf56A+KfPGCT2hDQUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Slgjv2rC;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271B9606A323
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 22:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 271B9606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Slgjv2rC
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so70808595e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 14:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795733913; x=1796338713; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
        b=Slgjv2rCfiamg+O9GJlFWAOQ9tg1YUbYxrZ9VVQK1e3h5ZRy4TxckJc3EvLoHkPBcp
         6JFfOqwouWJHw9vFwDGw5BKLK/q4FoMI7a/1JQPvJVVt92csAcY0NU1qXo/KRh5S9t3I
         8s5YGzWbAkRGZqQ5yBUMWlQmj1gSwN/6uNKcvQbVoSKqbpgTXmaqjewhAp0RZtZkwIVp
         N07Kpy7P09kbXO7OWl47yKEzBcSb0PEkzk3p0gJ90757PLddYD3e7pKI2zllVzgTjXak
         Rs+BXgOS+tT2mG06wnEKBDGNAQQXcRnPnBLeg0r8YS8lC083UKyytdUQ5+LaBSlDVwfq
         fo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795733913; x=1796338713;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
        b=w63wSGMsgYJkzyZgqdwXcq9U/u3KecToNIQUqZphBvM3QnX7HCkBl6IgbjTRjQN79P
         TwiMt2J1whc/H01P7DGZSxVmqKOVoGV7WEo/DWXgMrIaS+clk6Whgj7rY9WMql7/p+Z7
         8SW0uBthRDGN9lIYZr5arn/0Tl1E4wqnh6E8kQjgzUi0dPDCRVl+txTmIR511RYwtFGC
         E5DXLu+ReTgGoOK0935KA2yzrkN5oO722jJ2+voqI1w/XLMu7bfJqYMfmKiYQKntc2Ha
         Um+KVpL4XHiElWsQJdedAV6JT4W7Mg9PM0/l57zJCGk2q8ZqeIpoQtCFSNgFvRbnOi7C
         ZSPQ==
X-Forwarded-Encrypted: i=1; AL+hErHk7lmNMCLBH5c4nFIYj/RglvMrhEAJiCLECOrPBWctO81p3pooqvttgc7uBNCdxHyzJ8UzfI0BbT4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9nc7JBBYqFGf3anI+bevtG1n0Fc24RV0Oj22ZG0YWoSYaFP2Vh
	0c8qx9+OSZPAWB9q3ihZd9rJ4sQD/gZTkhHZBGZ506BGqH/QMzAuhM56
X-Gm-Gg: AZFdTZc7bOV8WbDjwrr9+nVANwdKIXgXS8LuUwcNrPagdkO1ibhDxyCTjn7YEBCYteb
	Sz3b86cBT+vCyv89uJis2n0JguDumRNOnMQ5MVxGhvVviH4lZk7rYVrfrXpcsF8iv1dwshWlMSa
	o3lQpAXBve0CGuWPy8YOCTUmRpPB+HOQjeKmLp2Dgeqn1niPF5/eyqrvb8fB4U4o9ODssZqCZxn
	8XwH91RNRc6L3J9Hijr2jaGZ0zAkfwevEl5jD8F8nXhXmQrav7TOFyBg2Do32HNtai5nbeGO7V8
	qAmsGavW6Fj95d1aPMQmflVh/EjRJyLudjBamjGT/IUvzImnCjAvn9yUnZZy3RGmmX9qDYCgbQA
	V4sD6BC9XfexynKZdC51TLkqOi7xQD8oJ2tzIteQ8nqUYDQ/o9MLaZwmcsrgH9x/1H3MaovvWu/
	wpmq4oRjQDTqi9weBaTvF9r/R2O7jsuBobjnFyRxb3XmAB0PNrKwfWu9Gg8Xw32LghtsqWkQ0Db
	Z4Zk9k47wGFNiElo3mm3PS9/R5RAJDcukbDxgRxHRu05vZYQvL7HhfXcuTiuIMypF7STIrbvf1O
	ZimMl/zCYwgRMWbz9TTpBnVy+Q==
X-Received: by 2002:a05:600c:4e87:b0:4a7:6bc7:f778 with SMTP id 5b1f17b1804b1-4bb88938d38mr467930345e9.30.1795733913027;
        Thu, 26 Nov 2026 14:58:33 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110c3csm41489064f8f.36.2026.11.26.14.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 14:58:31 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 26 Nov 2026 23:58:25 +0100
Message-Id: <DN5IJJMT5L0L.QV32G91MJ6D7@gmail.com>
Subject: Re: [PATCH v2 0/4] Add f*_xflags_{rw,ro}_mask flags to the fileattr
 API
From: "koraynilay" <koray.fra@gmail.com>
To: "koraynilay" <koray.fra@gmail.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>, "Eric Biggers"
 <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, "Jaegeuk Kim"
 <jaegeuk@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J
 . Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, "Lauri Gates" <lauri.gates@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, "Dave Chinner" <dgc@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <ntfs@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>

--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 26, 2026 at 5:31 PM CET, koraynilay wrote:
> This is a follow up patch series stemmed from [1] and [2], splitting the
> _mask change for the fileattr API into its own separate patch.
>
> The first patch is a preparatory cleanup so that the code in the later
> patches can be formatted better.
>
> The second patch updates fscrypt_prepare_setflags() to take FS_XFLAG_*
> xflags instead of legacy FS_*_FL flags.
>
> The third patch is the actual implementation, which introduces:
> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_ka=
ttr
> - AT_FILE_ATTR_MASKS at_flag for file_[gs]etattr()
>
> These masks have the following semantics:
> - rw_mask:
>   * for filesystems: advertise which xflags they support changing
>   * for userspace: specify which xflags it wants to modify
> - ro_mask:
>   * for filesystems: advertise which xflags they support only reading
>   * for userspace: ignored

...and I forgot to include the improved explanation.

I'll write it and send it tomorrow (hopefully).

> This allows userspace to not have to do a RMW cycle when using the
> file_[gs]etattr() syscalls, avoiding possible race conditions and
> simplifying their usage.
>
> Patch 3/4 also introduces the missing FS_XFLAG_PROJID flag so that
> programs like chattr can leverage the new mask API.
> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAGS_MASK and so it's
> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
> will be used moving forward for any new xflag (like the one proposed in [=
2]).
>
> Patch 4/4 converts fs/ntfs to this new API, to show how it can benefit
> filesystem drivers too, and for this purpose adds FS_XFLAG_COMPR and
> FS_XFLAG_ENCRYPT from their FS_COMPR_FL and FS_ENCRYPT_FL counterparts.
>
> The series has been tested with custom xfstests [3] (generic/816-835,
> xfs/611, xfs/673) across NTFS, ext4 (project quotas), XFS (project
> quotas and extent size hints), Btrfs, and F2FS.
> Note: these tests were written by gemini and not manually checked,
> before sending them upstream (if needed) I'll have to review/rewrite
> them manually.
>
> Note 2: there are apparently quite a few bugs with overlayfs and a few
> other issues, but I wanted to get the final API design out first.
>
> v2 changes:
> - make fa_xflags_{rw,ro}_mask in struct file_attr __u64;
> - add AT_FILE_ATTR_MASKS to opt in to mask semantics instead of needing
>   unreliable heuristics on usize and mask values;
> - reject intermediate sizes between VER0 and VER1;
> - reject non-zero masks on SET without AT_FILE_ATTR_MASKS;
> - add patch 2/4 for fscrypt_prepare_setflags;
> - add xflags_to_flags() / flags_to_xflags() and
>   fileattr_set_{legacy_to_mask,mask_to_legacy}() to translate between
>   legacy RMW callers/filesystems and _mask callers/filesystems;
> - clamp fa->fsx_xflags to rw_user_mask in file_attr_to_fileattr();
> - update fileattr_set_prepare() to validate capabilities and projid
>   changes against rw_user_mask / xflags;
> - move the rw_mask =3D=3D 0 early-return no-op from file_setattr() into
>   vfs_fileattr_set();
> - put FS_XFLAG_COMPR in FS_XFLAG_RDONLY_MASK only (keep FS_XFLAG_ENCRYPT
>   in both FS_XFLAG_COMMON and FS_XFLAG_RDONLY_MASK);
> - update ntfs_fileattr_set() to apply only bits selected in
>   fsx_xflags_rw_mask;
>
> Thanks,
> koraynilay
>
> [1]: https://lore.kernel.org/CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFs=
bcGp1ew@mail.gmail.com/
> [2]: https://lore.kernel.org/CAOQ4uxjVQ9cjV=3D_jBjQtNg9zCuWUEJT9KNYMKV+1j=
wBkHen5OA@mail.gmail.com/
> [3]: https://github.com/koraynilay/xfstests/tree/patches-in-queue
>
> koraynilay (4):
>   vfs: use goto out on error in vfs_fileattr_set()
>   fscrypt: update fscrypt_prepare_setflags() to use xflags
>   vfs: add xflags mask to fileattr API
>   ntfs: switch to the new xflags fileattr API
>
>  fs/crypto/hooks.c          |  10 +-
>  fs/file_attr.c             | 357 +++++++++++++++++++++++++++++++++----
>  fs/ntfs/file.c             | 109 +++++------
>  include/linux/fileattr.h   |  14 +-
>  include/linux/fscrypt.h    |   6 +-
>  include/uapi/linux/fcntl.h |   6 +
>  include/uapi/linux/fs.h    |   9 +-
>  7 files changed, 409 insertions(+), 102 deletions(-)
>
>
> base-commit: 3857587d9d6fa44d40d1c73bde6a39f6f7a5216c



--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawi5kQAKCRDmj22qf5IG
XG6WAPwJQXkvnYM2T6CI+OL3CbCXJcdyvNtTqqpqmtzkWtEBdQD8CWhtnTm8Mn20
vvyMXHnKEDWD/QMw27jw1T31axApsQ0=
=Trt/
-----END PGP SIGNATURE-----

--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b--
