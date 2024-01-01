Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568247ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5542a7f1f3cso9098629a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 16:24:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704068682; x=1704673482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWuC/PleNu1/9K+H7jPGI6S6J65an3P59tr7a0lY/mA=;
        b=Ci7SDtItF3TOShR8zwIwRKx9ZxmbcLbhXNN5WG/bvuYUUoqPrBxONcHSV68ZbWJFqy
         PNfxkAJ9Wfmw6ag8r0xUl1tdhM0ZmBcu6Hv7P7il7/rISRXwRFo38QhfSxSJBGoD+v5B
         G7R4HbzWH+qNKezTZJ2N/81HdBxgGNXzG56wiiXt7mFt7WncQgW1MI9bsl/fvj2OQkvX
         9TnoIxYq7kFafHzN1y5el8DJ9BzLUcZ2dBAOD9OAgOjfA6c8qHy4Y5L6TLNipoF/U1Qe
         PwgSY4ilGaUYb2HQgE24j6ag8bpwB7G4Vyb+ljWZ4qzGi8MOEeTutPQDYyeGCvg2Q2Xb
         OROQ==
X-Gm-Message-State: AOJu0Yx8JLLVbne6hy4LJbZeCt7N0Su51uBAPqwdog1g+J42Alm8Ycwm
	WyI9uPRTsicEvd0REhOpTdnFtKBJfAcmgenR
X-Google-Smtp-Source: AGHT+IEPBPswCkShuF4k2WocvG/xEQRcXUZ7wkYN1UFzwwXfy5OmI2uI/j12oQuGH/19FOH24l0ZzQ==
X-Received: by 2002:a50:d4c1:0:b0:554:4c8a:ffeb with SMTP id e1-20020a50d4c1000000b005544c8affebmr8422373edj.11.1704068682083;
        Sun, 31 Dec 2023 16:24:42 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id es15-20020a056402380f00b0055267663784sm13974959edb.11.2023.12.31.16.24.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Dec 2023 16:24:41 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5542a7f1f3cso9098626a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 16:24:41 -0800 (PST)
X-Received: by 2002:a17:906:4716:b0:a23:619f:9e68 with SMTP id
 y22-20020a170906471600b00a23619f9e68mr5196047ejq.150.1704068681808; Sun, 31
 Dec 2023 16:24:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs> <170405001950.1800712.15718005791386216226.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001950.1800712.15718005791386216226.stgit@frogsfrogsfrogs>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 31 Dec 2023 19:24:04 -0500
X-Gmail-Original-Message-ID: <CAEg-Je-zrh-q-FVDorsRMEjD6ZAbsaNNNCZq2J7FXAqWUyFUJA@mail.gmail.com>
Message-ID: <CAEg-Je-zrh-q-FVDorsRMEjD6ZAbsaNNNCZq2J7FXAqWUyFUJA@mail.gmail.com>
Subject: Re: [PATCH 8/9] xfs_scrub_fail: move executable script to /usr/libexec
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 31, 2023 at 5:54=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Per FHS 3.0, non-PATH executable binaries are supposed to live under
> /usr/libexec, not /usr/lib.  xfs_scrub_fail is an executable script,
> so move it to libexec in case some distro some day tries to mount
> /usr/lib as noexec or something.
>
> Cc: Neal Gompa <neal@gompa.dev>
> Link: https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04s07.html
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  include/builddefs.in             |    1 +
>  scrub/Makefile                   |    7 +++----
>  scrub/xfs_scrub_fail@.service.in |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
>
> diff --git a/include/builddefs.in b/include/builddefs.in
> index eb7f6ba4f03..9d0f9c3bf7c 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -52,6 +52,7 @@ PKG_ROOT_SBIN_DIR =3D @root_sbindir@
>  PKG_ROOT_LIB_DIR=3D @root_libdir@@libdirsuffix@
>  PKG_LIB_DIR    =3D @libdir@@libdirsuffix@
>  PKG_LIB_SCRIPT_DIR     =3D @libdir@
> +PKG_LIBEXEC_DIR        =3D @libexecdir@/@pkg_name@
>  PKG_INC_DIR    =3D @includedir@/xfs
>  DK_INC_DIR     =3D @includedir@/disk
>  PKG_MAN_DIR    =3D @mandir@
> diff --git a/scrub/Makefile b/scrub/Makefile
> index fd47b893956..8fb366c922c 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -140,8 +140,7 @@ install: $(INSTALL_SCRUB)
>         @echo "    [SED]    $@"
>         $(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
>                    -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
> -                  -e "s|@pkg_lib_dir@|$(PKG_LIB_SCRIPT_DIR)|g" \
> -                  -e "s|@pkg_name@|$(PKG_NAME)|g" \
> +                  -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
>                    < $< > $@
>
>  %.cron: %.cron.in $(builddefs)
> @@ -151,8 +150,8 @@ install: $(INSTALL_SCRUB)
>  install-systemd: default $(SYSTEMD_SERVICES)
>         $(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
>         $(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
> -       $(INSTALL) -m 755 -d $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
> -       $(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIB_SCRIPT_DIR)/$(=
PKG_NAME)
> +       $(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
> +       $(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIBEXEC_DIR)
>
>  install-crond: default $(CRONTABS)
>         $(INSTALL) -m 755 -d $(CROND_DIR)
> diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.ser=
vice.in
> index 048b5732459..48a0f25b5f1 100644
> --- a/scrub/xfs_scrub_fail@.service.in
> +++ b/scrub/xfs_scrub_fail@.service.in
> @@ -10,7 +10,7 @@ Documentation=3Dman:xfs_scrub(8)
>  [Service]
>  Type=3Doneshot
>  Environment=3DEMAIL_ADDR=3Droot
> -ExecStart=3D@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %f
> +ExecStart=3D@pkg_libexec_dir@/xfs_scrub_fail "${EMAIL_ADDR}" %f
>  User=3Dmail
>  Group=3Dmail
>  SupplementaryGroups=3Dsystemd-journal
>

Looks great to me.

Reviewed-by: Neal Gompa <neal@gompa.dev>



--
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
