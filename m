Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3402C10F27
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E032468D
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YoxbAKWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgCJLMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 07:12:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41020 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgCJLMY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 07:12:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id b1so6148826pgm.8;
        Tue, 10 Mar 2020 04:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Da8jl6k22PBSRxknPYcTChU/8VxX5cVJ/2imS9NsIVQ=;
        b=YoxbAKWxagmGU6FqVmCXQaJJXRScELlB+p+tAMWUIaQONESZSfKOFryLqNNGNxlcoo
         15DI2jOjYKkQSrwcXJAKp0m4KcWEEYHO7fwSqMTSLavb0fGFboMTmXf3hNy3igK2XLqa
         wlVLRcB79LuuMMF0kR5WXNdGr7GNWZcYQ+v4E8fKb4IIovZFF3Ui576TqBBRH30gCeYU
         oit1I5fq7tJ7iYzR8HZJWTGf6pUOA6qiAmcNIn7O7xjYXXqBaIjAopCrMgg8KO0U06jc
         p/2lwgOP3VfVokfq2ZaVDjqh5jg+opIiMMXWECGEa3SpH+CSpesImG5xv5yruzK4UeuP
         HUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Da8jl6k22PBSRxknPYcTChU/8VxX5cVJ/2imS9NsIVQ=;
        b=d5cBXeE9+NlcNuQIwPdkg2+rh2bnqs+imraItPFTEb209lx0Plbpgfb1Lify+8b03u
         7J7iLPtr/S632Cb1BbbVznusXSOEBtjvVbnOSsk5T1vcCVw4yVeuspuoG0th4shsh+F6
         h+Mjo5zcw6sYKTdBZk8bVKc/S0KyH0icnzz5O6WrGGsfd4/AdQiWt1gsdjzUrcz/aRPL
         4SPwEvRb2okur/78T936e2VT9e7m3NTY1fvcd7a2h1r5SkSmRgL+yjTJc93Eb2As0cMT
         YNA9vsWAYavz/LxlWTakCJMpOipHCUtjbgoTdaM/lHHNhw8jbDtGOLmyVZTMz+WAP4Zw
         GQ0g==
X-Gm-Message-State: ANhLgQ0xQxsz6i0gFrX3+VO/qazB92uW5KNdEzjo7PyjIou3P5JRg6Rc
        PqwIilhukp6jIDDXmbAiV20=
X-Google-Smtp-Source: ADFU+vtqRaKgwvejuIJkNNqlwejAu59lTJxUaRMqNrFDCKq/zZCbtpGJWLXq7K3I2xMCpHhtQmQXEA==
X-Received: by 2002:aa7:80d8:: with SMTP id a24mr1969pfn.140.1583838743980;
        Tue, 10 Mar 2020 04:12:23 -0700 (PDT)
Received: from Gentoo ([103.231.91.74])
        by smtp.gmail.com with ESMTPSA id 64sm47798625pfd.48.2020.03.10.04.12.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 04:12:23 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:42:08 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
Subject: Re: 5.5 XFS getdents regression?
Message-ID: <20200310111205.GB3151@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
References: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:45 Tue 10 Mar 2020, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:

Okay, hang on! don't you think you should query at fedora mailing list
instead here??

Because you are running fedora kernel and I believe it is patched by
their team. So, they might have much more concrete answer than to ask
the file system developer here for the outcome.

Kindly, provide the bug report to them fix your owes.

~Bhaskar




>Hello,
>
>One of my GitLab CI jobs stopped working after upgrading server 5.4.18-
>100.fc30.x86_64 -> 5.5.7-100.fc30.x86_64.
>(tested 5.5.8-100.fc30.x86_64 too, no change)
>The server is fedora30 with XFS rootfs.
>The problem reproduces always, and takes only couple minutes to run.
>
>The CI job fails in the beginning when doing "git clean" in docker
>container, and failing to rmdir some directory:
>"warning: failed to remove=20
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200114155413-6afb5195e5aa/intern
>al/socket: Directory not empty"
>
>Quick google search finds some other people reporting similar problems
>with 5.5.0:
>https://gitlab.com/gitlab-org/gitlab-runner/issues/3185
>
>
>Collected some data with strace, and it seems that getdents is not
>returning all entries:
>
>5.4 getdents64() returns 52+50+1+0 entries=20
>=3D> all files in directory are deleted and rmdir() is OK
>
>5.5 getdents64() returns 52+50+0+0 entries
>=3D> rmdir() fails with ENOTEMPTY
>
>
>Working 5.4 strace:
>10:00:12 getdents64(10<
>/builds/xyz/.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492d=
fa37a
>/internal/socket>, /* 52 entries */, 2048) =3D 2024 <0.000020>
>10:00:12 unlink("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket/cmsghdr.go") =3D 0 <0.000068>
>10:00:12 unlink("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket/cmsghdr_bsd.go") =3D 0 <0.000048>
>[...]
>10:00:12 getdents64(10<
>/builds/xyz/.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492d=
fa37a
>/internal/socket>, /* 50 entries */, 2048) =3D 2048 <0.000023>
>10:00:12 unlink("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket/sys_linux_386.s") =3D 0 <0.000062>
>[...]
>10:00:12 getdents64(10<
>/builds/xyz/.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492d=
fa37a
>/internal/socket>, /* 1 entries */, 2048) =3D 48 <0.000017>
>10:00:12 unlink("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket/zsys_solaris_amd64.go") =3D 0 <0.000039>
>10:00:12 getdents64(10<
>/builds/xyz/.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492d=
fa37a
>/internal/socket>, /* 0 entries */, 2048) =3D 0 <0.000015>
>10:00:12 rmdir("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket") =3D 0 <0.000055>
>
>
>Failing 5.5 strace:
>10:09:15 getdents64(10<
>/builds/xyz/.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492d=
fa37a
>/internal/socket>, /* 52 entries */, 2048) =3D 2024 <0.000031>
>10:09:15 unlink("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket/cmsghdr.go") =3D 0 <0.006174>
>[...]
>10:09:15 getdents64(10<
>/builds/xyz/.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492d=
fa37a
>/internal/socket>, /* 50 entries */, 2048) =3D 2048 <0.000034>
>10:09:15 unlink("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket/sys_linux_386.s") =3D 0 <0.000054>
>[...]
>10:09:16 getdents64(10<
>/builds/xyz/.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492d=
fa37a
>/internal/socket>, /* 0 entries */, 2048) =3D 0 <0.000020>
>10:09:16 rmdir("
>.vendor/pkg/mod/golang.org/x/net@v0.0.0-20200301022130-244492dfa37a/intern
>al/socket") =3D -1 ENOTEMPTY (Directory not empty) <0.000029>
>
>
>Any ideas what's going wrong here?
>
>-Tommi
>

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl5ndf4ACgkQsjqdtxFL
KRVpNggAr5qxaEzUzYPeIb17eIgDp/gcPbtaG0jiBH/H2YPbBIfflB10/+XJlFVY
/flXQ8u/5sFk+Zwlcf3VpftmOG3dEgEDSmiQcLvlWQnvZmK8hL+XhjhOfCIpdCbQ
H8mfbkKsbsIjlf3atYsDxSHARi7KlPMks82il/GlUDjp0pAxOHwscUEAkN/KB8/U
QC28EoRIxG/HlPb8fPa6FXkoMBVi/WMF/zKQTYX+Je9hsRUZvfbmO1Yy2sqdayZD
qzLALqsbh0eaW9lbZCjOFNfxsjspYPkA0MoEf8FmEG+has+ApZjtfVRFqMtcvbLJ
Ae2qce5vNN6uu9ONZljAr541OlOjbA==
=TU/r
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
