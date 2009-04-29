Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEhLGt165654 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:43:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C00BAC007
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:43:22 -0700 (PDT)
Message-Id: <645E0688-2C35-489F-B309-BE944F804346@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090429135000.GB30808@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] dmapi: add .gitignore
Date: Wed, 29 Apr 2009 09:43:21 -0500
References: <20090429135000.GB30808@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Apr 29, 2009, at 8:50 AM, Christoph Hellwig wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
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
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
