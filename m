Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEIJGL164921 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:18:19 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E6281CF805E
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:18:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id wTdtZPqoECSszG1B for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:18:19 -0700 (PDT)
Message-ID: <49F861A8.20106@sandeen.net>
Date: Wed, 29 Apr 2009 09:18:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] dmapi: add .gitignore
References: <20090429135000.GB30808@infradead.org>
In-Reply-To: <20090429135000.GB30808@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: dmapi-dev/.gitignore
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ dmapi-dev/.gitignore	2009-04-29 15:37:28.128650851 +0200
> @@ -0,0 +1,39 @@
> +# object files
> +*.o
> +
> +# build system
> +.census
> +Logs/
> +include/builddefs
> +install-sh
> +
> +# magic diretory symlinks
> +include/xfs
> +
> +# Makepgs
> +build/src-manifest
> +build/dmapi-*.tar.gz
> +doc/CHANGES.gz
> +dmapi-*
> +
> +# autoconf generated files
> +aclocal.m4
> +autom4te.cache/
> +config.guess
> +config.log
> +config.status
> +config.sub
> +configure
> +
> +# libtool
> +libtool
> +ltmain.sh
> +*.lo
> +*.la
> +.libs
> +
> +# quilt stuff
> +.pc/
> +patches/
> +
> +# binaries

(could add cscope/ too ...)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
