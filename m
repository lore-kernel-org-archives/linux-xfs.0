Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LHAJ84088715 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 12:10:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76B8B1E302A8
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 10:13:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hz5bPVB4jiAB6NmX for
	<xfs@oss.sgi.com>; Wed, 21 Jul 2010 10:13:20 -0700 (PDT)
Date: Wed, 21 Jul 2010 13:13:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs: only absolute run-paths are allowed
Message-ID: <20100721171319.GA17772@infradead.org>
References: <alpine.DEB.2.01.1007210408390.3964@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1007210408390.3964@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 21, 2010 at 04:31:01AM -0700, Christian Kujau wrote:
> Hi,
> 
> I noticed that I can't use --prefix= any more for the ./configure script. 
> Doing so makes libtool unhappy:
> 
> $ make configure
> $ ./configure --prefix=/opt/xfsprogs
> $ make
> [...]
> libtool: link: only absolute run-paths are allowed
> make[2]: *** [libxfs.la] Error 1

The patch below should fix this issue.  Note that you need to do a

	make realclean
	make configure

to regenerate the configure script first.

Index: xfsprogs-dev/configure.in
===================================================================
--- xfsprogs-dev.orig/configure.in	2010-07-21 19:03:45.225494681 +0200
+++ xfsprogs-dev/configure.in	2010-07-21 19:06:19.649494682 +0200
@@ -65,12 +65,17 @@ esac
 case $exec_prefix:$prefix in
 NONE:NONE | NONE:/usr | /usr:*)
   root_sbindir='/sbin'
-  AC_SUBST([root_sbindir])
-
   root_libdir="/${base_libdir}"
-  AC_SUBST([root_libdir])
+  ;;
+*)
+  root_sbindir="${sbindir}"
+  root_libdir="${libdir}"
+  ;;
 esac
 
+AC_SUBST([root_sbindir])
+AC_SUBST([root_libdir])
+
 # Find localized files
 LOCALIZED_FILES=""
 for lfile in `find ${srcdir} -name '*.c' -type f || exit 1`; do

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
