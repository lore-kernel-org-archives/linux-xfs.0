Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GGraYf080186 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 11:53:46 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BE9121CD1E
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 09:53:19 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id WPAIRy14Mjm1vDy5 for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2009 09:53:19 -0700 (PDT)
Message-ID: <49E7626E.8040207@sandeen.net>
Date: Thu, 16 Apr 2009 11:53:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: set default prefix to /usr
References: <20090416162913.GA493@infradead.org>
In-Reply-To: <20090416162913.GA493@infradead.org>
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
> Make sure the installation defaults to /usr like all the other xfs
> tools.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/configure.in
> ===================================================================
> --- xfsprogs-dev.orig/configure.in	2009-04-16 18:27:53.870074796 +0200
> +++ xfsprogs-dev/configure.in	2009-04-16 18:27:57.850950773 +0200
> @@ -2,6 +2,7 @@ AC_INIT(include/libxfs.h)
>  AC_CONFIG_AUX_DIR([.])
>  AC_CONFIG_MACRO_DIR([m4])
>  AC_CONFIG_HEADER(include/platform_defs.h)
> +AC_PREFIX_DEFAULT(/usr)
>  
>  AC_PROG_LIBTOOL

ACK

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
