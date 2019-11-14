Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92430C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 09:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BB7A20709
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 09:46:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqZdE6a3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfKNJqZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:46:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32695 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726428AbfKNJqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 04:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573724783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLlmhERT5qagmyJBze3yqqPZznfDv9NpvRCVOlJLGy4=;
        b=EqZdE6a3DnMfS+gevwp2OkBtOod6ErIWOHpSICtaU6Rkzb4KmXEQoOtNLYjgpDn1K7CtJA
        QKrvnlQWSUpbspheMoPSW4DVHZvRICMI8pW0Rs1p5AqwpHi7tN4WwWN77Kux2alfDfqa4b
        OERYsDmrx6hQGjsaDnwTu1tuL8ROGQM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-ataZYNxtMYCkscmZcjafBw-1; Thu, 14 Nov 2019 04:46:22 -0500
Received: by mail-wr1-f70.google.com with SMTP id p6so4103393wrs.5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 01:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=zmUvnXmJsTD5jPjpJPJoBnLXNZ6en9+Mtiyt+ngxs2c=;
        b=BGxHp/Uwmw2X/x92chcdYLxNnkjH3eIkuql5PTdVailbEXla5sXik/151EgSMIa66B
         P5bxe3OXmBoR1nrMSGC4rOX2frsPx1ZDZNw2tzzDppsBSQI3ZcYlyAn1Gw6Fjp5hJkPH
         h0vSKS1WNLfFvpjImlyGATCFRAeb/N5yQhfbzRBcrqRQnjdj4w7JfVKKmCmhqgQpWu/4
         mrQpvWUzPDHEllf3/Xa1JznZd6NbsckTCg2wh7cxuGRUkqqPDBaJ+5ynahj2YiB778L9
         aTUREaf4g2Ta9IKJEQv2gEuHQkugBelh/A/cVppJ96LWN1YzNX9jlo6OngiMSqfpufqD
         uMlw==
X-Gm-Message-State: APjAAAXtFGQoyp8MprSyYMnR4HJoaDxoPA8tFzEwfk8nZ/BY3ld2tVvE
        SV4RHIibIoB+lVdEeakLxsmEPkwxzZA6y6qyvDhliQ15eq95qbAW5T0PCF9asDy3Hr7qhbY4Udz
        CSZL+m/fm0hYwFJEsEvq7
X-Received: by 2002:adf:e506:: with SMTP id j6mr7470975wrm.19.1573724780840;
        Thu, 14 Nov 2019 01:46:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwGlc8swSlSu4neGyEpeXbn8UfxeJ6RlYGA7VFL2bWIQ93/grFrEzZOGqVsoVR47GQsRwAfTA==
X-Received: by 2002:adf:e506:: with SMTP id j6mr7470940wrm.19.1573724780570;
        Thu, 14 Nov 2019 01:46:20 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id k4sm5974872wmk.26.2019.11.14.01.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 01:46:19 -0800 (PST)
Date:   Thu, 14 Nov 2019 10:46:18 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: Remove kmem_alloc_{io, large} and
 kmem_zalloc_large
Message-ID: <20191114094618.yyedh3k7ica5rfjb@orion>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-12-cmaiolino@redhat.com>
 <20191113182343.GH6219@magnolia>
 <20191113200620.GU4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191113200620.GU4614@dread.disaster.area>
X-MC-Unique: ataZYNxtMYCkscmZcjafBw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> ANother question: how much work is there to be done on the userspace
> side of things?
>=20
> > >   */
> > > =20
> > > -extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags)=
;
> > > -extern void *kmem_alloc_large(size_t size, gfp_t);
> > > +extern void *xfs_kmem_alloc(size_t, gfp_t, bool, int);
> > >  static inline void  kmem_free(const void *ptr)
> > >  {
> > >  =09kvfree(ptr);
> > >  }
>=20
> Didn't an earlier patch get rid of kmem_free(), or am I just
> imagining this? Seems silly to leave this behind, now that the
> only place that needs kvfree() is the callers to kmem_alloc_io and
> kmem_alloc_large...

Yes, it's on my roadmap, I just wanted to work on the other wrappers first =
and
send it later when I had kmem_alloc_{io, large}() worked out. I'll make sur=
e to
convert this one on the V2.

>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

--=20
Carlos

