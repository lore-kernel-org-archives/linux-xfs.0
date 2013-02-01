Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 177B17F51
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 10:47:13 -0600 (CST)
Date: Fri, 1 Feb 2013 10:47:09 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/4] dmapi: Refactor release scripts to conform to
	using git archive
Message-ID: <20130201164709.GW27055@sgi.com>
References: <50F44B2E.9050408@sgi.com>
 <50F44BC0.80708@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50F44BC0.80708@sgi.com>
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

On Mon, Jan 14, 2013 at 12:17:36PM -0600, Andrew Dahl wrote:

> Refactored release scripts to conform to using git archive
> 
> When generating a release, there is a risk of some files being
> stale, such as configure and the m4/autotools temp files.  This
> is fixed with a clean at the beginning of release generation.
> In addition, there is no uniformity in the current method of
> source tar generation between xfs utilities. Using git archive
> solves this issue across all utilities.
> 
> Signed-off-by: Andrew Dahl <adahl@sgi.com>
> ---
>  Makefile       |   19 +++++++++++++++++++
>  Makepkgs       |    4 ++--
>  build/Makefile |   22 +---------------------
>  release.sh     |    5 ++++-
>  4 files changed, 26 insertions(+), 24 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 0bddb07..58e5caf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -9,6 +9,8 @@ ifeq ($(HAVE_BUILDDEFS), yes)
>  include $(TOPDIR)/include/builddefs
>  endif
>  
> +SRCTAR=$(PKG_NAME)-$(PKG_VERSION).tar.gz
> +
>  CONFIGURE = aclocal.m4 configure config.guess config.sub configure install-sh \
>  	    ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
>  	    m4/ltversion.m4 m4/lt~obsolete.m4
> @@ -84,3 +86,19 @@ distclean: clean
>  
>  realclean: distclean
>  	rm -f $(CONFIGURE)
> +
> +dist: default
> +ifeq ($(HAVE_BUILDDEFS), no)
> +	$(MAKE) $(MAKEOPTS) -C . $@
> +else
> +	$(MAKE) $(MAKEOPTS) $(SRCTAR)
> +	$(MAKE) $(MAKEOPTS) -C build dist
> +endif
> +
> +$(SRCTAR) : default
> +	git archive --prefix=$(PKG_NAME)-$(PKG_VERSION)/ --format=tar \
> +	  v$(PKG_VERSION) -o $(PKG_NAME)-$(PKG_VERSION).tar
		   	  > 

Other than that it looks fine.

# diff old.list new.list 
0a1
> dmapi-2.2.12/
1a3
> dmapi-2.2.12/build/
2a5
> dmapi-2.2.12/build/rpm/
6a10
> dmapi-2.2.12/build/tar/
12a17
> dmapi-2.2.12/debian/
17a23
> dmapi-2.2.12/doc/
22a29,30
> dmapi-2.2.12/.gitignore
> dmapi-2.2.12/include/
30a39
> dmapi-2.2.12/libdm/
49a59
> dmapi-2.2.12/m4/
62a73
> dmapi-2.2.12/man/
63a75
> dmapi-2.2.12/man/man3/

The old source tarball didn't have some directories in it.  That's ok.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
