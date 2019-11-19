Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE64C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 16:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCF392230F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 16:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ry40LmDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbfKSQud (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 11:50:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58253 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728483AbfKSQuc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 11:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574182231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZSr6aJbIwAbt0i4YaPCS1DXJ3G044mCGpatGmVY1OU=;
        b=Ry40LmDmFEcOYeax7JYcukfrRJIbACwX4JfBojJp3KHPItU6IcTmLxUp9waFaTMduNhzk7
        yOqDpttBxDnuaOS2VQbVaJt8tRXd72aTvIFUtbNfFEhfTggx55KaanhUUe2HjGqbIW+nYq
        8SaytvhMO+GWKF33/Ix+4c7eWfOxvYQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-inXHNQF7NparqgetPMRKBw-1; Tue, 19 Nov 2019 11:50:28 -0500
Received: by mail-wr1-f69.google.com with SMTP id q12so18786304wrr.3
        for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2019 08:50:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=z47WI+q07maCAJnrsJAuG47SN4OPzgCvR4LSJIlQ/Vk=;
        b=UtVVjcihyoxBf1TIBaIVE7bC4jjUwcii2Doh7y29uh1Xph3Ic8Ckq9gkhI8ppi92JQ
         Jc1WODiI4/RZAEA2PD1aENp6HrSmGOLU4J4KWowdDvDT98Qq8L6wvDAKU56KZDwiPezg
         hRNuBkHBQKIVJupyAMiWwnROVOibKjIdyTloTicxFdhcouV6QuxQNiViCUL/zjtTbXgt
         +O2MBhXkWm/mTAW48pqL0lt033IKzws4k3MyQUE+Y9pIL1wS6kUKpUJmBryO9lHidCyu
         vizpegHAKq/n0MPPQX2qidtv/Ki8rOz/bJBWD+cnHAuBATY5d9/1+CjqvrLYeXGi2TCr
         dwIw==
X-Gm-Message-State: APjAAAU8BlhhorN/n/HfhpVPfRvlG23QGTwlIehp7qYiDSg4g7xfyvO1
        +o37m8URNwIVQPbmNDm5p27Rwt50th1TdzYuQieMFixNh9SWidCKIyNJXClgTPibS91WLrBrxV/
        ts8aJqNIEzeQ4ugOimO2K
X-Received: by 2002:adf:dfc6:: with SMTP id q6mr38765045wrn.235.1574182227185;
        Tue, 19 Nov 2019 08:50:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGi3Pb7ggZe15vaehCDl3spIaW2yGyR/3bbOLr3ylbiXRw8/I51+6Ijb749/VLByolnQn/8w==
X-Received: by 2002:adf:dfc6:: with SMTP id q6mr38765015wrn.235.1574182226896;
        Tue, 19 Nov 2019 08:50:26 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id w4sm27994278wrs.1.2019.11.19.08.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 08:50:26 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:50:24 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Forbid FIEMAP on RT devices
Message-ID: <20191119165024.u2tbugzgqaxg5i6k@orion>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs@vger.kernel.org
References: <20191119154453.312400-1-cmaiolino@redhat.com>
 <c0f422cf-af47-0048-a991-2d9d4610c8ff@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <c0f422cf-af47-0048-a991-2d9d4610c8ff@sandeen.net>
X-MC-Unique: inXHNQF7NparqgetPMRKBw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 10:10:54AM -0600, Eric Sandeen wrote:
> On 11/19/19 9:44 AM, Carlos Maiolino wrote:
> > By now, FIEMAP users have no way to identify which device contains the
> > mapping being reported by the ioctl, so, let's forbid FIEMAP on RT
> > devices/files until FIEMAP can properly report the device containing th=
e
> > returned mappings.
>=20
> I'm not sure I agree with this - we don't return any device information w=
ith
> any mapping, ever. It's always up to the caller to understand what they h=
ave
> asked to have mapped. I'm not sure why RT files should be singled out, as=
 long
> as the mapping is correct.

It's been a long time discussion already on this subject, it all started ba=
ck
with btrfs and their virtual address spaces and how a fiemap should behave =
on
filesystems such as btrfs, which, by instance, the caller can't tell which
device the mapping refers to.

XFS RT device is the simplest of this kind of case, where the mapping retur=
ned
does not match with the mounted device, but by now that's the one blocking =
my
FIEMAP work, which I want to fix to move on to the next steps :P

>=20
> -Eric
>=20
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >=20
> > Hi folks, this change has been previously suggested by Christoph while =
the
> > fibmap->fiemap work was being discussed on the last version [1] of that=
 set.
> > And after some thought I do think RT devices shouldn't allow fiemap cal=
ls
> > either, giving the file blocks will actually be on a different device t=
han that
> > displayed on /proc/mounts which can lead to erroneous assumptions.
> >=20
> >  fs/xfs/xfs_iops.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index e532db27d0dc..ec7749cbd3ca 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -1138,6 +1138,9 @@ xfs_vn_fiemap(
> >  {
> >  =09int=09=09=09error;
> > =20
> > +=09if (XFS_IS_REALTIME_INODE(XFS_I(inode)))
> > +=09=09return -EOPNOTSUPP;
> > +
> >  =09xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
> >  =09if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
> >  =09=09fieinfo->fi_flags &=3D ~FIEMAP_FLAG_XATTR;
> >=20
>=20

--=20
Carlos

