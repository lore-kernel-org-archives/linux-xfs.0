Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC752F50A
	for <linux-xfs@vger.kernel.org>; Sat, 16 Dec 2023 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FI3ACOAY"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-58dd5193db4so405670eaf.1
        for <linux-xfs@vger.kernel.org>; Sat, 16 Dec 2023 07:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702741830; x=1703346630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nAWbv2szAoqqpAXpZZGjH1R+3FFAfM0pYHIhUPNv9M=;
        b=FI3ACOAYd3qZ0x0AzgtUse7LmcrgtmU2wfhgD+Dj+/BGWvU8PhYsFSMSVWRw2i2gdg
         qCKjPiSk3A37yjaUmoJN4s1UcBRaEVdJUgjZQ5/pWzyKXTRlHKFD1onk9a+xujEqQVtr
         VvUcpDV+1CKDPdTcd9LeUNB3JYxiXQMbWYaNXnCI6nGTj+/RwuLITXwChrhqDZ4rymge
         V0hsRT/T1yM1/W5gnQMKIUc5XDD7Dvat+iGKJwe9sdHPUTOhxt8IkPsSmGcIYPQXZB88
         jwQ0Kh8WbTEQDbacVHbx97GqbOYu/oiZwAU5P9iHdr+N60c4VSMvxdOhrEJSRE41CulP
         F0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702741830; x=1703346630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1nAWbv2szAoqqpAXpZZGjH1R+3FFAfM0pYHIhUPNv9M=;
        b=IQ29MuZNJdobRCCkagd/4ENetjuXRxr0STYpA/R2gZKp4B6pEspEkqJSg+2MnXxCI+
         wrZSMAZjOYm8Fo+pI92DDuarjFLCR7qj+FHpezTHy0jOiJrExjOKIaf3uj84i3THWmG+
         gzwQI8EauKRNfcQ6JkzjLBW3rHX7uZqonbvCdfV5X0DQK51KebdKzm+utQEMMeIV9SSe
         n9uE6+Fv6Nd61ARalA6xrVweKM5QBtjIBKx22w4APXCvALlBcl5HYhvkXS1V6vm7msRe
         Z1xdCAI6A+v+A+osfSVYLlYyNEHwo2bEoEOexBLIitMXr96ERWyc9rXAWge/diyhQdu+
         m6nw==
X-Gm-Message-State: AOJu0YwRz4KQJA+hf0tWyqz5i9lMGgRpcT62DqXoQmi7X9PppJWNBkkf
	BN20OmBiTd23cpU0yolwZJgevWvUTXamqtRr8PE=
X-Google-Smtp-Source: AGHT+IEa+XI05E2e9QwZsoudmZjdJkMqGlT6FEgoGDtBUlWQuL8pwV3WjnpZTSa7/MmrnDHXs1TMqLy9GpJ+Yw66H2s=
X-Received: by 2002:a05:6820:2d44:b0:58d:be0d:6f7b with SMTP id
 dz4-20020a0568202d4400b0058dbe0d6f7bmr21997839oob.1.1702741830122; Sat, 16
 Dec 2023 07:50:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214150708.77586-1-wenjianhn@gmail.com> <ZXtwBg3GUJLDydlW@dread.disaster.area>
In-Reply-To: <ZXtwBg3GUJLDydlW@dread.disaster.area>
From: Jian Wen <wenjianhn@gmail.com>
Date: Sat, 16 Dec 2023 23:49:53 +0800
Message-ID: <CAMXzGWJMJRFF8gxuX6aHh4tUOyr0c3K0=dNX-S970dJwYP6AJQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: improve handling of prjquot ENOSPC
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, 
	Jian Wen <wenjian1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 5:13=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Thu, Dec 14, 2023 at 11:07:08PM +0800, Jian Wen wrote:
> > Don't clear space of the whole fs when the project quota limit is
> > reached, since it affects the writing performance of files of
> > the directories that are under quota.
> >
> > Only run cow/eofblocks scans on the quota attached to the inode.
> >
> > Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> > ---
> >  fs/xfs/xfs_file.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index e33e5e13b95f..4fbe262d33cc 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -24,6 +24,9 @@
> >  #include "xfs_pnfs.h"
> >  #include "xfs_iomap.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_quota.h"
> > +#include "xfs_dquot_item.h"
> > +#include "xfs_dquot.h"
> >
> >  #include <linux/dax.h>
> >  #include <linux/falloc.h>
> > @@ -803,8 +806,18 @@ xfs_file_buffered_write(
> >               goto write_retry;
> >       } else if (ret =3D=3D -ENOSPC && !cleared_space) {
> >               struct xfs_icwalk       icw =3D {0};
> > +             struct xfs_dquot        *pdqp =3D ip->i_pdquot;
> >
> >               cleared_space =3D true;
> > +             if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount) &&
> > +                     pdqp && xfs_dquot_lowsp(pdqp)) {
> > +                     xfs_iunlock(ip, iolock);
> > +                     icw.icw_prid =3D pdqp->q_id;
> > +                     icw.icw_flags |=3D XFS_ICWALK_FLAG_PRID;
> > +                     xfs_blockgc_free_space(ip->i_mount, &icw);
> > +                     goto write_retry;
> > +             }
>
> This is just duplicating the EDQUOT error handling path for the
> specific case that project quota exhaustion returns ENOSPC instead
> of EDQUOT.  i.e. the root cause of the problem is that project
> quotas are returning ENOSPC rather than EDQUOT, right?
>
Yes, it is.
> Perhaps we should look at having project quotas return EDQUOT like
> the other quotas so we get the project quota block scan done in the
> correct places, then convert the error to ENOSPC if we get a second
> EDQUOT from the project quota on retry?
>
I did so by only returning EDQUOT in xfs_trans_dqresv(), it made error
handling more complex.

And after we get a second EDQUOT, we still need to check if it is
project quota that is over limit.
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com



--=20
Best,

Jian
