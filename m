Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CC3C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 09:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2848A20709
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 09:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+daDrqz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfKNJkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:40:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36649 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbfKNJkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 04:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573724430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twbpjZHnNVRAJylM5kwg9Ba27GOLrAEal1hoonpcBvY=;
        b=C+daDrqzdwi3k/j2CI7kmvyLCHflCZ8vvWTRP56ldcxwqkH3MhsumIqkIAL7J8UhlSukW3
        u2gAFj4p4Xc/inn9mDOXeSJEEhXJjctOA0khKigB/MXzyUo5VkshxPSwMMtl4n6G3A9nYG
        kbtg0qPHcDkakdQ8w6flmjlFDgOHGLI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-0VVWMpMBOvSy06E_wGA71Q-1; Thu, 14 Nov 2019 04:40:27 -0500
Received: by mail-wm1-f71.google.com with SMTP id y14so3042709wmj.9
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 01:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=YZ/EFzm4NW2U3ecFXn/aojrJeL4E0xp2e2YUrPxLtas=;
        b=DktfhvTRT5g4+JWVHH6Qm54YnNtMEaBUb9ePqKOT27HOZU5v2g9XJFugPVTD/1GKdI
         hkoxete4j9wosApRmbsp1Du4HGzjVFrhMy7FgRbOWpyknZc98qlemHLRUhRnnJvbhqhn
         dw/NJEhy0N0KRq4Wzhl3mHSzJ6DuesWmO1S7N6TMagLJl39Du5XdnTvCMybBwzWYKIZU
         Ft6Y9nBNetBz0vpN/c/wItou1dP+xhdzDM4uJ3387B4SzG7GFA+XnFtD/OsFAtfGROGk
         UlUBueWvhyTu4Yk87M9v95XeKJbQhsjmUT1BgbsKJWlElDB7MFUOpzIgbZB1j30ehD1E
         nkjA==
X-Gm-Message-State: APjAAAV0gnmlH5+1ZY0/ePDmsFO1p6kq/kQ0c/iFKabIXBX7EtpT4vxw
        t9C4aZ0lQ8Bm9qu97+beKA0hJHj4VvY9tqypjOXj1UPV+PxAaGSMqdiPjfqOBGGG9x0fzEasbAq
        RJu+WVnFQ09kmwDlB/ImI
X-Received: by 2002:a05:600c:214c:: with SMTP id v12mr6827652wml.124.1573724426053;
        Thu, 14 Nov 2019 01:40:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8It1uptpsbmvky7OfmjF4lCCf28t1/TweFf8QanaLX/B/hQEyF7LBn/2slfeZe9yI99GgLQ==
X-Received: by 2002:a05:600c:214c:: with SMTP id v12mr6827625wml.124.1573724425788;
        Thu, 14 Nov 2019 01:40:25 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id z9sm6486011wrv.35.2019.11.14.01.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 01:40:25 -0800 (PST)
Date:   Thu, 14 Nov 2019 10:40:22 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: rework kmem_alloc_{io,large} to use GFP_*
 flags
Message-ID: <20191114094022.u267tdwiistd6blb@orion>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-10-cmaiolino@redhat.com>
 <20191113180850.GK6235@magnolia>
 <20191113195653.GT4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191113195653.GT4614@dread.disaster.area>
X-MC-Unique: 0VVWMpMBOvSy06E_wGA71Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

> >=20
> > Why is it ok to remove the "wait for congestion and retry" logic here?
> > Does GFP_NOFAIL do all that for us?
>=20
> Yes - kmalloc will never return failure if GFP_NOFAIL is set, and
> it has internal congestion_wait() backoffs. All we lose here is
> the XFS specific error message - we'll get the generic warnings
> now...
>=20
> > Same question for the other two patches that remove similar loops from
> > other functions.
> >=20
> > > -=09} while (1);
> > > -}
> > > -
> > > -
> > > -/*
> > > - * __vmalloc() will allocate data pages and auxiliary structures (e.=
g.
> > > - * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context=
 here. Hence
> > > - * we need to tell memory reclaim that we are in such a context via
> > > - * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesy=
stem here
> > > - * and potentially deadlocking.
> > > - */
> > > -static void *
> > > -__kmem_vmalloc(size_t size, xfs_km_flags_t flags)
> > > -{
> > > -=09unsigned nofs_flag =3D 0;
> > > -=09void=09*ptr;
> > > -=09gfp_t=09lflags =3D kmem_flags_convert(flags);
> > > -
> > > -=09if (flags & KM_NOFS)
> > > -=09=09nofs_flag =3D memalloc_nofs_save();
> > > -
> > > -=09ptr =3D __vmalloc(size, lflags, PAGE_KERNEL);
> > > -
> > > -=09if (flags & KM_NOFS)
> > > -=09=09memalloc_nofs_restore(nofs_flag);
> > > -
> > > -=09return ptr;
> > > -}
> >=20
> > I think this deletes too much -- as the comment says, a caller can pass
> > in GFP_NOFS and we have to push that context all the way through to
> > /any/ allocation that happens under __vmalloc.
> >=20
> > However, it's possible that the mm developers have fixed __vmalloc to
> > pass GFP_NOFS through to every allocation that can be made.  Is that th=
e
> > case?
>=20
> Nope, vmalloc will still do GFP_KERNEL allocations internally. We
> need to keep the kmem_vmalloc wrappers as they stand, just converted
> to use GFP flags.
>=20

Ok, I'll leave it as-is (with converted flags).

> > TBH this series would be better sequenced as (1) get rid of pointless
> > wrappers, (2) convert kmem* callers to use GFP flags, and (3) save
> > whatever logic changes for the end.  If nothing else I could pull the
> > first two parts and leave the third for later.
>=20

I need to fix the line >80 characters and some other nit picks on the patch=
es,
so I can split this into this 3-series guideline and submit everything agai=
n, no
worries.

I do believe though the kmem_zone_alloc() removal falls into the 1st series=
 here
right? Giving the fact it removes the loop but doesn't really alter the log=
ic at
all, since __GFP_NOFAIL now implies the 'infinite loop' and the
congestion_wait()?

>=20
> > >  static inline void *
> > > -kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> > > +kmem_zalloc_large(size_t size, gfp_t flags)
> > >  {
> > > -=09return kmem_alloc_large(size, flags | KM_ZERO);
> > > +=09return kmem_alloc_large(size, flags | __GFP_ZERO);
> > >  }
>=20
> I'd also kill these zalloc wrappers and just pass __GFP_ZERO
> directly.

Thanks for the review guys.

Cheers

--=20
Carlos

