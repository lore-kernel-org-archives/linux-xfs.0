Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f182.google.com ([209.85.208.182]:45842 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732964AbeHADp3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 23:45:29 -0400
Received: by mail-lj1-f182.google.com with SMTP id w16-v6so11841494ljh.12
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 19:02:19 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 31 Jul 2018 20:02:17 -0600
Message-ID: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
Subject: xfsprogs 4.17.0 error building xfs_repair
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

Hi,
I'm doing this on Fedora 28, I'm including the entire output from
exporting environment variables from doc/INSTALL so it's kinda long...

[chris@f28s xfsprogs-dev]$ git reset --hard origin/master
HEAD is now at 0821de47 xfsprogs: Release v4.17.0

[chris@f28s xfsprogs-dev]$ export TAR=3D/usr/bin/tar
[chris@f28s xfsprogs-dev]$ export LIBTOOL=3D/usr/bin/libtool
[chris@f28s xfsprogs-dev]$ export INSTALL_GROUP=3Dwheel
[chris@f28s xfsprogs-dev]$ export
LOCAL_CONFIGURE_OPTIONS=3D"--enable-gettext=3Dno --enable-blkid=3Dno
--enable-librt=3Dno"
[chris@f28s xfsprogs-dev]$ make
libtoolize -c `libtoolize -n -i >/dev/null 2>/dev/null && echo -i` -f
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, '.'.
libtoolize: copying file './config.guess'
libtoolize: copying file './config.sub'
libtoolize: copying file './install-sh'
libtoolize: copying file './ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'm4'.
libtoolize: copying file 'm4/libtool.m4'
libtoolize: copying file 'm4/ltoptions.m4'
libtoolize: copying file 'm4/ltsugar.m4'
libtoolize: copying file 'm4/ltversion.m4'
libtoolize: copying file 'm4/lt~obsolete.m4'
libtoolize: Consider adding '-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
cp include/install-sh .
aclocal -I m4
autoconf
./configure $LOCAL_CONFIGURE_OPTIONS
configure: loading site script /usr/share/config.site
checking for a BSD-compatible install... /usr/bin/install -c
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
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
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking how to convert x86_64-pc-linux-gnu file names to
x86_64-pc-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-pc-linux-gnu file names to toolchain
format... func_convert_file_noop
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
checking for a working dd... /usr/bin/dd
checking how to truncate binary pipes... /usr/bin/dd bs=3D4096 count=3D1
checking for mt... no
checking if : is a manifest tool... no
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
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports
shared libraries... yes
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
checking for gmake... /usr/bin/gmake
checking for gzip... /usr/bin/gzip
checking whether gcc -MM is supported... yes
checking for sort... /bin/sort
checking whether ln -s works... yes
checking for rpm... /usr/bin/rpm
checking for rpmbuild... no
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
checking for pwritev2... yes
checking for preadv... yes
checking for copy_file_range... yes
checking for sync_file_range... yes
checking for syncfs... yes
checking mntent.h usability... yes
checking mntent.h presence... yes
checking for mntent.h... yes
checking whether fls is declared... no
checking for readdir... yes
checking whether fsetxattr is declared... no
checking whether mremap is declared... yes
checking for struct fsxattr... yes
checking for struct fsxattr.fsx_cowextsize... yes
checking for GETFSMAP... yes
checking for struct statfs... yes
checking for struct statfs.f_flags... yes
checking for MAP_SYNC... yes
checking for library containing dm_task_create... no
checking for mallinfo ... yes
checking attr/attributes.h usability... no
checking attr/attributes.h presence... no
checking for attr/attributes.h... no
checking for struct attrlist_cursor... no
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for libicu... no
checking whether openat is declared... yes
checking whether fstatat is declared... yes
checking for struct sg_io_hdr ... yes
checking for struct hd_geometry ... yes
checking for systemd... yes
checking for systemd system unit dir... /usr/lib/systemd/system
checking for system crontab dir... /etc/cron.d
checking if C compiler supports LTO... yes
checking for gcc-ar... /usr/bin/gcc-ar
checking for gcc-ranlib... /usr/bin/gcc-ranlib
checking if C compiler supports retpoline... yes
checking size of long... 8
checking size of char *... 8
checking for umode_t... no
configure: creating ./config.status
config.status: creating include/builddefs
config.status: creating include/platform_defs.h
config.status: executing libtool commands
   [HEADERS] include
   [HEADERS] libxfs
Building include
    [LN]     disk
Building libfrog
    [CC]     avl64.lo
    [CC]     convert.lo
    [CC]     fsgeom.lo
    [CC]     list_sort.lo
    [CC]     paths.lo
    [CC]     projects.lo
    [CC]     ptvar.lo
    [CC]     radix-tree.lo
    [CC]     topology.lo
topology.c:273:4: warning: #warning BLKID is disabled, so signature
detection and block device access are not working! [-Wcpp]
 #  warning BLKID is disabled, so signature detection and block device\
    ^~~~~~~
    [CC]     util.lo
    [CC]     workqueue.lo
    [CC]     linux.lo
    [LD]     libfrog.la
Building libxfs
    [CC]     gen_crc32table
    [GENERATE] crc32table.h
    [TEST]    CRC32
CRC_LE_BITS =3D 64
crc32: tests passed, 225944 bytes in 565 usec
crc32c: tests passed, 225944 bytes in 156 usec
    [CC]     cache.lo
    [CC]     crc32.lo
    [CC]     defer_item.lo
    [CC]     init.lo
    [CC]     kmem.lo
    [CC]     logitem.lo
    [CC]     rdwr.lo
    [CC]     trans.lo
    [CC]     util.lo
    [CC]     xfs_ag_resv.lo
    [CC]     xfs_alloc.lo
    [CC]     xfs_alloc_btree.lo
    [CC]     xfs_attr.lo
    [CC]     xfs_attr_leaf.lo
    [CC]     xfs_attr_remote.lo
    [CC]     xfs_bit.lo
    [CC]     xfs_bmap.lo
    [CC]     xfs_bmap_btree.lo
    [CC]     xfs_btree.lo
    [CC]     xfs_da_btree.lo
    [CC]     xfs_da_format.lo
    [CC]     xfs_defer.lo
    [CC]     xfs_dir2.lo
    [CC]     xfs_dir2_block.lo
    [CC]     xfs_dir2_data.lo
    [CC]     xfs_dir2_leaf.lo
    [CC]     xfs_dir2_node.lo
    [CC]     xfs_dir2_sf.lo
    [CC]     xfs_dquot_buf.lo
    [CC]     xfs_ialloc.lo
    [CC]     xfs_iext_tree.lo
    [CC]     xfs_inode_buf.lo
    [CC]     xfs_inode_fork.lo
    [CC]     xfs_ialloc_btree.lo
    [CC]     xfs_log_rlimit.lo
    [CC]     xfs_refcount.lo
    [CC]     xfs_refcount_btree.lo
    [CC]     xfs_rmap.lo
    [CC]     xfs_rmap_btree.lo
    [CC]     xfs_rtbitmap.lo
    [CC]     xfs_sb.lo
    [CC]     xfs_symlink_remote.lo
    [CC]     xfs_trans_resv.lo
    [LD]     libxfs.la
Building libxlog
    [CC]     xfs_log_recover.lo
    [CC]     util.lo
    [LD]     libxlog.la
Building libxcmd
    [CC]     command.lo
    [CC]     input.lo
    [CC]     help.lo
    [CC]     quit.lo
    [LD]     libxcmd.la
Building libhandle
    [CC]     handle.lo
    [CC]     jdm.lo
    [LD]     libhandle.la
Building copy
    [CC]     xfs_copy.o
    [LD]     xfs_copy
Building db
    [CC]     addr.o
    [CC]     agf.o
    [CC]     agfl.o
    [CC]     agi.o
    [CC]     attr.o
    [CC]     attrshort.o
    [CC]     bit.o
    [CC]     block.o
    [CC]     bmap.o
    [CC]     btblock.o
    [CC]     bmroot.o
    [CC]     check.o
    [CC]     command.o
    [CC]     convert.o
    [CC]     crc.o
    [CC]     debug.o
    [CC]     dir2.o
    [CC]     dir2sf.o
    [CC]     dquot.o
    [CC]     echo.o
    [CC]     faddr.o
    [CC]     field.o
    [CC]     flist.o
    [CC]     fprint.o
    [CC]     frag.o
    [CC]     freesp.o
    [CC]     hash.o
    [CC]     help.o
    [CC]     init.o
    [CC]     inode.o
    [CC]     input.o
    [CC]     io.o
    [CC]     logformat.o
    [CC]     malloc.o
    [CC]     metadump.o
    [CC]     output.o
    [CC]     print.o
    [CC]     quit.o
    [CC]     sb.o
    [CC]     sig.o
    [CC]     strvec.o
    [CC]     text.o
    [CC]     type.o
    [CC]     write.o
    [CC]     attrset.o
    [CC]     symlink.o
    [CC]     fsmap.o
    [CC]     fuzz.o
    [CC]     btdump.o
    [CC]     info.o
    [LD]     xfs_db
Building estimate
    [CC]     xfs_estimate.o
    [LD]     xfs_estimate
Building fsck
Building growfs
    [CC]     xfs_growfs.o
    [LD]     xfs_growfs
Building io
    [CC]     init.o
    [CC]     attr.o
    [CC]     bmap.o
    [CC]     cowextsize.o
    [CC]     encrypt.o
    [CC]     file.o
    [CC]     freeze.o
    [CC]     fsync.o
    [CC]     getrusage.o
    [CC]     imap.o
    [CC]     label.o
label.c: In function =E2=80=98label_f=E2=80=99:
label.c:71:4: warning: =E2=80=98strncpy=E2=80=99 specified bound 256 equals
destination size [-Wstringop-truncation]
    strncpy(label, optarg, sizeof(label));
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [CC]     link.o
    [CC]     mmap.o
    [CC]     open.o
    [CC]     parent.o
    [CC]     pread.o
    [CC]     prealloc.o
    [CC]     pwrite.o
    [CC]     reflink.o
    [CC]     scrub.o
    [CC]     seek.o
    [CC]     shutdown.o
    [CC]     stat.o
    [CC]     swapext.o
    [CC]     sync.o
    [CC]     truncate.o
    [CC]     utimes.o
    [CC]     fadvise.o
    [CC]     madvise.o
    [CC]     mincore.o
    [CC]     sendfile.o
    [CC]     fiemap.o
    [CC]     inject.o
    [CC]     resblks.o
    [CC]     copy_file_range.o
    [CC]     sync_file_range.o
    [CC]     readdir.o
    [CC]     fsmap.o
    [LD]     xfs_io
Building logprint
    [CC]     logprint.o
    [CC]     log_copy.o
    [CC]     log_dump.o
    [CC]     log_misc.o
    [CC]     log_print_all.o
    [CC]     log_print_trans.o
    [CC]     log_redo.o
    [LD]     xfs_logprint
Building mkfs
    [CC]     proto.o
    [CC]     xfs_mkfs.o
In function =E2=80=98finish_superblock_setup=E2=80=99,
    inlined from =E2=80=98main=E2=80=99 at xfs_mkfs.c:3937:2:
xfs_mkfs.c:3188:3: warning: =E2=80=98strncpy=E2=80=99 specified bound 12 eq=
uals
destination size [-Wstringop-truncation]
   strncpy(sbp->sb_fname, cfg->label, sizeof(sbp->sb_fname));
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [LD]     mkfs.xfs
Building quota
    [CC]     init.o
    [CC]     util.o
    [CC]     edit.o
edit.c: In function =E2=80=98restore_file=E2=80=99:
edit.c:392:10: warning: =E2=80=98strncpy=E2=80=99 specified bound 512 equal=
s
destination size [-Wstringop-truncation]
    dev =3D strncpy(devbuffer, buffer+5, sizeof(devbuffer));
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [CC]     free.o
    [CC]     path.o
    [CC]     project.o
    [CC]     quot.o
    [CC]     quota.o
    [CC]     report.o
    [CC]     state.o
    [CC]     linux.o
    [LD]     xfs_quota
Building mdrestore
    [CC]     xfs_mdrestore.o
    [LD]     xfs_mdrestore
Building repair
    [CC]     agheader.o
    [CC]     attr_repair.o
    [CC]     avl.o
    [CC]     bmap.o
    [CC]     btree.o
    [CC]     da_util.o
    [CC]     dino_chunks.o
    [CC]     dinode.o
    [CC]     dir2.o
    [CC]     globals.o
    [CC]     incore.o
    [CC]     incore_bmc.o
    [CC]     init.o
    [CC]     incore_ext.o
    [CC]     incore_ino.o
    [CC]     phase1.o
    [CC]     phase2.o
    [CC]     phase3.o
    [CC]     phase4.o
    [CC]     phase5.o
    [CC]     phase6.o
    [CC]     phase7.o
    [CC]     progress.o
    [CC]     prefetch.o
    [CC]     rmap.o
    [CC]     rt.o
    [CC]     sb.o
    [CC]     scan.o
    [CC]     slab.o
    [CC]     threads.o
    [CC]     versions.o
    [CC]     xfs_repair.o
    [LD]     xfs_repair
/tmp/cc95QLol.ltrans8.ltrans.o: In function `progress_rpt_thread.lto_priv.3=
52':
<artificial>:(.text+0xa2c9): undefined reference to `timer_create'
<artificial>:(.text+0xa2e4): undefined reference to `timer_settime'
<artificial>:(.text+0xa570): undefined reference to `timer_delete'
collect2: error: ld returned 1 exit status
gmake[3]: *** [../include/buildrules:46: xfs_repair] Error 1
gmake[2]: *** [include/buildrules:36: repair] Error 2
make[1]: *** [Makefile:77: default] Error 2
make: *** [Makefile:74: default] Error 2
[chris@f28s xfsprogs-dev]$


--=20
Chris Murphy
