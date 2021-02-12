Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77ADC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 977F864E36
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhBLV5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhBLV4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 16:56:33 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935C1C061574
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 13:55:18 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id y10so499401qvo.6
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 13:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nwI0wtbgdnusA2pYcigLlKl6qfisAE5u0jQBxRw+r/k=;
        b=GSiFci1852kbhXR3wVgP7fFNvx5oyDNqHQjPG7LPJdVzmq+JuLjfMfBpsu15MBF8/8
         sHjvU7h2sB0fPsc2vpOZ0MSliK+nAkujWFazUpfZtUF8t3cozRRB+aZq/s1VCKpD1jFA
         8ne8cyICGMUff4lWJtOtuaQXFeE2nHM6Nn+gI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nwI0wtbgdnusA2pYcigLlKl6qfisAE5u0jQBxRw+r/k=;
        b=f2eDV5fmM5YSrQCWxdbAf5aGnJKu6C9LdofUr8z2R2CcNWxkS7ZsRu/e+2Bgh7AOkD
         genUVDSEKRJOm1UOYMWl1TaBNUJrle+IR4wOLGF5J4jvvyC0ClDHpND/OSQoc1GGjCIV
         /GRj2k4GHpZ2TSwJ6ges0MY15+E9iTzl9iHiqFftXFgAYDho51P64zFhTMkzfSBu/l0s
         vIgb06JA9utvO8pKBRybor33qk5zNTuiEO1Xr2c/dkWKakG3fSagztlvTZwQ7yeEY4DU
         9tDGItC5459WTITP4AqpzI6E5cVZk3UZPtRlEAMHttydiUJzqYkHKplP2CJVrm03+nXg
         Z0SQ==
X-Gm-Message-State: AOAM530r02DwZ51oURNcQCbCcotXb8n0H7WPuBlhL0IaKh0PSMq4pDbW
        fANuM1EowJbmSchRw9j1BIyU1eXxQee3F/e6ZD7VXKmJpSpV/BWf
X-Google-Smtp-Source: ABdhPJxUYttEGohSBQfkpsuIXgBMSMeGpwIRxQbFgyZ/DHb5cf8SosH57FUPUDFpuGZveA0IOEJCOt+Rd+cvKFju7L4=
X-Received: by 2002:a0c:b611:: with SMTP id f17mr4452917qve.42.1613166917595;
 Fri, 12 Feb 2021 13:55:17 -0800 (PST)
MIME-Version: 1.0
References: <20210212204849.1556406-1-mmayer@broadcom.com> <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
 <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net>
In-Reply-To: <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net>
From:   Markus Mayer <mmayer@broadcom.com>
Date:   Fri, 12 Feb 2021 13:55:06 -0800
Message-ID: <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Linux XFS <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 12 Feb 2021 at 13:29, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 2/12/21 2:51 PM, Markus Mayer wrote:
> >> To prevent issues when the ".o" extension appears in a directory path,
> >> ensure that the ".o" -> ".lo" substitution is only performed for the
> >> final file extension.
> >
> > If the subject should be "[PATCH] xfsprogs: ...", please let me know.
>
> Nah, that's fine, I noticed it.
>
> So did you have a path component that had ".o" in it that got substituted=
?
> Is that what the bugfix is?

Yes and yes.

Specifically, I was asked to name the build directory in our build
system "workspace.o" (or something else ending in .o) because that
causes the automated backup to skip backing up temporary build
directories, which is what we want. There is an existing exclusion
pattern that skips .o files during backup runs, and they didn't want
to create specialized rules for different projects. Hence the request
for the oddly named directory to make it match the existing pattern.

We also have a symlink without the ".o" extension (workspace ->
workspace.o) which is commonly used to access the work space, but
symlinks  frequently get expanded when scripts run. In the end, the
xfsprogs build system saw the full path without the symlink
(".../workspace.o/.../xfsprogs-5.8.0/...") and started substituting
workspace.o with workspace.lo. And then the build died.

Like this:

>>> xfsprogs 5.8.0 Building
PATH=3D"/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/ar=
m64/host/bin:/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/outp=
ut/arm64/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:=
/bin:/usr/games:/usr/local/games:/snap/bin"
 /usr/bin/make -j33  -C
/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/buil=
d/xfsprogs-5.8.0/
   [HEADERS] include
   [HEADERS] libxfs
Building include
    [LN]     disk
make[3]: Nothing to be done for 'include'.
Building libfrog
    [CC]     gen_crc32table
    [GENERATE] crc32table.h
make[4]: *** No rule to make target
'/local/users/jenkins/workspace.lo/buildroot_linux-5.4_llvm/output/arm64/ta=
rget/usr/include/uuid/uuid.h',
needed by 'bitmap.lo'.  Stop.
make[4]: *** Waiting for unfinished jobs....
    [CC]     avl64.lo
include/buildrules:35: recipe for target 'libfrog' failed
make[3]: *** [libfrog] Error 2
Makefile:91: recipe for target 'default' failed
make[2]: *** [default] Error 2
package/pkg-generic.mk:247: recipe for target
'/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/bui=
ld/xfsprogs-5.8.0/.stamp_built'
failed
make[1]: *** [/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/out=
put/arm64/build/xfsprogs-5.8.0/.stamp_built]
Error 2

Regards,
-Markus
