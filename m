Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p29JJm9v057041 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 13:19:53 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 527EB10B61E8
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 11:22:27 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id jFidTORJnF6I9rgv for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 11:22:27 -0800 (PST)
Message-ID: <4D77D371.6070802@sandeen.net>
Date: Wed, 09 Mar 2011 13:22:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, v2 1/2] xfstests: a few fixes to Makefile
References: <201103091837.p29Ib3nc012048@stout.americas.sgi.com>
In-Reply-To: <201103091837.p29Ib3nc012048@stout.americas.sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On 3/9/11 12:37 PM, Alex Elder wrote:
> Change the top-level Makefile, to make it clearer just what makes
> what, and what depends on what:
> - Separate the rules for "configure" and "include/builddefs" into
>   two parts, each of which generate one of the files
> - Get rid of the rule for include/config.h, and group it with the
>   one for include/builddefs (the same command creates both files)
> 
> Having done this, we find that having both "include/builddefs" and
> "include/config.h" as dependencies for the default target results in
> a parallel invocation of "make" spawning two concurrent attempts to
> do the configure step--and that doesn't work.
> 
> Creating one of those two will result in the other getting created,
> so just list one of them as a dependency for the default rule.
> 
> A couple of other small fixes:
> - Get rid of the "new", "remake" and "check" dependencies for the
>   default rule, which serve no purpose
> - Use the $(Q) convention in a few missed spots
> - Stop a DMAPI-only comment from getting echoed on default build
> 
> This updated version folds in the content of a patch previously
> posted separately to fix the problem with parallel builds.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  Makefile |   23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> Index: b/Makefile
> ===================================================================
> --- a/Makefile
> +++ b/Makefile
> @@ -39,14 +39,14 @@ TOOL_SUBDIRS = ltp src m4
>  
>  SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
>  
> -default: include/builddefs include/config.h $(DMAPI_MAKEFILE) new remake check $(TESTS)
> +default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
>  ifeq ($(HAVE_BUILDDEFS), no)
>  	$(Q)$(MAKE) $(MAKEOPTS) $@
>  else
>  	$(Q)$(MAKE) $(MAKEOPTS) $(SUBDIRS)
> +ifeq ($(HAVE_DMAPI), true)
>  	# automake doesn't always support "default" target 
>  	# so do dmapi make explicitly with "all"
> -ifeq ($(HAVE_DMAPI), true)
>  	$(Q)$(MAKE) $(MAKEOPTS) -C $(TOPDIR)/dmapi all
>  endif
>  endif
> @@ -60,22 +60,19 @@ else
>  clean:  # if configure hasn't run, nothing to clean
>  endif
>  
> -configure include/builddefs:
> +configure: configure.in
>  	autoheader
>  	autoconf
> +
> +include/builddefs include/config.h: configure
>  	./configure \
>                  --libexecdir=/usr/lib \
>                  --enable-lib64=yes
>  
> -include/config.h: include/builddefs
> -## Recover from the removal of $@
> -	@if test -f $@; then :; else \
> -		rm -f include/builddefs; \
> -		$(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
> -	fi
> -
> +ifeq ($(HAVE_DMAPI), true)
>  $(DMAPI_MAKEFILE):
> -	cd $(TOPDIR)/dmapi/ ; ./configure
> +	$(Q)cd $(TOPDIR)/dmapi && ./configure
> +endif
>  
>  aclocal.m4::
>  	aclocal --acdir=`pwd`/m4 --output=$@
> @@ -97,5 +94,5 @@ install-dev install-lib:
>  	$(MAKE) $(MAKEOPTS) -C $* install
>  
>  realclean distclean: clean
> -	rm -f $(LDIRT) $(CONFIGURE)
> -	rm -rf autom4te.cache Logs
> +	$(Q)rm -f $(LDIRT) $(CONFIGURE)
> +	$(Q)rm -rf autom4te.cache Logs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
