Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CD2C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CAAE20702
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RtSPWEGC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgAZWXZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:23:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56380 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgAZWXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:23:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMLjs9046397;
        Sun, 26 Jan 2020 22:23:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=37XlLQh4Jl/VznaHglvrUE7GqKbQdZFXaRbr5lEI1Y8=;
 b=RtSPWEGCKEaQEVUuq+9izuNs5MDZXbH61cX+3+8N3q6dRsBoPC2DkIzV712ppm8XK8E0
 usYG0SiMwJrh4CRaMVFTGnfKJ9KDfOQn8W5lsBZYUmukTha2/TZH6S+zXR6GQxaJiA1G
 pXi3oPLRUEwQoqmos9V6Y6Ee4mCjbkySGiG9J/Tni3VtYHuHqh6SVFx/XD2xSNpSF10E
 ppo+SzhGb+JgHHepU1LzjbUwxXWbp17xDmCjT2GTKIzIS1tKX62hsPnNVCHO9c6Yrt/I
 kA37wQOyKuEXww9EcDEZ0bXMrKB6z8VABVJPBegm+OA/Ym6XjWx9sKx4WX9Ml7P1ky/O Tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xreaqvcah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:23:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMJbCR175861;
        Sun, 26 Jan 2020 22:21:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xry6nc660-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:21:19 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00QMLIF0022528;
        Sun, 26 Jan 2020 22:21:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:21:18 -0800
Date:   Sun, 26 Jan 2020 14:21:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfsprogs: stop generating platform_defs.h
Message-ID: <20200126222117.GI3447196@magnolia>
References: <20200126113541.787884-1-hch@lst.de>
 <20200126113541.787884-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126113541.787884-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 26, 2020 at 12:35:41PM +0100, Christoph Hellwig wrote:
> Now that all the autoconf substituations are gone, there is no need
> to generate this (and thus any) header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  .gitignore                                      |  1 -
>  Makefile                                        | 15 ++++-----------
>  configure.ac                                    |  1 -
>  debian/rules                                    |  2 --
>  include/Makefile                                |  2 +-
>  include/{platform_defs.h.in => platform_defs.h} |  0
>  6 files changed, 5 insertions(+), 16 deletions(-)
>  rename include/{platform_defs.h.in => platform_defs.h} (100%)
> 
> diff --git a/.gitignore b/.gitignore
> index fd131b6f..20d033ae 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -6,7 +6,6 @@
>  # build system
>  .census
>  .gitcensus
> -/include/platform_defs.h
>  /include/builddefs
>  /install-sh
>  
> diff --git a/Makefile b/Makefile
> index 0edc2700..ff6a977d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -49,7 +49,7 @@ SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
>             m4/ltversion.m4 po/xfsprogs.pot .gitcensus $(CONFIGURE)
>  LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
>  	conftest* built .census install.* install-dev.* *.gz *.xz \
> -	autom4te.cache/* libtool include/builddefs include/platform_defs.h
> +	autom4te.cache/* libtool include/builddefs
>  
>  ifeq ($(HAVE_BUILDDEFS), yes)
>  LDIRDIRT = $(SRCDIR)
> @@ -84,7 +84,7 @@ endif
>  # include is listed last so it is processed last in clean rules.
>  SUBDIRS = $(LIBFROG_SUBDIR) $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
>  
> -default: include/builddefs include/platform_defs.h
> +default: include/builddefs
>  ifeq ($(HAVE_BUILDDEFS), no)
>  	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
>  else
> @@ -130,13 +130,6 @@ configure: configure.ac
>  include/builddefs: configure
>  	./configure $$LOCAL_CONFIGURE_OPTIONS
>  
> -include/platform_defs.h: include/builddefs
> -## Recover from the removal of $@
> -	@if test -f $@; then :; else \
> -		rm -f include/builddefs; \
> -		$(MAKE) $(MAKEOPTS) $(AM_MAKEFLAGS) include/builddefs; \
> -	fi
> -
>  install: $(addsuffix -install,$(SUBDIRS))
>  	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
>  	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
> @@ -160,14 +153,14 @@ realclean: distclean
>  #
>  # All this gunk is to allow for a make dist on an unconfigured tree
>  #
> -dist: include/builddefs include/platform_defs.h default
> +dist: include/builddefs default
>  ifeq ($(HAVE_BUILDDEFS), no)
>  	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
>  else
>  	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
>  endif
>  
> -deb: include/builddefs include/platform_defs.h
> +deb: include/builddefs
>  ifeq ($(HAVE_BUILDDEFS), no)
>  	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
>  else
> diff --git a/configure.ac b/configure.ac
> index 5eb7c14b..49c3a466 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -3,7 +3,6 @@ AC_PREREQ(2.50)
>  AC_CONFIG_AUX_DIR([.])
>  AC_CONFIG_MACRO_DIR([m4])
>  AC_CONFIG_SRCDIR([include/libxfs.h])
> -AC_CONFIG_HEADER(include/platform_defs.h)
>  AC_PREFIX_DEFAULT(/usr)
>  
>  AC_PROG_INSTALL
> diff --git a/debian/rules b/debian/rules
> index e8509fb3..41c0c004 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -43,14 +43,12 @@ config: .census
>  	@echo "== dpkg-buildpackage: configure" 1>&2
>  	$(checkdir)
>  	AUTOHEADER=/bin/true dh_autoreconf
> -	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
>  	touch .census
>  
>  dibuild:
>  	$(checkdir)
>  	@echo "== dpkg-buildpackage: installer" 1>&2
>  	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
> -		$(diopts) $(MAKE) include/platform_defs.h; \
>  		mkdir -p include/xfs; \
>  		for dir in include libxfs; do \
>  			$(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
> diff --git a/include/Makefile b/include/Makefile
> index a80867e4..c92ecbd5 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -37,7 +37,7 @@ HFILES = handle.h \
>  	xqm.h \
>  	xfs_arch.h
>  
> -LSRCFILES = platform_defs.h.in builddefs.in buildmacros buildrules install-sh
> +LSRCFILES = builddefs.in buildmacros buildrules install-sh
>  LSRCFILES += $(DKHFILES) $(LIBHFILES)
>  LDIRT = disk
>  LDIRDIRT = xfs
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h
> similarity index 100%
> rename from include/platform_defs.h.in
> rename to include/platform_defs.h
> -- 
> 2.24.1
> 
