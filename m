Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D9219046D
	for <linux-xfs@vger.kernel.org>; Wed,  5 Jun 2024 06:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569569; cv=none; b=JwAnDlP3yacd7vIUN3VOdGOVn/ZtwiJyQH8fw8q86509jZicriaPGeKPV37/HkZ3MjoUEVOWlKx3asRWLoj7nrCBaTkydh/6ktC0MP6p5tKwmUdKvXMBBt8efXtnTORJ9V5f/TDsvC/kOxKbDZRXa+U1mTt0kYKFQS0Kn8LXXz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569569; c=relaxed/simple;
	bh=rutAPEixhDDHpdwwpk/nkL/cUqGqseT7TwLEZWbafOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OgUdiU7KuM2xybOQDOh7xzZRNdFxTWHQd6dizhiNUwIkusg/24gU/oZrCGyfmgbGCTzghxqYYWTRBmaHjIg+GYR2FrBCwoQtraTd5K32kQabatVKfslZgXVwU/aSrKFsG8yg/ioaOxya+wzrVa/vJKG0xWz67w/7zxd/7pS1n54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ccUPESKt; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccUPESKt"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dfa7790b11aso1931804276.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2024 23:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717569567; x=1718174367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rPO83kU/5Un6J1bCh7FWKo6xEXCmQrwshkeoeQAnEV8=;
        b=ccUPESKtD2j+NWMLTkncZjXO05YDrrAGB29DGd12eY/dnDjIn0Y7gbInh5QS/0TK4N
         xDsNy2CUJRlK1yH8aWDBw2n41Aty6MwsdJ2D0YIxwYbQoaBRbRo8ah7QYqK6iVAcRMlP
         QO68Lrougqi9cpny3t0L3veUuTZvicUq0O9rjhyoDSXXO/goPzKJncAqb6b/W/hDLSXd
         UVlaYqsS3+FUNLSXiKJ9G2BAiNn9Wy0bMB0i82XJbZI2i3dJfbL2fAFgDyFdk1ysZ0Dk
         zLxP8uT257JHl1Q/sJoedUp3eWlzJaZnpnzawfAPAtMiIuXwkD9MwHH3NzAvl6C8R+SK
         5Q/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717569567; x=1718174367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rPO83kU/5Un6J1bCh7FWKo6xEXCmQrwshkeoeQAnEV8=;
        b=dQfoI6nOLa8vKCNRVrZQXVXGCbvn4EsY6SJHV1zogzLKYBDA+vf73B3eCT0vrD+oUo
         mMXsCyTFiMomGZNGcqENSxmEwu+wyeurZGzd4jb9tpuIlz5tnDczkxHl1rcvvk0I4Bya
         Li2CJQ0JmML4cVhfu9HggJhwNTS0vgj/TgHrZlqpGxDP7fQPvlVdCplgIhlem82CWtrb
         zijzukA67cpVEPh4dz3VRW/yetcQ/lpfWMZStPW1x8ERogivKgDaD+H8yfraEFmGk9nz
         Ky+sJdF/08TGQmMZFrM5UY6bZA7cOLylsFkSf8lpnUFbLP9l0TWMpJDFIA8A11dnoF4W
         k/DA==
X-Gm-Message-State: AOJu0Yw+R7aTp2Esm/3oU4yq8lYxk6H3J7ljGJmmZozsBgN0a44jcPPc
	2e1DkG8xa5QnbHfISVmbrbqBuYA2t4oXO+zc3gM4y+B07KjCd8aIt/zhzJ72b/50TSUFOvbZNo1
	eh7GMvZlFdcGNmqEFt/xClLeeAU2z4YCuC/3SjttV
X-Google-Smtp-Source: AGHT+IHNArxnYwBLjsrumi8Wr1/FtfchpVJNTnw8ZG0r073k+jYs2TqV7PgEoyo6hqgKvMIvYnfKMrICYvg3n7uIcXA=
X-Received: by 2002:a25:9385:0:b0:dfa:a86a:c007 with SMTP id
 3f1490d57ef6-dfaca9bd893mr1647493276.23.1717569566936; Tue, 04 Jun 2024
 23:39:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603080146.81563-1-llfamsec@gmail.com>
In-Reply-To: <20240603080146.81563-1-llfamsec@gmail.com>
From: lei lu <llfamsec@gmail.com>
Date: Wed, 5 Jun 2024 14:39:15 +0800
Message-ID: <CAEBF3_b3WCmzUipNsebFMZgUhdv8C7gSq_Gs-dhbLJi6kQ=xFw@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: don't walk off the end of a directory data block
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Dave,

Do you have further comments and/or suggestions?

Thanks,
LL

On Mon, Jun 3, 2024 at 4:02=E2=80=AFPM lei lu <llfamsec@gmail.com> wrote:
>
> This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
> to make sure don'y stray beyond valid memory region. Before patching, the
> loop simply checks that the start offset of the dup and dep is within the
> range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
> can change dup->length to dup->length-1 and leave 1 byte of space. In the
> next traversal, this space will be considered as dup or dep. We may
> encounter an out of bound read when accessing the fixed members.
>
> In the patch, we check dup->length % XFS_DIR2_DATA_ALIGN !=3D 0 to make
> sure that dup is 8 byte aligned. And we also check the size of each entry
> is greater than xfs_dir2_data_entsize(mp, 1) which ensures that there is
> sufficient space to access fixed members. It should be noted that if the
> last object in the buffer is less than xfs_dir2_data_entsize(mp, 1) bytes
> in size it must be a dup entry of exactly XFS_DIR2_DATA_ALIGN bytes in
> length.
>
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.=
c
> index dbcf58979a59..dd6d43cdf0c5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -178,6 +178,11 @@ __xfs_dir3_data_check(
>                 struct xfs_dir2_data_unused     *dup =3D bp->b_addr + off=
set;
>                 struct xfs_dir2_data_entry      *dep =3D bp->b_addr + off=
set;
>
> +               if (offset > end - xfs_dir2_data_entsize(mp, 1))
> +                       if (end - offset !=3D XFS_DIR2_DATA_ALIGN ||
> +                           be16_to_cpu(dup->freetag) !=3D XFS_DIR2_DATA_=
FREE_TAG)
> +                               return __this_address;
> +
>                 /*
>                  * If it's unused, look for the space in the bestfree tab=
le.
>                  * If we find it, account for that, else make sure it
> @@ -188,6 +193,8 @@ __xfs_dir3_data_check(
>
>                         if (lastfree !=3D 0)
>                                 return __this_address;
> +                       if (be16_to_cpu(dup->length) % XFS_DIR2_DATA_ALIG=
N !=3D 0)
> +                               return __this_address;
>                         if (offset + be16_to_cpu(dup->length) > end)
>                                 return __this_address;
>                         if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup))=
 !=3D
> --
> 2.34.1
>
