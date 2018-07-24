Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from vic-mtaout3.csiro.au ([150.229.64.39]:15119 "EHLO
        vic-MTAout3.csiro.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388219AbeGXFYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 01:24:17 -0400
Received: from mayhem.atnf.CSIRO.AU (mayhem.atnf.csiro.au [130.155.194.144])
        by crux.atnf.csiro.au (Postfix) with ESMTP id 9318B199F7
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 14:09:44 +1000 (AEST)
Received: from mci156 by mayhem.atnf.CSIRO.AU with local (Exim 4.84_2)
        (envelope-from <mci156@mayhem.atnf.csiro.au>)
        id 1fhods-0008IH-DK
        for linux-xfs@vger.kernel.org; Tue, 24 Jul 2018 14:09:44 +1000
Date: Tue, 24 Jul 2018 14:09:44 +1000
From: Vincent McIntyre <vincent.mcintyre@csiro.au>
Subject: xfsprogs-dev failing to build
Message-ID: <20180724040944.GH27624@mayhem.atnf.CSIRO.AU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi

I am trying to build the latest xfsprogs on an older system,
details below. The configure script is failing on what appears
to be an unexpanded m4 macro,

  PKG_CHECK_MODULES(libicu, icu-i18n, have_libicu=yes, have_libicu=no)

I'm not quite sure how to work around this or if it is a bug.
Any advice would be appreciated.

Kind regards
Vince

System details:

% cat /etc/os-release 
PRETTY_NAME="Debian GNU/Linux 8 (jessie)"
NAME="Debian GNU/Linux"
VERSION_ID="8"
VERSION="8 (jessie)"
ID=debian
HOME_URL="http://www.debian.org/"
SUPPORT_URL="http://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

% git remote -v
origin  git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git (fetch)
origin  git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git (push)

% git log -1
commit 0821de47b419e6a2ed0e8a2c64fd26a93c398093
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Jun 29 02:52:21 2018

    xfsprogs: Release v4.17.0
    
    Update all the necessary files for a 4.17.0 release.
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Problem demonstration:

% make
libtoolize -c `libtoolize -n -i >/dev/null 2>/dev/null && echo -i` -f
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./config.guess'
libtoolize: copying file `./config.sub'
libtoolize: copying file `./install-sh'
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
cp include/install-sh .
aclocal -I m4
configure.ac:191: warning: PKG_PROG_PKG_CONFIG is m4_require'd but not m4_defun'd
m4/package_services.m4:4: AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR is expanded from...
configure.ac:191: the top level
configure.ac:191: warning: PKG_PROG_PKG_CONFIG is m4_require'd but not m4_defun'd
m4/package_services.m4:4: AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR is expanded from...
configure.ac:191: the top level
autoconf
configure.ac:191: warning: PKG_PROG_PKG_CONFIG is m4_require'd but not m4_defun'd
m4/package_services.m4:4: AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR is expanded from...
configure.ac:191: the top level
./configure $LOCAL_CONFIGURE_OPTIONS
checking for a BSD-compatible install... /usr/bin/install -c
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking how to print strings... printf
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
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+="... yes
checking how to convert x86_64-unknown-linux-gnu file names to x86_64-unknown-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-unknown-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking for gawk... gawk
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for mt... mt
checking if mt is a manifest tool... no
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
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
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
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking for gmake... no
checking for make... /usr/bin/make
checking for tar... /bin/tar
checking for gzip... /bin/gzip
checking whether gcc -MM is supported... yes
checking for sort... /usr/bin/sort
checking whether ln -s works... yes
checking for msgfmt... /usr/bin/msgfmt
checking for msgmerge... /usr/bin/msgmerge
checking for xgettext... /usr/bin/xgettext
checking for rpm... no
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
checking for fiemap... yes
checking for pwritev2... no
checking for preadv... yes
checking for copy_file_range... no
checking for sync_file_range... yes
checking for syncfs... yes
checking mntent.h usability... yes
checking mntent.h presence... yes
checking for mntent.h... yes
checking whether fls is declared... no
checking for readdir... yes
checking whether fsetxattr is declared... no
checking whether mremap is declared... yes
checking for struct fsxattr... no
checking for GETFSMAP... no
checking for struct statfs... yes
checking for struct statfs.f_flags... yes
checking for MAP_SYNC... no
checking for library containing dm_task_create... no
checking for mallinfo ... yes
checking attr/attributes.h usability... no
checking attr/attributes.h presence... no
checking for attr/attributes.h... no
checking for struct attrlist_cursor... no
./configure: line 14661: syntax error near unexpected token `libicu,'
./configure: line 14661: `       PKG_CHECK_MODULES(libicu, icu-i18n, have_libicu=yes, have_libicu=no)'
Makefile:115: recipe for target 'include/builddefs' failed
make: *** [include/builddefs] Error 2

% less -N configure
...
  14660 if test "$enable_libicu" = "yes" || test "$enable_libicu" = "probe"; then
  14661          PKG_CHECK_MODULES(libicu, icu-i18n, have_libicu=yes, have_libicu=no)
  14662 
  14663 
  14664 
  14665 
  14666 fi

Package versions:

% dpkg -l|grep icu
ii  icu-devtools                        52.1-8+deb8u7                      amd64        Development utilities for International Components for Unicode
ii  libicu-dev:amd64                    52.1-8+deb8u7                      amd64        Development files for International Components for Unicode
ii  libicu52:amd64                      52.1-8+deb8u7                      amd64        International Components for Unicode

% dpkg -l | grep -w m4
ii  m4                                  1.4.17-4                           amd64        macro processing language

% dpkg -l | grep libtool
ii  libltdl7:amd64                      2.4.2-1.11+b1                      amd64        System independent dlopen wrapper for GNU libtool
ii  libtool                             2.4.2-1.11                         all          Generic library support script

