Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF81CD3432
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 03:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjISDcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 23:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjISDcE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 23:32:04 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECDD118
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 20:31:58 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c09673b006so38137915ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 20:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695094318; x=1695699118; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oII5LNgWAejwLq5mJbDAiZazD4/og3mJqweJQN/9rU8=;
        b=UOud19ER5Uc1t1OIvTxhMo+mPacyc5tsE8kw63IwiFPq8GkSex8QDXPkrL2eliysxJ
         /npxNcLJcJhPnFPZHiyxgpBpht2FgW9MhwrOzHI1SeY/T6JrF+6F2r59nD6wUK/md96W
         wXuax2+OwJTrgcOTnX5ct2b5JYtfd/6Sph4XRQWF6sP08FdyhElDhkjCk3D01eVgIAF+
         /vDFcAFzjTnq4QscLIXrItRFUdCA22e7DOQ2wXESEin4Ze6+lIk4pJr/oCr77VIXtk9C
         HiLOv2cJclwuudPLGhBExPsS5JUHkHa0VzrbRdLGaH7CkeAO0+iXArqN/bDbbO6mNq/T
         7vdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695094318; x=1695699118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oII5LNgWAejwLq5mJbDAiZazD4/og3mJqweJQN/9rU8=;
        b=ifvHUt/81MMOyQDLXWddTqd2vaEc+dzoIjE3YMm9DXTl31Fdq2zwUcHg01WmvCpZmi
         uNeMgPxSqjRwWc97+ftteMql+Yw/vbg086Vz7PsRws4dvc8wttBcJomtMIPr5PX2VVn6
         hIlBje1wO3lj1XAmpkJCADn0sDQ88uPgDmYuEgchF4Y1zqtcJlDOH+5RhouaECuECSl9
         /bMkeifHZO8XTHw+HxSJu+/IsuRo0STzi9UzmY9aCX39bdpAMPDPuzPAo0vBaKufnoPj
         NdZ2fOAHQE+vMpz72Uz9sRjBDQ2esu/TQRLa/07xYJmCv/4Uqrkt5AG/ZaG99o8dGKxe
         MoaQ==
X-Gm-Message-State: AOJu0YxCd5JVAu+4+VzjOQHEJ1uuFJq/o39/tvIkr1K9W7VeHOvfilhc
        5P1OkLshyKUslCacDuo80GMMzHDC2wk=
X-Google-Smtp-Source: AGHT+IGlLFmGz2RtD+kb/y8EW9RqDPd5HPpvwsijoUNv5D25sb2tEDe4YSc8u/CbymR5v58/S5o3pw==
X-Received: by 2002:a17:902:ea0f:b0:1c4:72c9:64fc with SMTP id s15-20020a170902ea0f00b001c472c964fcmr5244822plg.22.1695094317701;
        Mon, 18 Sep 2023 20:31:57 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id n9-20020a170903110900b001bc930d4517sm8946357plh.42.2023.09.18.20.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 20:31:56 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 92287819448C; Tue, 19 Sep 2023 10:31:53 +0700 (WIB)
Date:   Tue, 19 Sep 2023 10:31:53 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Message-ID: <ZQkWKdkHTZXU_fHN@debian.me>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Rg7CLVaO9ozWVidg"
Content-Disposition: inline
In-Reply-To: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--Rg7CLVaO9ozWVidg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
> - Write a test case that performs a FICLONERANGE2 copy with a time budget.
>   If our implementation allows FICLONERANGE2 to be restarted after a sign=
al
>   interruption, we can test this by creating a loop and setting up a sign=
al
>   via alarm(2) or timer_create(2).
> - Write a test case that generates a file with many extents and tests that
>   the kernel exits with partial completion when given a very short time b=
udget.

For the actual tests, what are selected time budgets that are to be
implemented in the test?

--=20
An old man doll... just what I always wanted! - Clara

--Rg7CLVaO9ozWVidg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZQkWIwAKCRD2uYlJVVFO
ozipAP96lTdd++Wc6Uz2UCimEues0bBXpDXKwf3PSMl5R7qHlgD/dbZ57sVxN06b
2Kp2CEu9VEC3KwStcvmzHJzX8ISllg4=
=RVw0
-----END PGP SIGNATURE-----

--Rg7CLVaO9ozWVidg--
