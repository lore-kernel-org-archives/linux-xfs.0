Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20225C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 03:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8616206D4
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 03:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/CAcjfz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgD0Dai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726340AbgD0Dai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Apr 2020 23:30:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBA6C061A0F;
        Sun, 26 Apr 2020 20:30:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o185so8061305pgo.3;
        Sun, 26 Apr 2020 20:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=tqL9U//y5mnl9UT2TzE9aF40cu5r1lEwRulehFj9YQU=;
        b=O/CAcjfzpTTmTfNtQqV6kz4m96WQBl5k7rxyj/SUvrcvLYYC7F1q7yBrdyLLJpItcA
         EVKgnfXpdg3nl+iFuby2hAfUs+JwiVIlBV5fJXaQjFHN+NUVMr89EwfkJn5/QthCU/4o
         KoOhI0U9GXUFVI3MALjYav7fbVakfXIyRvhA9aojC7GP2gBMVFNH8xjxzG7UBMF/D65/
         ROpIdQZn1OQCw6A2XRTbMSIMx5V/8lcG3oUnEMc5QRISMkHKAevs+EJmn/wvLX335UBW
         kv5fmH1pC0ngUqVJKSISTX26yC8K4St37Knp7tR4ODLwjMe+oz1pYEfTEAlKv+BuSxsC
         kTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=tqL9U//y5mnl9UT2TzE9aF40cu5r1lEwRulehFj9YQU=;
        b=dvCWMYPgz0IsUiX2L9A6x45ZaNa9GEaQ1Fo5s2JT/UnUIMHYS6DS+mMsGJUXBfQEQg
         CW6n8NXUT16u2aD6nrJCGSB1F33f9Z9eHG8Pk/10clocXdM3NDHPb8SiE6aXjFsD8vtA
         b8zehE6MeD2m4LtZm9C1TuRjAGrzXL0aez3h/BvTY2YZvAvfaIjZdNhXutn1B6NC+T/y
         Le2DY9cOmWUpgALj/bA0apGcxnsRyjRwWWkbnC+OqKaDnpEcaM2dTZ0k7CBDqQD6RRlg
         /p4aREBfoeLw81YGnDGoP/50OZAcibpdz7NxfPUq2RuCDn3YlUWaI1DVuCRUpN/OgL0L
         KrQQ==
X-Gm-Message-State: AGi0PuaE9nyySFwoByEMcebbTfw0PdWKLkQdTgpT3dDLPgqY/geHIaQu
        Ze8202aOC5vinHJ2gnSDy4Q=
X-Google-Smtp-Source: APiQypIIxOuTBW+tqVf/rrBOZMOpIZ6AdroW2RE3Ovum9Sb5nZ8K7vDTVsg3EFVP4EGoTGCrJjIrBQ==
X-Received: by 2002:a63:1759:: with SMTP id 25mr21617119pgx.417.1587958236278;
        Sun, 26 Apr 2020 20:30:36 -0700 (PDT)
Received: from Slackware ([103.231.91.68])
        by smtp.gmail.com with ESMTPSA id d8sm11114996pfd.159.2020.04.26.20.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:30:35 -0700 (PDT)
Date:   Mon, 27 Apr 2020 09:00:23 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     david@fromorbit.com
Cc:     LinuxKernel <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: xfs superblock corrupt,how to find next one!
Message-ID: <20200427033023.GA30304@Slackware>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        david@fromorbit.com, LinuxKernel <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

  Hey Dave/Darrick,

  I was stumbled over this last week and ended up recreating(huh!) the
  fs from the scratch . Internet was littered with the information which
  I hardly could use. Oh, btw, I did stumble also in old google group
  where you suggested few stuff to do .=20

  But alas, none come to handy. I have tried xfs_db and it spit out lots
  of info including AGS ,but..I had  a simple requirement , just to
  replace the corrupted super block with another good one. Which,
  everyone including you know it very well that can done in ext in a blink =
of an
  eye(my lack of understanding and exposure are pardonable I believe).

  But I couldn't find an easy way to recover the fs.I followed the
  repair ..get into db as I said ...

  Is it lurking somewhere which I failed to discover or it has been
  implemented in different way , which is not easily decipherable by
  ordinary users...not sure though.

  Kindly ,point out ,which route should one take , when they encounter
  that kind of a situation. Recreating the fs is not an or probably the
  least option to opt for.=20


  Thanks,
  Bhaskar

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl6mUc8ACgkQsjqdtxFL
KRXh+gf/S4XIXZJPU3dFUyujCUJYWAWCWjf40fdrhuhtdM3Sapb8OOKW4tNsrR4r
oo9K7TvZOwmhiUY5aRRwii6gMA+k92cnlsOwhjsA+geZTfhW1wdez9sy79W6Ben4
H8LgeT+DqGp1tMdtajmJLOkkDqcE2xIBzspuU8BU23qC0HEpy1XN3SOV/ly0nOBi
cMOywgnJyQ3lE9oeHkqViuq12oBXEuuHplh9b6D/0i6R1Vr/pc+PUd85XIgZ+OkI
6Yv4uOfsBkFIHTNDYtm2fv2C2C3qardtO4v9kVWCg5J2TqrCy72CUAYfKk70ZOKw
neDhA2O8XWfAy4gdyJ1qzFQ7lCx5aw==
=SdUE
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
