Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B038E31691C
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772055828; cv=pass; b=GNj0LPjWGYkfGB9oe4+Qwb6wMPO7/BSKtRlV4mbduwNTtuDOjIjFCa4T7VhrclBL2i/x9lVNHrzERGJIHTflXkKpOSxOh6v2uJN6cr+9GNlpJeOHFPMFHmWmhuCd6aa9Jt8zTRoQK9gBLiANATZdKfyrfECw8HdYET2SOIAlwog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772055828; c=relaxed/simple;
	bh=hoZBQczrzcuyVPOXD+tTAmFlTYabJ94zI9Irylb/EVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iaLkvgsPA9RETSKHeJ6NB6qJMIcEtj30efUnhLKg9sFGBOMfea5CR5+vuFqh1jBPSAqBTlo6RmXtDTNn1UFZ7mWixw8qohMEeld7+9huGjs3SwEAaTWVLaGihUPx4qihOU8OYq3aFrqvIeqO/dNzIQhKhLgBfuwDF1FddmaCdkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DcXnIIPe; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DcXnIIPe"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65f3a35ff13so3619a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 13:43:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772055824; cv=none;
        d=google.com; s=arc-20240605;
        b=iH+kNR6a5OUhzudkV35XTvPHdQCRnLUxm2y+NGOtq21C5RaNvLkwfbNmvPIq8s3+KK
         ZZis+AiS/JfFZW9zsr2nXiK4XQUqIOb6HwxaP9mOlK2zD9qZy8UcgLPN11mv31VgrXkh
         YUJu9om+IsI7EuUrs9m0KRx34LVf9X60zeAhtWqq4psZaUL60WmPdVGRjh9wUe+mh/b4
         KDJtW6+TXMiypw8bzotU5etWbNRL/OcsfKmBq/VShJz6fktTmrfCGW3HF3nm2IiyCF4V
         DE0mRMItyMKjtK/Z+Yzk6Aq8m+lUXreApHIGUPvuUCHObaeoufwkWYNE+qKT0fzqgbSX
         s02Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vB9FeLIHdzkOeJQl8sZ1jnIIU5NTPuPRUQDCv7qOk1c=;
        fh=ryhpwwwf7BZFCo+wZblif4F1p5z8zzLWggxmawXQhd0=;
        b=TJguxANMB+NsakwJNLsdBQrZFET2H2tnY3QqZYF9Q7YR0q2UUUxbO0raro2Zij2jDk
         1mGF1RCfMiCzxJHx83VyQwa3U/oNlJR1RLXa70W4YS21K0Aw39dhoU08NTBthww/C3Zt
         iwVoBwtK+fI3BhljYN1oqPUE/bQCjFsFxmmxLhWsL0K8WGVokpMgtBfPjX96/ZT5ZG37
         oJ9zPXb1tGD6wyksMk59rKnwWzNoGig0yKBlniSWj0adjY1EloU364rgEUINSGhfwG1m
         fO5cb5Hg8Z3PV9BW9bcAScMXyjG4D0W3m4OqDjF1sFPRAwzgx9luSAvKDzQrlIEMxbe1
         AFCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772055824; x=1772660624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vB9FeLIHdzkOeJQl8sZ1jnIIU5NTPuPRUQDCv7qOk1c=;
        b=DcXnIIPehOR7Zcc84tU5ax/4/X+fJQQXdh6G/qeIGgAwD6QNLuPBvyozFNu04p1olg
         g2ioHyEBoajIsPgNamu8pOCASAUioThGOznYmtfFxA2PNCUI/goNDca2bs4YaC57UiMX
         hrNrJLYnxtIrwCeUCMpB65/mfvXVpuwHhNmB8r2rpeEZVUk9JmP1VTBaWsG8jXrjKXwl
         UiqonoSGe9mduDMaJoz8Kgszdb+iCjKBceJQZRl2elaXYdryJsUcOdQPBv+X7m1a9tcz
         uA3wykguwgIff37UR05C2cadCAQdbVnrzA/akWYG16NJ0Q72rMQDl7LjJp/0lKeJMubA
         Zb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772055824; x=1772660624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vB9FeLIHdzkOeJQl8sZ1jnIIU5NTPuPRUQDCv7qOk1c=;
        b=VUpC3lRr09eVYc0dpMqKD6teZ5CVcSoCYwfhvchkG/6FNj4OL0rzNMFtiUtSB0N28K
         3Ec3zUbw+4xdeCLhhfuQVMtvNoS8+N5rW20OdVlmhwK8e9UX8Mqn/5E6eQf/mCAxhRsJ
         RWO9qFlpOhbz9GWnDuW/mPmXRl3KXxqqCeh3LVjKLM/ge8UaR7khgmIpsI+YpWmcdhsm
         H08YaiEoW1wSJfVxGvvxWzeVNqUoPcEvSC+vAuBcHNLSZR9PMDEdgN9+m+Ao1SDJPPgk
         SzRfOI54yIDSQbfi8YWeBRZ4ifTiZxnEudqKTDTmBaP8YMt2WZbuMucirnRZUez3MR6K
         zq5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXfN8CODPhcXQrDDEJgOWpAqFjwdjt74atLZkzZeruRreGNutMKTcyDZ0ZcEBkf9BxakqPR1sj76cg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb0q0i/LErkuMEmdZbfBfgfwGt67SeMbyqby0zjqxSydSRJ37t
	gIe2zr9Us8Uv9qRfkkfLmr4mXX2BCzQmMpoUsJv+Ajys34nUt0aS64sEjKvzBl06jZA503Y6yz+
	AjDbdpl2rRtpo70D93Sr3eAYhNqRiT9NspE/9Dqz0
X-Gm-Gg: ATEYQzxcJZB5c59XUsA9G+aM4I8nmO8aF2QgyD1MupsVJ+KS8Bul6kJ8qtL0bH2hGFy
	Q1hAzvaRaH6I26lbQ8uvod0KYDAc55IKtBHvImyQ7rRk8VM2QUsBCJYfNOM9+7C2lQ4JGzR2H/H
	9ceBeKnGPkMrNnsi+wArP2FyvIdnK/O+SXds2u1hCv60pzty3DKg9iPfS0YJHF3Q61QSAuUH6T9
	q3ffjc9umcRSznBaUs/vbV6f+iU7uORx/1qO+C0tMi9ROMfs/f9CAL+/8TbGtu6aCP/IytoWhCv
	5zQTmEeD8vgUnyvcTvi+bxRYnDaleNnb7SmM2Q==
X-Received: by 2002:aa7:c7cf:0:b0:658:e7a:6fa7 with SMTP id
 4fb4d7f45d1cf-65fab61a7b0mr11377a12.4.1772055823405; Wed, 25 Feb 2026
 13:43:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619111806.3546162-3-yi.zhang@huaweicloud.com>
 <20260225000531.3658802-1-robertpang@google.com> <7d2a3f65-4272-46c1-991a-356f0d2323cb@huaweicloud.com>
In-Reply-To: <7d2a3f65-4272-46c1-991a-356f0d2323cb@huaweicloud.com>
From: Robert Pang <robertpang@google.com>
Date: Wed, 25 Feb 2026 13:43:31 -0800
X-Gm-Features: AaiRm53fO14_kYBnlB-QimzynwfGzteAR7wRZiT1Sf0awQgFveGcUyR_Z7IWsCY
Message-ID: <CAJhEC05L7QEc9iY7gFZVK3SPYvFhtFyURss6xQgZ-qWwZZkFjA@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] nvme: set max_hw_wzeroes_unmap_sectors if device
 supports DEAC bit
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Zhang Yi <yi.zhang@huawei.com>, bmarzins@redhat.com, brauner@kernel.org, 
	chaitanyak@nvidia.com, chengzhihao1@huawei.com, djwong@kernel.org, 
	dm-devel@lists.linux.dev, hch@lst.de, john.g.garry@oracle.com, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-xfs@vger.kernel.org, martin.petersen@oracle.com, 
	shinichiro.kawasaki@wdc.com, tytso@mit.edu, yangerkun@huawei.com, 
	yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Zhang Yi

Thank you for your quick response. Please see my comments below:

On Tue, Feb 24, 2026 at 6:32=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> Hi Robert!
>
> On 2/25/2026 8:05 AM, Robert Pang wrote:
> > Dear Zhang Yi,
> >
> > In reviewing your patch series implementing support for the
> > FALLOC_FL_WRITE_ZEROES flag, I noted the logic propagating
> > max_write_zeroes_sectors to max_hw_wzeroes_unmap_sectors in commit 545f=
b46e5bc6
> > "nvme: set max_hw_wzeroes_unmap_sectors if device supports DEAC bit" [1=
]. This
> > appears to be intended for devices that support the Write Zeroes comman=
d
> > alongside the DEAC bit to indicate unmap capability.
> >
> > Furthermore, within core.c, the NVME_QUIRK_DEALLOCATE_ZEROES quirk alre=
ady
> > identifies devices that deterministically return zeroes after a dealloc=
ate
> > command [2]. This quirk currently enables Write Zeroes support via disc=
ard in
> > existing implementations [3, 4].
> >
> > Given this, would it be appropriate to respect NVME_QUIRK_DEALLOCATE_ZE=
ROES also
> > to enable unmap Write Zeroes for these devices, following the prior com=
mit
> > 6e02318eaea5 "nvme: add support for the Write Zeroes command" [5]? I ha=
ve
> > included a proposed change to nvme_update_ns_info_block() below for you=
r
> > consideration.
> >
>
> Thank you for your point. Overall, this makes sense to me, but I have one
> question below.
>
> > Best regards
> > Robert Pang
> >
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index f5ebcaa2f859..9c7e2cabfab3 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -2422,7 +2422,9 @@ static int nvme_update_ns_info_block(struct nvme_=
ns *ns,
> >          * require that, it must be a no-op if reads from deallocated d=
ata
> >          * do not return zeroes.
> >          */
> > -       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3))) {
> > +       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)) ||
> > +           (ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> > +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
>                                 ^^^^^^^^^^^^^^^^^^
> Why do you want to add a check for NVME_CTRL_ONCS_DSM? In nvme_config_dis=
card(),
> it appears that we prioritize ctrl->dmrsl, allowing discard to still be
> supported even on some non-standard devices where NVME_CTRL_ONCS_DSM is n=
ot set.
> In nvme_update_disk_info(), if the device only has NVME_QUIRK_DEALLOCATE_=
ZEROES,
> we still populate lim->max_write_zeroes_sectors (which might be non-zero =
on
> devices that support NVME_CTRL_ONCS_WRITE_ZEROES). Right? So I'm not sure=
 if we
> only need to check for NVME_QUIRK_DEALLOCATE_ZEROES here.
>
The check for NVME_CTRL_ONCS_DSM is to follow the same check in [3]. There,=
 the
check was added by 58a0c875ce02 "nvme: don't apply NVME_QUIRK_DEALLOCATE_ZE=
ROES
when DSM is not supported" [6]. The idea is to limit
NVME_QUIRK_DEALLOCATE_ZEROES
to those devices that support DSM.

> >                 ns->head->features |=3D NVME_NS_DEAC;
>
> I think we should not set NVME_NS_DEAC for the quirks case.
>
Make sense. In that case, will it be more appropriate to set
max_hw_wzeroes_unmap_sectors in nvme_update_disk_info() where
NVME_QUIRK_DEALLOCATE_ZEROES is checked? I.e.

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f5ebcaa2f859..3f5dd3f867e9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2120,9 +2120,10 @@ static bool nvme_update_disk_info(struct
nvme_ns *ns, struct nvme_id_ns *id,
        lim->io_min =3D phys_bs;
        lim->io_opt =3D io_opt;
        if ((ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
-           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM))
+           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
                lim->max_write_zeroes_sectors =3D UINT_MAX;
-       else
+               lim->max_hw_wzeroes_unmap_sectors =3D UINT_MAX;
+       } else
                lim->max_write_zeroes_sectors =3D ns->ctrl->max_zeroes_sect=
ors;
        return valid;
 }

Best regards
Robert

> Cheers,
> Yi.
>
> >                 lim.max_hw_wzeroes_unmap_sectors =3D lim.max_write_zero=
es_sectors;
> >         }
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D545fb46e5bc6
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/nvme/host/nvme.h#n72
> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/nvme/host/core.c#n938
> > [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/nvme/host/core.c#n2122
> > [5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D6e02318eaea5
[6] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D58a0c875ce02
