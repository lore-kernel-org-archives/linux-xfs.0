Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB7MGxgi076604 for <xfs@oss.sgi.com>; Mon, 7 Dec 2009 16:16:59 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C5DFDD93EB
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2009 14:17:32 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id ITliWBITcVI9qskn for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2009 14:17:32 -0800 (PST)
Date: Tue, 8 Dec 2009 09:17:26 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1868065083.979161260224246802.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <1957734295.979141260224244359.JavaMail.root@mail-au.aconex.com>
Subject: Re: User Space Releases
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_68418_234063820.1260224246800"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com

------=_Part_68418_234063820.1260224246800
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


----- "Nathan Scott" <nscott@aconex.com> wrote:

> ----- "Christoph Hellwig" <hch@infradead.org> wrote:
> 
> > So I think we're almost reading to get xfsprogs 3.1.0 and xfsdump
> > 3.0.4
> > out of the door.
> >
> > As far as I'm concerned this is the todo list:
> >
> > xfsprogs:
> >  - get my pending repair btree checking patches reviewed and in
> >  - update the changelog and possibly any other documentation
> >  - update the Debian packaging
> 
> I've double-checked the deb packaging side of things, all good.
> Could someone review following patch which does mild cleanup?
> 

Here it is.

-- 
Nathan

------=_Part_68418_234063820.1260224246800
Content-Type: text/x-patch; name=xfsprogs.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xfsprogs.patch

diff --git a/.gitignore b/.gitignore
index 1703fda..b06e074 100644
--- a/.gitignore
+++ b/.gitignore
@@ -7,18 +7,23 @@ include/platform_defs.h
 include/builddefs
 install-sh
 
-# magic diretory symlinks
+# magic directory symlinks
 include/disk
 include/xfs
 
-# Makepgs
-build/src-manifest
-build/xfsprogs-*.tar.gz
+# packaging
 doc/CHANGES.gz
 xfsprogs-*
+xfsprogs_*
+xfslibs-dev_*
 
 # autoconf generated files
 aclocal.m4
+m4/libtool.m4
+m4/ltoptions.m4
+m4/ltsugar.m4
+m4/ltversion.m4
+m4/lt~obsolete.m4
 autom4te.cache/
 config.guess
 config.log
@@ -34,9 +39,13 @@ ltmain.sh
 .libs
 
 # gettext
+po/de.mo
 po/pl.mo
 po/xfsprogs.pot
 
+# cscope stuff
+cscope.*
+
 # quilt stuff
 .pc/
 patches/
diff --git a/debian/Makefile b/debian/Makefile
index 9a284a7..1ba204c 100644
--- a/debian/Makefile
+++ b/debian/Makefile
@@ -8,6 +8,8 @@ include $(TOPDIR)/include/builddefs
 LSRCFILES = changelog compat control copyright rules
 DEV_DOC_DIR = $(PKG_DOC_DIR)/../xfslibs-dev
 BOOT_MKFS_BIN = $(TOPDIR)/mkfs/mkfs.xfs-xfsprogs-udeb
+LDIRDIRT = xfslibs-dev xfsprogs xfsprogs-udeb
+LDIRT = files *.log *.substvars *.debhelper
 
 default:
 

------=_Part_68418_234063820.1260224246800
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_68418_234063820.1260224246800--
