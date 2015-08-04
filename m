Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 207307FA8
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 10:24:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F24348F8049
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 08:24:13 -0700 (PDT)
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25]) by
	cuda.sgi.com with ESMTP id FVnDsDtp1Idf3Lo7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 08:24:12 -0700 (PDT)
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <ferseiti@linux.vnet.ibm.com>;
	Tue, 4 Aug 2015 12:24:10 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 0D8E83520078
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 11:23:02 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
	t74FOUdO5071038 for <xfs@oss.sgi.com>; Tue, 4 Aug 2015 12:24:30 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	t74FO6ZF013716 for <xfs@oss.sgi.com>; Tue, 4 Aug 2015 12:24:06 -0300
Message-ID: <55C0D916.1010102@linux.vnet.ibm.com>
Date: Tue, 04 Aug 2015 12:24:06 -0300
From: Fernando Seiti Furusato <ferseiti@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: Bug#793495: xfsprogs fails to build on debian ppc64el
References: <55BB9271.6000300@gmx.net> <55BBEF4F.6070809@linux.vnet.ibm.com>
	<20150801225230.GR16638@dastard>
	<41BF7556-AAAB-4F22-B8C2-8991A0917DE2@gmx.net>
	<20150802221301.GO3902@dastard>
In-Reply-To: <20150802221301.GO3902@dastard>
Content-Type: multipart/mixed; boundary="------------050603000107000200000907"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, 793495@bugs.debian.org
Cc: Breno Leitao <brenohl@br.ibm.com>, Daniel Bast <daniel.bast@gmx.net>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------050603000107000200000907
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave.

I have just noticed that for config.guess and config.sub to be updated, no
autoreconf or dh_autotools-dev is needed, because of how Makefile was made.

In Makefile, @row 80:

  LIBTOOLIZE_INSTALL = `libtoolize -n -i >/dev/null 2>/dev/null && echo -i`

  configure:
          libtoolize -c $(LIBTOOLIZE_INSTALL) -f
          cp include/install-sh .
          aclocal -I m4
          autoconf

This runs libtoolize -c -i which updates those files.

The file debian/rules runs `make default`, which at some point calls the target
above (`make configure`). But the file configure already exists, so it does not
run.

Curiously, running `dpkg-buildpackage` twice, causes configure file to be
deleted, and the build completes without errors.

So, answering to your question:

 > Nowdays, the generated files in the 3.2.4 tarball created via a
 > 'make dist' rule. I run that on an up to date debian unstable box
 > with autoconfig 2.69 installed to generate the files, so the
 > question I have is this: why is an up-to-date build box generating
 > "out of date" configure/m4 scripts? What, exactly, is out of date,
 > and how do I ensure that the pre-build config files are correctly
 > up-to-date?

The configure file comes shipped with the debian package, so that specific file
is not re-generated and is always out of date.
By the looks of the Makefile, there is no need to include autoreconf or 
autotools-dev in debian/rules, but to force `make distclean` to `rm configure`.

Attached is a patch that summarizes that, but for some reason it does not work
when running with parallel jobs enabled. But you can get the idea :)

Regards.
-- 

Fernando Seiti Furusato
IBM Linux Technology Center

--------------050603000107000200000907
Content-Type: text/plain; charset=UTF-8;
 name="patch_xfsprogs.debdiff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch_xfsprogs.debdiff"

diff -Nru xfsprogs-3.2.4/debian/changelog xfsprogs-3.2.4ppc64el1/debian/changelog
--- xfsprogs-3.2.4/debian/changelog	2015-07-30 03:45:12.000000000 -0400
+++ xfsprogs-3.2.4ppc64el1/debian/changelog	2015-08-04 11:07:37.000000000 -0400
@@ -1,3 +1,10 @@
+xfsprogs (3.2.4ppc64el1) UNRELEASED; urgency=medium
+
+  * debian/rules: removed usage of dh_autoreconf since it is not necessary.
+  * Makefile: change distclean target to remove configure every time. 
+
+ -- Fernando Seiti Furusato <ferseiti@br.ibm.com>  Tue, 04 Aug 2015 11:07:01 -0400
+
 xfsprogs (3.2.4) unstable; urgency=low
 
   * New upstream release
diff -Nru xfsprogs-3.2.4/debian/rules xfsprogs-3.2.4ppc64el1/debian/rules
--- xfsprogs-3.2.4/debian/rules	2014-11-09 19:51:18.000000000 -0500
+++ xfsprogs-3.2.4ppc64el1/debian/rules	2015-08-04 11:06:56.000000000 -0400
@@ -35,7 +35,6 @@
 .census:
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
-	AUTOHEADER=/bin/true dh_autoreconf
 	$(options) $(MAKE) include/platform_defs.h
 	touch .census
 
@@ -58,7 +57,6 @@
 	$(MAKE) distclean
 	-rm -rf $(dirme) $(dirdev) $(dirdi)
 	-rm -f debian/*substvars debian/files* debian/*.debhelper
-	dh_autoreconf_clean
 	dh_clean
 
 binary-indep:
diff -Nru xfsprogs-3.2.4/Makefile xfsprogs-3.2.4ppc64el1/Makefile
--- xfsprogs-3.2.4/Makefile	2013-10-10 17:07:16.000000000 -0400
+++ xfsprogs-3.2.4ppc64el1/Makefile	2015-08-04 11:06:40.000000000 -0400
@@ -116,7 +116,7 @@
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-qa
 
 distclean: clean
-	$(Q)rm -f $(LDIRT)
+	$(Q)rm -f $(LDIRT) $(CONFIGURE)
 
 realclean: distclean
 	$(Q)rm -f $(CONFIGURE) .gitcensus

--------------050603000107000200000907
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------050603000107000200000907--
