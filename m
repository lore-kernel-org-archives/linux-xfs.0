Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3C44A10
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 02:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-556cd81163fso44638a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2024 18:02:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704247349; x=1704852149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C43bCs0K8WlD9V6hcg6uqWvQ0mfyJ+mvwYTPqAdiZaI=;
        b=xBMQ4VnfzmuWNb+uKIruM1kHAGeegfO7w4OhqeYEPnwVcWnkf5ZZ78H+DXU7Y2jlQ7
         a181XWY/IlQiIGdRuW5+l3ch/OmqffU47KdBFR4pj+hltl3GyaqTJOCuRFlp6k7EiDGw
         +b30emo5MvVANc01MWYaYIwHvGHob88iMHegVm9rrUlsQYY3ePWWTJ+2ujNpKJa1BYIx
         /GTJlsH4mKgfUBg3pBioGRNAvJ0vNOgOpjCDuGb9W48mLTsgn8X4U2XF/3axMunfSa9n
         cqwSrsq0cAi1e5Uuwb++5Gs8WuTQbyQ7YLElaxpkLZrlQtup1BGzJyjT5/viRFXuvg9I
         g9gw==
X-Gm-Message-State: AOJu0Yy1a9XHkO6bi4tYKWN6V06tlPnpp7toX2iD6J1mCEFxX+FpwhiR
	Far5sI9TIvOeXAq8HdXRg4k8FSvE8NPDb8h1
X-Google-Smtp-Source: AGHT+IFDGgFNjpIrzJ1cizR5xVqPXcxaa+oJZqWLYHqj44hM+U2o7fO1Ajn0cc5Jn/WSHavinPOeog==
X-Received: by 2002:a50:8ad2:0:b0:555:22c3:4a84 with SMTP id k18-20020a508ad2000000b0055522c34a84mr4476322edk.51.1704247348554;
        Tue, 02 Jan 2024 18:02:28 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id g20-20020a056402091400b005551b2f66f0sm10314513edz.43.2024.01.02.18.02.28
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jan 2024 18:02:28 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40d6b4e2945so49376115e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2024 18:02:28 -0800 (PST)
X-Received: by 2002:a7b:cd8b:0:b0:40d:3a32:7d43 with SMTP id
 y11-20020a7bcd8b000000b0040d3a327d43mr6369386wmj.95.1704247348059; Tue, 02
 Jan 2024 18:02:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs> <170405001964.1800712.10514067731814883862.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001964.1800712.10514067731814883862.stgit@frogsfrogsfrogs>
From: Neal Gompa <neal@gompa.dev>
Date: Tue, 2 Jan 2024 21:01:51 -0500
X-Gmail-Original-Message-ID: <CAEg-Je-q2P2EyhAKUtoL+0e3jygTtxXntEgVuTuUiTfMM-XdkA@mail.gmail.com>
Message-ID: <CAEg-Je-q2P2EyhAKUtoL+0e3jygTtxXntEgVuTuUiTfMM-XdkA@mail.gmail.com>
Subject: Re: [PATCH 9/9] xfs_scrub_all.cron: move to package data directory
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 2, 2024 at 8:23=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> cron jobs don't belong in /usr/lib.  Since the cron job is also
> secondary to the systemd timer, it's really only provided as a courtesy
> for distributions that don't use systemd.  Move it to @datadir@, aka
> /usr/share/xfsprogs.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  include/builddefs.in |    1 -
>  scrub/Makefile       |    2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
>
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 9d0f9c3bf7c..f5138b5098f 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -51,7 +51,6 @@ PKG_SBIN_DIR  =3D @sbindir@
>  PKG_ROOT_SBIN_DIR =3D @root_sbindir@
>  PKG_ROOT_LIB_DIR=3D @root_libdir@@libdirsuffix@
>  PKG_LIB_DIR    =3D @libdir@@libdirsuffix@
> -PKG_LIB_SCRIPT_DIR     =3D @libdir@
>  PKG_LIBEXEC_DIR        =3D @libexecdir@/@pkg_name@
>  PKG_INC_DIR    =3D @includedir@/xfs
>  DK_INC_DIR     =3D @includedir@/disk
> diff --git a/scrub/Makefile b/scrub/Makefile
> index 8fb366c922c..472df48a720 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -26,7 +26,7 @@ INSTALL_SCRUB +=3D install-crond
>  CRONTABS =3D xfs_scrub_all.cron
>  OPTIONAL_TARGETS +=3D $(CRONTABS)
>  # Don't enable the crontab by default for now
> -CROND_DIR =3D $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
> +CROND_DIR =3D $(PKG_DATA_DIR)
>  endif
>
>  endif  # scrub_prereqs
>
>

Looks good to me.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
