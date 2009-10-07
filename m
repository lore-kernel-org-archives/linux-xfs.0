Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97J0F0Z204581 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 14:00:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E9D9BD9BC6
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 12:01:41 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id NeEisWB5mB9Jhtqi for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 12:01:41 -0700 (PDT)
Message-ID: <4ACCE594.3050207@sandeen.net>
Date: Wed, 07 Oct 2009 14:01:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: update configure defaults
References: <20091006151458.GA2560@infradead.org>
In-Reply-To: <20091006151458.GA2560@infradead.org>
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

Christoph Hellwig wrote:
> Currenly xfsprogs has two different sets for configurating it, those
> in the configure.in template, and those passed to configure by the
> toplevel Makefile when just running make.
>
> Those in the makefile make a lot more sense as they install xfsprogs
> into the / vs /usr split used by most distributions, and enable multi-libs
> when detected.
>
> This patch changes the build system to also use the same defaults when
> running ./configure.  To do this we get rid of some of the hacky
> autoconf abuse we had in the past in xfsprogs and just use the normal
> default sbindir and libdir variables for /usr/sbin an /usr/lib respecticly
> and define new root_sbindir and root_libdir variables for those few
> binaries installed into /.  The installation to / is disabled if the
> user chooses a non-default exex prefix.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>   

This almost works for me in fedora, except that fedora's rpm uses a %configure
which sets --libdir=/usr/lib64 and then I end up with stuff installed in
/usr/lib6464 \o/

With this patch things are ok again if I add --disable-lib64 :


diff --git a/configure.in b/configure.in
index 35a1e6f..78ac522 100644
--- a/configure.in
+++ b/configure.in
@@ -58,7 +58,14 @@ NONE:NONE | NONE:/usr | /usr:*)
   root_sbindir='/sbin'
   AC_SUBST([root_sbindir])
 
-  root_libdir='/lib'
+  case $libdir in
+  *64)
+    root_libdir='/lib64'
+    ;;
+  *)
+    root_libdir='/lib'
+    ;;
+   esac
   AC_SUBST([root_libdir])
 esac


 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
