Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9052C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B6D024683
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vkp62liP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgA1Qua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 11:50:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44176 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726007AbgA1Qu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 11:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580230228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k8SY70uehQLfQFpkSmRMUNiLqwkg6ycJ+a4N9GF7a9c=;
        b=Vkp62liPc8pObeLTrCkqJ7KqT15G5yMU8tkAH4ulQT/pXsH6CYmNKNm8/C6RkvEystzBRB
        BxTqiGlQbCwTUdxZXXrg1LGkYUUb7Wr+bdl07rvRcjF+H+QUA9Bl5NaHCrAe3xkhoKWB9S
        qRZCzWiNOfXNUiniI5ht3f9VubLTnMI=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-6e0a6PjoMc2m2mp9ouQwhw-1; Tue, 28 Jan 2020 11:50:26 -0500
X-MC-Unique: 6e0a6PjoMc2m2mp9ouQwhw-1
Received: by mail-vk1-f197.google.com with SMTP id y28so5915546vkl.23
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 08:50:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k8SY70uehQLfQFpkSmRMUNiLqwkg6ycJ+a4N9GF7a9c=;
        b=tIN3+Z5gq3DWf59Bjpkwem36W/xhsYEBf/8o+9roYRPJ/mybleht8lGVGe7/yKQj/v
         7jSyIkdCPN78IsUHhG/7lHslbgIS538Ff3qyLQeCvvyXDyRNx3fFHFmjqGKqaVzzhMQv
         Odop1az8tnzq7IF2Re1Xoq7ORmigMGqtuc2GxigjxgGpmCSXhnvRoK3YxrV1laDW79J3
         Cq3iBVIP5L62zgbcSij7hHs2TdmDbvTqCcG9cGv+jD3m4IUx8m5FEhP/zuN55yn1UhDA
         vK2GDTDzGWRxCyjjX7d5bG1DSbmda4n8Mg61qH3K/RSHP71T2I+VsNV5WFD/uDT/0m/h
         FO2w==
X-Gm-Message-State: APjAAAU1cY5LbrwCqpDVU+Aykth3DOV9VsPz0Hybj7LbH4B8I/OEEGt8
        in4a/UcD5RcH1cdRqVDLBLkbYdEuMOKU39OECllY5oG6dBVQi2QjD5666lDyON8DqH5rJU+gBgv
        e/QRB1H/nE3ztCOaw08d5ReOWbA1ZRkv0lBcg
X-Received: by 2002:a9f:3e0f:: with SMTP id o15mr13715007uai.37.1580230225673;
        Tue, 28 Jan 2020 08:50:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgGjotGO0uOJ9woKb1Eh//FSfaI9UwuWTGtC81yzwLYsTB3VQat1gdTA1HKz5sm4ZFrZnXhn+0xMKnK75Nv3M=
X-Received: by 2002:a9f:3e0f:: with SMTP id o15mr13714992uai.37.1580230225394;
 Tue, 28 Jan 2020 08:50:25 -0800 (PST)
MIME-Version: 1.0
References: <20200128145528.2093039-1-preichl@redhat.com> <20200128145528.2093039-2-preichl@redhat.com>
 <20200128164200.GP3447196@magnolia>
In-Reply-To: <20200128164200.GP3447196@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Tue, 28 Jan 2020 17:50:14 +0100
Message-ID: <CAJc7PzVAaufs+8OLPN9S2Fx7eXgiGCZhZQwzfhA8=HaDif5r8w@mail.gmail.com>
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, maybe performance optimalizaton? If debug_locks is false then
there's no need to call lockdep_is_held_type()? But I'm not sure :-)

On Tue, Jan 28, 2020 at 5:42 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Tue, Jan 28, 2020 at 03:55:25PM +0100, Pavel Reichl wrote:
> > mr_writer is obsolete and the information it contains is accesible
> > from mr_lock.
> >
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c5077e6326c7..32fac6152dc3 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -352,13 +352,17 @@ xfs_isilocked(
> >  {
> >       if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> >               if (!(lock_flags & XFS_ILOCK_SHARED))
> > -                     return !!ip->i_lock.mr_writer;
> > +                     return !debug_locks ||
> > +                             lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
>
> Why do we reference debug_locks here directly?  It looks as though that
> variable exists to shut up lockdep assertions WARN_ONs, but
> xfs_isilocked is a predicate (and not itself an assertion), so why can't
> we 'return lockdep_is_held_type(...);' directly?
>
> (He says scowling at his own RVB in 6552321831dce).
>
> --D
>
> >               return rwsem_is_locked(&ip->i_lock.mr_lock);
> >       }
> >
> >       if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> >               if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> > -                     return !!ip->i_mmaplock.mr_writer;
> > +                     return !debug_locks ||
> > +                             lockdep_is_held_type(
> > +                                     &ip->i_mmaplock.mr_lock,
> > +                                     0);
> >               return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> >       }
> >
> > --
> > 2.24.1
> >
>

