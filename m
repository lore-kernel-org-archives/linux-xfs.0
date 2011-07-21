Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6L96OC5017748 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 04:06:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 514FA8857E
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 02:06:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zRpo5ZYMNX9aeHub for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2011 02:06:21 -0700 (PDT)
Date: Thu, 21 Jul 2011 05:06:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems building xfsprogs
Message-ID: <20110721090619.GA26263@infradead.org>
References: <20110720175918.GB17971@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110720175918.GB17971@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 20, 2011 at 01:59:18PM -0400, Ted Ts'o wrote:
> a) "make configure" doesn't work until I patch the top-level Makefile:
> 
> diff --git a/Makefile b/Makefile
> index c40fb2c..37973f5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -82,7 +82,7 @@ configure:
>  	libtoolize -c $(LIBTOOLIZE_INSTALL) -f
>  	cp include/install-sh .
>  	aclocal -I m4
> -	autoconf
> +	autoconf -I m4
>  
>  include/builddefs: configure
>  	./configure $$LOCAL_CONFIGURE_OPTIONS

I works fine for me on various releases of Debian, Fedsora, RHEL and
SLES.  But all he machines I've quickly checked seem to have an autoconf
that can handle -I, so could you please send this pach with a proper
signoff and description?

> b) By default xfsprogs builds with DEBUG, and this causes building
> libxfs/xfs_ialloc.c to blow up since there a reference of
> xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
> fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
> two figure this out....

The defaul actually is DEBUG=-DNDEBUG.  No sure how you go he debug
build. but we surely should fix it.  I'll add the stub as soon as I get
some time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
