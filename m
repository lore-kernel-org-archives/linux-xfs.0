Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJ4XntF233805 for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 22:33:49 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4D769A2CA
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:34:12 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id CAmNFvvxjS1TnVQg for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:34:12 -0800 (PST)
Message-ID: <4B04CAC2.7040502@sandeen.net>
Date: Wed, 18 Nov 2009 22:34:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] libhandle: add symbol versioning
References: <20091030131213.GA18462@infradead.org>
In-Reply-To: <20091030131213.GA18462@infradead.org>
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
> Add symbol versioning for libhandle.  For now version 1.0.3 contains all
> pre-existing symbols, any new additions both needs a minor version bump
> and an entry in libhandle.sym.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I don't claim to be a libtool expert, but as far as I can tell,
this seems ok to me.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>


> Index: xfsprogs-dev/libhandle/Makefile
> ===================================================================
> --- xfsprogs-dev.orig/libhandle/Makefile	2009-10-30 13:00:51.000000000 +0000
> +++ xfsprogs-dev/libhandle/Makefile	2009-10-30 13:09:43.000000000 +0000
> @@ -10,7 +10,10 @@ LT_CURRENT = 1
>  LT_REVISION = 3
>  LT_AGE = 0
>  
> +LTLDFLAGS += -Wl,--version-script,libhandle.sym
> +
>  CFILES = handle.c jdm.c
> +LSRCFILES = libhandle.sym
>  
>  default:  $(LTLIBRARY)
>  
> Index: xfsprogs-dev/libhandle/libhandle.sym
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfsprogs-dev/libhandle/libhandle.sym	2009-10-30 13:00:45.000000000 +0000
> @@ -0,0 +1,36 @@
> +/*
> + * The symbol versioning ensures that a new application requiring symbol foo()
> + * can't run with old libhandle.so not providing foo() - the global SONAME
> + * version info can't enforce this since we never change the SONAME.
> + *
> + * Older versions of libhandle (<= 1.0.3) do not to use symbol versioning --
> + * all the original symbols are in LIBHANDLE_1.0.3 now.
> + */
> +
> +LIBHANDLE_1.0.3 {
> +global:
> +	/* handle.h APIs */
> +	path_to_handle;
> +	path_to_fshandle;
> +	handle_to_fshandle;
> +	free_handle;
> +	open_by_fshandle;
> +	open_by_handle;
> +	readlink_by_handle;
> +	attr_multi_by_handle;
> +	attr_list_by_handle;
> +	parents_by_handle;
> +	parentpaths_by_handle;
> +	fssetdm_by_handle;
> +
> +	/* jdm.h APIs */
> +	jdm_getfshandle;
> +	jdm_new_filehandle;
> +	jdm_delete_filehandle;
> +	jdm_open;
> +	jdm_readlink;
> +	jdm_attr_multi;
> +	jdm_attr_list;
> +	jdm_parents;
> +	jdm_parentpaths;
> +};
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
