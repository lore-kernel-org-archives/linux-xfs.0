Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E2264612
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772156094; cv=pass; b=gH13utT1SxpzhH7jeOmQG1LtwhPbHq30oMZH2RZeVIXUnQj6qeH23n1hSlyiuwWMU6PoF+z2oeU/t0yd0xIvCu9MxRmUurczTk4zmgI0Je/5zxtuwusSiJVEuhWL86lJZOQwMLhFDo/RYEuVlyCj6sQy9Qw5LwoZ8hXeOdF0r94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772156094; c=relaxed/simple;
	bh=z+/M+lo5ksz1TRd449byu/D3ls0drNyd6IdGp40lVms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pnNMV0Cjf9+qg5Auzaz6zx9ja7xGWFDKRhneV0y25E3vlfIionNcXONmQF+ylQJKjVqnO0IN3XN+a5YmuxPrqH7k1YKGhIdTi3zeY8d+AH0/Jp7tIL2AddipN2iIyclulBdkKdbI2CtYAoA/cxWtdCDu0zXM9SOxMqwYkgIFZik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rddm3gQ1; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rddm3gQ1"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65a38c42037so5825a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 17:34:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772156091; cv=none;
        d=google.com; s=arc-20240605;
        b=Jpp79nyyQpfqnW9IyCKKHKbLi+3kO2hezgcxxI45cMsTdd2LTFvCi1UyjSuVE2VbP2
         voPhWlg2Gia3IYB4Mbm8+MsjV46mmBe9QADlCrJDX+m9qiiqH6DsfG1ZAxTliGqEWhi0
         y+lCVJTIhV0ZajA8rPEMYeVt5QHXm1QIEm1V18MPmxxPdmmRQ2IF2Kk0IvN3+4IBcnq9
         /FXFisD7FwElInsM/SHFP5IKOOtR/oswC/p+73U87f0nysBmtKwQPsHgMjMuF+hqfM1v
         B0e/oXKHZ1ITsCXTT8dQCG7W6oeyFVkqRkALogwfWAhFRqiWu3SVoapRO4cy2XC8UAI6
         kGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        fh=IL8JcOtLFyAKyZgDWV+TvtdXdB4fOfDrSIFO4oihj4g=;
        b=X4GmbN8AIBJ1bcTbJoZsMOlNwQYeIB7a4Ag+t2G+JKoCbTNhA41prEgiOtY6TDKdyQ
         nOFwB+80a5fDysoG4HIc3KJD3zWvw+hfOslgrB+O1YJVDSS0pUHNasobo4yM6i+lw5oq
         pKypMKiL3H5DSDhJDe1E05Xe1UXCFqMlCUwbctEPrsy9GzY4m30QRTYQZStFT44P9T7E
         fVvjYgKsr6JVrlF6GYzPVVK1B/GiJFpiP7Vrrq+MF1Zo1pq2cT3K+NOg/5GXKSqpZfJT
         gUyOCghf797wXrU1ZeQSydaURxDXUjTvzCjX7MmTI2wsBJm6W1WTd4JkYeZ0/rgzw6D5
         Ciow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772156091; x=1772760891; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        b=rddm3gQ1poAClVezwlhFzOklnlG2jCOcA8fPH+hPp39nqDYzbC13+YaQ5knel9Nc4X
         9txnBTkpriryN3sCntMm14YJHjPutq9y4fdcbgrBcx8QOfsslKMJRmijVl4Qr0dLfNmX
         sZ/QORdUvMtqPpg8a/G/Ao4vAZ6lxE5RahFokvAfNkUQCX6j5jlPFrA43P0Cfod1RJkD
         M0Ud3vrqyldiAZKDKgQ2bToAoJrckOSlpN1PLMP131kbZ/zi1uiaPq18LBiIt36QsWIt
         30JJ8ovJkBBLtU1MCuG7CwqmlwVn4f7QXR9ix1yfdhJb+4sHBp246ezHLS7EBQ8rPioS
         qnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772156091; x=1772760891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        b=hWRM9TtCWT35dbtb97FvBf61dde62gXP4E0KEmCx1M1iVHOY3mZ9DqoXCECeHm6aUd
         xTtC9qnG2tL3bnKXLvh3S5lUO1ZpB3ZVvOy6Jqe9NKnd3//gJuUPElKi3oe1LpmU+m+Z
         p79cpNH758jOIQtrBZbUrY+lLswQFdV1JiddtbrImGM8dMgkklElltqWvmGXJIByP9rv
         4Md8CfVzMrRSce6nsLIMqX62+6fVJaKX+XQnV/U3Tjwq/A3okuXUtdjO/Awqmw/ezAkv
         lKuxtsSF7ISB+rHDAbHEpopFErf/xfOElfSRlbXmgX5vweTZV2Pzq42U057ob5ztAR9W
         Ucsw==
X-Forwarded-Encrypted: i=1; AJvYcCVZ5W+4FtOYNoScYhLnZclXywDEkdjw/6LO6Mda+V8gpWaJoVC5jfG+J31dksQ1bREFjZ6zufzRbJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGq0Fgdp0LkX01yaweYuZrQcq4MKGcI/7hUIPnNGMgW69xP2Bz
	YN2qsjAOz7m12P9ji53OMxUil+/xCLTvCJhZMZCfT2PjOs5H1Bep9fRaLo8daYCjBC3/KjUELpk
	a7RJk6+p5a0owUtVGSxYptBgp2M/ZzRmYBG93c2Cz
X-Gm-Gg: ATEYQzyMSa83XoXXwyajViOl4kc6EtbvgFYiE49ZrCL1XNXCu3y+sqdv4/n7jd1A3dL
	lL88NM1PRGGaibMahBgpLuT0VT7+ebW8wDIcPvTcJVAq5rZkqwLSf/ZjwRIT8REbbXDXIGEA5yR
	L+WDL6OgugV+LxYTz30bOLRAM2ha1W0ocg6yWpzsxs1hzpj9y4sq7MgEwyrzeICi7+s6N5kB+o2
	BCHnhNIV4RhMuaBJAatqHhMS0Vdmy8Tw/QayW/lf2/vtICAE4p7LYr2ZnQWfU+wFXZzadla2XdA
	TxBnxqxATzqf79Fhiw8B6rSrk0+PssLAhuK7Fw==
X-Received: by 2002:a05:6402:4619:10b0:65f:76c8:b92f with SMTP id
 4fb4d7f45d1cf-65fab2c4155mr103050a12.0.1772156090158; Thu, 26 Feb 2026
 17:34:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619111806.3546162-3-yi.zhang@huaweicloud.com>
 <20260225000531.3658802-1-robertpang@google.com> <7d2a3f65-4272-46c1-991a-356f0d2323cb@huaweicloud.com>
 <CAJhEC05L7QEc9iY7gFZVK3SPYvFhtFyURss6xQgZ-qWwZZkFjA@mail.gmail.com> <8a45c55f-8abe-4cdf-be70-208550edf320@huaweicloud.com>
In-Reply-To: <8a45c55f-8abe-4cdf-be70-208550edf320@huaweicloud.com>
From: Robert Pang <robertpang@google.com>
Date: Thu, 26 Feb 2026 17:34:38 -0800
X-Gm-Features: AaiRm52oy9vcXDycCt3HX0a8oowZo0wXmgzHk3BLllBwVjMbefXMCEMxh3i5upc
Message-ID: <CAJhEC04Vpo96SKN7iRjV0fUKXEj3oQ698RdoVAdWjRjVLpgvGw@mail.gmail.com>
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

On Thu, Feb 26, 2026 at 3:09=E2=80=AFAM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> On 2/26/2026 5:43 AM, Robert Pang wrote:
> > Dear Zhang Yi
> >
> > Thank you for your quick response. Please see my comments below:
> >
> > On Tue, Feb 24, 2026 at 6:32=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.=
com> wrote:
> >>
> >> Hi Robert!
> >>
> >> On 2/25/2026 8:05 AM, Robert Pang wrote:
> >>> Dear Zhang Yi,
> >>>
> >>> In reviewing your patch series implementing support for the
> >>> FALLOC_FL_WRITE_ZEROES flag, I noted the logic propagating
> >>> max_write_zeroes_sectors to max_hw_wzeroes_unmap_sectors in commit 54=
5fb46e5bc6
> >>> "nvme: set max_hw_wzeroes_unmap_sectors if device supports DEAC bit" =
[1]. This
> >>> appears to be intended for devices that support the Write Zeroes comm=
and
> >>> alongside the DEAC bit to indicate unmap capability.
> >>>
> >>> Furthermore, within core.c, the NVME_QUIRK_DEALLOCATE_ZEROES quirk al=
ready
> >>> identifies devices that deterministically return zeroes after a deall=
ocate
> >>> command [2]. This quirk currently enables Write Zeroes support via di=
scard in
> >>> existing implementations [3, 4].
> >>>
> >>> Given this, would it be appropriate to respect NVME_QUIRK_DEALLOCATE_=
ZEROES also
> >>> to enable unmap Write Zeroes for these devices, following the prior c=
ommit
> >>> 6e02318eaea5 "nvme: add support for the Write Zeroes command" [5]? I =
have
> >>> included a proposed change to nvme_update_ns_info_block() below for y=
our
> >>> consideration.
> >>>
> >>
> >> Thank you for your point. Overall, this makes sense to me, but I have =
one
> >> question below.
> >>
> >>> Best regards
> >>> Robert Pang
> >>>
> >>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> >>> index f5ebcaa2f859..9c7e2cabfab3 100644
> >>> --- a/drivers/nvme/host/core.c
> >>> +++ b/drivers/nvme/host/core.c
> >>> @@ -2422,7 +2422,9 @@ static int nvme_update_ns_info_block(struct nvm=
e_ns *ns,
> >>>          * require that, it must be a no-op if reads from deallocated=
 data
> >>>          * do not return zeroes.
> >>>          */
> >>> -       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)))=
 {
> >>> +       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)) =
||
> >>> +           (ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> >>> +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
> >>                                 ^^^^^^^^^^^^^^^^^^
> >> Why do you want to add a check for NVME_CTRL_ONCS_DSM? In nvme_config_=
discard(),
> >> it appears that we prioritize ctrl->dmrsl, allowing discard to still b=
e
> >> supported even on some non-standard devices where NVME_CTRL_ONCS_DSM i=
s not set.
> >> In nvme_update_disk_info(), if the device only has NVME_QUIRK_DEALLOCA=
TE_ZEROES,
> >> we still populate lim->max_write_zeroes_sectors (which might be non-ze=
ro on
> >> devices that support NVME_CTRL_ONCS_WRITE_ZEROES). Right? So I'm not s=
ure if we
> >> only need to check for NVME_QUIRK_DEALLOCATE_ZEROES here.
> >>
> > The check for NVME_CTRL_ONCS_DSM is to follow the same check in [3]. Th=
ere, the
> > check was added by 58a0c875ce02 "nvme: don't apply NVME_QUIRK_DEALLOCAT=
E_ZEROES
> > when DSM is not supported" [6]. The idea is to limit
> > NVME_QUIRK_DEALLOCATE_ZEROES
> > to those devices that support DSM.
> >
>
> OK.
>
> >>>                 ns->head->features |=3D NVME_NS_DEAC;
> >>
> >> I think we should not set NVME_NS_DEAC for the quirks case.
> >>
> > Make sense. In that case, will it be more appropriate to set
> > max_hw_wzeroes_unmap_sectors in nvme_update_disk_info() where
> > NVME_QUIRK_DEALLOCATE_ZEROES is checked? I.e.
> >
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index f5ebcaa2f859..3f5dd3f867e9 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -2120,9 +2120,10 @@ static bool nvme_update_disk_info(struct
> > nvme_ns *ns, struct nvme_id_ns *id,
> >         lim->io_min =3D phys_bs;
> >         lim->io_opt =3D io_opt;
> >         if ((ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> > -           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM))
> > +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
> >                 lim->max_write_zeroes_sectors =3D UINT_MAX;
> > -       else
> > +               lim->max_hw_wzeroes_unmap_sectors =3D UINT_MAX;
> > +       } else
> >                 lim->max_write_zeroes_sectors =3D ns->ctrl->max_zeroes_=
sectors;
> >         return valid;
> >  }
> >
>
> Yeah, it looks good to me.

Thank you for your confirmation. I will follow up and submit the patch
to other maintainers for their review.

Best regards,
Robert

> Best regards,
> Yi.
>
> > Best regards
> > Robert
> >
> >> Cheers,
> >> Yi.
> >>
> >>>                 lim.max_hw_wzeroes_unmap_sectors =3D lim.max_write_ze=
roes_sectors;
> >>>         }
> >>>
> >>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D545fb46e5bc6
> >>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/nvme.h#n72
> >>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/core.c#n938
> >>> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/core.c#n2122
> >>> [5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D6e02318eaea5
> > [6] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D58a0c875ce02
>
