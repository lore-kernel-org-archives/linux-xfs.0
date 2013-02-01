Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF9797F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 20:10:52 -0600 (CST)
Date: Thu, 31 Jan 2013 20:10:48 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/4] xfsprogs: Refactor release scripts to conform to
	using git archive
Message-ID: <20130201021048.GT27055@sgi.com>
References: <50F44B2E.9050408@sgi.com>
 <50F44B62.7060504@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50F44B62.7060504@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

Andrew,

On Mon, Jan 14, 2013 at 12:16:02PM -0600, Andrew Dahl wrote:
> Refactored release scripts to conform to using git archive
> 
> When generating a release, there is a risk of missing necessary
> source files. This is fixed by using git archive, which also
> fixes the lack of conformity between the xfs utilities. As well,
> some files may be stale during packaging. This is fixed with a
> clean at the beginning of release generation.
> 
> Signed-off-by: Andrew Dahl <adahl@sgi.com>

Compared the old 'make dist' with the new one:
# diff old.list new.list
129a130
> xfsprogs-3.1.10/.gitignore

The only difference in the file list is the addition of .gitignore.

> ---
>  Makefile   |   11 ++++++++---
>  release.sh |    3 +++
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 0bdc5e8..e73af88 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -29,6 +29,8 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
>  
>  CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
>  LSRCFILES = configure.ac release.sh README VERSION $(CONFIGURE)
> +SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
> +           m4/ltversion.m4 po/xfsprogs.pot $(CONFIGURE)
>  
>  LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
>  	conftest* built .census install.* install-dev.* *.gz \
> @@ -144,7 +146,10 @@ $(SRCDIR) : $(_FORCE)
>  	rm -fr $@
>  	mkdir -p $@
>  
> -$(SRCTAR) : default $(SRCDIR)
> -	$(Q)$(MAKE) $(MAKEOPTS) source-link
> -	unset TAPE; $(TAR) -cf - $(SRCDIR) | $(ZIP) --best > $@ && \
> +$(SRCTAR) : default
> +	$(Q)git archive --prefix=$(SRCDIR)/ --format=tar v$(PKG_VERSION) \
> +	  -o $(SRCDIR).tar

Older versions of git do not support the -o option.  I changed this to >
$(SRCDIR).tar and it works fine.

> +	$(Q)$(TAR) --transform "s,^,$(SRCDIR)/," -rf $(SRCARC).tar \
						       SRCDIR

With those changes this looks and works fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
