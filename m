Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 449127F72
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 07:24:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32637304053
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 05:24:12 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id WLNykdwBt6THNzLE (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 05:24:10 -0700 (PDT)
Subject: Bug#757455: please run dh_autoreconf or manually update m4/libtool.m4
	for ppc64el
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.757455.B.140750047430208@bugs.debian.org>
Message-ID: <53E4C0A5.8060704@debian.org>
Date: Fri, 08 Aug 2014 14:20:53 +0200
From: Matthias Klose <doko@debian.org>
MIME-Version: 1.0
Reply-To: Matthias Klose <doko@debian.org>, 757455@bugs.debian.org
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Debian Bug Tracking System <submit@bugs.debian.org>

Package: src:xfsprogs
Version: 3.2.1

trying to use dh_autoreconf:

        autoreconf -f -i
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
autoheader: warning: missing template: HAVE_UMODE_T
autoheader: Use AC_DEFINE([HAVE_UMODE_T], [], [Description])
autoheader: warning: missing template: HAVE___PSINT_T
autoheader: warning: missing template: HAVE___PSUNSIGNED_T
autoheader: warning: missing template: HAVE___U32
autoreconf: /usr/bin/autoheader failed with exit status: 1

please fix this and use dh_autoreconf, or update libtool.m4 manually as in
http://launchpadlibrarian.net/181798228/xfsprogs_3.1.9ubuntu2_3.2.1ubuntu1.diff.gz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
