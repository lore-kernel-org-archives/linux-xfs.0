Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0BgQV050763 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:11:42 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC9341D8A728
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:54:43 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id OuCyEQHsviZcmRhE for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:54:43 -0700 (PDT)
Date: Thu, 21 Jul 2011 19:54:41 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Build script for a hermetic build of xfstests
Message-ID: <20110721235441.GB25092@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

With the six patches which I just sent (3 for xfsprogs, 3 for
xfstests), I'm now able to build xfstests hermetically using the
following script.  It's still a bit rough, but I offer it up if anyone
else wants to be able to build xfstests without having to worry about
hidden dependencies in the distro-supplied /usr/include/xfs
directories, etc.

						- Ted

#!/bin/bash -vx

DESTDIR=$(pwd)/bld

mkdir -p $DESTDIR

export CFLAGS="-I$DESTDIR/include"
export LDFLAGS="-static -L$DESTDIR/lib"

(cd e2fsprogs-libs; ./configure --prefix=/; make ; make DESTDIR=$DESTDIR install)

(cd attr; ./configure --prefix=$DESTDIR; make LLDFLAGS=-all-static ; make install-dev ; make install)

(cd acl; ./configure --prefix=$DESTDIR; make LLDFLAGS=-all-static; make install-dev; make install)

(cd libaio; make prefix=$DESTDIR install)

export DIST_ROOT=$DESTDIR
export LIBS=-lpthread
(cd xfsprogs-dev; make realclean ; make configure ; ./configure --prefix=/; make LLDFLAGS=-all-static BUILD_VERBOSE=1; make install; make install-dev)
unset LIBS
unset DIST_ROOT

export LIBTOOL="/usr/bin/libtool --tag=CC"
(cd dmapi; CFLAGS="-I$DESTDIR/include  -L$DESTDIR/lib" LDFLAGS=-static ./configure --prefix=$DESTDIR; make LLDFLAGS=-all-static; make install-dev; make install)
unset LIBTOOL

find . -name \*.la | xargs rm -f      # Die, libtool, die!!!!
cp $DESTDIR/include/xfs/dmapi.h $DESTDIR/include
set

export LIBS=-lpthread
export CFLAGS="-I$DESTDIR/include  -fno-stack-protector"
(cd xfstests-dev; ./configure ; make LLDFLAGS=-all-static BUILD_VERBOSE=1)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
