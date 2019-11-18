Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90224C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644242073A
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:30:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YGKc4FbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfKRIaR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:30:17 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43949 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726332AbfKRIaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 03:30:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574065815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2hadao/YCyJH+oao+IOm+LAMJWjAfs0zI1b9Ye0/tE=;
        b=YGKc4FbJBLGY1RwlNmLr8Q3RIPkH5KGxmWo3RSISiZ1RTlGrQ4JzZR6MLQmx+3CwPvcKph
        OO2Pf28ALa3FMMzz1m+XCauqf0YTQRGZqkN1v9KdF+jfeXri6zxb+JbwklipsXiu0KXoap
        yEuasj3KFZeH4lHlmgkGXue44Q2XZOs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-RtAxEQy-MfyPaO6oe4Gfug-1; Mon, 18 Nov 2019 03:30:14 -0500
Received: by mail-wr1-f72.google.com with SMTP id m17so14826988wrb.20
        for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2019 00:30:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=a89Uds7SnGxbP86rNqYrQYHGijoqvIwNGi1UciE4m+A=;
        b=Ms5/2s8Q9wG1zqdTYMKmtyhpdmGbBQ6/ZWaRML0zegvIn88fvoJGWBLCQp3+on9P87
         08y2shM8sy/GbcWJcHzn1MeOu0aZD5D/l8G7QRPe69X2I3oyjhqngBhXj96ieYJoJ2YM
         0yM9cr5Ug/pWD2wYWBrj4dZzAzKPgu2gEWrzBoUrcXbY+lp/SiDXzvPLELagG9D56Z2A
         Ek5CaB438OR4mRnl6bkR6ivkpFvtz4B7FGUY9/tmYYGt3i14HYlKeCptnCzQHbJMO6Ab
         Xt5hTk3a4yTZCD3LLwTVaZySWAGPrwK1u/WG9u4ofjmRokAATbz3wPpJNu2RDL13caSH
         BWDg==
X-Gm-Message-State: APjAAAXF/l0WLP9CMu0SUVTF93ph8aAnkJkvDG8D7LI/EK/h537vdky5
        JuBofpQkCtTqlwyhSu+CO8Q/aiLcELORs+A1o/siXGvNvtP84kzMnfLnCHkEBu6w+FdvIUc01sz
        e72FBcFhoSe/eu1DUKRuP
X-Received: by 2002:adf:ffd0:: with SMTP id x16mr27092774wrs.86.1574065812887;
        Mon, 18 Nov 2019 00:30:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqzE9zzm1fmsBX/QuU95xHucoQd/wXrb5Hr/w0sJ3EqLoXzCmhI9v4tNA/P7X2cqtSfo1i4fqw==
X-Received: by 2002:adf:ffd0:: with SMTP id x16mr27092750wrs.86.1574065812640;
        Mon, 18 Nov 2019 00:30:12 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id h124sm20598663wme.30.2019.11.18.00.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 00:30:10 -0800 (PST)
Date:   Mon, 18 Nov 2019 09:30:08 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191118083008.ttbikkwmrjy4k322@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, dchinner@redhat.com
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
 <20191114210000.GL6219@magnolia>
 <20191115142055.asqudktld7eblfea@orion>
 <20191115172322.GO6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191115172322.GO6219@magnolia>
X-MC-Unique: RtAxEQy-MfyPaO6oe4Gfug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 09:23:22AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 15, 2019 at 03:20:55PM +0100, Carlos Maiolino wrote:
> > On Thu, Nov 14, 2019 at 01:00:00PM -0800, Darrick J. Wong wrote:
> > > On Thu, Nov 14, 2019 at 09:09:55PM +0100, Carlos Maiolino wrote:
> > > > This can be replaced by direct calls to kfree() or kvfree() (whenev=
er
> > > > allocation is done via kmem_alloc_io() or kmem_alloc_large().
> > > >=20
> > > > This patch has been partially scripted. I used the following sed to
> > > > replace all kmem_free() calls by kfree()
> > > >=20
> > > >  # find fs/xfs/ -type f -name '*.c' -o -name '*.h' | xargs sed -i \
> > > >    's/kmem_free/kfree/g'
> > >=20
> > > Coccinelle? ;)
> >=20
> > /me Doesn't understand the reference but thinks Darrick is talking abou=
t
> > Coccinelle fancy brand :P
> >=20
> > /me is adept to conference-wear :D
>=20
> http://coccinelle.lip6.fr/
>=20
> The semantic patch thing, because understanding the weird spatch
> language is slightly less infuriating than making tons of minor code
> changes by hand. :P

Oh, I didn't know about this. Thanks. The name could be something different
other than a fashion brand making googling for it easier :(

> > I can't really say we will have any benefits in segmenting it by using =
kvfree()
> > only where kmem_alloc_{large, io} is used, so I just relied on the comm=
ents
> > above kvfree(), and well, we have an extra function call and a few extr=
a
> > instructions using kvfree(). So, even though it might be 'slightly' fas=
ter, this
> > might build up on hot paths when handling millions of kfree().
> >=20
> > But, at the end, I'd be lying if I say I spotted any significant differ=
ence.
>=20
> <nod> Though the way I see it, kfree vs. kvfree is another bookkeepping
> detail that xfs developers will have to keep straight.  But maybe that's
> fine for the dozen or so specialized users of _io and _large?  What do
> others think?

Ok, if we decide to move everything to kvfree() I'll just send a V2 of this
patch, which should apply cleanly on top of the other 3.

>=20
> > Btw, Dave mentioned in a not so far future, kmalloc() requests will be
> > guaranteed to be aligned, so, I wonder if we will be able to replace bo=
th
> > kmem_alloc_large() and kmem_alloc_io() by simple calls to kvmalloc() wh=
ich does
> > the job of falling back to vmalloc() if kmalloc() fails?!
>=20
> Sure, but I'll believe that when I see it.  And given that Christoph
> Lameter seems totally opposed to the idea, I think we should keep our
> silly wrapper for a while to see if they don't accidentally revert it or
> something.
>=20

Sure, I don't have any plans to do it now in this series or in a very near
future, I just used the email to share the idea :P

Thanks for the review.

--=20
Carlos

