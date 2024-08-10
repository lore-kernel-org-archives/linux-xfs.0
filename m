Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA416158546
	for <linux-xfs@vger.kernel.org>; Sat, 10 Aug 2024 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723301311; cv=none; b=WPa4gYDf8KqB+TIHiBrN+PXyk3dSPIgrtlKyX2X6w/5dUL+XM1lIbv/RzUoiE2ZfyLXEUf/ynjvBsDvgTUBK4E8JOSgnyjfuw5Qck0Gik4sQZiaWr2uEzxhezbOl1Xr28uAzMYOXFQUpGR3x4MAMj4d1eXBAbkvv/9zYtL9lZv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723301311; c=relaxed/simple;
	bh=i3SFS1b8LvCYbwu+07GOq8digP+zTllBuU8ZCRzeQrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fRo5LkudSYKbMw0gnouaOjVYgD+9FMtxgCf7aN6udiH+o/vu6bpC2rXs5zgfIhq4vSeI8cLwQdbhix/zgnomoAvqDywEZbXICZuN+iclQZvGVg1JfHi+aWIJVWcwsHDhGV2uAhqpmVCXv7kopoPYa1Gh2DBvR5vgylinnqErHLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzPxgqLk; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzPxgqLk"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e026a2238d8so2699736276.0
        for <linux-xfs@vger.kernel.org>; Sat, 10 Aug 2024 07:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723301309; x=1723906109; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csuNfgaPEfPYA2/XoFer2oC+hEEo+N5ucKUjDedV5bs=;
        b=RzPxgqLkEywWvwncT+KzN567Rfkh52gDFM53W2zLSRbfGhSl9EvY7Eu//jO8QEzYQV
         2S3LfDYZoaJbjxuCiM9rIqzZYZXjzY1bYxxLHvHoPEahA8CmEEj7uDjXN0GxzQPBiRa5
         pFXGz39J4QlaUJ4sq+UNTr7zLdyTLGcyBWnWMfXV94LNG/b7b7xuQE9fedkD6Z58Leu+
         7Ejl568Zz0mTXO1Hxb5ozthnhwtfBREtYj9zwDGG7by9IX6EeEWtyBwjqBwuRHtaGrH9
         JgpDmQRPx63Epv0QhDszz+0BHXPD1Ik++NPVSsMfx2lcNmVDNqOsNFvbbFI+BHk5h2iQ
         YWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723301309; x=1723906109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csuNfgaPEfPYA2/XoFer2oC+hEEo+N5ucKUjDedV5bs=;
        b=uTGMMawJk0bYOuUiTxTvJd5iacsT5VbW8VW2hJxWiysGwgxRhBOKmH7R6GhJzLxYJE
         HeSEVOGyp1yAWTAqJ9q9zwVbMydyBulO/j2P8Z28fvgZwf9CeqKqrzpYLHHvoR5Sn6sC
         l8cNJg+MyyrS/1iZWSB7qbEkkbneyAXCcO/YPoBpGYHk3AMaTwYoAKsEP7UpFPxUNKje
         dDN2YJQAuwuhHBFnQSqWNh8/qbwYB8CfzZwcxNcnF2q8zMUj74v6Kv45K+lKoC81csEH
         CAGKrGyca80l/gnZwIpFcSMNzFMQamWrbMvTDUNBGF4PaQxq/NCNWb7L3p3q3nSI+uyN
         XQtw==
X-Forwarded-Encrypted: i=1; AJvYcCUlEj0op8m4rkXP5GhwRIe6fr/sPRbOCwSLng1Rf3G2xOu1vJ6vemxPdNTZwOiZjP3RsDaQ+VTdnZX9TFF3IEZk6yHYUUgYPUGn
X-Gm-Message-State: AOJu0YzJ4Go0Q7o7+WueTqWp94SDKu1Zxwt+xsGRe/j3hYTzU8JKr2Ph
	knOX4ftmjJ7FC2vx6mVzSOYBLVp8Mg+pR8CZibPdAcpYuqGP1/4faYaaLWUvsbFfL+3HnXvfZ5b
	h5aEK4H5FRbedclfh1dThCOvvGAeSCIkf
X-Google-Smtp-Source: AGHT+IEdsZ4wTd0qhFPn74IBK4JCwyrTM8zg3pmGHphHmcVM9zv9ZqHaiVIkBIO7qYBleBPW9eHK5fmNMpBjqK41mrg=
X-Received: by 2002:a05:6902:250e:b0:e0b:b91d:766e with SMTP id
 3f1490d57ef6-e0eb9946363mr5400747276.22.1723301308665; Sat, 10 Aug 2024
 07:48:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240805184645.GC623936@frogsfrogsfrogs>
In-Reply-To: <20240805184645.GC623936@frogsfrogsfrogs>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Sat, 10 Aug 2024 20:18:16 +0530
Message-ID: <CAFqt6zbwgNsD5Cti3bQ8Fu=8mDSedb7B9iY1zDq10qMcuJmorw@mail.gmail.com>
Subject: Re: [PATCH] xfs: conditionally allow FS_XFLAG_REALTIME changes if
 S_DAX is set
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 12:16=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> If a file has the S_DAX flag (aka fsdax access mode) set, we cannot
> allow users to change the realtime flag unless the datadev and rtdev
> both support fsdax access modes.  Even if there are no extents allocated
> to the file, the setattr thread could be racing with another thread
> that has already started down the write code paths.
>
> Fixes: ba23cba9b3bdc ("fs: allow per-device dax status checking for files=
ystems")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_ioctl.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 4e933db75b12..6b13666d4e96 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -483,6 +483,17 @@ xfs_ioctl_setattr_xflags(
>                 /* Can't change realtime flag if any extents are allocate=
d. */
>                 if (ip->i_df.if_nextents || ip->i_delayed_blks)
>                         return -EINVAL;
> +
> +               /*
> +                * If S_DAX is enabled on this file, we can only switch t=
he
> +                * device if both support fsdax.  We can't update S_DAX b=
ecause
> +                * there might be other threads walking down the access p=
aths.
> +                */
> +               if (IS_DAX(VFS_I(ip)) &&
> +                   (mp->m_ddev_targp->bt_daxdev =3D=3D NULL ||
> +                    (mp->m_rtdev_targp &&
> +                     mp->m_rtdev_targp->bt_daxdev =3D=3D NULL)))
> +                       return -EINVAL;
Any chance of  mp->m_ddev_targp =3D=3D NULL  ?

>         }
>
>         if (rtflag) {
>
