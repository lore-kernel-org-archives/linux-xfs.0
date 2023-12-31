Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14038BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40d87df95ddso4079275e9.0
        for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 12:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704054379; x=1704659179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNYeOvdQHrrrMa6Z7eWj6gBpa2W/26/4djgzJNUxQho=;
        b=vI5KVHawrcV3Jy7nP4+8JX2L0m/RyZPr3y/CVjDWJ2Wbt49oWc25s7yrN5g0pDsLOZ
         YaAED5WZjEUgAoiczXkoaTrX0orUiVtRxwVOTzm5UwbbebUwuDVBh+sw9/o8Q3r4371f
         nwd3T2QQ/7oUDIWQqtRXu196y6fkdxu12zsQnjZ81a7XPKnl0/G46v7tAzZ8lFotbFA3
         R5xoE+tEktcjqVHuzM47HrmnMHLzBMjaChZVzbTpiE+P5xChLVTW+o8VVOB4oLKc/fEO
         gwyC9a1oOAA/tlxUVlma/BVbU/FIIGiUVmbC50ZuLHaxJLSsEI3eDXjybOd8FSSYrabV
         P8bA==
X-Gm-Message-State: AOJu0YynaLiE+4J+zhF55fhmuG1lVEWy1MKWPkWxYagchJ7mfIMg4aOh
	Gn2s7wSY40QfzNydXLb6TdBqAfUlYW5z/Q==
X-Google-Smtp-Source: AGHT+IHsykNF5+XZ9+aiEOKmrj2q5GCf+Adw7LQMptC5aIZs2sWx23Etxb/QMmxzC56TeOotxl7QuA==
X-Received: by 2002:a05:600c:21da:b0:40d:3ad5:7609 with SMTP id x26-20020a05600c21da00b0040d3ad57609mr4138233wmj.200.1704054378579;
        Sun, 31 Dec 2023 12:26:18 -0800 (PST)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id ex15-20020a170907954f00b00a26ae85cfeasm9553469ejc.28.2023.12.31.12.26.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Dec 2023 12:26:18 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a22f59c6ae6so972322266b.1
        for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 12:26:18 -0800 (PST)
X-Received: by 2002:a17:906:2216:b0:a27:f73f:30c5 with SMTP id
 s22-20020a170906221600b00a27f73f30c5mr168267ejs.199.1704054378278; Sun, 31
 Dec 2023 12:26:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231231181215.GA241128@frogsfrogsfrogs> <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 31 Dec 2023 15:25:41 -0500
X-Gmail-Original-Message-ID: <CAEg-Je_ynMS2Xz+kWje7Ym=BMaK=_hvHfymj2SOvG-icxJ7vkw@mail.gmail.com>
Message-ID: <CAEg-Je_ynMS2Xz+kWje7Ym=BMaK=_hvHfymj2SOvG-icxJ7vkw@mail.gmail.com>
Subject: Re: [PATCHSET v29.0 34/40] xfs_scrub: fixes for systemd services
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 31, 2023 at 2:48=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> Hi all,
>
> This series fixes deficiencies in the systemd services that were created
> to manage background scans.  First, improve the debian packaging so that
> services get installed at package install time.  Next, fix copyright and
> spdx header omissions.
>
> Finally, fix bugs in the mailer scripts so that scrub failures are
> reported effectively.  Finally, fix xfs_scrub_all to deal with systemd
> restarts causing it to think that a scrub has finished before the
> service actually finishes.
>
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
>
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
>
> --D
>
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/=
?h=3Dscrub-service-fixes
> ---
>  debian/rules                     |    1 +
>  include/builddefs.in             |    2 +-
>  scrub/Makefile                   |   26 ++++++++++++++------
>  scrub/xfs_scrub@.service.in      |    6 ++---
>  scrub/xfs_scrub_all.in           |   49 ++++++++++++++++----------------=
------
>  scrub/xfs_scrub_fail.in          |   12 ++++++++-
>  scrub/xfs_scrub_fail@.service.in |    4 ++-
>  7 files changed, 55 insertions(+), 45 deletions(-)
>  rename scrub/{xfs_scrub_fail =3D> xfs_scrub_fail.in} (62%)
>

In your Makefile changes, you should be able to drop
PKG_LIB_SCRIPT_DIR entirely from your Makefiles since it should be
unused now, can you fold that into
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/com=
mit/?h=3Dscrub-service-fixes&id=3D1e0dce5c54270f1813f5661c266989917f08baf8
?


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
