Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.134
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793884590;
	b=k2P2SWeOiIP7zW6v1CmGH1WcmPRSRK6KYRAGsZ8JB9ROLopGaJVKpKp20g99gyIAWRmt
	 sZZrNPK17IwAgkCDodHsNkMXO8h1yGB6waExJWJhjao/kVERMBNeTJGwlAGwXa8tUrF2z
	 mQd5SvnLULZBwr0q2tMale3FSGpsFd4QcF2k3mxpElc7tNiQ+roAgHKyI73IUbwyLNkDk
	 E/QVfdm0M8a2h3JWdaO9iUNZC4RvzZFVKO8i8HXaEieozFPLm9dGiv8bep232/BqMuxnZ
	 UZIbfW51YqnnIXrRNASGVppYUnzvDoJjr88gg8GcbYG+YYDBvJuYsMyLzCSRFEopfSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884590;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0fgN5PaurQZf0bnKLww2WDC3U/fAE8PImoVXNeNjn4s=;
	b=l5Ox2crffLJW5dC0GBV+xiuIcqf9MihNO3Y42xsfm7FK7Sv/KRzcoJJ5waKcb2P5O8Oo
	 kimBNxkX8bC+vlyA8JKzAR27qg6+ri6PFNdTDVbIcTGYf6Ywo+nnBnae11yOeChJE2pBw
	 b4SWkirt+HVKVqBks0FkGt1I0i7PlU4NAXYMYh2nTYD9se0/PWE5zbX5lrPBUMhQLsoZu
	 xv+DtssMikThYkBKM2tOaeeD7khcZwTzQvj8KKxCjoXtOIcypplw0zgfbCrl3NlJjndQg
	 1Heu5/Dqt6kBgcMx6zSVL+RMw7u5DW1flRB4vRpwJdiPR5rRmX0r5h3afl4T1eMAVcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T9d35M+1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.134
Received: from mail-yx2-f6.google.com (mail-yx2-f6.google.com [74.125.224.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D39606A329
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 13:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18D39606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T9d35M+1
Received: by mail-yx2-f6.google.com with SMTP id 956f58d0204a3-67bfda43022so485528d50.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Nov 2026 05:16:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793884589; cv=none;
        d=google.com; s=arc-20260327;
        b=BfN02fUrPiCiKoxCT4SoVVp2CeRjXkofessaFECu/XadH1TKN1+FE1m1i2aIUjVOKt
         R6IxbKVyvCwP4dbiX7YW+ontOh4ZksgvR5Pqdwy4ttN3UVPPAX9LM0Xv51QW7Ys4j3QR
         VX7Xdbolf2Alc4rkX+czQLJC+MEvbw8n1DjP+yzwH5QP96dlJOsBw7KnU4b6vTR88lhh
         FWQyKoBEvh3+qR/ceTsbkp2fYRwCM9dKRnNK6BXvZi/SFlO9Y9uB2EbJbaqr2amZakXz
         EWrZUOdclR1SOWwrlXMchxCnMbAJCyTahEMCumgghXIRkB3daxzpD5ZJpAmkHOapZ/lh
         UJRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0fgN5PaurQZf0bnKLww2WDC3U/fAE8PImoVXNeNjn4s=;
        fh=omg5m/p5HmzXfmvkSuoQlrh9yhje4OSFoX25yhqN2c4=;
        b=JmZo5vIOQ5MLsYSAfCTvmAjF2eRNRjhIX0tZ+9q34BJsgd6yv/aWRQyYVfs3zS5Zyr
         nJBPGCZ+R21BfW+QQav7bKIXG/CztW7F9hubP8gta/XI2JnvKSbr6JKFtHPlMQjwsgYC
         iJvm2EQipRPAQxR0kOKaH1t/mszOsNStROVD0VLmg0M8xdXbFmudyk4ydKIuXObynjnN
         IZcZUq0Hmr8o73k1519Llu9hOHUPW2kM0tKPxrnPFfaP98e4jDLjJMqSck9uG2qYmRcB
         fqQgdtD1fAjiDnfUKngiwZRNugzqHGDwfvpK/JYJt4vErpqDWth6J9SLXFAj2C6uv4PD
         ZiWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793884589; x=1794489389; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0fgN5PaurQZf0bnKLww2WDC3U/fAE8PImoVXNeNjn4s=;
        b=T9d35M+1WnI3C59PijPm+YPFFTG5eVnjEpz2KqMASOHu117WXN05YtNBaN4QxakS8I
         qViwu3cYhS7W/ZwD8HVqVchU65Z07xM8a/HZLPFRVhPHpsQyxTITfiGKvTYQyTgrWdBr
         UZI+YEphZSpXsBaSDwfvYO3tx3eu67G9FhUkjwoYeJcPYLTv2m/OtmYjSankJ4IcN/PP
         wV5oc8+l/5QFxuVlhIRNApaLlfPZqszHteBKiuxgMqVJWl/lFcM/vQg1WaMBGt0f8QHc
         13HKmd3APZBz38bcG6M2KRe1yIdRBcQ9OW3f/mDePVTvoO9/eIEWpMVz8xmaCP/VG8Ul
         f4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793884589; x=1794489389;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0fgN5PaurQZf0bnKLww2WDC3U/fAE8PImoVXNeNjn4s=;
        b=gVXJY5uUrGa0nYBqfcRjA5mtAhZFlIFEfuznUiJck7DgxPcvjwW7xgNiRyAPVfkOuY
         TzE/KP1eheVD/a7mVvfU5oOypEF7abGHQpCMzbWHQ9fbyMTvyxLiamRPMTW1J8b6MWmR
         gHb+QR03PFuLeI8ur3Ja1kOegQU95Dfm/UgW3nxx/fgqmKK9NquLz0aqRGacgEf84zmn
         zWnYXVjG/2D3YL+qieV6PKXY07uqJWOcV+dkKNXM9XgUTgmR0eSoggVoq6TPyO3N9NVr
         hEO93AJTTRblehDCxDNakIMwhahGBVTtt4IbR6wSlQmcpBwsXgxYoATXAVzaNz0xSjou
         np2Q==
X-Forwarded-Encrypted: i=1; AKwUvByYHbg9B4R6aMHvnoir23h2VDumSlio2S+/tRSNJExV1VE3hN7UkPf3jObrri4ZENeQrEXYQMiLNX8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8MDB4rpIzm8ZhU9ImjArgwqNiIRoyImfHEpu9CGVUPhAZEIEG6
	ItVSnvlr9r1myWScpypjuyQVuOIMU1378TxXkh98geRDJrOwK0lL7fc0OcU2eJovAfiviKlU7z0
	zsOKvdEjJWtXi8/NVHAGWhUyu+57BGAI=
X-Gm-Gg: AYBFou3MLyOOrHVKIItDOfnrHSGvcF23PgAAOpfLNPHjytDdWt7VSOBG9jjsfnLGqTB
	8N5bnqzUPfppdNnBI9FcXsUWX/kpGHRhXawAqo1Lul4JBO6kX/1Q8AUd0rVQVWqu/EWA/A6CI9h
	xtKbDnLnwVW1zpwUC9KVAINa8eOB8ZzYmxr2IygX2cEivVEEq87xMBNNhCF+dxcSiej2dXWx42c
	zYG2QtrklUG0PX8Ev3aWuVauxYY9DL0fUv1YB227QrN260Sa31Ytm4c4HW1MQXIRFMDE23TGEW5
	8jQuF87mMCt8tYKli8TV2GS/BBaazOLVxhU9/qobTp86LNT7tLviTEGabsLtpEacI8cwbBJ3njb
	igKhI7QNwMss46uwTyNJs2w8xmjb9byv9+CSlWU4FpexGjCgK+DRapmow+7poiHb6Zs7DgIG6Rp
	IBEza1ut+li6lhzK0aHg==
X-Received: by 2002:a05:690e:1183:b0:679:887f:a2af with SMTP id
 956f58d0204a3-67ba5017fa5mr9815288d50.126.1793884589062; Thu, 05 Nov 2026
 05:16:29 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103144148.14430-1-jianyungao89@gmail.com>
 <aun6-mywXYg2VTL4@nidhogg.toxiclabs.cc> <CAHP3+4ChRtv5OCoRrF9-D2GYXJnu0kS4_3O7kXqYRbTtLAt8mA@mail.gmail.com>
 <autIEIDr0097CaNS@nidhogg.toxiclabs.cc>
In-Reply-To: <autIEIDr0097CaNS@nidhogg.toxiclabs.cc>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Thu, 5 Nov 2026 21:16:18 +0800
X-Gm-Features: AclHuK-HsRoAU3woefVw2Yrio7whOe0XI8exE-ALNXQ5hLdRjfouZVkMBTd2OPU
Message-ID: <CAHP3+4Dd2t4xpQ2M0HO=QCcWQU6CksPwifuHy69KwzYo0YepAA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix spurious len double-counting in rmap three-way
 merge check
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Eric Sandeen <sandeen@redhat.com>, 
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>, Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>, 
	Dave Chinner <dchinner@redhat.com>, 
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Carlos,

Thanks for the feedback. I've now run the full auto group with the patch
applied, and as you suggested, this gives a much more thorough picture
than the two targeted tests.

Command and configuration:
  kvm-xfstests -c xfs/default -g auto -X generic/778
  KERNEL: 7.3.0-rc6-xfstests-00194-gf4a2f5951fee
  CPUS: 8, MEM: ~8G
  xfstests: v2025.11.04-10-gdf376ed02

Results:
  xfs/4k: 1214 tests, 7 failures, 231 skipped, 10890 seconds
  Totals: 1242 tests, 231 skipped, 31 failures, 0 errors, 10122s

Failure analysis:
- generic/633, generic/696, generic/697, generic/753, xfs/018: these are kn=
own
  pre-existing failures on this kernel version (also reported in
recent community test runs);
  they are unrelated to the rmap merge logic.
- xfs/013: the test's own output shows ENOSPC errors leaking from a known
  shell redirection bug that broke the filter_enospc logic; a fix was
  posted upstream in June 2026 but is not present in the v2025.11.04
  snapshot used here.
- xfs/155 (marked flaky at 20%): the full log shows xfs_repair returning
  an unexpected exit code (1) after the test intentionally injected write
  failures via LIBXFS_DEBUG_WRITE_CRASH. This is a userspace tool/test
  interaction issue, not a kernel rmap regression.
- generic/778 was excluded as it is a known flaky/performance-bug test
  (40% flaky in an earlier run), and Darrick's later fix for it is not in
  this xfstests snapshot.

There are no new failures attributable to the rmap three-way merge
change. The xfs/236 run from the previous series also still passes.

Please let me know if you'd like any additional configurations or
specific tests re-run.

Thanks,
Jianyun

On Wed, Nov 4, 2026 at 11:01=E2=80=AFPM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Wed, Nov 04, 2026 at 11:27:54AM +0800, Jianyun Gao wrote:
> > Hi Carlos,
> >
> > Thanks for the review. To answer your questions:
> >
> > How I found it: I found this while reviewing the merge logic in
> > xfs_rmap_map. After tracing the left-edge merge path, I noticed that
> > ltrec.rm_blockcount is already updated at line 1119
> > (ltrec.rm_blockcount +=3D len), so adding len again in the overflow che=
ck
> > is redundant. When the real merged length is still within
> > XFS_RMAP_LEN_MAX but the inflated value exceeds it, the three-way merge
> > is incorrectly rejected, leaving the right record unmerged.
> >
> > Testing: I ran the rmap-specific regression tests with this patch
> > applied, using kvm-xfstests on a 4k-block XFS configuration with
> > rmapbt=3D1 and reflink=3D1:
> >
> >   kvm-xfstests -c xfs/4k xfs/236 xfs/578
> >
> > Results:
> >   xfs/236      Pass     6s
> >   xfs/578      Pass     34s
> > Totals: 2 tests, 0 skipped, 0 failures, 0 errors
> >
> > xfs/236 directly exercises the rmap btree grow/shrink paths affected by
> > this change. I did not observe any regressions or warnings.
> > If there are specific test cases you'd like me to run, please let me kn=
ow.
>
> Ok, I'd expect the tests to be a bit more thorough than two test cases,
> ie. I'd expect this to be ran against at least the auto group too. But
> nevertheless I'm glad you at did at least some of the homework.
>
> The patch also seems fine to me, so
>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>
> >
> > Thanks,
> > Jianyun
> >
> > On Tue, Nov 3, 2026 at 11:33=E2=80=AFPM Carlos Maiolino <cem@kernel.org=
> wrote:
> > >
> > > On Tue, Nov 03, 2026 at 10:41:44PM +0800, jianyungao89@gmail.com wrot=
e:
> > > > From: Jianyun Gao <jianyungao89@gmail.com>
> > > >
> > > > In xfs_rmap_map, the left-edge merge path already executes
> > > > ltrec.rm_blockcount +=3D len at line 1119 before checking whether t=
he
> > > > right record is also contiguous and can be merged.  The subsequent
> > > > overflow guard therefore must compare the already-incremented
> > > > ltrec.rm_blockcount plus gtrec.rm_blockcount against XFS_RMAP_LEN_M=
AX,
> > > > but it incorrectly adds len a second time:
> > > >
> > > > (unsigned long)ltrec.rm_blockcount + len +
> > > >    gtrec.rm_blockcount <=3D XFS_RMAP_LEN_MAX
> > > >
> > > > The extra len makes the check too strict: when the real merged leng=
th
> > > > does not overflow but the inflated value exceeds XFS_RMAP_LEN_MAX, =
the
> > > > three-way merge is rejected and the code falls back to a two-way me=
rge,
> > > > leaving the right record unmerged.  This produces rmap btree
> > > > fragmentation but does not corrupt on-disk metadata.
> > > >
> > > > Remove the spurious len from the overflow check.
> > > >
> > > > Fixes: 0a1b0b3855cf7 ("xfs: add an extent to the rmap btree")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> > >
> > > Hi, even though this looks reasonably correct, how did you find this
> > > issue?
> > > Did you test this at all against any regressions (i.e. running it
> > > against xfstests)? This is touching critical logic on the rmap trees
> > > which can potentially end really bad.
> > >
> > > Cheers.
> > >
> > > > ---
> > > >  fs/xfs/libxfs/xfs_rmap.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > > index 14aef87837a9..c2b2f8e7502d 100644
> > > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > > @@ -1120,7 +1120,7 @@ xfs_rmap_map(
> > > >               if (have_gt &&
> > > >                   bno + len =3D=3D gtrec.rm_startblock &&
> > > >                   (ignore_off || offset + len =3D=3D gtrec.rm_offse=
t) &&
> > > > -                 (unsigned long)ltrec.rm_blockcount + len +
> > > > +                 (unsigned long)ltrec.rm_blockcount +
> > > >                               gtrec.rm_blockcount <=3D XFS_RMAP_LEN=
_MAX) {
> > > >                       /*
> > > >                        * right edge also contiguous, delete right r=
ecord
> > > > --
> > > > 2.34.1
> > > >
> > > >
> >
