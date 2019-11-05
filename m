Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5872C5DF62
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 20:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36CC21A49
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 20:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbfKEU5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 15:57:24 -0500
Received: from outbound.smtp.vt.edu ([198.82.183.121]:51922 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729906AbfKEU5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 15:57:24 -0500
Received: from mr6.cc.vt.edu (mr6.cc.ipv6.vt.edu [IPv6:2607:b400:92:8500:0:af:2d00:4488])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id xA5KvM9g011141
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 15:57:22 -0500
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        by mr6.cc.vt.edu (8.14.7/8.14.7) with ESMTP id xA5KvH5E028343
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 15:57:22 -0500
Received: by mail-qk1-f199.google.com with SMTP id b82so1023111qkc.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 12:57:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=MBXhOxNin9mvpJEf+EL+olFVquhzYl5dF3xWGaJhuMU=;
        b=eiuT6Kt3Ue+7sz7OjOuEgTDs5vDuWiBhEPsHPTmnSF9h0hSWc3VZrd3OnuVQnxxy00
         WzPFFtOxbpU4ME9V3w8QIj5/txJ5vZko+9rr4Cfz8B/62d6HL+656FqGfAaENlF5+Yh+
         sge4uV85ZFTVQN9zhqY8tIT8U2Rys9hCdu3DQNfn6OQvYTlZUUvyurG1HcR8D/Wm9q/p
         tZZQwen6NekqS9oO66dJ2F77kKdktUZHnaerSbgE3cGRd2Y50Yap0pzIYUbB9rClO/kJ
         Zn36LlS6Hf7lAHKI/IzyymlwM136fnZ34XFulF1MiScKTMDFD6z3rzKfm4HFeoXkntgM
         48hA==
X-Gm-Message-State: APjAAAXZS0jW1PWPiG2AGmLy+eU9EvChrdmjk0bpius31WKGLQAaFkuK
        cBN0jwB8gBn1NNw2Prv4oXyo7Ajshut+Yc3r7bw3j2OsIcwFRO8UUP+me806lpZv4AwitVMUsVZ
        fJzOxCpwiF2QEoMrsWjdf5vLKE7zTEM0=
X-Received: by 2002:a37:b403:: with SMTP id d3mr22864304qkf.415.1572987436641;
        Tue, 05 Nov 2019 12:57:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqxDNTKWJZSa0xMopygThw6VT3DdT7WC8At6HBen1ZT58IvMEY+XYz6wkkA8lFAhsp9RuyzHJw==
X-Received: by 2002:a37:b403:: with SMTP id d3mr22864288qkf.415.1572987436234;
        Tue, 05 Nov 2019 12:57:16 -0800 (PST)
Received: from turing-police ([2601:5c0:c001:c9e1::359])
        by smtp.gmail.com with ESMTPSA id m5sm8676126qtp.97.2019.11.05.12.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 12:57:14 -0800 (PST)
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] errno.h: Provide EFSBADCRC for everybody
In-Reply-To: <20191105024618.194134-1-Valdis.Kletnieks@vt.edu>
References: <20191105024618.194134-1-Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1572987433_14215P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Nov 2019 15:57:13 -0500
Message-ID: <249994.1572987433@turing-police>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--==_Exmh_1572987433_14215P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Nov 2019 21:46:14 -0500, Valdis Kletnieks said:
> Four filesystems have their own defines for this. Move it
> into errno.h so it's defined in just one place.
>
> Signed-off-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>

Going to have to retract this. and the other patch for EFSCORRUPTED.

On Tue, 05 Nov 2019 10:17:52 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> said:

> Does that work? Six architectures (alpha ia64 mips parisc powerpc sparc)
> have their own asm/errno.h. ia64 and powerpc include asm-generic/errno.h
> from their asm/errno.h, but the remaining four will no longer have a
> definition of EFSBADCRC.

I knew some architectures had their own syscall values.  I admit it comes as
a surprise to me (and probably a number of others) that errno.h is that way too....

Thanks for spotting this, Rasmus...

--==_Exmh_1572987433_14215P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBXcHiKQdmEQWDXROgAQILDg/+IpFcal1QlvbuIHm2Skf6HofxtKqb0d6M
tK77zP5Q+nv9p4o41Nh3lYk5p3an6xlcd3157L9fmOjQFy8dZJbY8i07oVCO/gtS
oV8xesp6X7uYEgSARDK6lO/1/9bAuCt4ghd5lKcsyBKDv1MQ80x3+mWx++oV1SG4
EYqkIglqmnZ2ZrielunCbKqSqs0tUY50ayaogkISJzMDliTsYfTMpWF+MkrYiuEU
kSQ8ifkclZ6rRQgeQzYRe/7Q4x02sudSWPkWHCOw5Gtg4vd0H7O4OhCadSt44uHv
Za+sDJ3TZ5bUlROV5SKj3Jfrp2EuuW3jbFHEVEvjrP5rZbOC6sPKy4N81oDCYQ5X
SbNfryx8h3CwOtGM6hgtLj1U3BFNESqkc6TnAarC8015rEbOoZn9vivgrtZ1xB6n
K9XXs1guqWZ2xBPdFbOTmv6T3Heg8Y4c/GhV/PcRTV+XZzUs77SmAKtaH9qH9bkf
efM4xNwEyBJsFn3ycYeP1lAjxlhJPsyEQVKfGNcyzGq4jP4EHNpWclncbZ9Wf/mw
QzHYeoP5jtmf2Mppe6/nTGm5Mdra1IptAZKdBRehe4XJc78exI3mfAi/2LoqHuzy
6EiVhn2WrtzPJ+s4SzNud9tOQz5tRhvh2wjiY0pDWYXMX8xg2DvdWpj03bM5ojHA
ePHUo1dE0Xs=
=2I65
-----END PGP SIGNATURE-----

--==_Exmh_1572987433_14215P--
