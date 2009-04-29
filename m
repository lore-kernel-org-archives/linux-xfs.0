Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEKCWk164988 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:20:12 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A93C21CF815A
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:20:12 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id QqtLGtxsWvAZO9CE for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:20:12 -0700 (PDT)
Message-ID: <49F8621B.4060103@sandeen.net>
Date: Wed, 29 Apr 2009 09:20:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: add .gitignore
References: <20090429135050.GC30808@infradead.org>
In-Reply-To: <20090429135050.GC30808@infradead.org>
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
> This one is pretty ugly due to all the symlinked files, any better
> suggestions?
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsdump-dev/.gitignore
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfsdump-dev/.gitignore	2009-04-29 15:48:26.996484383 +0200
> @@ -0,0 +1,134 @@
> +# object files
> +*.o
> +
> +# build system
> +.census
> +Logs/
> +include/config.h
> +include/builddefs
> +install-sh
> +
> +# magic diretory symlinks
> +#include/disk
> +#include/xfs
> +
> +# Makepgs
> +build/src-manifest
> +build/xfsdump-*.tar.gz
> +doc/CHANGES.gz
> +xfsdump-*
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
> +po/xfsdump.pot
> +po/*.mo
> +
> +# quilt stuff
> +.pc/
> +patches/
> +
> +# binaries
> +dump/xfsdump
> +invutil/xfsinvutil
> +restore/xfsrestore
> +
> +# @%#% symlinked sourced files
> +dump/arch_xlate.[ch]
> +dump/cldmgr.[ch]
> +dump/content.h
> +dump/content_common.[ch]
> +dump/content_inode.h
> +dump/dlog.[ch]
> +dump/drive.[ch]
> +dump/drive_minrmt.c
> +dump/drive_scsitape.c
> +dump/drive_simple.c
> +dump/exit.h
> +dump/fs.[ch]
> +dump/getdents.[ch]
> +dump/global.[ch]
> +dump/hsmapi.[ch]
> +dump/inv_api.c
> +dump/inv_core.c
> +dump/inv_files.c
> +dump/inv_fstab.c
> +dump/inv_idx.c
> +dump/inv_mgr.c
> +dump/inv_priv.h
> +dump/inv_stobj.c
> +dump/inventory.h
> +dump/lock.[ch]
> +dump/main.c
> +dump/media.h
> +dump/mlog.[ch]
> +dump/openutil.[ch]
> +dump/path.[ch]
> +dump/qlock.[ch]
> +dump/rec_hdr.h
> +dump/ring.[ch]
> +dump/sproc.[ch]
> +dump/stream.[ch]
> +dump/ts_mtio.h
> +dump/types.h
> +dump/util.[ch]
> +
> +invutil/global.h
> +invutil/inv_files.c
> +invutil/inv_priv.h
> +invutil/inventory.h
> +invutil/mlog.h
> +invutil/types.h
> +invutil/util.h
> +
> +restore/arch_xlate.[ch]
> +restore/cldmgr.[ch]
> +restore/content.h
> +restore/content_inode.h
> +restore/dlog.[ch]
> +restore/drive.[ch]
> +restore/drive_minrmt.c
> +restore/drive_scsitape.c
> +restore/drive_simple.c
> +restore/exit.h
> +restore/fs.[ch]
> +restore/getdents.[ch]
> +restore/global.[ch]
> +restore/hsmapi.[ch]
> +restore/inv_api.c
> +restore/inv_core.c
> +restore/inv_files.c
> +restore/inv_fstab.c
> +restore/inv_idx.c
> +restore/inv_mgr.c
> +restore/inv_priv.h
> +restore/inv_stobj.c
> +restore/inventory.h
> +restore/lock.[ch]
> +restore/main.c
> +restore/media.h
> +restore/mlog.[ch]
> +restore/openutil.[ch]
> +restore/path.[ch]
> +restore/qlock.[ch]
> +restore/rec_hdr.h
> +restore/ring.[ch]
> +restore/sproc.[ch]
> +restore/stream.[ch]
> +restore/ts_mtio.h
> +restore/types.h
> +restore/util.[ch]
> 

could add cscope/ here too, but, *shrug*

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
