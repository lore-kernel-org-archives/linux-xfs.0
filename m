Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9B2C1599;
	Thu, 10 Jul 2025 10:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752143177; cv=none; b=u6Lv/zJ1PGPOfwWSiC7ZTgoTqifu1DGnKqIsxhZBsKsL2dGhi4NAqudDJBl+T5rSkRwXcOxuoLSTxGdj8ispslv06LhUS3IkitR94BT2+WP31cL+TIHMeHEaYOqZOtL/jDtcZWAPFneTn1Tf9oXbvICe/plfRXI1Uiu2H+ZIiCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752143177; c=relaxed/simple;
	bh=dNJ2BlI7nka+u3xFOW98qNIIsNrxtNUmHoEVzVrCpqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DmA0K0Dq4vSid7RCG9jIZkm8isajfWGpPJfhu+KA4dH0tV04fC8T7tWByTaI2vr6ajyOKLaAvzxpyIjgFuqizI3kSM0+H6Pep8/ewO2Bnt/jZe9iHHB8L4pLcRekwXTm/jPadyWWN5TYDofMkp/83Cu+Uvspu1NB2XSQX5MdMaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lPZDo0pF; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lPZDo0pF"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55516abe02cso863159e87.0;
        Thu, 10 Jul 2025 03:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752143173; x=1752747973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiwExPst7XweTj0HPRw/VeccnikzVdQnHxSZ/nSW2RY=;
        b=lPZDo0pFDAsezgTkGDAKxAMjsvZnaqfvTze5ibqcE9li8e1IS9EV+UW0WKPOSmz9TD
         dpZUBVQHEBWuDbQWMRqvV9zTuSapMjJgkprllWde38UBQTjl+t+EeBKDHlQRCLfdpNiI
         s9/YEeATXYhVTZENlYVJXN+20WaAFS+ltCO6O/kvWGMt6Op3KDoMH/KwS6t9UFoMNIyM
         i9i5U1NJFAn7tS8sWc0E5zdqcoAflej+FRrS364ruglJhcC5K+CaBz0NKQAATEHHjos+
         9lR3YgxNWwhCpZjyWhsR0qBdfq8vpcnyRlWLIQjFbljBFkdGtKavi3Ew66m7AwH2C3f8
         xsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752143173; x=1752747973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XiwExPst7XweTj0HPRw/VeccnikzVdQnHxSZ/nSW2RY=;
        b=V5zkcSS9o+y2WRHCEw6RKAPYMDVlsObNiZmDjm19UVXYN9minizBlT+I4X2D1pgApA
         QbIlColKmTrc2NA+3SMr71matp+obIncBH/uqAF65g6RXxaHcWZpKwsP4mSVy49SecEz
         JVzaB7KCXgVct8tZzkZLTUvVGSn3+KzJKyj7RDbBPCaSVUadHvu2+HcAura4jT0u7wcz
         KCk8wJT8aYYPL4HW9r1ys6cP8ttWu+ZJhKaawxnGfRATyPDttzmhj4eWRA/ju5/bsuP9
         fkm5m3csDjjVvQPFYmUv8E6I2+ldVhGi/m1amGsTZdFCwI9b0NXPMFumOmmhwLln/d9b
         SrCA==
X-Forwarded-Encrypted: i=1; AJvYcCUGbnVxxVAuUA5WakJP9d6losrQCcHFCsb6uy1YNa+fS1EB2ttsAtLM5HgnT8s+hapULKRjUiI+ldg7LbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJQ3fxf5hzWHtfn2moHpP401oOWw4r/tSMmEFdjbIbj5amNujl
	9nSLPE1OwylMB3pMvC3msmacCb/BCmNFINaC6CI8bMitAIerJU3Z5lyh/jin+TVEhij+/ALYexj
	dmrGzRxCFtt0HcFTQLO0EFSNAK5HqeMyMBnFn
X-Gm-Gg: ASbGncsy60MOIGD4iHraJimyLVTQuUvDbi87Qleu167oSf/QsOAdmvXTMeSe9PVYm6S
	iT68epNIMmPxMsyzVnsFUh9/z3dXCC3AAuBfNof/wnGTtgK/mRuUiypcZKbU5CYA71f1M55lqHd
	4R3agHuEHiwZSvvStYIMHQGaoYGmmyMVUoBJGE24UPxoVSVcyiPfZlZmVBivpxbchTGAytFShZr
	rtt
X-Google-Smtp-Source: AGHT+IFidGHXl+2EEjCVlww/f/kyG374Q2YBQpzErMafktQNvPBNiIiW7AM3Qo4KbMeXfzQQanbGQft8qHovXPtWt6A=
X-Received: by 2002:a05:6512:4023:b0:553:ac0c:dce9 with SMTP id
 2adb3069b0e04-559007168eamr1015205e87.17.1752143172501; Thu, 10 Jul 2025
 03:26:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704101250.24629-1-pranav.tyagi03@gmail.com>
In-Reply-To: <20250704101250.24629-1-pranav.tyagi03@gmail.com>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Thu, 10 Jul 2025 15:56:01 +0530
X-Gm-Features: Ac12FXwsF8ofN1uPqgzPPxs2ghXYYUrrumicdJlsv8eXTaje2HanDawqxzc7snM
Message-ID: <CAH4c4jLCyb3kF0G25GU2JpPVkOXrgMTtMF+NTWgJpXBoEUaA5w@mail.gmail.com>
Subject: Re: [PATCH v2] fs/xfs: replace strncpy with memtostr_pad()
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: cem@kernel.org, djwong@kernel.org, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 4, 2025 at 3:42=E2=80=AFPM Pranav Tyagi <pranav.tyagi03@gmail.c=
om> wrote:
>
> Replace the deprecated strncpy() with memtostr_pad(). This also avoids
> the need for separate zeroing using memset(). Mark sb_fname buffer with
> __nonstring as its size is XFSLABEL_MAX and so no terminating NULL for
> sb_fname.
>
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 2 +-
>  fs/xfs/xfs_ioctl.c         | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 9566a7623365..779dac59b1f3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -112,7 +112,7 @@ typedef struct xfs_sb {
>         uint16_t        sb_sectsize;    /* volume sector size, bytes */
>         uint16_t        sb_inodesize;   /* inode size, bytes */
>         uint16_t        sb_inopblock;   /* inodes per block */
> -       char            sb_fname[XFSLABEL_MAX]; /* file system name */
> +       char            sb_fname[XFSLABEL_MAX] __nonstring; /* file syste=
m name */
>         uint8_t         sb_blocklog;    /* log2 of sb_blocksize */
>         uint8_t         sb_sectlog;     /* log2 of sb_sectsize */
>         uint8_t         sb_inodelog;    /* log2 of sb_inodesize */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d250f7f74e3b..c3e8c5c1084f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -990,9 +990,8 @@ xfs_ioc_getlabel(
>         BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>
>         /* 1 larger than sb_fname, so this ensures a trailing NUL char */
> -       memset(label, 0, sizeof(label));
>         spin_lock(&mp->m_sb_lock);
> -       strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> +       memtostr_pad(label, sbp->sb_fname);
>         spin_unlock(&mp->m_sb_lock);
>
>         if (copy_to_user(user_label, label, sizeof(label)))
> --
> 2.49.0
>
Hi,

This is a gentle follow-up on this patch. I would like to
know if there is any update on its state.

Regards
Pranav Tyagi
