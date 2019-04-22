Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfDVS2q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Apr 2019 14:28:46 -0400
Date: Mon, 22 Apr 2019 13:28:42 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 01/10] scrub: fix Makefile targets which depend on
 builddefs
Message-ID: <20190422182842.GA27749@redhat.com>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594789626.115924.12751110694998923783.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155594789626.115924.12751110694998923783.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 08:44:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add Makefile dependencies for targets that require variables set in
> builddefs.  Although most of the required variables are file paths
> defined during the ./configure process, we cannot simply use
> AC_CONFIG_FILES to generate the scripts because that macro only expands
> one level deep and its documentation says that it's only to be used for
> generating makefiles, not build targets themselves.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  scrub/Makefile |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/scrub/Makefile b/scrub/Makefile
> index f4710d3e..882da8fd 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -3,7 +3,8 @@
>  #
>  
>  TOPDIR = ..
> -include $(TOPDIR)/include/builddefs
> +builddefs=$(TOPDIR)/include/builddefs
> +include $(builddefs)
>  
>  # On linux we get fsmap from the system or define it ourselves
>  # so include this based on platform type.  If this reverts to only
> @@ -101,27 +102,27 @@ LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
>  
>  default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
>  
> -xfs_scrub_all: xfs_scrub_all.in
> +xfs_scrub_all: xfs_scrub_all.in $(builddefs)
>  	@echo "    [SED]    $@"
>  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
>  		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
>  		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
>  	$(Q)chmod a+x $@
>  
> -phase5.o unicrash.o xfs.o: $(TOPDIR)/include/builddefs
> +phase5.o unicrash.o xfs.o: $(builddefs)
>  
>  include $(BUILDRULES)
>  
>  install: $(INSTALL_SCRUB)
>  
> -%.service: %.service.in
> +%.service: %.service.in $(builddefs)
>  	@echo "    [SED]    $@"
>  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
>  		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
>  		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
>  		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
>  
> -%.cron: %.cron.in
> +%.cron: %.cron.in $(builddefs)
>  	@echo "    [SED]    $@"
>  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" < $< > $@
>  
> 
