Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908EE134A8;
	Wed, 12 Feb 2025 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739385604; cv=none; b=k90U7180GOUcd9eYNaQGi3XzDmX7BN8Gz0HSwyoKLgAjcRo8dCIps72lLpPAeI9r7W6drCm92xA41+C7Lgz4gNqe2JrVFPv8jFAWV60oHrLLfS/a3umyb9NHqjaRv/gk8Me+XwgQJtcCNgAu4M4jhm5e12mWAuaMrmKgzE1l1+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739385604; c=relaxed/simple;
	bh=LP+SGmGCxPBCMOab2K0KFqZ0io2BfeFA9iaFb9gKQ6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZIkzWnjXqX3943cpXzapeh1TPEcpwFimPVeg9xs17yoiIZBkCaYfBs76eFjUAnoMQWQBG3lzcmucYKYOihC6gzrqmexYSrKkbegfsaSVeBumQWEc1wN7FNC8PM7etSS1TqKkT2wwxR6ECFA2NIvwZSE90bSUeIt57UN0iAC77A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DOGqZq3h; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOGqZq3h"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-47196e33b43so32460881cf.1;
        Wed, 12 Feb 2025 10:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739385601; x=1739990401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lh6NXkkBQKx4PXR+oYH9IGfimfXkrrE5NqMbDycTiY=;
        b=DOGqZq3hrUFy09f/BbjQrSXXqwHmmwb7xSe6ITeI1uVSaKcQ81/FqyXqe1Y9rSeTL5
         Ztr2JKGb6ok4VCwzUZ1fM4hCVa88rSNPjjLRgfAvoGfh6Qrgq/7U9Wjwq6Z9yO9Y1anH
         M4nvsgR2AxG8cvSm53OI+hplAidP35H3RBYP2WjWLaWEg4ZSfbOXfGWDrgW+2cD6q+ME
         r1rzZRZPzMVy1bYFvTZ67rWi6IA15YvD0ZMpI1Faswrj1fRsrQCKH1am8sWL/JQj30BS
         4yXHN0uUskuX9QPTMCDN2PpjG/zlSAIVAvJss31PUOI0GdvCs84l8t5NC/Z0kAwJYzNH
         sMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739385601; x=1739990401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+lh6NXkkBQKx4PXR+oYH9IGfimfXkrrE5NqMbDycTiY=;
        b=ZiJCFduZA/lhGk285X+9iQRv/Y1JG9+6qiSOUit7Le1CuIbyrWu5Jid6HwCBWNovZ6
         QS046g1XEslAPtzS4Oxlo6WDyfyUqnXjhaCFZDW79sORkHS7tt9+TS8qJeQ3daJL6OSY
         lARqJWUrnWJtHy20B3ovDDqtSunyOLH9FAp3HD0xZ3g7rFEbjPWkdau1GyNohFw8Gc01
         3UpQ+nUGLn34DezQEsmgfzhqxu3YA34SjNCVESBdRURSZtyKjXOLZfzyLvF7Tu7JrpGz
         B7N2CZ7X4Pgro3ctam2PZh18aSP731Zerlp/cbCsRjnQ48GdrleNnbCmPX+cXkWGl/QV
         OQKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIEfjnrUlIUB6Uns9mf7xoS+RiGw0MbyhxgGf7+mjkIG/BYN2YhDdCvG0TUiKSgzsPnuxGx6A/G0aU@vger.kernel.org, AJvYcCW/sVBfEzU2zGRHAzibga/Ja9Tp3b/ZTRYyCPrbYLuaOFX2mYnbBZ5eI2gVgaBHrtMPqZVj7R1J@vger.kernel.org
X-Gm-Message-State: AOJu0YyRVeUYJZE5WYWxUi1uDEu3p8v/55EqREKAk+CtDXDMOfxoohZ1
	KkFYvFr/Yohs2+7UlFPXbAwgpBLKj6+CrYDxUBckGOS65KXh6KlX0ifv4YPGdkPJg84RxGkjrpi
	CpOhbNIdretIdY5FplfuXpfFnOmo=
X-Gm-Gg: ASbGncutSZwf/rM9fw5XLMw+a307tLdpTfDGwVk6mjQQigUMK+5KzS1k/310hT26way
	o9vu6rqGsNR1rOlddsQ/RRo/7iXPiIaCHtYOMlDzFY4hk5e4JUMhV+YMYtTjGGCb3sn5ZXCr3hQ
	P9aVIUYgWqEoM=
X-Google-Smtp-Source: AGHT+IGimR44K+Dzc2hx14D5lef3D+BfqrfZ+C31VdtR0ycCjHXc9u9xfvi3W5xOhjnVmoA7RMkhsK+SPHEPWa9+gyM=
X-Received: by 2002:ac8:6f10:0:b0:471:bbdb:9f4c with SMTP id
 d75a77b69052e-471bbdba02amr28811521cf.30.1739385601283; Wed, 12 Feb 2025
 10:40:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs> <173933094507.1758477.425979019420266054.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094507.1758477.425979019420266054.stgit@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 12 Feb 2025 10:39:50 -0800
X-Gm-Features: AWEUYZnBz97NVS59sn9_mnZ_3YvExL_5LBmmJmnCdkxLZOTTd8q9HKP-kqkdUF4
Message-ID: <CAJnrk1YM_t=_UoyWhLJHQ0x=wWX5pW6x+WQZq5kAY7MWuk06nw@mail.gmail.com>
Subject: Re: [PATCH 10/34] generic/759,760: skip test if we can't set up a
 hugepage for IO
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025 at 7:33=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> On an arm64 VM with 64k base pages and a paltry 8G of RAM, this test
> will frequently fail like this:
>
> >  QA output created by 759
> >  fsx -N 10000 -l 500000 -h
> > -fsx -N 10000 -o 8192 -l 500000 -h
> > -fsx -N 10000 -o 128000 -l 500000 -h
> > +Seed set to 1
> > +madvise collapse for buf: Cannot allocate memory
> > +init_hugepages_buf failed for good_buf: Cannot allocate memory
>
> This system has a 512MB hugepage size, which means that there's a good
> chance that memory is so fragmented that we won't be able to create a
> huge page (in 1/16th the available DRAM).  Create a _run_hugepage_fsx
> helper that will detect this situation at the start of the test and skip
> it, having refactored run_fsx into a properly namespaced version that
> won't exit the test on failure.
>
> Cc: <fstests@vger.kernel.org> # v2025.02.02
> Cc: joannelkoong@gmail.com
> Fixes: 627289232371e3 ("generic: add tests for read/writes from hugepages=
-backed buffers")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks for adding this.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  common/rc         |   34 ++++++++++++++++++++++++++++++----
>  ltp/fsx.c         |    6 ++++--
>  tests/generic/759 |    6 +++---
>  tests/generic/760 |    6 +++---
>  4 files changed, 40 insertions(+), 12 deletions(-)
>
>
> diff --git a/common/rc b/common/rc
> index b7736173e6e839..36e270abbc082a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4982,20 +4982,46 @@ _require_hugepage_fsx()
>                 _notrun "fsx binary does not support MADV_COLLAPSE"
>  }
>
> -run_fsx()
> +_run_fsx()
>  {
> -       echo fsx $@
> +       echo "fsx $*"
>         local args=3D`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZ=
E / $psize /g"`
>         set -- $here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk
>         echo "$@" >>$seqres.full
>         rm -f $TEST_DIR/junk
>         "$@" 2>&1 | tee -a $seqres.full >$tmp.fsx
> -       if [ ${PIPESTATUS[0]} -ne 0 ]; then
> +       local res=3D${PIPESTATUS[0]}
> +       if [ $res -ne 0 ]; then
>                 cat $tmp.fsx
>                 rm -f $tmp.fsx
> -               exit 1
> +               return $res
>         fi
>         rm -f $tmp.fsx
> +       return 0

I think this could also be further simplified to

if [$res -ne 0]; then
    cat $tmp.fsx
fi
rm -rf $tmp.fsx
return $res


> +}
> +
> +# Run fsx with -h(ugepage buffers).  If we can't set up a hugepage then =
skip
> +# the test, but if any other error occurs then exit the test.
> +_run_hugepage_fsx() {
> +       _run_fsx "$@" -h &> $tmp.hugepage_fsx
> +       local res=3D$?
> +       if [ $res -eq 103 ]; then
> +               # According to the MADV_COLLAPSE manpage, these three err=
ors
> +               # can happen if the kernel could not collapse a collectio=
n of
> +               # pages into a single huge page.
> +               grep -q -E ' for hugebuf: (Cannot allocate memory|Device =
or resource busy|Resource temporarily unavailable)' $tmp.hugepage_fsx && \
> +                       _notrun "Could not set up huge page for test"
> +       fi
> +       cat $tmp.hugepage_fsx
> +       rm -f $tmp.hugepage_fsx
> +       test $res -ne 0 && exit 1
> +       return 0
> +}
> +
> +# run fsx or exit the test
> +run_fsx()
> +{
> +       _run_fsx "$@" || exit 1
>  }
>
>  _require_statx()
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index cf9502a74c17a7..d1b0f245582b31 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -2974,13 +2974,15 @@ init_hugepages_buf(unsigned len, int hugepage_siz=
e, int alignment, long *buf_siz
>
>         ret =3D posix_memalign(&buf, hugepage_size, size);
>         if (ret) {
> -               prterr("posix_memalign for buf");
> +               /* common/rc greps this error message */
> +               prterr("posix_memalign for hugebuf");
>                 return NULL;
>         }
>         memset(buf, '\0', size);
>         ret =3D madvise(buf, size, MADV_COLLAPSE);
>         if (ret) {
> -               prterr("madvise collapse for buf");
> +               /* common/rc greps this error message */
> +               prterr("madvise collapse for hugebuf");
>                 free(buf);
>                 return NULL;
>         }
> diff --git a/tests/generic/759 b/tests/generic/759
> index a7dec155056abc..49c02214559a55 100755
> --- a/tests/generic/759
> +++ b/tests/generic/759
> @@ -15,9 +15,9 @@ _require_test
>  _require_thp
>  _require_hugepage_fsx
>
> -run_fsx -N 10000            -l 500000 -h
> -run_fsx -N 10000  -o 8192   -l 500000 -h
> -run_fsx -N 10000  -o 128000 -l 500000 -h
> +_run_hugepage_fsx -N 10000            -l 500000
> +_run_hugepage_fsx -N 10000  -o 8192   -l 500000
> +_run_hugepage_fsx -N 10000  -o 128000 -l 500000
>
>  status=3D0
>  exit
> diff --git a/tests/generic/760 b/tests/generic/760
> index 4781a8d1eec4ec..f270636e56a377 100755
> --- a/tests/generic/760
> +++ b/tests/generic/760
> @@ -19,9 +19,9 @@ _require_hugepage_fsx
>  psize=3D`$here/src/feature -s`
>  bsize=3D`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
>
> -run_fsx -N 10000            -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -=
W -h
> -run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -=
W -h
> -run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -=
W -h
> +_run_hugepage_fsx -N 10000            -l 500000 -r PSIZE -t BSIZE -w BSI=
ZE -Z -R -W
> +_run_hugepage_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSI=
ZE -Z -R -W
> +_run_hugepage_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSI=
ZE -Z -R -W
>
>  status=3D0
>  exit
>
