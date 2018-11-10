Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbeKJQ3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 11:29:05 -0500
Subject: Re: [PATCH 6/6] xfs_scrub: move everything to /usr/sbin
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181075273.3727.12563703121689677996.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e97f4f2c-9978-96cc-0589-90942e2f4188@oracle.com>
Date: Fri, 9 Nov 2018 23:45:07 -0700
MIME-Version: 1.0
In-Reply-To: <154181075273.3727.12563703121689677996.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@tlinx.org

Looks ok to me.  You can add my review:

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 11/9/18 5:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Recently, it was pointed out that xfs_scrub{,_all} depend on components
> and libraries (libicu, python) that live in /usr.  /sbin binaries
> shouldn't depend on /usr, so let's move the scrub binaries to /usr/sbin.
> 
> Reported-by: xfs@tlinx.org
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   scrub/Makefile |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/scrub/Makefile b/scrub/Makefile
> index aebc7e43..c6473c12 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -103,7 +103,7 @@ default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
>   
>   xfs_scrub_all: xfs_scrub_all.in
>   	@echo "    [SED]    $@"
> -	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" \
> +	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
>   		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
>   		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
>   	$(Q)chmod a+x $@
> @@ -116,14 +116,14 @@ install: $(INSTALL_SCRUB)
>   
>   %.service: %.service.in
>   	@echo "    [SED]    $@"
> -	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" \
> +	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
>   		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
>   		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
>   		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
>   
>   %.cron: %.cron.in
>   	@echo "    [SED]    $@"
> -	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" < $< > $@
> +	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" < $< > $@
>   
>   install-systemd: default $(SYSTEMD_SERVICES)
>   	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
> @@ -136,9 +136,9 @@ install-crond: default $(CRONTABS)
>   	$(INSTALL) -m 644 $(CRONTABS) $(CROND_DIR)
>   
>   install-scrub: default
> -	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
> -	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
> -	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_ROOT_SBIN_DIR)
> +	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> +	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> +	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)
>   
>   install-dev:
>   
> 
