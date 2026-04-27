Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85243ECBC4
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314689; cv=pass; b=hCP1IGii5poGIQ5IJ5OEXkAjLyygVkE+6j5Qyq4xiehLInx+oLkpxDSqDaoVlNwkI+4RjJalMRH1emVZuijmrNIbOIFm7oCKPCfNbwaqwD0khFXxmC6enzUDCiz1K/EcNyigjlf18AIigon8oGZml64coHepJZPyIQ7BJQ0uL14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314689; c=relaxed/simple;
	bh=y5vNoVjRrCeEb0mNeJ57C/lgX2jIu5b+hJdLehDSizI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k9xviuSVbV+WpojNF6GwW5XzXxWiq0XQvb6WsqYC8Di7jHBh7i5KRwc1QgGul22qb/qQplLWFVCy0O/aedu1JmpG8dJXJTpSDAuQFfJbPZ54esYfJUXFeUnlxC+1kBOTBwOU8mpV7x7fPuFn64Mrx3Su59NjT7y/pptnBquzHhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g9E8KppX; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9E8KppX"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b936331786dso1376873766b.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 11:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777314686; cv=none;
        d=google.com; s=arc-20240605;
        b=Hrtr+GuIbZvxIwo0CBC82qBELQGcUc7oQG+d7vYpWxmSoa1NBYqC8fovAh3bqlDL+q
         DN4HvW/GkeUFwdtf9qPf24bdpGV6AWXjcgDHiaAjxcP845tOBDb68fFenYuNkSdDJZ7d
         /H5sZgXDAaxJJZFkQi4cZYHeVO/dRgGpocOuxfU2k8CLVr5tzL3mo3+77lg63uGls9t/
         /wtWO3rMjYHTPqX9f7raMby2/H07i+4TZZlT6mS6pcYXYYKr/QPhYm2Uz+Fe+z1XCbVF
         6iv85HbYpiM5oSn++fYhls9SsAf2llAPDTcjf89Qa8l+4S2xxCf+86LJo1zU6e7qcPIa
         gBsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        fh=0oL2aundpENW2XlxbeGG6S6ElOnq6bcT378/c1+Sumk=;
        b=SMnVWKD5zqbtZz/CNGkuamPIlIgiVfMUourlNToYTPjBPC11OXzufL+/8fyJmVf7/O
         zpJTvGQ3G3Y/D3CeHpmnhyp2ixVImsECl7FnOmsvcjxJVokFro4ahhPh96PmoKKayAiE
         O43Jx67sSA/BQeWGeCQ8kiuIA7Tc7udIEP56F5cgOBmpYwLveEwV5MJHGeqqxFHDqQia
         rG/Kf9MUjPcSOCN4D9nHRx2McIMuxscVGR97W4YgsRQr8y5Q71d0rB8FTb3u6bKV6h1S
         1JgZPmAH/PMczJOAmhFRXyQthJI1tAeEHjQhaAMv5KvaYMYJtHvmieGnifZXzbNprj3o
         U0Mw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777314686; x=1777919486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        b=g9E8KppXOGP+2YshzElHjYypJOoFSumRh8nKOHEMqlQ1thu4nV8VbkX1FUeocZEA0H
         alIgwcCm4qgTvesoEIP/Sy16rr7NJuYp8L1j4fk4BFWv1Q9w7hoA3zEf47AMnf197OV7
         mCyZu/NdkRuKXUmmB96AxJwaOFp/EtbNnd54XiEC0sIRBDzG7kXvOudD/ydXUwE0fRmL
         N+HEtvs2Pq7jpHZc11C4B7cmpg4qge9oz5WZ4zAta7U+yEG7OppkAkLBlon6sOek3rVP
         fzHfkTyWMxDB8qYXnP7FBsnpcH6s5Mggz0O8+/jZgLKQRLOQbXvyhF26Dtx+xt1w3oE5
         1qPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314686; x=1777919486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        b=VsiahUjO85n23uEAnuo2XqNEr4c8khLxCbiMx4vRESRLsYSY6iVIPvlr/UCKMJWB/a
         cjO0AV90www1qYv1+MF8a05AWClchuEdLMlm26S++n/K1E6IcQajS3nKE5kASHfzDMqh
         GsIqrpAot58ldGgtyyu4BPJXgEVEXB8diqQQUuOtXFhRmTamsUyu9hWIHsIM4qFP/iiV
         jh4Svq2CE8U4UAUBqMNpY/TbHgAQDVZG9wVveGu4KQMvzkd+rTEb6slAAFZcohUnYSms
         qGiWzIJkVgvSIDbqH8lT1GsamSoW/qliBzTJxaNqgWAXTkgukcIr9P1t1uDUE/+LFvZS
         AqBg==
X-Forwarded-Encrypted: i=1; AFNElJ80ecY/G9EvbF4NYOfMc2XOQdVu+LeAOwucBC9r2u6LbIoFsufM8OpBSTYxNnIOzTTcg4Q30q5Vjf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU0fSByuaf56TfUA3WXfFf4YpM5D+0tbCma8+h4OFC6YMtCdN0
	UJ3y38Z84Yd5CImZFKtle6T3hFakREk5EeidiQZ8HjIYAJByPbOHWFzIK39NixlrK8gNks176lN
	TJ3eCjHzt7i8mXUJJ/oMTxmdN7xQhrUE=
X-Gm-Gg: AeBDiev41Pgkg/2CrMnsgYcekrQbPztUHe4wAZU/sS+lkiv/GgGrxFBNEZ42cA8LWa9
	oMpOFtATTp9Y6SXz0D43zxWSmCZ+/6xvkIj55TmXCZ83D3fyBsaWYHOxO4thWdaCfjk2xxsuC4f
	fjlNTL4aqHOV8hD4j8E9V5E5P5rcc5M2QkApBZVJf9GHsZCJQ/GVyConjmMGctsCTu1SXCoYJXl
	fIHM4W+1zJUrkSgc7QMJC2JZWo8S0DYVlFT/M5ewoPfa+yTSIO77aCcC21rKmrWzDncZaf/Ywoq
	VwDwKO6PIrqyjrNXiMp7VvqHehhs5ip5LZ2xjmO85ZZoGUo/zHg5
X-Received: by 2002:a17:907:6b85:b0:ba5:391e:20f0 with SMTP id
 a640c23a62f3a-bb7fd277cffmr2751366b.42.1777314685571; Mon, 27 Apr 2026
 11:31:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777281778.git.asj@kernel.org> <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
In-Reply-To: <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 20:31:14 +0200
X-Gm-Features: AVHnY4IQzHFWkbOhQxy-O7952b296RbWBnPSd_gwXqTuhmjQtW-vYoNk5uAynBw
Message-ID: <CAOQ4uxjEcHiqzB+JrnzDExMcBuTbLaPT5qQcEDX0GO0TX7hp=g@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] fstests: add _loop_image_create_clone() helper
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs@vger.kernel.org, zlang@redhat.com, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 12:19=E2=80=AFPM Anand Jain <asj@kernel.org> wrote:
>
> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
> image file and clone it to another image file, and attach a loop device t=
o
> them. And its destroy part.
>
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/common/rc b/common/rc
> index 9632b211b58f..0e7b7eb1d98f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1503,6 +1503,50 @@ _scratch_resvblks()
>         esac
>  }
>
> +_loop_image_create_clone()
> +{
> +       local -n _ret=3D$1
> +       local pre_clone_tune_func=3D$2
> +       local img_file=3D$TEST_DIR/${seq}.img
> +       local img_file_clone=3D$TEST_DIR/${seq}_clone.img
> +       local size=3D$(_small_fs_size_mb 128) # Smallest possible
> +       local loop_devs
> +
> +       size=3D$((size * 1024 * 1024))
> +       $XFS_IO_PROG -f -c "truncate $size" $img_file
> +
> +       loop_devs=3D$(_create_loop_device $img_file)
> +       _ret=3D($loop_devs)
> +
> +       case $FSTYP in
> +       xfs)
> +               _mkfs_dev "-s size=3D4096" $img_file
> +               ;;
> +       btrfs)
> +               _mkfs_dev $img_file
> +               ;;
> +       *)
> +               _mkfs_dev $img_file

You making a wrong assumption that FSTYP can format the loop devices

You should add _require_block_device $SCRATCH_DEV
to all your tests or maybe nicer, add:

_require_loop_mountable which requires loop and block dev fs
and use this requirement instead of just _require_loop in all tests.

Thanks,
Amir.
