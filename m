Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BD9C388F3
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 12:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2194A21850
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 12:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7aMzzLN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfI0Maj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 08:30:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727366AbfI0Maj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Sep 2019 08:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569587438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AFDJQWRn2oArs9e8CMB06UNLGBpTQguzdCqG6kqxSNg=;
        b=R7aMzzLN03/bHiENFi7C4nRtBxFR02y+/oMYO6Vhtgbl1rHMVFmiv6dVkzyBIW69jav22E
        e8hf4SFY3ikFHRLxJItoPjBx3sXZpAGXh4X+I02kPyRSnjoljWnkFak3TZjaClet5SCB2J
        yn5HwoAioaAh6tyzid0TKMzp9kwz2Dg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-bS4ZAoI5P2eNxLtJQA7DVg-1; Fri, 27 Sep 2019 08:30:33 -0400
Received: by mail-wr1-f70.google.com with SMTP id v18so937642wro.16
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 05:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=TXt6Do7+QksBQ/PEVkntzatXUKf3m6AnI+sNceWC7po=;
        b=mF2hb0X4yDC2GQvW7J3k6AGhx+mX5lg6I6YO1f7ZJaGqCwYc/1xErF6+6kbS2DmYf7
         PyYoUrnZJ342QiXQcvDbMHgDZfkiqyfTFc5BGoRH+JEuTabA0pTKcksJb92XHeTyU9UR
         ZFQ3KqwuDLrjIfzVD5paH6wXCjUmTGuh63DsTy4tY+B/oWP+NylaCOxpDV3Zcvu6Hgvo
         WxRMjw9cxWbrtitBaV2T300B+P/mDwbJv3wF6tbri4oLSS+otSQB8mZK9O1Bd2P3IjAT
         iVKkkEjZpzzMkap1gX6eim13EVnNZW5ud/NWK63gqkq1d0aT7Ua+3xsDLS8jj22bZlap
         P8pg==
X-Gm-Message-State: APjAAAUgEFbspoVggHIuZdjU+lyoIeAfCsWoyoHWEAKiMjfw6esHAlep
        qosohFafQVtMNum9wLEaN6HL7EGBvwPLrbRNyitv42k7vUsANXJJozcZD35cG049goGcbJrUp9x
        iR2rBr24OgkU/IVgi7N5T
X-Received: by 2002:adf:e64e:: with SMTP id b14mr3023513wrn.16.1569587432139;
        Fri, 27 Sep 2019 05:30:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxz1nrmCa9+5IzOv5f5K+Y70yJMCn9m5ceft0qt7yoJfzd4TPgzF5RWvfRSBzjLGnGAdULR/A==
X-Received: by 2002:adf:e64e:: with SMTP id b14mr3023493wrn.16.1569587431914;
        Fri, 27 Sep 2019 05:30:31 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id s13sm4737323wmc.28.2019.09.27.05.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 05:30:31 -0700 (PDT)
Date:   Fri, 27 Sep 2019 14:30:29 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: btheight should check geometry more carefully
Message-ID: <20190927123028.yb5hwr6y7owgqse3@pegasus.maiolino.io>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765385.303060.16945955453073433913.stgit@magnolia>
 <20190926091147.dbjrf5i7rfgmzehb@pegasus.maiolino.io>
 <20190926173843.GD9916@magnolia>
MIME-Version: 1.0
In-Reply-To: <20190926173843.GD9916@magnolia>
User-Agent: NeoMutt/20180716
X-MC-Unique: bS4ZAoI5P2eNxLtJQA7DVg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 10:38:43AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 26, 2019 at 11:11:48AM +0200, Carlos Maiolino wrote:
> > On Wed, Sep 25, 2019 at 02:40:53PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >=20
> > > The btheight command needs to check user-supplied geometry more
> > > carefully so that we don't hit floating point exceptions.
> > >=20
> > > Coverity-id: 1453661, 1453659
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > =20
> >=20
> > Patch looks good, but.
> >=20
> >=20
> > > +=09if (record_size > blocksize) {
> > > +=09=09fprintf(stderr,
> > > +=09=09=09_("%s: record size must be less than %u bytes.\n"),
> >=20
> > =09Couldn't this message maybe be better saying "less than current bloc=
ksize"?
> > =09Saying it is less than X bytes sounds kind of meaningless, requiring=
 a
> > =09trip to the code to understand what exactly 'bytes' mean here.
> >=20
> > =09Maybe something like:
> >=20
> > =09_("%s: record size must be less than current block size (%u).\n"),
>=20
> I think I'll change that to 'selected' from 'current' since the caller
> can change the block size with -b, but otherwise I agree.

Sounds good o me too, thanks

>=20
> --D
>=20
> >=20
> > Same for the next two.
> >=20
> > > +=09=09=09tag, blocksize);
> > > +=09=09goto out;
> > > +=09}
> > > +
> > > +=09if (key_size > blocksize) {
> > > +=09=09fprintf(stderr,
> > > +=09=09=09_("%s: key size must be less than %u bytes.\n"),
> > > +=09=09=09tag, blocksize);
> > > +=09=09goto out;
> > > +=09}
> > > +
> > > +=09if (ptr_size > blocksize) {
> > > +=09=09fprintf(stderr,
> > > +=09=09=09_("%s: pointer size must be less than %u bytes.\n"),
> > > +=09=09=09tag, blocksize);
> > > +=09=09goto out;
> > > +=09}
> > > +
> > >  =09p =3D strtok(NULL, ":");
> > >  =09if (p) {
> > >  =09=09fprintf(stderr,
> > > @@ -211,13 +244,24 @@ report(
> > >  =09int=09=09=09ret;
> > > =20
> > >  =09ret =3D construct_records_per_block(tag, blocksize, records_per_b=
lock);
> > > -=09if (ret) {
> > > -=09=09printf(_("%s: Unable to determine records per block.\n"),
> > > -=09=09=09=09tag);
> > > +=09if (ret)
> > >  =09=09return;
> > > -=09}
> > > =20
> > >  =09if (report_what & REPORT_MAX) {
> > > +=09=09if (records_per_block[0] < 2) {
> > > +=09=09=09fprintf(stderr,
> > > +_("%s: cannot calculate best case scenario due to leaf geometry unde=
rflow.\n"),
> > > +=09=09=09=09tag);
> > > +=09=09=09return;
> > > +=09=09}
> > > +
> > > +=09=09if (records_per_block[1] < 4) {
> > > +=09=09=09fprintf(stderr,
> > > +_("%s: cannot calculate best case scenario due to node geometry unde=
rflow.\n"),
> > > +=09=09=09=09tag);
> > > +=09=09=09return;
> > > +=09=09}
> > > +
> > >  =09=09printf(
> > >  _("%s: best case per %u-byte block: %u records (leaf) / %u keyptrs (=
node)\n"),
> > >  =09=09=09=09tag, blocksize, records_per_block[0],
> > > @@ -230,6 +274,20 @@ _("%s: best case per %u-byte block: %u records (=
leaf) / %u keyptrs (node)\n"),
> > >  =09=09records_per_block[0] /=3D 2;
> > >  =09=09records_per_block[1] /=3D 2;
> > > =20
> > > +=09=09if (records_per_block[0] < 1) {
> > > +=09=09=09fprintf(stderr,
> > > +_("%s: cannot calculate worst case scenario due to leaf geometry und=
erflow.\n"),
> > > +=09=09=09=09tag);
> > > +=09=09=09return;
> > > +=09=09}
> > > +
> > > +=09=09if (records_per_block[1] < 2) {
> > > +=09=09=09fprintf(stderr,
> > > +_("%s: cannot calculate worst case scenario due to node geometry und=
erflow.\n"),
> > > +=09=09=09=09tag);
> > > +=09=09=09return;
> > > +=09=09}
> > > +
> > >  =09=09printf(
> > >  _("%s: worst case per %u-byte block: %u records (leaf) / %u keyptrs =
(node)\n"),
> > >  =09=09=09=09tag, blocksize, records_per_block[0],
> > > @@ -284,8 +342,26 @@ btheight_f(
> > >  =09=09}
> > >  =09}
> > > =20
> > > -=09if (argc =3D=3D optind || blocksize <=3D 0 || blocksize > INT_MAX=
 ||
> > > -=09    nr_records =3D=3D 0) {
> > > +=09if (nr_records =3D=3D 0) {
> > > +=09=09fprintf(stderr,
> > > +_("Number of records must be greater than zero.\n"));
> > > +=09=09return 0;
> > > +=09}
> > > +
> > > +=09if (blocksize > INT_MAX) {
> > > +=09=09fprintf(stderr,
> > > +_("The largest block size this command will consider is %u bytes.\n"=
),
> > > +=09=09=09INT_MAX);
> > > +=09=09return 0;
> > > +=09}
> > > +
> > > +=09if (blocksize < 128) {
> > > +=09=09fprintf(stderr,
> > > +_("The smallest block size this command will consider is 128 bytes.\=
n"));
> > > +=09=09return 0;
> > > +=09}
> > > +
> > > +=09if (argc =3D=3D optind) {
> > >  =09=09btheight_help();
> > >  =09=09return 0;
> > >  =09}
> > >=20
> >=20
> > --=20
> > Carlos
> >=20

--=20
Carlos

