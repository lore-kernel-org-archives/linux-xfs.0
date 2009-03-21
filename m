Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2L4Gpfe217719 for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 23:17:11 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C4C51B3ACB
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 21:16:31 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id vyL2hiKdkUWmozzE for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2009 21:16:31 -0700 (PDT)
Message-ID: <49C466CE.3000609@sandeen.net>
Date: Fri, 20 Mar 2009 23:02:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: make sure Makpekgs is complete
References: <20090224183819.GA25706@infradead.org>
In-Reply-To: <20090224183819.GA25706@infradead.org>
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

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfsdump-dev/doc/Makefile
> ===================================================================
> --- xfsdump-dev.orig/doc/Makefile	2009-02-24 19:31:07.048152638 +0100
> +++ xfsdump-dev/doc/Makefile	2009-02-24 19:31:34.859030054 +0100
> @@ -7,13 +7,8 @@ include $(TOPDIR)/include/builddefs
>  
>  README = README.xfsdump
>  LSRCFILES = INSTALL PORTING CHANGES COPYING $(README) \
> -	directories.gif directories.obj               \
> -	files.gif files.obj                           \
> -	global_hdr.gif global_hdr.obj                 \
> -	inode_map.gif inode_map.obj                   \
> -	media_files.gif media_files.obj               \
> -	split_algorithm.gif split_algorithm.obj       \
> -	xfsdump.html xfsdump_ts.txt
> +	xfsdump.html xfsdump_ts.txt \
> +	*.obj *.gif
>  
>  LDIRT = *.gz
>  
> Index: xfsdump-dev/include/Makefile
> ===================================================================
> --- xfsdump-dev.orig/include/Makefile	2009-02-24 19:31:49.244027259 +0100
> +++ xfsdump-dev/include/Makefile	2009-02-24 19:37:18.132152625 +0100
> @@ -5,7 +5,7 @@
>  TOPDIR = ..
>  include $(TOPDIR)/include/builddefs
>  
> -HFILES = swap.h
> +HFILES = swab.h swap.h
>  LSRCFILES = builddefs.in buildmacros buildrules config.h.in
>  
>  default install install-dev :
> Index: xfsdump-dev/inventory/Makefile
> ===================================================================
> --- xfsdump-dev.orig/inventory/Makefile	2009-02-24 19:32:17.497028005 +0100
> +++ xfsdump-dev/inventory/Makefile	2009-02-24 19:34:01.969057100 +0100
> @@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
>  
>  LSRCFILES = inv_api.c inv_core.c inv_fstab.c inv_idx.c inv_mgr.c \
>  	inv_oref.c inv_oref.h inv_priv.h inv_stobj.c inv_files.c \
> -	inventory.h
> +	inventory.h getopt.h testmain.c
>  
>  default install install-dev:
>  
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
