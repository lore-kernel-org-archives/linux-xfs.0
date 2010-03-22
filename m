Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2MFVlBW016554 for <xfs@oss.sgi.com>; Mon, 22 Mar 2010 10:31:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EBBC1451988
	for <xfs@oss.sgi.com>; Mon, 22 Mar 2010 08:33:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PRqZydxPltASMKeC for
	<xfs@oss.sgi.com>; Mon, 22 Mar 2010 08:33:27 -0700 (PDT)
Date: Mon, 22 Mar 2010 11:33:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: builddefs.in
Message-ID: <20100322153325.GA29823@infradead.org>
References: <20100321141349.GE1827@lasse.mail.plastictre.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100321141349.GE1827@lasse.mail.plastictre.net>
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
To: Lasse Kliemann <lasse-private-2010@mail.plastictree.net>
Cc: xfs@oss.sgi.com

On Sun, Mar 21, 2010 at 03:13:50PM +0100, Lasse Kliemann wrote:
> Using 3.1.1.
> 
> When configured with a '--prefix', the build fails:
> 
> [...]
>     [CC]     linux.lo
>     [LD]     libxfs.la
> libtool: link: only absolute run-paths are allowed
> gmake[2]: *** [libxfs.la] Error 1
> gmake[1]: *** [libxfs] Error 2
> make: *** [default] Error 2
> 
> Calling 'make' in 'libxfs' reveals that '-rpath' option is used 
> with no argument. The attached patch remedies this. Indeed, with 
> this patch the correct argument is given to '-rpath', at least in 
> 'libxfs' subdirectory. 
> 
> It also remedies a similar problem when installing executables 
> into '.../sbin' directory.

> diff --git a/include/builddefs.in b/include/builddefs.in
> index cc75b5d..801b09e 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -52,8 +52,8 @@ datarootdir	= @datarootdir@
>  top_builddir	= @top_builddir@
>  
>  PKG_SBIN_DIR	= @sbindir@
> -PKG_ROOT_SBIN_DIR = @root_sbindir@
> -PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
> +PKG_ROOT_SBIN_DIR = @sbindir@
> +PKG_ROOT_LIB_DIR= @libdir@@libdirsuffix@

This is against the intent of the whole ROOT_LIB/SBIN_DIR
mechnism as it makes them equivalent to the normal ones.
It seems we have some problem generatin the correct @root_sbindir@ /
@root_libdir@ paths in the autoconf macros for your use case, I'll
look into that once I get a bit of time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
