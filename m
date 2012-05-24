Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4ODj8Va001575 for <xfs@oss.sgi.com>; Thu, 24 May 2012 08:45:09 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id PdWqeOUlZOqjP1DY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 May 2012 06:45:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by seven.medozas.de (Postfix) with ESMTP id 7826921A0C2E
	for <xfs@oss.sgi.com>; Thu, 24 May 2012 15:45:02 +0200 (CEST)
Date: Thu, 24 May 2012 15:45:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
Subject: xfsprogs: .lai files not found
Message-ID: <alpine.LNX.2.01.1205241517400.10834@frira.zrqbmnf.qr>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com


So I tried changing the xfsprogs package in openSUSE to build without 
static libraries, and what I got back from the build system was a 
warning about completely improper rpath settings.


	ERROR: RPATH "/home/abuild/rpmbuild/BUILD/xfsprogs-3.1.6/libxfs/.libs" 
	on 
	/home/abuild/rpmbuild/BUILDROOT/xfsprogs-3.1.6-0.x86_64/usr/sbin/mkfs.xfs 
	is not allowed
	[lots of these]

I therefore ripped out

	-LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)

from include/buildmacros, only to find that the install procedure then 
does not work at all anymore.

	cd ../libhandle/.libs; ../../install-sh -o abuild -g abuild -m 755 -d /lib64; ../../install-sh -o abuild -g abuild -m 644 -T so_dot_version libhandle.lai /lib64; ../../install-sh -o abuild -g abuild -T so_dot_current libhandle.lai /lib64
	install-sh: Unable to find libtool library file libhandle.lai
	install-sh: Unable to find libtool library file libhandle.lai
	gmake[1]: *** [install] Error 2
	make: *** [libhandle-install] Error 2
	error: Bad exit status from /var/tmp/rpm-tmp.JjlSJb (%install)

(I frown upon using libtool directly and seek to replace it with an
assisted version using automake. There is however __quite__ some
cruft in the src tree.)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
