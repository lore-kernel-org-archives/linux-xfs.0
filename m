Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 78F307F6C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 21:55:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EEC4304032
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 19:55:10 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9yJHEwrgDmjN2HtK for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 19:55:08 -0700 (PDT)
Date: Fri, 31 Jul 2015 12:55:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfsprogs: use <>-style includes in installed headers
Message-ID: <20150731025506.GP16638@dastard>
References: <1437927209-31354-1-git-send-email-hch@lst.de>
	<1437927209-31354-7-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437927209-31354-7-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Jul 26, 2015 at 06:13:25PM +0200, Christoph Hellwig wrote:
> Once installed these are system headers, so we need to use <>-style inclu=
de
> statements between them.
> =

> Signed-off-by: Christoph Hellwig <hch@lst.de>

This causes a build failure on my system when doing a parallel
build. For some reason, make is trying to install libxfs headers
before the include headers, and fails because include/xfs doesn't
yet exist.

.....
config.status: executing libtool commands
   [HEADERS] libxfs
   [HEADERS] include
ln: failed to create symbolic link =BF../include/xfs/xfs_fs.h=BF: No such f=
ile or directory
Makefile:141: recipe for target 'xfs_fs.h-hdrs' failed
....

I made a small change to pull the creation of include/xfs out of
include/Makefile and up into include/buildrules where it is done
before running the install-headers rule on each header subdir,
and that fixes it. i.e:

diff --git a/include/Makefile b/include/Makefile
index bd8b0ca..705090a 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -67,12 +67,9 @@ include $(BUILDRULES)
 # set up include/xfs header directory
 install-headers: $(addsuffix -hdrs, $(HFILES) $(PHFILES) $(DKHFILES) $(LIB=
HFILES))

-%-hdrs: xfs
+%-hdrs:
        $(Q)$(LN_S) -f $(PWD)/include/$* xfs/$*

-xfs:
-       @mkdir -p xfs
-
 install: default
        $(INSTALL) -m 755 -d $(PKG_INC_DIR)

diff --git a/include/buildrules b/include/buildrules
index 72491db..1ece843 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -14,10 +14,16 @@ clean clobber : $(addsuffix -clean,$(SUBDIRS))
        $(Q)$(MAKE) $(MAKEOPTS) -C $* clean

 ifdef HDR_SUBDIRS
-headers: $(addsuffix -headers, $(HDR_SUBDIRS))
+.PHONY: .xfs
+
+headers: .xfs $(addsuffix -headers, $(HDR_SUBDIRS))
+
 %-headers:
        @echo "   [HEADERS] $*"
        $(Q)$(MAKE) $(MAKEOPTS) -C $* NODEP=3D1 install-headers
+
+.xfs:
+       @mkdir -p include/xfs
 endif

 # Never blow away subdirs


Now I've just got to work out which patch is breaking 'make deb'....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
