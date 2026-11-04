Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.135
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793762887;
	b=0vUB15xg62z+Y8axqT5EsPpk/0Sr5dpsXYkvG8K7XZMIeN1YxZD0Qi0K7qw6QLd3hg8h
	 MVsbvn12v6xg4+onqhQlfuuVWIombUUod2LZVOTPTnoojISEFv9Idcm/w8u8dmonrXU6R
	 S3wVrYx8frESF6+a31DNMNoU2fw3BDLop54bJUIlnX5EL0i4aRUdyNsVrK4PJiVweOje8
	 oQvqNejvTVeVW/989MVoqutja0qoF1k74UUKZZ60IodqcfZzDrOO9WKmCGGINkdtTgdZt
	 p2U7EvZF3RRsAUnxDCmB14nDJGIMA69fvbjsYFNdatPP3Hn/y34LGQjZC2FaLEB5TJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793762887;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TKN5fm3lE6PDFTg4E4wZZqhp3eyt6dK1s1483aTN3Bo=;
	b=tFGsiu6HPD/VdfdxU7dblMUUzw/9jjveeIECqnMRiwWQOsu5LarmGcULEVT4K6Fecs02
	 vffUjZZB+7bTvM/5/vvHQUBcyEuvCHj80GU4etKLX9HWFyxKjTxqxHuU4cWVzWF75QCcf
	 1heJIAvqzjZ3SEqM7R/OLytUTkyIKV8/HzrmSWIlORkhKdVMD0FVIvmfvFnm4WiMt0nzW
	 G1RT/OprdgWGXy2UGOajj0EOzjykyIYvXvz4lIr2aFzwPgHfmpfKjTzgZHg/m4mbH3EeZ
	 Y7bo9HeG+D8kcFm/8F29u3M64AzgfBWCB7DSp0rR29Mhcp0L3+CCPBuKRScB896P+KQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dw1w6O5E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.135
Received: from mail-yx2-f7.google.com (mail-yx2-f7.google.com [74.125.224.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D77606A326
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 03:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0D77606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dw1w6O5E
Received: by mail-yx2-f7.google.com with SMTP id 956f58d0204a3-67a3d39e403so153079d50.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2026 19:28:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793762886; cv=none;
        d=google.com; s=arc-20260327;
        b=o8tNRCapGEh6ZvA0KoMuDJBmUJ6O4NqN4wOkWOJ7GfUr2ZFzLhMOfBkoyRtZDJtyG8
         PPas/VSNneZ8zYPWpGOnpsq+dDHNR9WwQhBjJrtk5gNLVX4PbUYoU+wc+xol30PEsGNQ
         b8FmQKKDNoCCkApaqKVczlUsaH/OxGqSiFCxKL96brvCQhyKkI9xDSD6JWbflL7cjbOW
         ZkRrt97vZXGjBZu4ALc81s59+Zh62+kKeRFGWXxWKW8+1F0LcAvas2LgfKQ1lAGXaoU9
         GPgdV0sFd0uuQMWr7lksQzmkB+5bch4/6BKoD1v4yYAR7stdMnBciI8ma8h0CiYUC/Qp
         CdbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TKN5fm3lE6PDFTg4E4wZZqhp3eyt6dK1s1483aTN3Bo=;
        fh=JB48SUkaQfHkHcF86dg+xk2emyThmrHRb01xDE45Nag=;
        b=gorFE2xicwUPhZnA+JwfEbd16i+bh7WH1iWm1D7Gg276NjYVu0B5sy0uHgKMlYEsGF
         ieaLC+y4NJNTeOviT2ptPAYynZ+8mUzrZgaz9GDo3I3BezvzI3Zh2+G71xJwUWWiKdDJ
         wpjCuBTLTAA+hwReIhvQasaEcQD32GQn40S/X+nN+en9MbpwBO/FgRg9uue3Zr5j7T0Y
         454sns5EY67eIv4ds6VUha0Nutem0Zn2M22mAVg/LeH560K+4U6StxMZOU8Z41ZIDKRN
         Uc5HfAT7Q0fXsrhJBEL7o+Owtc/D4RoUrbglPyW3/tiZFK3kq8P0gJxM5IWgi4ieXvuV
         kt8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793762886; x=1794367686; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TKN5fm3lE6PDFTg4E4wZZqhp3eyt6dK1s1483aTN3Bo=;
        b=Dw1w6O5EUnpm393XQ2xHXvpYnx4DuRvEb75Qu6TwCtbbIxjyYM0Vb88t/Vc/UeEVVD
         5B7ypa7o5ZhemJ5Yvh77dquQToqee/RAyTWH74SrjIpeqD1tqkRJAhPnu7cTIkWul2bF
         eQalHBHwFKvLUQV9hdCGpbhUgbkd7RiMhkYOU2oD1V+niZVKMMaN4Ep5Dqxq9bsclcB0
         SQVeemz6NVgahtYGmTIoM6/vQeRfLFt1Vn/mNVSAT+d73T39tCXkoBKrn1ScqCl7AFf0
         iVRTJkV8FfiGoVTaNJSLcEfa084ZVqJa5OFGa6JMYCgFQCNVfuxCaG4za6Drh12gGSCF
         Bg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793762886; x=1794367686;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TKN5fm3lE6PDFTg4E4wZZqhp3eyt6dK1s1483aTN3Bo=;
        b=MBlYkD9qvsihpvTQr4EFc02iOlTpANZud1HMj3NotBulzfB2UkuX1hPWFCZkTuAQgn
         XoIqxehPNwttzAFH67y1O0zEa4UR8XB6euEyU0S7Esqu/8z7ywDyflKeg/hTuuMaGw1i
         6aLuP9W0tZjwo+pKLEMAypLapyEPEgzLhGFVt5FKyWIqL7l9H3GT48Kp1ipJORoJv8Ju
         FDmMxrqMtd2sBFic9SoaQ+ZY8mqZP80SdDy7/tBW2wD2BpffThq2JQSqxakTFzQ7YR6j
         +1A8SKRXva4iN6vr1wSMn4+iZokGFk1rhjS1vTfHAF/ynLVc645bQ/TOO/8c+ZZgP4cy
         ZvVA==
X-Forwarded-Encrypted: i=1; AKwUvBx9VeFZjrnJVG/MbBx+f4DhXw0VCDJEdpniLGH5Lxnq8+XrqvMxbEXnQUG4VX21fpoQrh5IWnan3dE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+gtKElQx8F9kkpXoaCZ2/ybxpFMuyekR5H7RSHC0p6QXeBRvBp
	KuUBt/TkSoeQYlgIOBhswrVp+S+UMFnR7JcfzyBMmzx6KwIkfyFbMRrKWkpYggw32n8TbXaVAjx
	5mWg4YFVJmgKyp8VI/0erR4/Ll1JwhwOD0KAR2VQZsc69mi4=
X-Gm-Gg: AYBFou0TB7BVJr+16yc4MsZ+Ufxc22cEAtzQEaUmEaFk42Wy4IQlbpt2PF35vQEpJYQ
	c8OErbZHWo7t2FcfI4Hu3m9gP6mETpWSzfCBdKE5sAjzbg+IsR9J7aq6JQ2vwbum2C1/lDPrIB1
	llACiL5q9TA/y67JddpmG+YviK6W3Ea2lEIgnihiXOMFp2e2scFsLPViRHoIJl9IlMt438yMpHL
	ePn/DFDVkY1hFYbgBo4Za6NHDBBdNGyXIfapRgzrsVtGI+NKJAzU37je2y4YJ0FHtsoT3C5YTd9
	6IK1+7bwlp4uesTXuDEynLxzIe4Blc1nr1ri6jYCQuOckfEtOMVvPQiXbTyp9rGRvSWYdFykHVM
	psjhlb63RNFsExEDO3n7fSY87YjE8lQrZr1uTSMuVa/P1zj6frpgkgm9Gqu1QnLQ8Eu8gIMWHgX
	MT71dNlwwJJ91u1u4=
X-Received: by 2002:a05:690e:484f:b0:679:bf13:c01b with SMTP id
 956f58d0204a3-67ba4e968d9mr7976806d50.17.1793762885716; Tue, 03 Nov 2026
 19:28:05 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103144148.14430-1-jianyungao89@gmail.com> <aun6-mywXYg2VTL4@nidhogg.toxiclabs.cc>
In-Reply-To: <aun6-mywXYg2VTL4@nidhogg.toxiclabs.cc>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Wed, 4 Nov 2026 11:27:54 +0800
X-Gm-Features: AclHuK8-QaZQophNFvzc0AoFSF-bpUKDXP10OLzU1_aqdxeGYmQPW2wekA4osYg
Message-ID: <CAHP3+4ChRtv5OCoRrF9-D2GYXJnu0kS4_3O7kXqYRbTtLAt8mA@mail.gmail.com>
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

Thanks for the review. To answer your questions:

How I found it: I found this while reviewing the merge logic in
xfs_rmap_map. After tracing the left-edge merge path, I noticed that
ltrec.rm_blockcount is already updated at line 1119
(ltrec.rm_blockcount +=3D len), so adding len again in the overflow check
is redundant. When the real merged length is still within
XFS_RMAP_LEN_MAX but the inflated value exceeds it, the three-way merge
is incorrectly rejected, leaving the right record unmerged.

Testing: I ran the rmap-specific regression tests with this patch
applied, using kvm-xfstests on a 4k-block XFS configuration with
rmapbt=3D1 and reflink=3D1:

  kvm-xfstests -c xfs/4k xfs/236 xfs/578

Results:
  xfs/236      Pass     6s
  xfs/578      Pass     34s
Totals: 2 tests, 0 skipped, 0 failures, 0 errors

xfs/236 directly exercises the rmap btree grow/shrink paths affected by
this change. I did not observe any regressions or warnings.
If there are specific test cases you'd like me to run, please let me know.

Thanks,
Jianyun

On Tue, Nov 3, 2026 at 11:33=E2=80=AFPM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Tue, Nov 03, 2026 at 10:41:44PM +0800, jianyungao89@gmail.com wrote:
> > From: Jianyun Gao <jianyungao89@gmail.com>
> >
> > In xfs_rmap_map, the left-edge merge path already executes
> > ltrec.rm_blockcount +=3D len at line 1119 before checking whether the
> > right record is also contiguous and can be merged.  The subsequent
> > overflow guard therefore must compare the already-incremented
> > ltrec.rm_blockcount plus gtrec.rm_blockcount against XFS_RMAP_LEN_MAX,
> > but it incorrectly adds len a second time:
> >
> > (unsigned long)ltrec.rm_blockcount + len +
> >    gtrec.rm_blockcount <=3D XFS_RMAP_LEN_MAX
> >
> > The extra len makes the check too strict: when the real merged length
> > does not overflow but the inflated value exceeds XFS_RMAP_LEN_MAX, the
> > three-way merge is rejected and the code falls back to a two-way merge,
> > leaving the right record unmerged.  This produces rmap btree
> > fragmentation but does not corrupt on-disk metadata.
> >
> > Remove the spurious len from the overflow check.
> >
> > Fixes: 0a1b0b3855cf7 ("xfs: add an extent to the rmap btree")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
>
> Hi, even though this looks reasonably correct, how did you find this
> issue?
> Did you test this at all against any regressions (i.e. running it
> against xfstests)? This is touching critical logic on the rmap trees
> which can potentially end really bad.
>
> Cheers.
>
> > ---
> >  fs/xfs/libxfs/xfs_rmap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index 14aef87837a9..c2b2f8e7502d 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -1120,7 +1120,7 @@ xfs_rmap_map(
> >               if (have_gt &&
> >                   bno + len =3D=3D gtrec.rm_startblock &&
> >                   (ignore_off || offset + len =3D=3D gtrec.rm_offset) &=
&
> > -                 (unsigned long)ltrec.rm_blockcount + len +
> > +                 (unsigned long)ltrec.rm_blockcount +
> >                               gtrec.rm_blockcount <=3D XFS_RMAP_LEN_MAX=
) {
> >                       /*
> >                        * right edge also contiguous, delete right recor=
d
> > --
> > 2.34.1
> >
> >
