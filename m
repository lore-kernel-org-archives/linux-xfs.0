Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9239CE732C4
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 11:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjI1LYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 07:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjI1LXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 07:23:44 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D751FEF
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 04:19:21 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-5041d6d8b10so21175058e87.2
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 04:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695899959; x=1696504759; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLBLLMD2f31+xnhZOlxPkL12brW0awGEKMX3uE3yq5Y=;
        b=jyNAXf03ljp7H3jmBVjy2tg5l5HxEIDghKXcX+2mwDneW8TBpVjNahZDrD0eJH0/I/
         eaZ3XG6OcZbdrTx72gSwBsBIhK1V0lXp/LPh67VLtASO7Emg3NAhS/A+JeE/zJ8VTWOM
         Z3Cp6U53tGPHc0YaK+FGldm89yXMJvQNIfKLAKlTDtnuMOI1b8L81Dj7ntgHPpn6vGH0
         Vk0vK1+8KcZ7IKWYDyi2u4X28P93VP5YXsalBw9pu+3IEfTJ2wIlngUEXc9pKgdnN1XG
         iytzNqVjQy4WTOlTqWZHALBIbQqHe/k9C7agE0YLsUrEm2lVMJ6j34zo72DWmuRHy8sV
         2Sww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695899959; x=1696504759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLBLLMD2f31+xnhZOlxPkL12brW0awGEKMX3uE3yq5Y=;
        b=SlJkUUnPy2o/4bo4UtfmvdmI3Abp6POECX7JpYrDAcJxPPvc9llh361yr8RTfLRbGF
         3/OFOWtiI7bhX8HUsbSgf1Q+kbxhcBW67ULGv7QqCDR02fdHCFF/HP0dVhgQ4pZAb9iG
         YG1CCdzDhi3JZR9FUZ5TnXGm+8QzJfKbwE73pJFby7rX2s78TXRQ1iRhHp9vnUWGv/GH
         +13+gcoEG9Oy6dfOMdEKVkQTX/aScR8rh2VYDXvggriNEvP4RXnhW3k3GC84uPChMuT3
         NUTBPIOFtRhkZJ9582zBui9rzDqGGqkVLVEt0ZU3o/UwBqpllb0rt/j3DipJ7moHDMZb
         YRHw==
X-Gm-Message-State: AOJu0YzKgA6NrV98BI+xHOqGUf29SfL/3IA9YjSfWpm/yXSEFDEm1oRY
        /57gJtrnooLpDILyb0gFQiZlM5Z9lHJkytzXgUM=
X-Google-Smtp-Source: AGHT+IFomS5JLKceDfCXsmVRVWiR0L5zwNvsq0dOCD4bXlLJOHqbDAjOxRP5cmRkzfJh+qAiKhqyM8fsOANqwv6i1Y4=
X-Received: by 2002:ac2:434d:0:b0:500:7685:83d with SMTP id
 o13-20020ac2434d000000b005007685083dmr803627lfl.48.1695899959268; Thu, 28 Sep
 2023 04:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230927063847.81000-1-knowak@microsoft.com> <20230927142742.GG11439@frogsfrogsfrogs>
In-Reply-To: <20230927142742.GG11439@frogsfrogsfrogs>
From:   Krzesimir Nowak <qdlacz@gmail.com>
Date:   Thu, 28 Sep 2023 13:19:08 +0200
Message-ID: <CANoGTXAJjH+AGo=7gNHB4b9VMwo13QD4yZSTu8gauGFPxtwP9g@mail.gmail.com>
Subject: Re: [PATCH] libfrog: drop build host crc32 selftest
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Krzesimir Nowak <knowak@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

=C5=9Br., 27 wrz 2023 o 16:27 Darrick J. Wong <djwong@kernel.org> napisa=C5=
=82(a):
>
> On Wed, Sep 27, 2023 at 08:38:47AM +0200, Krzesimir Nowak wrote:
> > CRC selftests running on a build host were useful long time ago, when
> > CRC support was added to the on-disk support. Now it's purpose is
> > replaced by fstests. Also mkfs.xfs and xfs_repair have their own
> > selftests.
> >
> > On top of that, it fails to build when crosscompiling and would be
> > useless anyway.
>
> Nit: It doesn't fail if the crosscompile host itself has liburcu
> installed.

Right, our (Flatcar SDK) host didn't. I'll amend the commit message and res=
end.

>
> > Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>
>
> Nits aside, this is a good simplification of the build process, so:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks!

> --D
>
> > ---
> >  libfrog/Makefile | 14 ++------------
> >  libfrog/crc32.c  | 21 ---------------------
> >  2 files changed, 2 insertions(+), 33 deletions(-)
> >
> > diff --git a/libfrog/Makefile b/libfrog/Makefile
> > index f292afe3..8cde97d4 100644
> > --- a/libfrog/Makefile
> > +++ b/libfrog/Makefile
> > @@ -57,9 +57,9 @@ ifeq ($(HAVE_GETMNTENT),yes)
> >  LCFLAGS +=3D -DHAVE_GETMNTENT
> >  endif
> >
> > -LDIRT =3D gen_crc32table crc32table.h crc32selftest
> > +LDIRT =3D gen_crc32table crc32table.h
> >
> > -default: crc32selftest ltdepend $(LTLIBRARY)
> > +default: ltdepend $(LTLIBRARY)
> >
> >  crc32table.h: gen_crc32table.c crc32defs.h
> >       @echo "    [CC]     gen_crc32table"
> > @@ -67,16 +67,6 @@ crc32table.h: gen_crc32table.c crc32defs.h
> >       @echo "    [GENERATE] $@"
> >       $(Q) ./gen_crc32table > crc32table.h
> >
> > -# The selftest binary will return an error if it fails. This is made a
> > -# dependency of the build process so that we refuse to build the tools=
 on broken
> > -# systems/architectures. Hence we make sure that xfsprogs will never u=
se a
> > -# busted CRC calculation at build time and hence avoid putting bad CRC=
s down on
> > -# disk.
> > -crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h randb=
ytes.c
> > -     @echo "    [TEST]    CRC32"
> > -     $(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=3D1 randbytes.=
c crc32.c -o $@
> > -     $(Q) ./$@
> > -
> >  include $(BUILDRULES)
> >
> >  install install-dev: default
> > diff --git a/libfrog/crc32.c b/libfrog/crc32.c
> > index 2499615d..d07e5371 100644
> > --- a/libfrog/crc32.c
> > +++ b/libfrog/crc32.c
> > @@ -186,24 +186,3 @@ u32 __pure crc32c_le(u32 crc, unsigned char const =
*p, size_t len)
> >                       (const u32 (*)[256])crc32ctable_le, CRC32C_POLY_L=
E);
> >  }
> >  #endif
> > -
> > -
> > -#ifdef CRC32_SELFTEST
> > -# include "crc32cselftest.h"
> > -
> > -/*
> > - * make sure we always return 0 for a successful test run, and non-zer=
o for a
> > - * failed run. The build infrastructure is looking for this informatio=
n to
> > - * determine whether to allow the build to proceed.
> > - */
> > -int main(int argc, char **argv)
> > -{
> > -     int errors;
> > -
> > -     printf("CRC_LE_BITS =3D %d\n", CRC_LE_BITS);
> > -
> > -     errors =3D crc32c_test(0);
> > -
> > -     return errors !=3D 0;
> > -}
> > -#endif /* CRC32_SELFTEST */
> > --
> > 2.25.1
> >
