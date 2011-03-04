Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24GXJNs176559 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 10:33:20 -0600
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C38ADA99B02
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 08:36:09 -0800 (PST)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id RgUXmRBLDA0QNrDp for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 08:36:09 -0800 (PST)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvXz6-0007fB-Kr
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 16:36:08 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvXz6-0005iR-G6
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 16:36:08 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1PvXz6-0001zq-Mo
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 17:36:08 +0100
Date: Fri, 4 Mar 2011 17:36:08 +0100
From: Marc Lehmann <schmorp@schmorp.de>
Subject: git xfsprogs don't build
Message-ID: <20110304163608.GB2030@schmorp.de>
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
To: xfs@oss.sgi.com

> Bug reports on build problems are welcome as well.

When I try to build a git clone clone from two days ago, I get this on amd64:

   [...]
    [LD]     libxfs.la
    /usr/bin/ld: .libs/xfs_bmap.o: relocation R_X86_64_PC32 against undefined
    symbol `xfs_bmap_check_leaf_extents' can not be used when making a shared
    object; recompile with -fPIC
    /usr/bin/ld: final link failed: Bad value
    collect2: ld returned 1 exit status
    make[2]: *** [libxfs.la] Error 1

That almost certainly means somebody tried to build a shared object or
library with some object file compiled without -fPIC.

In 32 bit (which wouldn't have that limitation), I get these:

   [...]
   Building copy
       [DEP]
       [CC]     xfs_copy.o
       [LD]     xfs_copy
   ../libxfs/.libs/libxfs.a(xfs_ialloc.o): In function `xfs_dilocate':
   /tmp/xfsprogs/libxfs/xfs_ialloc.c:1087: undefined reference to `xfs_stack_trace'
   ../libxfs/.libs/libxfs.a(xfs_inode.o): In function `xfs_validate_extents':
   /tmp/xfsprogs/libxfs/xfs_inode.c:45: undefined reference to `get_unaligned'
   /tmp/xfsprogs/libxfs/xfs_inode.c:46: undefined reference to `get_unaligned'
   ../libxfs/.libs/libxfs.a(xfs_inode.o): In function `xfs_imap_to_bp':
   /tmp/xfsprogs/libxfs/xfs_inode.c:146: undefined reference to `XFS_BUFTARG_NAME'
   ../libxfs/.libs/libxfs.a(xfs_bmap.o): In function `xfs_bmap_add_extent':
   /tmp/xfsprogs/libxfs/xfs_bmap.c:650: undefined reference to `xfs_bmap_check_leaf_extents'
   ../libxfs/.libs/libxfs.a(xfs_bmap.o): In function `xfs_bmapi':
   /tmp/xfsprogs/libxfs/xfs_bmap.c:4848: undefined reference to `xfs_bmap_validate_ret'
   collect2: ld returned 1 exit status
   make[2]: *** [xfs_copy] Error 1
   make[1]: *** [copy] Error 2
   make: *** [default] Error 2

This is the cofnigure output of the 32 bit build:

   debian32 /tmp/xfsprogs# ./configure
   checking build system type... i686-pc-linux-gnu
   checking host system type... i686-pc-linux-gnu
   checking for gcc... gcc
   checking whether the C compiler works... yes
   checking for C compiler default output file name... a.out
   checking for suffix of executables... 
   checking whether we are cross compiling... no
   checking for suffix of object files... o
   checking whether we are using the GNU C compiler... yes
   checking whether gcc accepts -g... yes
   checking for gcc option to accept ISO C89... none needed
   checking for a sed that does not truncate output... /bin/sed
   checking for grep that handles long lines and -e... /bin/grep
   checking for egrep... /bin/grep -E
   checking for fgrep... /bin/grep -F
   checking for ld used by gcc... /usr/bin/ld
   checking if the linker (/usr/bin/ld) is GNU ld... yes
   checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
   checking the name lister (/usr/bin/nm -B) interface... BSD nm
   checking whether ln -s works... yes
   checking the maximum length of command line arguments... 6144000
   checking whether the shell understands some XSI constructs... yes
   checking whether the shell understands "+="... yes
   checking for /usr/bin/ld option to reload object files... -r
   checking for objdump... objdump
   checking how to recognize dependent libraries... pass_all
   checking for ar... ar
   checking for strip... strip
   checking for ranlib... ranlib
   checking command to parse /usr/bin/nm -B output from gcc object... ok
   checking how to run the C preprocessor... gcc -E
   checking for ANSI C header files... yes
   checking for sys/types.h... yes
   checking for sys/stat.h... yes
   checking for stdlib.h... yes
   checking for string.h... yes
   checking for memory.h... yes
   checking for strings.h... yes
   checking for inttypes.h... yes
   checking for stdint.h... yes
   checking for unistd.h... yes
   checking for dlfcn.h... yes
   checking for objdir... .libs
   checking if gcc supports -fno-rtti -fno-exceptions... no
   checking for gcc option to produce PIC... -fPIC -DPIC
   checking if gcc PIC flag -fPIC -DPIC works... yes
   checking if gcc static flag -static works... yes
   checking if gcc supports -c -o file.o... yes
   checking if gcc supports -c -o file.o... (cached) yes
   checking whether the gcc linker (/usr/bin/ld) supports shared libraries... yes
   checking whether -lc should be explicitly linked in... no
   checking dynamic linker characteristics... GNU/Linux ld.so
   checking how to hardcode library paths into programs... immediate
   checking whether stripping libraries is possible... yes
   checking if libtool supports shared libraries... yes
   checking whether to build shared libraries... yes
   checking whether to build static libraries... yes
   checking for gcc... (cached) gcc
   checking whether we are using the GNU C compiler... (cached) yes
   checking whether gcc accepts -g... (cached) yes
   checking for gcc option to accept ISO C89... (cached) none needed
   checking for gcc... (cached) gcc
   checking whether we are using the GNU C compiler... (cached) yes
   checking whether gcc accepts -g... (cached) yes
   checking for gcc option to accept ISO C89... (cached) none needed
   checking for gmake... no
   checking for make... /usr/bin/make
   checking for tar... /bin/tar
   checking for gzip... /bin/gzip
   checking whether gcc -MM is supported... yes
   checking for awk... /usr/bin/awk
   checking for sort... /usr/bin/sort
   checking whether ln -s works... yes
   checking for msgfmt... /usr/bin/msgfmt
   checking for msgmerge... /usr/bin/msgmerge
   checking for xgettext... /usr/bin/xgettext
   checking for rpm... /usr/bin/rpm
   checking for rpmbuild... /usr/bin/rpmbuild
   checking aio.h usability... yes
   checking aio.h presence... yes
   checking for aio.h... yes
   checking for lio_listio... no
   checking for lio_listio in -lrt... yes
   checking uuid.h usability... no
   checking uuid.h presence... no
   checking for uuid.h... no
   checking sys/uuid.h usability... no
   checking sys/uuid.h presence... no
   checking for sys/uuid.h... no
   checking uuid/uuid.h usability... yes
   checking uuid/uuid.h presence... yes
   checking for uuid/uuid.h... yes
   checking for uuid_compare... no
   checking for uuid_compare in -luuid... yes
   checking pthread.h usability... yes
   checking pthread.h presence... yes
   checking for pthread.h... yes
   checking for pthread_mutex_init in -lpthread... yes
   checking for fadvise ... yes
   checking for madvise ... yes
   checking for mincore ... yes
   checking for sendfile ... yes
   checking for getmntent ... yes
   checking for getmntinfo ... no
   checking for fallocate... yes
   checking for library containing blkid_probe_all... no
   checking for blkid_probe_get_topology... no
   checking for __psint_t ... no
   checking for __psunsigned_t ... no
   checking for __u32 ... yes
   checking size of long... 4
   checking size of char *... 4
   configure: creating ./config.status
   config.status: creating include/builddefs
   config.status: creating include/platform_defs.h
   config.status: executing libtool commands


-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
