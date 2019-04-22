Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48464 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfDVS1E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Apr 2019 14:27:04 -0400
Subject: Re: [PATCH 01/10] scrub: fix Makefile targets which depend on
 builddefs
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594789626.115924.12751110694998923783.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a2b8a3bf-7bb1-63d3-b607-075548034470@sandeen.net>
Date: Mon, 22 Apr 2019 13:27:03 -0500
MIME-Version: 1.0
In-Reply-To: <155594789626.115924.12751110694998923783.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 4/22/19 10:44 AM, Darrick J. Wong wrote:
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

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
