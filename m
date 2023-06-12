Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE92C88CB2
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 15:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbjFLP6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238635AbjFLP6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 11:58:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FF8E5
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 08:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686585482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2MaW8k4BiMcy3VNz0QknaUl+mGPTFiF92AIL3GY/vzM=;
        b=KVZRcSvf11kd/RKVvY5JL4AR0wUL/Hyr872VtW6JVW0jEvpx0rtco6VgEJxnGnJLsS1NLl
        4nTrff1bLuNkLtsqod6vGXnuRVo4yXOi0hCddbiCcXSLw845yS8fnb7S+NBZfldpxUN/ak
        jZlFpim+wtP8h5LAKwPN972Rmce4L3U=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-uauzb5zRNASGpBdDQZLG2g-1; Mon, 12 Jun 2023 11:58:01 -0400
X-MC-Unique: uauzb5zRNASGpBdDQZLG2g-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1b3ac2e4555so11557295ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 08:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686585480; x=1689177480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2MaW8k4BiMcy3VNz0QknaUl+mGPTFiF92AIL3GY/vzM=;
        b=bEDzccKAUdtttrriTULbLvj1riwbScg1awh75JLQMsLnls6v9bnmGMZuKfwh5XeIX/
         iBF72R9JnDlyezf/FRi5k0+4Ucbrv1SkWqTLTT1+ptCKl2unhZWWQhKLH96TiGxKaiI3
         0PHbd4v3c0bZMmTB0EesAPrwXTbG5+gB/t8lLwg9dHKIhItTS7T9PW6qj4D0CAEAUd7E
         A7S+INvOvpP5rhgcbtwOlgHuW+4J9xFCDwXIxoztoEyV0iAYtSc2My0Z+wkyFB1DsnwG
         uwoOI8JXvknsS9oKUDx4uI5EuIAvAg3gRegVbpPWJf87MsMmG2kwMM/bCO5v8PkIlhBJ
         lLeA==
X-Gm-Message-State: AC+VfDwgmV2Gf3H3F+zVwOmiHGm95rEu0Xz+n8F6ZWFkwk7+GMJtFccZ
        4V3WVUofBB5yHEhrpPNexcxzZH/Jz6hV9YNrjSaIjnTYV7cxEtd5cQdBvMmC/7uRqAC5fp5CvGb
        ndlFVUCBDP1Ac9Yk/bp+plwHCliX17T9MbCqu
X-Received: by 2002:a17:903:2286:b0:1ac:9cad:1845 with SMTP id b6-20020a170903228600b001ac9cad1845mr7935715plh.18.1686585480535;
        Mon, 12 Jun 2023 08:58:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7yOiCf5BTOxgVMTE+GRdfgui8plW5bqROqPlURsSezkT44MIgjpNtQdfo37M1rHXmtSWVYzGzYFWAmg4uMHXc=
X-Received: by 2002:a17:903:2286:b0:1ac:9cad:1845 with SMTP id
 b6-20020a170903228600b001ac9cad1845mr7935704plh.18.1686585480237; Mon, 12 Jun
 2023 08:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAHc6FU5xMQfGPuTBDChS=w2+t4KAbu9po7yE+7qGaLTzV-+AFw@mail.gmail.com>
 <87o7lkhfpj.fsf@doe.com> <ZIc4ujLJixghk6Zp@casper.infradead.org>
In-Reply-To: <ZIc4ujLJixghk6Zp@casper.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 12 Jun 2023 17:57:48 +0200
Message-ID: <CAHc6FU7GnVeKmUC4GkySqE1bV3WgbA_WTuQ3D0dcMyn193M4VA@mail.gmail.com>
Subject: Re: [PATCHv9 3/6] iomap: Add some uptodate state handling helpers for
 ifs state bitmap
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Ritesh Harjani <ritesh.list@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 5:24=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> On Mon, Jun 12, 2023 at 08:48:16PM +0530, Ritesh Harjani wrote:
> > > Since we're at the nitpicking, I don't find those names very useful,
> > > either. How about the following instead?
> > >
> > > iomap_ifs_alloc -> iomap_folio_state_alloc
> > > iomap_ifs_free -> iomap_folio_state_free
> > > iomap_ifs_calc_range -> iomap_folio_state_calc_range
> >
> > First of all I think we need to get used to the name "ifs" like how we
> > were using "iop" earlier. ifs =3D=3D iomap_folio_state...
> >
> > >
> > > iomap_ifs_is_fully_uptodate -> iomap_folio_is_fully_uptodate
> > > iomap_ifs_is_block_uptodate -> iomap_block_is_uptodate
> > > iomap_ifs_is_block_dirty -> iomap_block_is_dirty
> > >
> >
> > ...if you then look above functions with _ifs_ =3D=3D _iomap_folio_stat=
e_
> > naming. It will make more sense.
>
> Well, it doesn't because it's iomap_iomap_folio_state_is_fully_uptodate.

Exactly.

> I don't think there's any need to namespace this so fully.
> ifs_is_fully_uptodate() is just fine for a static function, IMO.

I'd be perfectly happy with that kind of naming scheme as well.

Thanks,
Andreas

