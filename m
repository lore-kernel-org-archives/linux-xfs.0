Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbdALTGa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 14:06:30 -0500
Date: Thu, 12 Jan 2017 13:06:26 -0600
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 2/3] build: add .tar.xz target
Message-ID: <20170112190626.GB17868@redhat.com>
References: <056383cb-cf7e-3880-aecf-d97d5516a60f@sandeen.net>
 <d8bdc1f2-af99-f7fd-659b-45f7ebf36efb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8bdc1f2-af99-f7fd-659b-45f7ebf36efb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 12, 2017 at 11:14:52AM -0600, Eric Sandeen wrote:
> kup generates .xz files, and Fedora RPMs now use that.
> It'd be nice to have a handy target to generate .xz
> files locally, so hack that in.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> I imagine there's a prettier way with wildcards or
> templates or whatnot, but my Make is rusty.
> 
>  Makefile | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 84dc62c..6e45733 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -26,18 +26,19 @@ endif
>  
>  SRCDIR = $(PKG_NAME)-$(PKG_VERSION)
>  SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
> +SRCTARXZ = $(PKG_NAME)-$(PKG_VERSION).tar.xz
>  
>  CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
>  LSRCFILES = configure.ac release.sh README VERSION $(CONFIGURE)
>  SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
>             m4/ltversion.m4 po/xfsprogs.pot .gitcensus $(CONFIGURE)
>  LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
> -	conftest* built .census install.* install-dev.* *.gz \
> +	conftest* built .census install.* install-dev.* *.gz *.xz \
>  	autom4te.cache/* libtool include/builddefs include/platform_defs.h
>  
>  ifeq ($(HAVE_BUILDDEFS), yes)
>  LDIRDIRT = $(SRCDIR)
> -LDIRT += $(SRCTAR)
> +LDIRT += $(SRCTAR) $(SRCTARXZ)
>  endif
>  
>  # header install rules to populate include/xfs correctly
> @@ -165,6 +166,11 @@ $(SRCTAR) : default $(SRCTARINC) .gitcensus
>  	   `cat .gitcensus` $(SRCTARINC)
>  	echo Wrote: $@
>  
> +$(SRCTARXZ) : default $(SRCTARINC) .gitcensus
> +	$(Q)$(TAR) --transform "s,^,$(SRCDIR)/," -Jcf $(SRCDIR).tar.xz  \
> +	   `cat .gitcensus` $(SRCTARINC)
> +	echo Wrote: $@
> +
>  .gitcensus: $(_FORCE)
>  	$(Q)if test -d .git; then \
>  	  git ls-files > .gitcensus && echo "new .gitcensus"; \
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
