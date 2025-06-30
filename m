Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE3B28A1DA;
	Mon, 30 Jun 2025 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751287702; cv=none; b=EDJlPtLEq8EQmzhVNo3vX8goMJXEnK2iMLgdPYdQ7EUuMqJHcP/j0+vUvneRLg+DQXz1JhOiGWG+CzJkI8bpnRI1rDkAWgjMDn7PclgkUueNhPu4KhbltwfWX3IHYEeCpqpvXrmqu+yCJnw/4HirZfNZbdRNLQ09iIbp0LmZZ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751287702; c=relaxed/simple;
	bh=MIZWGT2T7Tlm6PSUwjsJxR8tlB50tfC/tPCtXTT3SHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdlBUbxfbMiOPdtXjDOT6UgLu1nChgA3FYCt3QXr0+j3e/09UXgruosKBxvrywCxwBpcBL4tzZFjTQ5WUgg/xH5eF6rk85RPGW5gNsri6IvfZIPiXCoJT1CmDEWjZ84T3KFpzxGcd9GSHQExQeWCGB1K2PfCGGeXxzAz/5my3NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BQ4P3PLR; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BQ4P3PLR"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32addf54a00so17585421fa.1;
        Mon, 30 Jun 2025 05:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751287699; x=1751892499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lc9GOsuKWZQ30zdGq//5svH3uKcqx16A1j5YGKqNoSw=;
        b=BQ4P3PLRx0WRZR49YFROK0XDuYVAYCvGi5QPbXer1pYDcR/ZHaIoPCsodpBiL4LBPj
         H2+Lf8TXl57mOOcLKXcwhkL8Dn1t/MxNhJkk51yqR2eODfV7pwRFbCDxrDJ8dJMdInJZ
         xiBpnJ3gVU+XlkLwYoJ5lbpKJoHsXx0dh+EJS2N2RFnGUxhknkrxpNoz5rsh9YK4os7Q
         NENjOzSqiYOa3QATXcaggPt3mv0GnbTqq9/PvF9IOyLT3cFM1in1wt+xq05TxszORLP6
         F3D4xCJKVWs/+ta13ninZvQOe1dESP2GHySJ+URlIxgjmnS35cZI9ANde0qyWmYsRAKN
         rH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751287699; x=1751892499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lc9GOsuKWZQ30zdGq//5svH3uKcqx16A1j5YGKqNoSw=;
        b=j2tEUmPlastcll8LmKYkGu/aorkVWEeMV9rqGSYaCamYRTv7IBrGng8I6HH42KRw67
         SbI/2wiHMVpugBuluXByi5kCIbIas6cjA5kq0Ns3GjgirVhrBWRnLuFEx6A8vMI8+LhF
         ncxAx3JOuSZC7vFzRcz2DEhg555DfHagbbLIiXyoqFmZbkg7OlCchmxBHLfrz8EFWssG
         lF9+wlYDINm2/8+1a1JFT6Wcqv4ccQWN3xWRyU8TdzEMTy5OVO3TZq1EDMXivsfXaNyO
         CUxm7VxaohttGQqp4kMkT150gA986w9QHVtWr+MQfymqwPppfyHJHQsD7V4NViFkJYOx
         jSRg==
X-Forwarded-Encrypted: i=1; AJvYcCU8nnByOkIM5ampJDASzwsIGxnk9HkwXUQpGUQwzwUer/3/SpH9v9SZVUqEHRnk3nhJ38qFBrWi6LaE@vger.kernel.org, AJvYcCVDExgQ61kDv7snz9V0X74AsAvLBA/IcGFkB3X1Hij5NUilEDl4U2M9GSyZXyHDhtbioGoAkxaXpqJ1bMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN6IGKs+8DNNANTjdSxgCofQXe9Ec0NhwdP3tec1PtujjL6jQ2
	fpd4s5HrYtXEOLR1V3lHk4InDoDLyQ3i/dc2DDNSwbc2tty16xnRBQ81jpgXFRs1fsxe/9a27ra
	eNe9N72Z6Qt2dbaF5416AqeA05f0fS2Y=
X-Gm-Gg: ASbGncvFnw22v+hCV64GrQ7xKkPcQ2RNCqSl4/MTsB7L2vu8Gsd3JsDiYsBZwTYi3RI
	EWDgfNxPLjNO4FuymLh6Y2++OjupkGOCk8YO3bhPOrJukjSlnIaoFz7zGRyIx0BxUgWoloV0uvt
	SuFhGpS8wFwmeifnlFuYrcwpvt6HL29Qk0kN77PNDeVbGlhAzQJnGlC84Psa8IHrDF5WrI8mFHZ
	rtg
X-Google-Smtp-Source: AGHT+IFZ/PwzE3gErBSpWi0Zkh9xrC5ZLYgbi/qGccvzQTySne2UpxDe9iNCPiJTyZ8bkqlsOfb+KmXM3QtlG93FFAk=
X-Received: by 2002:a2e:9189:0:b0:32a:61cd:81f6 with SMTP id
 38308e7fff4ca-32cdc4c1204mr29656731fa.19.1751287698497; Mon, 30 Jun 2025
 05:48:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <oxpeGQP7AC5GXfnifSYyeW7X_URDJhOvCxTG09iGmuvIXd330ZdXanoBmbUB3wpOcIORP1CakEzevsjtJKynhw==@protonmail.internalid>
 <20250617131446.25551-1-pranav.tyagi03@gmail.com> <huml6d5naz4kf6a3kh5g74dyrtivlaqyzajzwwmyvnpsqhuj3d@7zazaxb3225t>
In-Reply-To: <huml6d5naz4kf6a3kh5g74dyrtivlaqyzajzwwmyvnpsqhuj3d@7zazaxb3225t>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Mon, 30 Jun 2025 18:18:06 +0530
X-Gm-Features: Ac12FXy4ugl-kesbBpcuHZe6MsZHfUKRgMJ1GachXE79Ciews1udZ0uKWbxXa7Q
Message-ID: <CAH4c4j+dhh9uW=GOoxaaefBTWQtbLeWQs1SqrWwpka9R8mwBTg@mail.gmail.com>
Subject: Re: [PATCH] xfs: replace strncpy with memcpy in xattr listing
To: Carlos Maiolino <cem@kernel.org>
Cc: skhan@linuxfoundation.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 5:49=E2=80=AFPM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Tue, Jun 17, 2025 at 06:44:46PM +0530, Pranav Tyagi wrote:
> > Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
> > The length is known and a null byte is added manually.
> >
> > No functional change intended.
> >
> > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > ---
> >  fs/xfs/xfs_xattr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index 0f641a9091ec..ac5cecec9aa1 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -243,7 +243,7 @@ __xfs_xattr_put_listent(
> >       offset =3D context->buffer + context->count;
> >       memcpy(offset, prefix, prefix_len);
> >       offset +=3D prefix_len;
> > -     strncpy(offset, (char *)name, namelen);                 /* real n=
ame */
> > +     memcpy(offset, (char *)name, namelen);                  /* real n=
ame */
> >       offset +=3D namelen;
> >       *offset =3D '\0';
>
> What difference does it make?

I intended this to be a cleanup patch as strncpy()
is deprecated and its use discouraged.

Regards
Pranav Tyagi
>
>
> >
> > --
> > 2.49.0
> >
