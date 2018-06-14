Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48548 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935815AbeFNCyx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 22:54:53 -0400
Subject: Re: [PATCH 3/5] mkfs: hoist mkfs configfile dir string generation to
 build system
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <152891832515.3968.9067729692865604405.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <242e37f8-50fd-713b-2761-8c21a449859a@sandeen.net>
Date: Wed, 13 Jun 2018 21:54:52 -0500
MIME-Version: 1.0
In-Reply-To: <152891832515.3968.9067729692865604405.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/13/18 2:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the generation of MKFS_XFS_CONF_DIR to the build system; in the
> next few patches we're going to use that to install a (disabled) default
> config file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/builddefs.in |    4 +++-
>  mkfs/Makefile        |    5 +++++
>  mkfs/config.h        |    3 ---
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index e1ee9f7b..06cb71a6 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -65,6 +65,9 @@ PKG_MAN_DIR	= @mandir@
>  PKG_ETC_DIR	= @sysconfdir@
>  PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>  PKG_LOCALE_DIR	= @datadir@/locale
> +PKG_CFG_DIR	= $(PKG_ETC_DIR)/xfs
> +PKG_MKFS_CFG_DIR = $(PKG_CFG_DIR)/mkfs
> +PKG_MKFS_DEFAULT_CFGFILE = default
>  
>  CC		= @cc@
>  BUILD_CC	= @BUILD_CC@
> @@ -197,7 +200,6 @@ endif
>  
>  GCFLAGS = $(DEBUG) \
>  	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
> -	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
>  	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
>  
>  ifeq ($(ENABLE_GETTEXT),yes)
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 5af8a6cc..102f5214 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -10,6 +10,9 @@ LTCOMMAND = mkfs.xfs
>  HFILES =
>  CFILES = proto.c xfs_mkfs.c config.c defaults.c
>  
> +CFGFILE_CFLAGS = -DMKFS_XFS_CONF_DIR=\"$(PKG_MKFS_CFG_DIR)\" \
> +		 -DMKFS_XFS_DEFAULT_CONFIG=\"$(PKG_MKFS_DEFAULT_CFGFILE)\"
> +LCFLAGS += $(CFGFILE_CFLAGS)
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
>  	$(LIBUUID)
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
> @@ -22,6 +25,8 @@ include $(BUILDRULES)
>  install: default
>  	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
> +	$(INSTALL) -m 755 -d $(PKG_CFG_DIR)
> +	$(INSTALL) -m 755 -d $(PKG_MKFS_CFG_DIR)
>  install-dev:
>  
>  -include .dep
> diff --git a/mkfs/config.h b/mkfs/config.h
> index f00849e9..69f44405 100644
> --- a/mkfs/config.h
> +++ b/mkfs/config.h
> @@ -19,9 +19,6 @@
>  #ifndef _XFS_MKFS_CONFIG_H
>  #define _XFS_MKFS_CONFIG_H
>  
> -#define MKFS_XFS_CONF_DIR      	ROOT_SYSCONFDIR "/xfs/mkfs"
> -#define MKFS_XFS_DEFAULT_CONFIG	"default"
> -
>  struct fsxattr;
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
