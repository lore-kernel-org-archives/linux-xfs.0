Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B663C5DF60
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 20:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2292B21A49
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 20:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbfKEU6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 15:58:48 -0500
Received: from outbound.smtp.vt.edu ([198.82.183.121]:52222 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729739AbfKEU6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 15:58:48 -0500
Received: from mr4.cc.vt.edu (junk.cc.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id xA5Kwl49011551
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 15:58:47 -0500
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        by mr4.cc.vt.edu (8.14.7/8.14.7) with ESMTP id xA5KwgP9020374
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 15:58:47 -0500
Received: by mail-qk1-f198.google.com with SMTP id 64so22574294qkm.5
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 12:58:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=S50K21onMwLaHq3dPT4Qwhc6hjGO5VfOOOJ5JGwTxQE=;
        b=hlkJPVVwsiYyzTTwV/xDsftI6azsoJ0dSj3C3n4/VNM0kGVjRij/vEuFRuSXf/u23d
         2fmkQfK1JZXrvkBy2MoiS5J2wGCI56mZJ3JQMrHxCcdQ9NQEAb3xGbSgPLbM+7uMkfGS
         uM1xqKowivQQwCPZlcgJvnSi9y43EjehwnVXkQYT0pl7Q5OaUOjepwF0ysGAG1d0332d
         HiWjqQzd20ktDm9/iU4yBpq/KDsMGtu/8vGl4Q607S7ySYCcUOIOcNV/z9gIRDYOTSQQ
         3Us3ph7ocLCNtkDz9QUPtQ/QHtxNdaaYtpsuUqesa8qrSi45rw2Cvp6z/9iGWVOLlLb3
         +m7w==
X-Gm-Message-State: APjAAAVt5lwM108wK45VhmizGwB96oABGOG1Y2TnAESLsqyhyKPAEIcW
        n9sGMTzD101KhQPkpBi06e3JWlz69j1EW1NsFn0JexvzEoKQJCzxRMUcPAJCrXZhy75r5cWQhD/
        8VOFZKPsRfuyq5Pk3T0/arWRhqxNSYNk=
X-Received: by 2002:ac8:524a:: with SMTP id y10mr18951014qtn.325.1572987522080;
        Tue, 05 Nov 2019 12:58:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqx24doZC2vszjGyzN8ksjbbXYHRswolJBukeRP8MxDNjSGnmrve+cRRNS5kWu9wK6cSyWOUJw==
X-Received: by 2002:ac8:524a:: with SMTP id y10mr18950991qtn.325.1572987521831;
        Tue, 05 Nov 2019 12:58:41 -0800 (PST)
Received: from turing-police ([2601:5c0:c001:c9e1::359])
        by smtp.gmail.com with ESMTPSA id k17sm9903799qkg.63.2019.11.05.12.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 12:58:40 -0800 (PST)
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] errno.h: Provide EFSBADCRC for everybody
In-Reply-To: <20191105151736.GB4153244@magnolia>
References: <20191105024618.194134-1-Valdis.Kletnieks@vt.edu>
 <20191105151736.GB4153244@magnolia>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1572987519_14215P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Nov 2019 15:58:39 -0500
Message-ID: <250143.1572987519@turing-police>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--==_Exmh_1572987519_14215P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Nov 2019 07:17:36 -0800, "Darrick J. Wong" said:
> On Mon, Nov 04, 2019 at 09:46:14PM -0500, Valdis Kletnieks wrote:
> > Four filesystems have their own defines for this. Move it
> > into errno.h so it's defined in just one place.
> >
> > Signed-off-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
>
> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> You can build all six filesystems with both this and the EFSCORRUPTED
> patch applied, correct?

I can.  But it was pointed out to me that it blows up on some architectures..



--==_Exmh_1572987519_14215P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBXcHifwdmEQWDXROgAQLj5RAApcBiDjlLyeNreRjX2DmNwO+Ua9G5e5Sp
eXKK/n2L2aQzyRQz7vGUMquNdBYorbtXuzT13bysejTkkkISSGz9lABhFZibT3n5
EUxZmFM8LKoRYx+sAkw3sHfwj4pmLhuz3O5GXA3IkEn57++QiOoi+QR01H7B6KIU
2W2NoauIR6t5hiO83EIpioJq07WOm1QP46diNozGGCskSwgEeJVXnWMNoIS23Xc7
OK1FlYHnJ0wxDtnuzCEb9rOoi7u1Fr3FXTwpLo5V2krxLdW+jYhIRSoK+UPM0yky
HIKCcTErRDckrbcT4+T6uszVrt+tXLdZE/mWgHLqbWnfB3g3Hh4C1ccX7TWqAG5S
63ok39pe6rDa5sTRwHhEhIfBKOWXhGA1XNay3cWCgBroEwPpz0Zhy8xBP397bwZA
7RubcSMY6Ct4tTUsS/8Ocmo/U0Kuo6k3El246di3UILbLQ1hvUXBeHtBbNKD0u4u
nHhCqndqK0JAluIzlkpqVkcFXSWBlzlxfpNNNpgrr3aIGkwFWjJnsgkhB9T0cT4L
8gK8W3Ly4V8A+oYoI4MgZ1LJ+jN/y7aDpDMHL3mjBECucfSmvaZLbRTOiAN7OHdz
J7lkyAPaFi9NCVNYzS4tKLPOQcgJIA+GMCfSGmEAWiW07o2qb62I1kJz2vSkiTQC
j0Tlv0TH9BI=
=1Y8S
-----END PGP SIGNATURE-----

--==_Exmh_1572987519_14215P--
