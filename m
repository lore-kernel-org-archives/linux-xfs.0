Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 730D57F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 20:36:07 -0600 (CST)
Date: Thu, 31 Jan 2013 20:36:06 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/4] xfsdump: Refactor release scripts to conform to
	using git archive
Message-ID: <20130201023606.GU27055@sgi.com>
References: <50F44B2E.9050408@sgi.com>
 <50F44B87.3040102@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50F44B87.3040102@sgi.com>
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

On Mon, Jan 14, 2013 at 12:16:39PM -0600, Andrew Dahl wrote:
> Refactored release scripts to conform to using git archive
> 
> When generating a release, there is a risk of some files being
> stale, such as configure and the m4/autotools temp files. This
> is fixed with a clean at the beginning of the release generation.
> In addition, there is no uniformity in the current method of
> source tar generation between xfs utilities. Using git archive
> solves this issue accross all utilities.
> 
> Signed-off-by: Andrew Dahl <adahl@sgi.com>

Here is the difference between the old 'make dist' and the new one:

# diff old.list new.list
99a100
> xfsdump-3.1.2/.gitignore
190d190
< xfsdump-3.1.2/po/xfsdump.pot

Adding .gitignore is fine, and xfsdump.pot needn't be in the archive, it is an
output file from gettext.

> diff --git a/Makefile b/Makefile
> index 39881af..23b6a9e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -29,6 +29,8 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
>  
>  CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
>  LSRCFILES = configure.ac release.sh README VERSION $(CONFIGURE)
> +SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
> +            m4/ltversion.m4 $(CONFIGURE)
>  
>  LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
>  	conftest* built .census install.* install-dev.* *.gz \
> @@ -124,7 +126,10 @@ $(SRCDIR) : $(_FORCE)
>  	rm -fr $@
>  	mkdir -p $@
>  
> -$(SRCTAR) : default $(SRCDIR)
> -	$(Q)$(MAKE) $(MAKEOPTS) source-link
> -	unset TAPE; $(TAR) -cf - $(SRCDIR) | $(ZIP) --best > $@ && \
> +$(SRCTAR) : default
> +	$(Q)git archive --prefix=$(SRCDIR)/ --format=tar v$(PKG_VERSION) \
> +           -o $(SRCDIR).tar

Changed this to 

 > $(SRCDIR).tar

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
