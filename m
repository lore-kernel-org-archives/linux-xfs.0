Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795781098;
	b=T1YjQ31m0q0qzgANip7UaO3jhRcJ48pzY/7ChHYEGDqwzBowlTBpBskdPB5qEOGgpdNg
	 k+iNems2ArcQlfrGi15jDWkYsDIcIfGfsE1bhcsAcr/gccVgro24b6j77qXQNPbu25PYU
	 OsXhSbDX5SbFW91gj6yupwg2qnvGcl+0A+HbmnErNJwC4qgaZcc+dzruZaSsgzRcnKF+T
	 UJ3IyM+dQcxz52kp40F1tKtr/mhNqpW+mAqyOc9ILIPgHZ+/nnIIzH3izWGKKsMH84/BU
	 KNxS+1G012hewwmJZiYIlh6ocliUx1P7PTpKGk/ZekasZC/9z3bXeMC4/8hNApvQbXg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
	b=BEN6EbAHji1pfBSkdbcy5joTaigqN6yL22GcQ/NaGkd0fdc5w6Di3fyOCS4CbX+8/eeH
	 SBlJnHggDagKQE+w1rz2yqc2cgzMyLPAnsRLCcArVJhhs8fAioV3DOr2XyHD26XSPG6yH
	 6MiVC+EI4Sxk4/BIZPCeCZoDyP/EJXQIzgCfXrECjJcoPEUnz6mIQ6fQLqD67ydapm2Eu
	 sKpqvmVLBLosJ0jVJ9BrHNPkZEnd9ggBLjL69GOQc+SLZDuDEBe65yRn6v914f83i86HU
	 tHDwDCai/VWVfPVefYul9WDgpymuGF1rkNVmRnw15QTcAPhOyqNR6HbmF4tYtnXJ5Sw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="a/faIOem";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19941606A32A
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 12:04:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19941606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a/faIOem
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b8c60e0d39so10282060a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 04:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795781096; cv=none;
        d=google.com; s=arc-20260327;
        b=EEUcGlYOwD5ldEyr0cRMb3hhsWqA2mEEo2zy7OOpM4ydmLt/z/Mn2R1axJ9HMGUec6
         1trnw68sohA14YwJyJ+rDVw98qyIf8hm2UNDd6yUK2IBCNeUv+6qO5bbuaobcQgs+lAm
         AfqOmWkl3v9NPE8vZKOYqXLxAaH0uA8knrHfLl+FphAIRoUxBZ1lx57hoyParuxlVZhk
         sU31UwFwpb8BAYYyVg81MaVudfpuiR5NI+/sW8HPdnV2Wu9Tqw8QvVJpYNHp2uOYgR35
         5ictTtvRptDdc9yg0hmOHg/aRkvMEifvwiEG7L+4OsuZIjvmEZlSR5SfmyhE02SeRkfQ
         g1Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        fh=NpZGhCSQ5KP1Mg2ndfDwHCoIpk1kPYlaYWW5dAY6U0k=;
        b=bpZUHr/4MxdfvE/yRB39r050ktSbWyg+O5Nh1dA/jO7eRoglmySJXjJLOJJ2tz8+tC
         1sSz0aJMJskwFeuubiqeqBQVGkPsIozXQglxhjNLcW9T6BGcYDsVrMo5LiIeb2OohXor
         LFtWYpF7UwDXHGeIdqje+zQEZKJOlrgYVwJJT5aryAfrKliuqUDWT++jD2WXLg4zQbKG
         cnsWVXp0xX7eDFHZ0aaiN8UF5jUgB5oPVs+UOsbQWaU4WDGhIIHCMWLqA5664wxWC+ut
         NGoZkyWp+B/X1OlpW/6aZcMMn4aIabqNQFI74j/ygXHuUncysg/TcvptN6ar1f5oCGAw
         cHgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795781096; x=1796385896; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        b=a/faIOemKG9XP9oN9nHZ0RXKAJGUuULcrj5tlG5oW/VxoETGk/czdvSllhhNf3cLZ9
         QZfgoKUPAO+lxAeT39SzbkiTrobrvkwTRilpOiRfynBTw3Dq4mQQOsaPpO2q3L/eNCw6
         75tG8Way+N5Y7kNdc374kxwLxPpgXrf4M3aS8Tkoc7ZPyjzg6Rzr+n+Pscq1n8ZXh53X
         8gOnoWD+dlS10yDPmY1W05uiGKpWUmd1Zb6pGB8AYpx6o/RFlMqxj59WZhRkFmmQMlzf
         d6R5FFbL3Np6vQDGcBL5tFUkX4TUGEgF/3bqMPd6LQvhH05HX1jyMVN8C3RNkqypH2BI
         RiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795781096; x=1796385896;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        b=vli1re3Uhd3PLm3bfRM6Xt8Jr8qzfoABCUfB2G+plfFExujVHoafuC4oIRYFHvktsF
         6gcgaDyZT64j2zhYU3NI6ysMmjx0seUVd8h4NPwnd896KXUS1vu3ZvQAkw66igT9GxMJ
         dZRhQgiUhx49NiIcV7a/zyznc5fXTO9ZFlx9bJ6RJIempsZrSnlAljwgd56rCLkjEAMH
         5HbmcxtSkvOyk7N/JwSN1xO5y2xDkev5GIpD+0s1vSUGK6TLr4XhkBTigoNdAnChJYUI
         SxZxxzpFmgu544HCucyC3lkJ0Sriif2QDalWfO6wZh4tDCLUf/57IjPHwBYvmflcxaSt
         Qm8Q==
X-Forwarded-Encrypted: i=1; AL+hErERvil3WyNSR5cccyNfELL9LhTOvbgSJQZYDtV2cSO02hxH6XtgjP7/K2DGqoSDaHsvoM1hruHPz3o=@vger.kernel.org
X-Gm-Message-State: APuU4Z9iX3RO4Bb0lw9lNFWsedNLu+nxnezhScal6V4pslBRb00xndID
	X4pF/XTfgXC01nFA+YH3OhQUgYJplpP60auj2fMlPzEEc5+WeWfeMVs6QFO+KvAH1njYZHNFp3B
	ZC2ddHxx4XWkF9c7jq3gz+E+dFee3Mlw=
X-Gm-Gg: AZFdTZeMRiaodATKIESJdI0p2BWnigr0RYd9M5qUz1YrQyoxC2Sa21GPaA2Xi7iK79K
	BHLohMAO8iNyo1J/H5yXUxbpzo60NEWx+zBtyhaG74Iu5zMCSg/ssLGw/ukDb5YcGVLnUAbLR9x
	9Smd8h1wGNXaTJxd+tSv8jxJqY0MAGs9xAzWnkwKkRGtCHjGpVKmv+WZ6d8E6TcaezfSvtQgpz0
	0f1XO6KHSzkf3ytKPTOOzsvcbf/wnqxWzGn8QsZchENx3Zx6LNDxFjPWss+r7MdNxeUXTpQcGpR
	iX5vg6/tNy297JH5SciGeNjprV8QNvRFIE6HE/gxPEHOPZgHPFnAo51A7PltXTUPzzU7WewOFSx
	MCAsse8gB/eoM7m/lHOH7Z89gco/2OGDGijGeSPM6mbNoFzazQhTg508=
X-Received: by 2002:a05:6402:320f:b0:6b4:59d0:7294 with SMTP id
 4fb4d7f45d1cf-6ba37e9ec85mr20367582a12.31.1795781096175; Fri, 27 Nov 2026
 04:04:56 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-5-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-5-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 13:04:44 +0100
X-Gm-Features: Aa3M54qEfB_iTiJNZjGRc3XRinkgqc1ntuigIkhA7BS94_VSwwZ4uoMmp26Q3TQ
Message-ID: <CAOQ4uxgJjy3TaORBkMOdef-JvzX2uA5K2sbMDEcLqmpkedsESw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Alexander Aring <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> modern xflags (FS_XFLAG_*) fileattr API with masks.
>

This is where the commit ends doing what its subject is saying.

> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT to be used in this API
> upgrade.
>
> Following the FS_XFLAG_VERITY example, put FS_XFLAG_ENCRYPT in
> FS_XFLAG_RDONLY_MASK and in FS_XFLAG_COMMON, since it's read-only for
> all filesystems.
>
> Following the FS_XFLAG_CASEFOLD example, put FS_XFLAG_COMPR in
> FS_XFLAG_RDONLY_MASK but not in FS_XFLAG_COMMON, since it's read-write
> for some filesystems and read-only for others, to avoid breaking
> existing filesystems.
>
> Also update vfs fileattr_fill_* helpers to include these two flags as
> well.

All of those non trivial bits deserve a patch of their own.

Not only are they independent vfs changes, but they also have
implications outside
of ntfs which need to be spelled out.

With current patches, I think this change now advertizes COMPR|ENCRYPT
in fxs_xflags for all filesystems that have them set even with the old VER0=
 API.
That may be ok, but it needs to be spelled out.

Do we also allow to set COMPR via VER0 API? Do we want to?
These are questions to be asked on a standalone patch.

Thanks,
Amir.
