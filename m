Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70383C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 15:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4779B22304
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 15:49:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U/r3X0QS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfKSPtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:49:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49162 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727937AbfKSPtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 10:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574178542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFSVcSgbipZyRlk8K1bqc7oIByTs/iVjCQ6yrfamVJ8=;
        b=U/r3X0QSPAen6jyreSVMe1g0Fh6dAKNdHqHgfpz/NJxOImWuu5dV5frpFmNQv/oM/bhI+7
        vr+QEwfmSSRCiKMzazFQonugsBx7u63ktYl8aGibEa1Qp94ghT6IuZFJzFox+he9OrZnvZ
        nrgpU9ga0zoid50b/hJvDCm3UtZEq9k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-iA9n2DCRPIaWHGeNG_0VeQ-1; Tue, 19 Nov 2019 10:49:00 -0500
Received: by mail-wm1-f70.google.com with SMTP id t203so2487066wmt.7
        for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2019 07:49:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=FMSJPDR63EJrIPR1+nUbPPHh37H+XzyOdUC+9dQfMs4=;
        b=r0qCFjhMIA5K4j66sl2rjFWp7FXGAgqXmLiQGGZIm9ymbs1G4ZUGA+FG/RpvsiibZq
         hFFtIwFt/DhlbXwJmXwtauc3sLIOgp664kNMilw7VK6p3v0pZI3cv50pVXC7gO8j/0xv
         t7adI70snTwEuPszwGhnfvggAG6XGY12lF6BPd9nArSc4I+ZTtHRDXydG7fMl8WFb2KW
         rvNAyFk6F8h/JBMNXM/igbFWnlOQpupWSjTTyhp4xQDcGibx+jAjAtOo3B7fYXkOnpv7
         3m/tv8J0/71uQEDQh3IfvXfvg3LFWrAzAXt+AiwHGBGNJ/CdoNiC5M8cMyrz1kfOcp68
         YpWA==
X-Gm-Message-State: APjAAAU9t35w8XokHcgYcFzbF7c/dABRytEDS1zF/QTLt8OtZmXfIzr1
        kz9LMVL+fkRvL+MahRwDbcyU1fxJIsisfujCR2B0OVrJ6bhADDEnWSkTL7k5TjxVw41I7ACe+Q4
        Uqtq9NitIMjPSaV70O9EH
X-Received: by 2002:a5d:574d:: with SMTP id q13mr40890402wrw.263.1574178539480;
        Tue, 19 Nov 2019 07:48:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqxcw92FXSaZnSfO7QkWpXBlglnL6PqQXPsqc995ylOTVgmePezGpKFONbqDwB6pdGlWcXDo/A==
X-Received: by 2002:a5d:574d:: with SMTP id q13mr40890375wrw.263.1574178539264;
        Tue, 19 Nov 2019 07:48:59 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a11sm3654335wmh.40.2019.11.19.07.48.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 07:48:58 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:48:56 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Forbid FIEMAP on RT devices
Message-ID: <20191119154856.eyf5ztphjmjihy6x@orion>
Mail-Followup-To: linux-xfs@vger.kernel.org
References: <20191119154453.312400-1-cmaiolino@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191119154453.312400-1-cmaiolino@redhat.com>
X-MC-Unique: iA9n2DCRPIaWHGeNG_0VeQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 04:44:53PM +0100, Carlos Maiolino wrote:
> By now, FIEMAP users have no way to identify which device contains the
> mapping being reported by the ioctl, so, let's forbid FIEMAP on RT
> devices/files until FIEMAP can properly report the device containing the
> returned mappings.
>=20
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>=20
> Hi folks, this change has been previously suggested by Christoph while th=
e
> fibmap->fiemap work was being discussed on the last version [1] of that s=
et.
> And after some thought I do think RT devices shouldn't allow fiemap calls
> either, giving the file blocks will actually be on a different device tha=
n that
> displayed on /proc/mounts which can lead to erroneous assumptions.

Fingers are faster than my brain:

[1]: https://lore.kernel.org/linux-xfs/20190918132436.GA16210@lst.de/T/

>=20
>  fs/xfs/xfs_iops.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index e532db27d0dc..ec7749cbd3ca 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1138,6 +1138,9 @@ xfs_vn_fiemap(
>  {
>  =09int=09=09=09error;
> =20
> +=09if (XFS_IS_REALTIME_INODE(XFS_I(inode)))
> +=09=09return -EOPNOTSUPP;
> +
>  =09xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
>  =09if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
>  =09=09fieinfo->fi_flags &=3D ~FIEMAP_FLAG_XATTR;
> --=20
> 2.23.0
>=20

--=20
Carlos

