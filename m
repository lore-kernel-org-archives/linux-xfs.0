Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GMRbfQ097964 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 17:27:47 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC5AC8F8096
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 15:27:21 -0700 (PDT)
Message-Id: <02D38720-DD97-45F9-B742-8EE9628C3A02@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090416195311.GA22431@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfsprogs: add .gitignore file
Date: Thu, 16 Apr 2009 16:36:03 -0500
References: <20090416195311.GA22431@infradead.org>
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


On Apr 16, 2009, at 2:53 PM, Christoph Hellwig wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: xfsprogs-dev/.gitignore
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfsprogs-dev/.gitignore	2009-04-16 21:50:04.101077123 +0200
> @@ -0,0 +1,58 @@
> +# object files
> +*.o
> +
> +# build system
> +.census
> +Logs/
> +include/platform_defs.h
> +include/builddefs
> +install-sh
> +
> +# magic diretory symlinks
> +include/disk
> +include/xfs
> +
> +# Makepgs
> +build/src-manifest
> +build/xfsprogs-*.tar.gz
> +doc/CHANGES.gz
> +xfsprogs-*
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
> +# gettext
> +po/pl.mo
> +po/xfsprogs.pot
> +
> +# quilt stuff
> +.pc/
> +patches/
> +
> +# binaries
> +copy/xfs_copy
> +db/xfs_db
> +estimate/xfs_estimate
> +fsr/xfs_fsr
> +growfs/xfs_growfs
> +io/xfs_io
> +logprint/xfs_logprint
> +mdrestore/xfs_mdrestore
> +mkfs/fstyp
> +mkfs/mkfs.xfs
> +quota/xfs_quota
> +repair/xfs_repair
> +rtcp/xfs_rtcp
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
