Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFC7C7F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 20:55:56 -0600 (CST)
Date: Thu, 31 Jan 2013 20:55:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/4] xfstests: Refactor release scripts to conform to
	using git archive
Message-ID: <20130201025553.GV27055@sgi.com>
References: <50F44B2E.9050408@sgi.com>
 <50F44BA5.9030509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50F44BA5.9030509@sgi.com>
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

On Mon, Jan 14, 2013 at 12:17:09PM -0600, Andrew Dahl wrote:

> Refactored release scripts to conform to using git archive
> 
> When generating a release, there is a risk of some files being
> stale, such as configure and the m4/autotools temp files. This
> is fixed with a clean at the beginning of release generation.
> In addition, there is no uniformity in the current method of
> source tar generation between xfs utilities. Using git archive
> solves this issue across all utilities.
> 
> Signed-off-by: Andrew Dahl <adahl@sgi.com>
> ---
>  Makefile   |   20 ++++++++++++++++++++
>  release.sh |   11 +++++++++--
>  2 files changed, 29 insertions(+), 2 deletions(-)
>  mode change 100644 => 100755 release.sh
> 
> diff --git a/Makefile b/Makefile
> index b68ec11..a0aef85 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -39,12 +39,17 @@ ifeq ($(HAVE_BUILDDEFS), yes)
>  include $(TOPDIR)/include/builddefs
>  endif
>  
> +SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
> +
>  TESTS = $(shell sed -n -e '/^[0-9][0-9][0-9]*/s/ .*//p' group)
>  CONFIGURE = configure include/builddefs include/config.h
>  LSRCFILES = configure configure.ac aclocal.m4 README VERSION
>  LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
>  	conftest* check.log check.time
>  
> +ifeq ($(HAVE_BUILDDEFS), yes)
> +LDIRT += $(SRCTAR)
> +endif
>  
>  LIB_SUBDIRS = include lib
>  TOOL_SUBDIRS = ltp src m4
> @@ -102,3 +107,18 @@ install-dev install-lib:
>  realclean distclean: clean
>  	$(Q)rm -f $(LDIRT) $(CONFIGURE)
>  	$(Q)rm -rf autom4te.cache Logs
> +
> +dist: include/builddefs include/config.h default
> +ifeq ($(HAVE_BUILDDEFS), no)
> +	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
> +else
> +	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
> +endif
> +
> +$(SRCTAR) : default
> +	$(Q)git archive --prefix=$(PKG_NAME)-$(PKG_VERSION)/ --format=tar \
> +	  v$(PKG_VERSION) -o $(PKG_NAME)-$(PKG_VERSION).tar

Again, changed this to
 > $(PKG_NAME)-$(PKG_VERSION).tar

And it worked fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
