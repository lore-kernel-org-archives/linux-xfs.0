Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85660186B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmignBtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5148EC433C7;
	Wed,  3 Jan 2024 01:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704245203;
	bh=EZeu8njTGMtLBSEzSNLi5UHD8tusS1oBjmi9bqF7ggw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SmignBtdFtDRDeIfHXrb9AF08nfgIWPbvnrz584asGdYAww5MvzagMKUpL/QhrlJQ
	 BaX+K/o+9dXeELpZA0O50W3iuU5nIO7IwvyYDd/accJ0F0ym1ua31McP5X6MzrLzDL
	 7wpfcfeMkPPoIjUb3DKyXDhNjKagC6iB1WzqFVw4WUywHk2WobhE3ay+ssfFyQBdsZ
	 lVtaL4Ot84PyWtdBIHpKrDohL2sah0957deSeCyp+ulZQtfgz2ZKwILPu7zu3/4zF1
	 wKBz9YYUcUfXJhKLyK5UL+IlY3cjzodYemCxpDnrLDtrhKZ7bgd6ijhqJ7bbfLZTQk
	 liXvFOKA0xZtA==
Date: Tue, 2 Jan 2024 17:26:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Neal Gompa <neal@gompa.dev>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_scrub_fail: move executable script to
 /usr/libexec
Message-ID: <20240103012642.GG361584@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
 <170405001950.1800712.15718005791386216226.stgit@frogsfrogsfrogs>
 <CAEg-Je-zrh-q-FVDorsRMEjD6ZAbsaNNNCZq2J7FXAqWUyFUJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEg-Je-zrh-q-FVDorsRMEjD6ZAbsaNNNCZq2J7FXAqWUyFUJA@mail.gmail.com>

On Sun, Dec 31, 2023 at 07:24:04PM -0500, Neal Gompa wrote:
> On Sun, Dec 31, 2023 at 5:54 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Per FHS 3.0, non-PATH executable binaries are supposed to live under
> > /usr/libexec, not /usr/lib.  xfs_scrub_fail is an executable script,
> > so move it to libexec in case some distro some day tries to mount
> > /usr/lib as noexec or something.
> >
> > Cc: Neal Gompa <neal@gompa.dev>
> > Link: https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04s07.html
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  include/builddefs.in             |    1 +
> >  scrub/Makefile                   |    7 +++----
> >  scrub/xfs_scrub_fail@.service.in |    2 +-
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> >
> >
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index eb7f6ba4f03..9d0f9c3bf7c 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -52,6 +52,7 @@ PKG_ROOT_SBIN_DIR = @root_sbindir@
> >  PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
> >  PKG_LIB_DIR    = @libdir@@libdirsuffix@
> >  PKG_LIB_SCRIPT_DIR     = @libdir@
> > +PKG_LIBEXEC_DIR        = @libexecdir@/@pkg_name@
> >  PKG_INC_DIR    = @includedir@/xfs
> >  DK_INC_DIR     = @includedir@/disk
> >  PKG_MAN_DIR    = @mandir@
> > diff --git a/scrub/Makefile b/scrub/Makefile
> > index fd47b893956..8fb366c922c 100644
> > --- a/scrub/Makefile
> > +++ b/scrub/Makefile
> > @@ -140,8 +140,7 @@ install: $(INSTALL_SCRUB)
> >         @echo "    [SED]    $@"
> >         $(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
> >                    -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
> > -                  -e "s|@pkg_lib_dir@|$(PKG_LIB_SCRIPT_DIR)|g" \
> > -                  -e "s|@pkg_name@|$(PKG_NAME)|g" \
> > +                  -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
> >                    < $< > $@
> >
> >  %.cron: %.cron.in $(builddefs)
> > @@ -151,8 +150,8 @@ install: $(INSTALL_SCRUB)
> >  install-systemd: default $(SYSTEMD_SERVICES)
> >         $(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
> >         $(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
> > -       $(INSTALL) -m 755 -d $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
> > -       $(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
> > +       $(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
> > +       $(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIBEXEC_DIR)
> >
> >  install-crond: default $(CRONTABS)
> >         $(INSTALL) -m 755 -d $(CROND_DIR)
> > diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
> > index 048b5732459..48a0f25b5f1 100644
> > --- a/scrub/xfs_scrub_fail@.service.in
> > +++ b/scrub/xfs_scrub_fail@.service.in
> > @@ -10,7 +10,7 @@ Documentation=man:xfs_scrub(8)
> >  [Service]
> >  Type=oneshot
> >  Environment=EMAIL_ADDR=root
> > -ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %f
> > +ExecStart=@pkg_libexec_dir@/xfs_scrub_fail "${EMAIL_ADDR}" %f
> >  User=mail
> >  Group=mail
> >  SupplementaryGroups=systemd-journal
> >
> 
> Looks great to me.
> 
> Reviewed-by: Neal Gompa <neal@gompa.dev>

Thanks!

--D

> 
> 
> 
> --
> 真実はいつも一つ！/ Always, there's only one truth!
> 
