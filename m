Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A422701DC;
	Mon,  7 Jul 2025 14:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751898742; cv=none; b=inF3MUsg0L2MkWVrLCI24uf8/BpHJCxwvBnVsp7aAy8xbaYOWDMoxTh7hL9qg6SHWZVrXvdAWz8ZrNXjOyveMDXiTH9Q4qrSNZiw9Ar3vsRl77iYtkpDEQ0BTgjErHvNNDU0v3VUrK630b12qZxgtMl7sxfCxJtXl8SMqF07wOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751898742; c=relaxed/simple;
	bh=nhc83eAPy8ZVz/rx/WT9VLQ+rUQ71HcQIgBfRRZQAgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLegfSwXqk91UiOa2gPcytfpQVP+8SuZ8RD7vwg9DZzaOzexqK5AjbcExydXPFrFmg/TWKjjAQn76Pda/sFkkrAdAyMUn4SCmqm+mPiC8+LWWhE21m3Hj4BkLwgo36+wnpWd9ATsqCDUfc2ZXJol7tBej0O+unCDCkBbSQa39ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4sKF85p; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4sKF85p"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32b5226e6beso29072671fa.2;
        Mon, 07 Jul 2025 07:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751898739; x=1752503539; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/FMSBqJeKFryaW0a1HucMaUdkq/Nt2BLzJLFvyV1UM=;
        b=B4sKF85pbVUSOvrxAA3mNPU7HF5kg+y4m9dstDwEupLjre9o146xTOK5rm7+uYMp/o
         682ddnOLjyec23br9CUQJ0GH/qIoXgX7uIKrhwjll+h3p55WkCQ6gFFPrMvMmJpEyCv+
         NgS0NNcIkvzUmR625n44NLCGFBaSAEPeuXarKRZ6cFRQ/0JiRQA1jA05nNWKBKQrdh9Z
         IpOWoMAQ/QYk3YVWmbHL8F7uFDKG7mAwOsYen7QeqMa6PUCmzFRtDU9MfDVvxG7pe230
         7oYUcNvUbQdu3vGysFhG7u+igaPDIysNi2RrcDW0DuQgbxWaqPG+7F976RyBpDk/og9E
         rYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751898739; x=1752503539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/FMSBqJeKFryaW0a1HucMaUdkq/Nt2BLzJLFvyV1UM=;
        b=u2FSf2oqCvDcIQT+AMgrH0LR8n/jZp1gJWuJj/1zTqghNGuCtp1HKqTdf3NKnONVyJ
         WLsQDjeqcDXeB6mGgHiHoD28VTUDQ+cbxwwWYiIY6GIJmojo2yI5AMZZ/Nai8+EV1JsR
         ARljb9z+wL4PvQFTSakTGafkru3BQNnXsHf+TAjqNMWVj8Hm8dnYlmHd2w0h8/TCJZXM
         tFaYVSETWzwsoTTnABGc70tsYsiGeq2UYqUejh5ZjmwdQGhjEaAc2XxlwhpQJ5waCOk0
         /cfXgEFTSdmBjfEbI3EEm3XTRQ88ANGY0y9pfFIeK1SpyT1rCjNEGEKorU2to0LxSJCK
         9Hug==
X-Forwarded-Encrypted: i=1; AJvYcCWMAVUpln4CvNKw0m+9+8ayRc5hJlASkOpq53Eu8rc/SzIYyyzB5BnwVmhaWm/QgeXcLLWYhr1i7ZcTmI8=@vger.kernel.org, AJvYcCX5XgnLD3VwPkaAW+tFexJOnpVDENPUC1lj0JKmAYfaOc+8Ez6CqXMamgWO0QBMDwtj+FuMmXRSzgHl@vger.kernel.org
X-Gm-Message-State: AOJu0YytYvkWKOb4Hjn5spGJt9284i6p9qofq9Gath/yXa/tHYgVRspb
	iRZlWGElW+IXreDWBSRMtPHU+u4RScDyYAF3REXLP7MS50TrRXI87VunYU9pvBhx5YQOMY5fIQP
	bY2AR5AAK4YDQhnupaxYlbNUF+LnkLi51FPoFlT0=
X-Gm-Gg: ASbGncvQb/tpyPd0kgn5TyQidKUyHjRKPCWtxIatZtDJPgOoMkMKiTLptJGROoNDFUH
	X6cFSMVzV2jmE55XydIIzxSFFe9gcv/zyW8vGlNyk6cN32YdmtrA9CjVV9YBK94ImMTCYqCtv3l
	riO+iEUk/kSHjDQ/gNAkVeeq71tuFXnWgUVKM8Acy1eeDrTwwwo+ZTso7rnQmfYs/0Z/XqRom0O
	Bwu
X-Google-Smtp-Source: AGHT+IFULVURJBOVYtWcIZw+X3lh3wL59Axl2kzkDpO3LIcnEioQra3fSYTDbUsjwm8D9OHJl/nvyiF7r3K15zHyCak=
X-Received: by 2002:a05:651c:221d:b0:32b:4773:7aaf with SMTP id
 38308e7fff4ca-32f09328c9emr30825051fa.35.1751898738869; Mon, 07 Jul 2025
 07:32:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <oxpeGQP7AC5GXfnifSYyeW7X_URDJhOvCxTG09iGmuvIXd330ZdXanoBmbUB3wpOcIORP1CakEzevsjtJKynhw==@protonmail.internalid>
 <20250617131446.25551-1-pranav.tyagi03@gmail.com> <huml6d5naz4kf6a3kh5g74dyrtivlaqyzajzwwmyvnpsqhuj3d@7zazaxb3225t>
 <rkCSJQOnZAt9nfcVUrC8gHDWqHhzMThp3xx38GD2BgJZM4iXJfvVgXZwa21-3xikSHHLO-scI4_47aO-O1d5FQ==@protonmail.internalid>
 <CAH4c4j+dhh9uW=GOoxaaefBTWQtbLeWQs1SqrWwpka9R8mwBTg@mail.gmail.com> <aaywkct2isosqxd37njlua4xxxll2vlvv7huhh34ko3ths7iw4@cdgrtvlp3cwh>
In-Reply-To: <aaywkct2isosqxd37njlua4xxxll2vlvv7huhh34ko3ths7iw4@cdgrtvlp3cwh>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Mon, 7 Jul 2025 20:02:06 +0530
X-Gm-Features: Ac12FXzf6bQbW208adFb3L3sqINPLXWf5JxB8WTi60gS2v2uT9WkHERIFtfHvtI
Message-ID: <CAH4c4jKisoACHNOQH5Cusduu-_51_PcevxYJT3k_o6MjBWsVJw@mail.gmail.com>
Subject: Re: [PATCH] xfs: replace strncpy with memcpy in xattr listing
To: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Cc: skhan@linuxfoundation.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 12:04=E2=80=AFAM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Mon, Jun 30, 2025 at 06:18:06PM +0530, Pranav Tyagi wrote:
> > On Mon, Jun 30, 2025 at 5:49=E2=80=AFPM Carlos Maiolino <cem@kernel.org=
> wrote:
> > >
> > > On Tue, Jun 17, 2025 at 06:44:46PM +0530, Pranav Tyagi wrote:
> > > > Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
> > > > The length is known and a null byte is added manually.
> > > >
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > > > ---
> > > >  fs/xfs/xfs_xattr.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > > index 0f641a9091ec..ac5cecec9aa1 100644
> > > > --- a/fs/xfs/xfs_xattr.c
> > > > +++ b/fs/xfs/xfs_xattr.c
> > > > @@ -243,7 +243,7 @@ __xfs_xattr_put_listent(
> > > >       offset =3D context->buffer + context->count;
> > > >       memcpy(offset, prefix, prefix_len);
> > > >       offset +=3D prefix_len;
> > > > -     strncpy(offset, (char *)name, namelen);                 /* re=
al name */
> > > > +     memcpy(offset, (char *)name, namelen);                  /* re=
al name */
> > > >       offset +=3D namelen;
> > > >       *offset =3D '\0';
> > >
> > > What difference does it make?
> >
> > I intended this to be a cleanup patch as strncpy()
> > is deprecated and its use discouraged.
>
> Fair enough. This is the kind of information that's worth
> to add to the patch description on your future patches.
>
> No need to re-send this again.
>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Thanks Darrick and Carlos for the Reviewed-by tag.

I also wanted to ask if this patch has been queued for merging.

Regards
Pranav Tyagi
>
> >
> > Regards
> > Pranav Tyagi
> > >
> > >
> > > >
> > > > --
> > > > 2.49.0
> > > >
