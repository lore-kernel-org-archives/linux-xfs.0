Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C63C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4C520738
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:06:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kRKLh+9x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgD0RGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:06:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgD0RGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:06:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RH3E1G001732;
        Mon, 27 Apr 2020 17:06:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vkIr73cY0VlIVk0mNLayzJjx/zktGFZeYmsqppdRypo=;
 b=kRKLh+9xD3DCJzkK/p9IOymkXtbNXgXrfRGRMvqdKlRf94I3DvaffPztsEiWc/XRt7Ta
 fuJuVqs0aApFro5oDRQZpo012CEXcFYYLqBFgXp5L8cVf4utDVlvjLMq+sQ4gzE1BDkf
 cLKMNrtoHcs+5o7UAdzkiRSkk7yNH1UdlGZTzclv03PCw0DCUszRGnYhc6fYa3GIGm8T
 9iKOCYLhAXe8luscsqScyiXD1cM1xg1tpOVz22ReICHPAJpyaECvgWpLysVvSCqlDbhz
 AJYjBt5LDPoPGcKJWjmwFgMvE5g0KcndeLQFC+3j4D4cMPHNakXsF+eTNqjPDioLMSqg hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p00aaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:06:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RH2vn9055130;
        Mon, 27 Apr 2020 17:06:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my0a0gac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:06:36 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RH6YLO022388;
        Mon, 27 Apr 2020 17:06:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:06:33 -0700
Date:   Mon, 27 Apr 2020 10:06:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: remove libreadline support
Message-ID: <20200427170632.GP6742@magnolia>
References: <20200427072603.1238216-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427072603.1238216-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=9 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=9 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 09:26:03AM +0200, Christoph Hellwig wrote:
> libreadline has been relicensed to GPLv3 and thus incompatible to
> xfsprogs many years ago, and all the distros have dropped or are
> in the stages of dropping the last GPLv2 version.  As the BSD
> licensed libeditline provides the same functionality there is no
> need to keep the obsolete libreadline support around.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable, but did you notice that xfs_io segfaults if you build
with libedit and feed stdin garbage/EOF? :)

Anyway this is a straightforward removal, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> ---
>  configure.ac         |  7 -------
>  db/Makefile          |  5 -----
>  db/input.c           | 26 ++------------------------
>  growfs/Makefile      |  3 ---
>  include/builddefs.in |  2 --
>  io/Makefile          |  4 ----
>  libxcmd/Makefile     |  5 -----
>  libxcmd/input.c      | 18 ++----------------
>  quota/Makefile       |  5 -----
>  spaceman/Makefile    |  4 ----
>  10 files changed, 4 insertions(+), 75 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index c609ff6a..0d1ca43e 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -42,13 +42,6 @@ AC_ARG_ENABLE(blkid,
>  	enable_blkid=yes)
>  AC_SUBST(enable_blkid)
>  
> -AC_ARG_ENABLE(readline,
> -[  --enable-readline=[yes/no] Enable readline command editing [default=no]],
> -	test $enable_readline = yes && libreadline="-lreadline",
> -	enable_readline=no)
> -AC_SUBST(libreadline)
> -AC_SUBST(enable_readline)
> -
>  AC_ARG_ENABLE(editline,
>  [  --enable-editline=[yes/no] Enable editline command editing [default=no]],
>  	test $enable_editline = yes && libeditline="-ledit",
> diff --git a/db/Makefile b/db/Makefile
> index ed9f56c2..9bd9bf51 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -21,11 +21,6 @@ LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
>  LLDFLAGS += -static-libtool-libs
>  
> -ifeq ($(ENABLE_READLINE),yes)
> -LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> -CFLAGS += -DENABLE_READLINE
> -endif
> -
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>  CFLAGS += -DENABLE_EDITLINE
> diff --git a/db/input.c b/db/input.c
> index 4d6c7376..553025bc 100644
> --- a/db/input.c
> +++ b/db/input.c
> @@ -13,10 +13,7 @@
>  #include "malloc.h"
>  #include "init.h"
>  
> -#if defined(ENABLE_READLINE)
> -# include <readline/history.h>
> -# include <readline/readline.h>
> -#elif defined(ENABLE_EDITLINE)
> +#ifdef ENABLE_EDITLINE
>  # include <histedit.h>
>  #endif
>  
> @@ -211,26 +208,7 @@ fetchline_internal(void)
>  	return rval;
>  }
>  
> -#ifdef ENABLE_READLINE
> -char *
> -fetchline(void)
> -{
> -	char	*line;
> -
> -	if (inputstacksize == 1) {
> -		line = readline(get_prompt());
> -		if (!line)
> -			dbprintf("\n");
> -		else if (line && *line) {
> -			add_history(line);
> -			logprintf("%s", line);
> -		}
> -	} else {
> -		line = fetchline_internal();
> -	}
> -	return line;
> -}
> -#elif defined(ENABLE_EDITLINE)
> +#ifdef ENABLE_EDITLINE
>  static char *el_get_prompt(EditLine *e) { return get_prompt(); }
>  char *
>  fetchline(void)
> diff --git a/growfs/Makefile b/growfs/Makefile
> index 4104cc0d..a107d348 100644
> --- a/growfs/Makefile
> +++ b/growfs/Makefile
> @@ -10,9 +10,6 @@ LTCOMMAND = xfs_growfs
>  CFILES = xfs_growfs.c
>  
>  LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> -ifeq ($(ENABLE_READLINE),yes)
> -LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> -endif
>  
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 6ed9d295..30b2727a 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -25,7 +25,6 @@ LIBUUID = @libuuid@
>  LIBPTHREAD = @libpthread@
>  LIBTERMCAP = @libtermcap@
>  LIBEDITLINE = @libeditline@
> -LIBREADLINE = @libreadline@
>  LIBBLKID = @libblkid@
>  LIBDEVMAPPER = @libdevmapper@
>  LIBXFS = $(TOPDIR)/libxfs/libxfs.la
> @@ -82,7 +81,6 @@ RPM_VERSION	= @rpm_version@
>  ENABLE_SHARED	= @enable_shared@
>  ENABLE_GETTEXT	= @enable_gettext@
>  ENABLE_EDITLINE	= @enable_editline@
> -ENABLE_READLINE	= @enable_readline@
>  ENABLE_BLKID	= @enable_blkid@
>  ENABLE_SCRUB	= @enable_scrub@
>  
> diff --git a/io/Makefile b/io/Makefile
> index 1112605e..71741926 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -68,10 +68,6 @@ ifeq ($(HAVE_SYNCFS),yes)
>  LCFLAGS += -DHAVE_SYNCFS
>  endif
>  
> -ifeq ($(ENABLE_READLINE),yes)
> -LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> -endif
> -
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>  endif
> diff --git a/libxcmd/Makefile b/libxcmd/Makefile
> index f9bc1c5c..70e54308 100644
> --- a/libxcmd/Makefile
> +++ b/libxcmd/Makefile
> @@ -14,11 +14,6 @@ LTLDFLAGS += -static
>  
>  CFILES = command.c input.c help.c quit.c
>  
> -ifeq ($(ENABLE_READLINE),yes)
> -LCFLAGS += -DENABLE_READLINE
> -LTLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> -endif
> -
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LCFLAGS += -DENABLE_EDITLINE
>  LTLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
> diff --git a/libxcmd/input.c b/libxcmd/input.c
> index 137856e3..203110df 100644
> --- a/libxcmd/input.c
> +++ b/libxcmd/input.c
> @@ -9,10 +9,7 @@
>  #include <ctype.h>
>  #include <stdbool.h>
>  
> -#if defined(ENABLE_READLINE)
> -# include <readline/history.h>
> -# include <readline/readline.h>
> -#elif defined(ENABLE_EDITLINE)
> +#ifdef ENABLE_EDITLINE
>  # include <histedit.h>
>  #endif
>  
> @@ -28,18 +25,7 @@ get_prompt(void)
>  	return prompt;
>  }
>  
> -#if defined(ENABLE_READLINE)
> -char *
> -fetchline(void)
> -{
> -	char	*line;
> -
> -	line = readline(get_prompt());
> -	if (line && *line)
> -		add_history(line);
> -	return line;
> -}
> -#elif defined(ENABLE_EDITLINE)
> +#ifdef ENABLE_EDITLINE
>  static char *el_get_prompt(EditLine *e) { return get_prompt(); }
>  char *
>  fetchline(void)
> diff --git a/quota/Makefile b/quota/Makefile
> index 384f023a..da5a1489 100644
> --- a/quota/Makefile
> +++ b/quota/Makefile
> @@ -14,11 +14,6 @@ LLDLIBS = $(LIBXCMD) $(LIBFROG)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static
>  
> -ifeq ($(ENABLE_READLINE),yes)
> -LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> -CFLAGS += -DENABLE_READLINE
> -endif
> -
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>  CFLAGS += -DENABLE_EDITLINE
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index d01aa74a..2a366918 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -14,10 +14,6 @@ LLDLIBS = $(LIBXCMD) $(LIBFROG)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static
>  
> -ifeq ($(ENABLE_READLINE),yes)
> -LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> -endif
> -
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>  endif
> -- 
> 2.26.1
> 
