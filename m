Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01Htn6e010256 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 11:55:56 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C20D1BF805E
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 09:55:47 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id aOKqcQfXEaFpd1kK for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 09:55:47 -0800 (PST)
Message-ID: <495D03A1.6090307@sandeen.net>
Date: Thu, 01 Jan 2009 11:55:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: make install-qa should only install additional
	headers
References: <20081230174152.GA18469@infradead.org>
In-Reply-To: <20081230174152.GA18469@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> make install-qa should only install the headers a normal install-dev
> doesn't install instead of repeating the whole game.
> 
> That way the additional headers for xfsqa can be installed manually
> while using dpkg / rpm for the normal package. 

This seems mostly ok, but "install-qa" sort of sounds like it should
install the headers you need for qa and it doesn't, it only (now)
installs the extras right...?  By itself it's kind of a useless target
without also running install-dev isn't it?

To be correct, I think install-qa should have install-dev as a prereq.

Maybe do that, and add a new install-qa-only target? :)

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs/Makefile
> ===================================================================
> --- xfsprogs/Makefile	2008-12-30 13:03:06.000000000 +0000
> +++ xfsprogs/Makefile	2008-12-30 13:03:15.000000000 +0000
> @@ -76,7 +76,7 @@
>  
>  install-dev: default $(addsuffix -install-dev,$(SUBDIRS))
>  
> -install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
> +install-qa: default $(addsuffix -install-qa,$(SUBDIRS))
>  
>  %-install:
>  	$(MAKE) -C $* install
> Index: xfsprogs/include/Makefile
> ===================================================================
> --- xfsprogs/include/Makefile	2008-12-30 13:02:05.000000000 +0000
> +++ xfsprogs/include/Makefile	2008-12-30 13:02:31.000000000 +0000
> @@ -54,5 +54,5 @@
>  	$(INSTALL) -m 755 -d $(DK_INC_DIR)
>  	$(INSTALL) -m 644 $(DKHFILES) $(DK_INC_DIR)
>  
> -install-qa: install-dev
> +install-qa: default
>  	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)
> Index: xfsprogs/libdisk/Makefile
> ===================================================================
> --- xfsprogs/libdisk/Makefile	2008-12-30 13:00:53.000000000 +0000
> +++ xfsprogs/libdisk/Makefile	2008-12-30 13:01:39.000000000 +0000
> @@ -29,4 +29,4 @@
>  install-dev: default
>  	$(INSTALL_LTLIB_STATIC)
>  
> -install-qa: install-dev
> +install-qa: default
> Index: xfsprogs/libhandle/Makefile
> ===================================================================
> --- xfsprogs/libhandle/Makefile	2008-12-30 13:01:09.000000000 +0000
> +++ xfsprogs/libhandle/Makefile	2008-12-30 13:01:34.000000000 +0000
> @@ -22,4 +22,4 @@
>  install-dev: default
>  	$(INSTALL_LTLIB_DEV)
>  
> -install-qa: install-dev
> +install-qa: default
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
