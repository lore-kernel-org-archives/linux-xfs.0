Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4KC0O2e102333 for <xfs@oss.sgi.com>; Wed, 20 May 2009 07:00:24 -0500
Received: from padma.gslab.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 89EAF29B09B
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 05:00:33 -0700 (PDT)
Received: from padma.gslab.com (padma.gslab.com [59.163.66.102]) by
	cuda.sgi.com with SMTP id 05Tegv39kdszFcoX for
	<xfs@oss.sgi.com>; Wed, 20 May 2009 05:00:33 -0700 (PDT)
Subject: CFLAGS not taken while linking mkfs.xfs?
From: Milind <milind@gslab.com>
Date: Wed, 20 May 2009 17:30:27 +0530
Message-Id: <1242820827.3457.21.camel@alhena>
Mime-Version: 1.0
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Theodore Tso <tytso@mit.edu>

My CFLAGS are
-Wl,--dynamic-linker,/home/beehive/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/ld-linux-x86-64.so.2,--rpath,/home/beehive/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/

when I cross compile xfsprogs and do ldd on mkfs/mkfs.xfs I see
following thing
	linux-vdso.so.1 =>  (0x00007fff8e5fe000)
	libuuid.so.1
=> /home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/libuuid.so.1 (0x00007f4386030000)
	librt.so.1
=> /home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/librt.so.1 (0x00007f4385e15000)
	libpthread.so.0
=> /home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/libpthread.so.0 (0x00007f4385bfa000)
	libc.so.6
=> /home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/libc.so.6 (0x00007f43858b1000)
/lib64/ld-linux-x86-64.so.2 (0x00007f4386236000)

shouldn't mkfs.xfs be dependant
on /home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/ld-linux-x86-64.so.2
rather than
/lib64/ld-linux-x86-64.so.2 (0x00007f4386236000)?

When do following changes it works. 

ifdef LTCOMMAND
$(LTCOMMAND) : $(SUBDIRS) $(OBJECTS) $(LTDEPENDENCIES)
-        $(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
+         $(LTLINK) -o $@ $(CFLAGSS) $(LDFLAGS) $(OBJECTS) $(LDLIBS)
endif

linking of mkfs.xfs happes as follows with above change

libtool: link: 
gcc
-Wl,--dynamic-linker,/home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/ld-linux-x86-64.so.2,
--rpath,/home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib -o
mkfs.xfs maxtrres.o proto.o xfs_mkfs.o  ../libxfs/.libs/libxfs.a
-luuid ../libdisk/.libs/libdisk.a -lrt -lpthread

above problem is seen for other binaries too. Like xfs_io, xfs_copy.

-Miline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
