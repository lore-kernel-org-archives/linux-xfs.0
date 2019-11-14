Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C20C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 10:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82E3720409
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 10:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZkFChjMI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNKb0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:31:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57958 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726202AbfKNKbZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 05:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573727484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pKIR3UmL9ta/2e3N4QgxJYvIQj7Sdgixpx5l4Ms7M0Q=;
        b=ZkFChjMI9NPs2F0W9R1Q6i492g5fI9OoJve2wlVNaKAeuVmgweu80D1qClcF7bhYxkiAB9
        kD5P790th/TrPvBqBHUyClxLPpWkEfhYRRyV771/VexyDRBLKeaghLxMRkToYOervmkBg1
        YYCPadBsSns1+4ZVi5HsBonyxfw0/uo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-ti5_8zA_NEKDwP-ojmS5vg-1; Thu, 14 Nov 2019 05:31:23 -0500
Received: by mail-wr1-f71.google.com with SMTP id m17so4105195wrb.20
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 02:31:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=JWCxLpv/UjLrjB7zShi6a454QE9sIot7OJ3CKF77vug=;
        b=o474xMmeTM2XWbZd6ROkvMrvNgKWX79DWwiYmEajmhy/a4+ulgTf5dUl9dbCqJTrSJ
         g2oiIFH6E6Uxzap74eBuKq1gBON6iCEb5WJPltg+kIb7TIh37E7avefuXwd5899Ufupz
         VV0QAybN1B8IWWRQaz40r+mwBIgG3bgrblE22Z1/K3t8RbT4DAW2x4oarsdl0zXkr+r1
         /cm5U08XLYnfzylLmDQKG0hefssNdJx3fb8K4tf3t9uQhYibGk8juASsFJEE81L+X7fU
         ppuuL62XS6NeTnicI7DBRtd8uPQ7pHWkN/ywvjLPa3qM1FvQHcxYD/mjLCQe2pkF0M+2
         u5VA==
X-Gm-Message-State: APjAAAWKbnwpph/49kkzf34IkmJIOUCSEUXpVMRJa15IIAyuTigCZag2
        L+tA5M3BUM4rkSrEoUhl4pRFRLYDHOIM13Q8TODK6ogS28pcu9K0Lfh4yQ5x5J60hhZtWKrx5JP
        B9XQ+j1Ottzi0v7Q+ww2f
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr7266620wrj.102.1573727481609;
        Thu, 14 Nov 2019 02:31:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCB6yZUzrSC3NneONeIFWJ2fXTfBPbBveCNsh+u0Ybk0/qNgqZAfPQrZrLQcMG//m1yB0RXA==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr7266598wrj.102.1573727481426;
        Thu, 14 Nov 2019 02:31:21 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id j7sm7405752wro.54.2019.11.14.02.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 02:31:20 -0800 (PST)
Date:   Thu, 14 Nov 2019 11:31:17 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: rework kmem_alloc_{io,large} to use GFP_*
 flags
Message-ID: <20191114103117.pb6cpyqgnuug3epm@orion>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-10-cmaiolino@redhat.com>
 <20191113180850.GK6235@magnolia>
 <20191113195653.GT4614@dread.disaster.area>
 <20191114094022.u267tdwiistd6blb@orion>
MIME-Version: 1.0
In-Reply-To: <20191114094022.u267tdwiistd6blb@orion>
X-MC-Unique: ti5_8zA_NEKDwP-ojmS5vg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Ok, I'll leave it as-is (with converted flags).
>=20
> > > TBH this series would be better sequenced as (1) get rid of pointless
> > > wrappers, (2) convert kmem* callers to use GFP flags, and (3) save
> > > whatever logic changes for the end.  If nothing else I could pull the
> > > first two parts and leave the third for later.
> >=20
>=20
> I need to fix the line >80 characters and some other nit picks on the pat=
ches,
> so I can split this into this 3-series guideline and submit everything ag=
ain, no
> worries.
>=20
> I do believe though the kmem_zone_alloc() removal falls into the 1st seri=
es here
> right? Giving the fact it removes the loop but doesn't really alter the l=
ogic at
> all, since __GFP_NOFAIL now implies the 'infinite loop' and the
> congestion_wait()?

NVM, it should be on set (2), not one...

/me goes grab more coffee.


>=20
> >=20
> > > >  static inline void *
> > > > -kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> > > > +kmem_zalloc_large(size_t size, gfp_t flags)
> > > >  {
> > > > -=09return kmem_alloc_large(size, flags | KM_ZERO);
> > > > +=09return kmem_alloc_large(size, flags | __GFP_ZERO);
> > > >  }
> >=20
> > I'd also kill these zalloc wrappers and just pass __GFP_ZERO
> > directly.
>=20
> Thanks for the review guys.
>=20
> Cheers
>=20
> --=20
> Carlos

--=20
Carlos

