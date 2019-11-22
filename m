Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DF4C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 14:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449532071F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 14:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIvA4yPg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfKVOqy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:46:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39832 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbfKVOqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 09:46:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574434012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=poXlYyuR5hbKZyt+2XTPlfqFLp3PRqBPWZ8y2g6VDnU=;
        b=gIvA4yPgZPdNAjnqEpbY0FWoGEeykv3NFddetM9Mx6KGqI89EiByfCM4si0OLvJwaIl/3J
        Wz+XHyrqAedig6te/raBB32HXYoNGyPVV5/EuDvd8RN6AGscMPTiZzobX0odgk4um5YhWT
        98jY6hDvtg2ewfzlVL0jUtEwPe5wg6U=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-P5GX2781OkSrE2QhUCe53w-1; Fri, 22 Nov 2019 09:46:51 -0500
Received: by mail-vk1-f197.google.com with SMTP id t128so2977286vkb.9
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 06:46:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5kcWD6HidoJD9L1yuypcIvgpDD3p1VAqRGcuUGWfCs=;
        b=kchJ22pI06xQJ24qmnIL6CoAK0nAdo+1dclFuMJlTdVmqbJxajq+qmS03kwMRBPGbH
         DEr6XGKC1DmVBfubxtBCboVemTbiy4NGpTzokzCZCLa2luTKwXvKzTRW20cBn7pzg/4B
         c7twxl7WAr4Jjb9mOHz0fklWZQ3v+F8Gq4NcPgiQdVprZxHZSCPxp3U2Ln2gw8MDBVFn
         Ak4i7u1n2J38n99HIk2BaG5ph8boCVCSoKAHlggzE23DD9vXQh+DsV8I8xDBe9IKmp5A
         S43GFW19RJdYMkGqBG49VCZkX547XJNufWAigUzEuFajPLxtbgsEpkqEB+Ohj91/arlZ
         48/g==
X-Gm-Message-State: APjAAAU3eLMoioPlFy421th9LnpHGFT07MZS/bbcI6LfbSghaOvmmLsT
        mTNrqy5OOcqIrr21+7OAHEZh/qn6mue5NCLcQmVRDu3AKJbZri+1xuMtJyww7964tkPdRBOIvlG
        /p2V5MDlQFuci2+w4xc4qq5XHyx848D/OUAQ2
X-Received: by 2002:ab0:7403:: with SMTP id r3mr9606168uap.42.1574434010841;
        Fri, 22 Nov 2019 06:46:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqyxeQJVac2jnXhg2Wj07lUtZVL0e1/VtLOe2nj1cEkjKzsrGagLrD0TmYIujVsgqfW7+KVOVW63Nd+KmWh2TCw=
X-Received: by 2002:ab0:7403:: with SMTP id r3mr9606144uap.42.1574434010479;
 Fri, 22 Nov 2019 06:46:50 -0800 (PST)
MIME-Version: 1.0
References: <20191121214445.282160-1-preichl@redhat.com> <20191121214445.282160-2-preichl@redhat.com>
 <20191121215501.GZ6219@magnolia>
In-Reply-To: <20191121215501.GZ6219@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Fri, 22 Nov 2019 15:46:39 +0100
Message-ID: <CAJc7PzW+ibAZ_tPJ_oRPAdfhbop59z53C2pLxmENzWDCu+Gcrg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
X-MC-Unique: P5GX2781OkSrE2QhUCe53w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks Darrick for the comments. It makes sense to me, the next
iteration of the patchset will address that.

On Thu, Nov 21, 2019 at 10:57 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Thu, Nov 21, 2019 at 10:44:44PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 32 +++++++++++++++++++++++++-------
> >  1 file changed, 25 insertions(+), 7 deletions(-)
> >
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 18338a61..a02d6f66 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -1242,15 +1242,33 @@ done:
> >  static void
> >  discard_blocks(dev_t dev, uint64_t nsectors)
> >  {
> > -     int fd;
> > +     int             fd;
> > +     uint64_t        offset          =3D 0;
> > +     /* Maximal chunk of bytes to discard is 2GB */
> > +     const uint64_t  step            =3D (uint64_t)2<<30;
>
> You don't need the tabs after the variable name, e.g.
>
>         /* Maximal chunk of bytes to discard is 2GB */
>         const uint64_t  step =3D 2ULL << 30;
>
> > +     /* Sector size is 512 bytes */
> > +     const uint64_t  count           =3D nsectors << 9;
>
> count =3D BBTOB(nsectors)?
>
> >
> > -     /*
> > -      * We intentionally ignore errors from the discard ioctl.  It is
> > -      * not necessary for the mkfs functionality but just an optimizat=
ion.
> > -      */
> >       fd =3D libxfs_device_to_fd(dev);
> > -     if (fd > 0)
> > -             platform_discard_blocks(fd, 0, nsectors << 9);
> > +     if (fd <=3D 0)
> > +             return;
> > +
> > +     while (offset < count) {
> > +             uint64_t        tmp_step =3D step;
>
> tmp_step =3D min(step, count - offset); ?
>
> Otherwise seems reasonable to me, if nothing else to avoid the problem
> where you ask mkfs to discard and can't cancel it....
>
> --D
>
> > +
> > +             if ((offset + step) > count)
> > +                     tmp_step =3D count - offset;
> > +
> > +             /*
> > +              * We intentionally ignore errors from the discard ioctl.=
 It is
> > +              * not necessary for the mkfs functionality but just an
> > +              * optimization. However we should stop on error.
> > +              */
> > +             if (platform_discard_blocks(fd, offset, tmp_step))
> > +                     return;
> > +
> > +             offset +=3D tmp_step;
> > +     }
> >  }
> >
> >  static __attribute__((noreturn)) void
> > --
> > 2.23.0
> >
>

