Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4310199920
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 09:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771492411; cv=pass; b=Wd+zRdDtOH+qbzoCqKjsS+eshtyjfbLFvRBp9UmMSA6TTvYzCDCFZhyvyJje6xSzaVgaBgQiJWUGSYjo55e1YZ8nSCNQeYtfs8T22Hn0kMC6l4tAHnGKpILgI6DvSDQoFTs+nRuFSm/laHGLYSPiM2RyFzav3IrrhhuWg07UJUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771492411; c=relaxed/simple;
	bh=6SdLRE7Uye7mecwC75Z6G0WHM07HcenmkmdKgcB2OKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PX0HOxI5+PAuXGonwA8VUsp2WAPlTvm1c1wTSZ/5YizoX7vTnNFNjtOdlx2ZQocSyGghQrL1lPU2FS8G/bHTzM3vbL8F+X0oQq5oVrIljsX3Ft+F3cXTuqxnR1zeegdhXDIeAhFAl1NisvmAuaYm35f0fEstlNmQVtweWmKB0LI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+RkdUkB; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+RkdUkB"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8f96f6956aso98271066b.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 01:13:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771492408; cv=none;
        d=google.com; s=arc-20240605;
        b=b9Feqcz1UPXsaomE1MgT2LwPR7CzSerWixLypt38dx32WfPk2/8j8tzzmAR5pd6SaY
         Rcx5My6ujN04WJH4DBvh2Dahq6s1kcfWCIgrptgxz+AVmgC+TmS/RWIdVV4Wll8XzGZq
         4y2E1GR0S2ioE8XftoTkIBlDk8DjcWPfO8gOLaL70NErmXxmRjhYv0dtO/UwV0ca63Fz
         fxi3wSWVDSq2rti3h7KrsyH2/gxwyHvNbT9nUj2x0BQrURK0JcG5JEqrDo5Ei6QYNO5i
         7xlnk5fZLOiSbn4gpE2zLcW6MmLOwP8qg6K8N6Fl4x10gBi6mEhiAbCXEibCzVIzuOjx
         w4nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=giQ2yQPplON01LAnGnRJuxTbuZrduE2SkCeIirbKbS4=;
        fh=NnoUyvDVXRmjYO0BM9m/y7RJNDNLm/VkC891lzo+eGA=;
        b=JthVzxojG+PxFrM3vLciv52sSYejpzNglmhmEMpeWaZFw6Y1WZxpklkYkhVuf0npRU
         sZcSB7OhM72u6IHi8RM0T0ydTLR9j7ygSqkRes3wZ3qbD05UAI9UgpMoagfXsM71JjUj
         W2m7e1ClHYayJV7iGrpvqtG4NEQ500C4a48E/L7RMleTwiSgywirgttpTkNpZgoOmOdT
         PeOZQNaxfssZiSdEeQdJ5ZTKeq09DjttGgzFwy6EeWoS3+3JHjD/4Yrd72ouu3ZGC1s0
         WDLI2FoeOMfe9CElt3J2KMOKx1u4w7zHXgh808zYUbjn6Vj0eg0vmKvtSBnlOwp6Htrd
         vPOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771492408; x=1772097208; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giQ2yQPplON01LAnGnRJuxTbuZrduE2SkCeIirbKbS4=;
        b=N+RkdUkBIUtoIqs0lhwzWit/4c0ZFu+Gni4Nkru0WQwBhf0i6+YrrLO2GZncAd7CGj
         OrnPl6Oie59sx5nly+sS86GfBXKg0AKAhenhuGp9GMzrDK75WcfgbJAw3SSTE649ju3T
         JZYSBLtqsZMcfQZdWfSsctn6FaukOdXcncHgJXzYyBdIxdmgHjTjagZI3owOGgUWm70S
         J9NvtK3iwBjzEaoHnEBhZhILW8wvF4SvUH/uX6U1CPantQh9ilLl08pDBoAbAG/Wbdiz
         tozSNG2geXtnMEgYHqbCWm58uFLWOQQrs29Vu9lp8jnkDQAIPqohGV1Loe/yjJSM/9Uo
         GGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771492408; x=1772097208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=giQ2yQPplON01LAnGnRJuxTbuZrduE2SkCeIirbKbS4=;
        b=qgvLMC+ZeGeSK56Fhnmp2UFqPO8MLQafDgf6RHQo/I8RcyMZB9R+MR2nj9fwjC2Zq/
         OWgi76bFU+awKcTKCE1MyCEFRVyb5c3AY78spB6bMYLL/1yd1lTr7DeAT4H1P/oz3d6J
         W4xi9YhNGEyPUBEjCb2ck6+D9P2iEhKXyoPaL6VNR7p0Hc5FSZy8iUYmsJ3clVZoVtHr
         xunuwbos8aAgCqVs6tVJZZGPL4gj6jX7QSZQvpGBDKYVRymTu+HHgY3VMNjg4hBZ8SDh
         GJQeacur11QlQkrVo2D8thijtwbNBu5qbg/xqNpjmxW2hK5gfvGuRGRboo5nEQRWVQ2/
         fSUg==
X-Forwarded-Encrypted: i=1; AJvYcCUL/6DTykzThr6jHVM7ieg6Z/bL4PkuFPlxduxFG+K+NMVgMMbHZNgEUi95lkHJbgilfe+PpFxxc1U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRbG3zwBRhe/EiahPQSvIf934+CN+H8NA7eb5c3evgiGghPPdx
	j0zY4eT3GvWBOTOyerxDiwYyrVmjW0EevDfUQKmXc7lTm+Gbw+aLZGF3qGWdgmKHQTDvWoOVDcu
	j8NdZNhUT0ow1PRIf+bcySpvL31ILsjI=
X-Gm-Gg: AZuq6aLnylV8ZtdI5S3P9SF6sBTiCmdTUDbe9Zh4guZTDthsYOIq5A7/KTyRWVXc2hC
	uRH1UEdY5kdfR1Rs/ia4pcOfR7xTVQVJn4h5gi30gvUb+4h+9AivQJIsU8cNKgZdC0PJR4LI9Ph
	yh6EN4I+xPAIYUTMR+n7syJxfhBp7xMu5Ta5w9Gu9WK9lY2NJB8BxlR3JDk03NlHAUdzfOICwr4
	q0FV+sq+seGc7Uq3QDIM4BINUIKVg37islcBvOEDXjVWIsMp93PRo1WKiwiLDxhHB2QzYsPUDxY
	6Omi+JE0
X-Received: by 2002:a17:907:94ca:b0:b8a:f91e:283b with SMTP id
 a640c23a62f3a-b903dd391f4mr240466866b.60.1771492407632; Thu, 19 Feb 2026
 01:13:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <177145925746.402132.684963065354931952.stgit@frogsfrogsfrogs> <177145925776.402132.12925789451998493951.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925776.402132.12925789451998493951.stgit@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Feb 2026 11:13:16 +0200
X-Gm-Features: AaiRm50TFRps7R-TKjszjJl7mIQyvJdTGmaSE9eJDDRH466ForswRbN23IB6gW0
Message-ID: <CAOQ4uxhR0UZt7wcRSXtsQq_GU8m_yLVc3bK2zJJduzqSmfe7FQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] fsnotify: drop unused helper
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org, 
	brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2026 at 8:02=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Remove this helper now that all users have been converted to
> fserror_report_metadata as of 7.0-rc1.
>
> Cc: jack@suse.cz
> Cc: amir73il@gmail.com
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  include/linux/fsnotify.h |   13 -------------
>  1 file changed, 13 deletions(-)
>
>
> diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> index 28a9cb13fbfa38..079c18bcdbde68 100644
> --- a/include/linux/fsnotify.h
> +++ b/include/linux/fsnotify.h
> @@ -495,19 +495,6 @@ static inline void fsnotify_change(struct dentry *de=
ntry, unsigned int ia_valid)
>                 fsnotify_dentry(dentry, mask);
>  }
>
> -static inline int fsnotify_sb_error(struct super_block *sb, struct inode=
 *inode,
> -                                   int error)
> -{
> -       struct fs_error_report report =3D {
> -               .error =3D error,
> -               .inode =3D inode,
> -               .sb =3D sb,
> -       };
> -
> -       return fsnotify(FS_ERROR, &report, FSNOTIFY_EVENT_ERROR,
> -                       NULL, NULL, NULL, 0);
> -}
> -
>  static inline void fsnotify_mnt_attach(struct mnt_namespace *ns, struct =
vfsmount *mnt)
>  {
>         fsnotify_mnt(FS_MNT_ATTACH, ns, mnt);
>
