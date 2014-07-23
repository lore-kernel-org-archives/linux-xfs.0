Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6213D7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2014 09:02:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F5118F8035
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2014 07:02:17 -0700 (PDT)
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	by cuda.sgi.com with ESMTP id BAhwTrECrWWOKM51 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Jul 2014 07:02:11 -0700 (PDT)
Date: Wed, 23 Jul 2014 09:01:18 -0500
From: scameron@beardog.cce.hp.com
Subject: Re: Problem building xfsprogs
Message-ID: <20140723140118.GI14599@beardog.cce.hp.com>
References: <20140722160641.GU17967@beardog.cce.hp.com>
	<20140722205605.GJ20518@dastard>
	<20140722210951.GE14599@beardog.cce.hp.com>
	<20140722214727.GP4453@dastard>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20140722214727.GP4453@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: scameron@beardog.cce.hp.com, fstests@vger.kernel.org, xfs@oss.sgi.com


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 23, 2014 at 07:47:27AM +1000, Dave Chinner wrote:
> On Tue, Jul 22, 2014 at 04:09:51PM -0500, scameron@beardog.cce.hp.com wrote:
> > On Wed, Jul 23, 2014 at 06:56:05AM +1000, Dave Chinner wrote:
> > > Nothing built in the include directory - is this a clean build area?
> > 
> > Well, it was originally clean, but I did try the build several
> > times (not sure why I thought trying it again might help, but
> > in any case I suppose the subsequent attempts may not have been
> > considered clean.)
> > 
> > So, I just tried a fresh checkout with the same results:
> > 
> > [relliott@msablackburn ~]$ rm -fr xfsprogs
> > [relliott@msablackburn ~]$ git clone git://oss.sgi.com/xfs/cmds/xfsprogs
> > Initialized empty Git repository in /home/relliott/xfsprogs/.git/
> > remote: Counting objects: 14359, done.
> > remote: Compressing objects: 100% (5042/5042), done.
> > remote: Total 14359 (delta 11622), reused 11396 (delta 9306)
> > Receiving objects: 100% (14359/14359), 4.43 MiB | 1.34 MiB/s, done.
> > Resolving deltas: 100% (11622/11622), done.
> > [relliott@msablackburn ~]$ cd xfsprogs
> > [relliott@msablackburn xfsprogs]$ make
> ....
> > checking for gmake... /usr/bin/gmake
> > checking for tar... /bin/tar
> > checking for gzip... /bin/gzip
> > checking whether gcc -MM is supported... yes
> 
> So, the $MAKEDEP variable should be fine....
> 
> > [relliott@msablackburn xfsprogs]$ make realclean; make Q=
> ...
> > aclocal -I m4
> > autoconf
> > ./configure $LOCAL_CONFIGURE_OPTIONS
> > checking build system type... x86_64-unknown-linux-gnu
> > checking host system type... x86_64-unknown-linux-gnu
> > checking for gcc... gcc
> > checking for C compiler default output file name... a.out
> > checking whether the C compiler works... yes
> > checking whether we are cross compiling... no
> > checking for suffix of executables... 
> > checking for suffix of object files... o
> > checking whether we are using the GNU C compiler... yes
> > checking whether gcc accepts -g... yes
> > checking for gcc option to accept ISO C89... none needed
> > checking for a sed that does not truncate output... /bin/sed
> > checking for grep that handles long lines and -e... /bin/grep
> > checking for egrep... /bin/grep -E
> > checking for fgrep... /bin/grep -F
> > checking for ld used by gcc... /usr/bin/ld
> > checking if the linker (/usr/bin/ld) is GNU ld... yes
> > checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
> > checking the name lister (/usr/bin/nm -B) interface... BSD nm
> > checking whether ln -s works... yes
> > checking the maximum length of command line arguments... 1572864
> > checking whether the shell understands some XSI constructs... yes
> > checking whether the shell understands "+="... yes
> > checking for /usr/bin/ld option to reload object files... -r
> > checking for objdump... objdump
> > checking how to recognize dependent libraries... pass_all
> > checking for ar... ar
> > checking for strip... strip
> > checking for ranlib... ranlib
> > checking command to parse /usr/bin/nm -B output from gcc object... ok
> > checking how to run the C preprocessor... gcc -E
> > checking for ANSI C header files... yes
> > checking for sys/types.h... yes
> > checking for sys/stat.h... yes
> > checking for stdlib.h... yes
> > checking for string.h... yes
> > checking for memory.h... yes
> > checking for strings.h... yes
> > checking for inttypes.h... yes
> > checking for stdint.h... yes
> > checking for unistd.h... yes
> > checking for dlfcn.h... yes
> > checking for objdir... .libs
> > checking if gcc supports -fno-rtti -fno-exceptions... no
> > checking for gcc option to produce PIC... -fPIC -DPIC
> > checking if gcc PIC flag -fPIC -DPIC works... yes
> > checking if gcc static flag -static works... no
> > checking if gcc supports -c -o file.o... yes
> > checking if gcc supports -c -o file.o... (cached) yes
> > checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
> > checking whether -lc should be explicitly linked in... no
> > checking dynamic linker characteristics... GNU/Linux ld.so
> > checking how to hardcode library paths into programs... immediate
> > checking whether stripping libraries is possible... yes
> > checking if libtool supports shared libraries... yes
> > checking whether to build shared libraries... yes
> > checking whether to build static libraries... yes
> > checking for gcc... (cached) gcc
> > checking whether we are using the GNU C compiler... (cached) yes
> > checking whether gcc accepts -g... (cached) yes
> > checking for gcc option to accept ISO C89... (cached) none needed
> > checking for gcc... (cached) gcc
> > checking whether we are using the GNU C compiler... (cached) yes
> > checking whether gcc accepts -g... (cached) yes
> > checking for gcc option to accept ISO C89... (cached) none needed
> > checking for gmake... /usr/bin/gmake
> > checking for tar... /bin/tar
> > checking for gzip... /bin/gzip
> > checking whether gcc -MM is supported... yes
> > checking for awk... /bin/awk
> > checking for sort... /bin/sort
> > checking whether ln -s works... yes
> > checking for msgfmt... /usr/bin/msgfmt
> > checking for msgmerge... /usr/bin/msgmerge
> > checking for xgettext... /usr/bin/xgettext
> > checking for rpm... /bin/rpm
> > checking for rpmbuild... /usr/bin/rpmbuild
> > checking aio.h usability... yes
> > checking aio.h presence... yes
> > checking for aio.h... yes
> > checking for lio_listio... no
> > checking for lio_listio in -lrt... yes
> > checking uuid.h usability... yes
> > checking uuid.h presence... yes
> > checking for uuid.h... yes
> > checking sys/uuid.h usability... no
> > checking sys/uuid.h presence... no
> > checking for sys/uuid.h... no
> > checking uuid/uuid.h usability... yes
> > checking uuid/uuid.h presence... yes
> > checking for uuid/uuid.h... yes
> > checking for uuid_compare... no
> > checking for uuid_compare in -luuid... yes
> > checking pthread.h usability... yes
> > checking pthread.h presence... yes
> > checking for pthread.h... yes
> > checking for pthread_mutex_init in -lpthread... yes
> > checking for fadvise ... yes
> > checking for madvise ... yes
> > checking for mincore ... yes
> > checking for sendfile ... yes
> > checking for getmntent ... yes
> > checking for getmntinfo ... no
> > checking for fallocate... yes
> > checking for fiemap... yes
> > checking for preadv... yes
> > checking for sync_file_range... yes
> > checking for library containing blkid_probe_all... -lblkid
> > checking for blkid_probe_get_topology... yes
> > checking for readdir... yes
> > checking size of long... 8
> > checking size of char *... 8
> > checking for __psint_t ... no
> > checking for __psunsigned_t ... no
> > checking for __u32 ... yes
> > checking for umode_t... yes
> > configure: creating ./config.status
> > config.status: creating include/builddefs
> > config.status: creating include/platform_defs.h
> > config.status: executing libtool commands
> > make --no-print-directory Q= -C . default
> > /usr/bin/gmake --no-print-directory Q= include libxfs libxlog libxcmd libhandle libdisk copy db estimate fsck fsr growfs io logprint mkfs quota mdrestore repair rtcp m4 man doc po debian
> > Building include
> > /usr/bin/gmake --no-print-directory Q= -q -C include || /usr/bin/gmake --no-print-directory Q= -C include
> >     [LN]     xfs
> > ln -s . xfs
> >     [LN]     disk
> > ln -s . disk
> > Building libxfs
> > /usr/bin/gmake --no-print-directory Q= -q -C libxfs || /usr/bin/gmake --no-print-directory Q= -C libxfs
> >     [CC]     gen_crc32table
> > gcc -g -O2 -I. -g -O2 -DNDEBUG -DVERSION=\"3.2.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT   -o gen_crc32table gen_crc32table.c
> >     [GENERATE] crc32table.h
> > ./gen_crc32table > crc32table.h
> 
> But it's not running the dependency generation rule here, which is
> what generates the .ltdep file.
> 
> Can you please attach the built include/builddefs and
> include/platform_defs.h files that autoconf built?

Attached.

> 
> Also, what version of autoconf are you running?

[relliott@msablackburn include]$ autoconf --version
autoconf (GNU Autoconf) 2.63
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv2+: GNU GPL version 2 or later
<http://gnu.org/licenses/old-licenses/gpl-2.0.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by David J. MacKenzie and Akim Demaille.
[relliott@msablackburn include]$ 

-- steve


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=builddefs
Content-Transfer-Encoding: quoted-printable

#
# Copyright (c) 2004-2006 Silicon Graphics, Inc.
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# include/builddefs.  Generated from builddefs.in by configure.
#

ifndef _BUILDDEFS_INCLUDED_
_BUILDDEFS_INCLUDED_ =3D 1

DEBUG =3D -DDEBUG
OPTIMIZER =3D -g -O2
MALLOCLIB =3D=20
LOADERFLAGS =3D=20
LTLDFLAGS =3D=20
CFLAGS =3D -g -O2

LIBRT =3D -lrt
LIBUUID =3D -luuid
LIBPTHREAD =3D -lpthread
LIBTERMCAP =3D=20
LIBEDITLINE =3D=20
LIBREADLINE =3D=20
LIBBLKID =3D -lblkid
LIBXFS =3D $(TOPDIR)/libxfs/libxfs.la
LIBXCMD =3D $(TOPDIR)/libxcmd/libxcmd.la
LIBXLOG =3D $(TOPDIR)/libxlog/libxlog.la
LIBDISK =3D $(TOPDIR)/libdisk/libdisk.la
LIBHANDLE =3D $(TOPDIR)/libhandle/libhandle.la

PKG_NAME	=3D xfsprogs
PKG_USER	=3D relliott
PKG_GROUP	=3D relliott
PKG_RELEASE	=3D 1
PKG_VERSION	=3D 3.2.1
PKG_PLATFORM	=3D srcv
PKG_DISTRIBUTION=3D Linux

prefix		=3D /usr
exec_prefix	=3D ${prefix}
datarootdir	=3D ${prefix}/share
top_builddir	=3D ..

PKG_SBIN_DIR	=3D ${exec_prefix}/sbin
PKG_ROOT_SBIN_DIR =3D /sbin
PKG_ROOT_LIB_DIR=3D /lib64
PKG_LIB_DIR	=3D ${exec_prefix}/lib64
PKG_INC_DIR	=3D ${prefix}/include/xfs
DK_INC_DIR	=3D ${prefix}/include/disk
PKG_MAN_DIR	=3D ${datarootdir}/man
PKG_DOC_DIR	=3D ${datarootdir}/doc/xfsprogs
PKG_LOCALE_DIR	=3D ${datarootdir}/locale

CC		=3D gcc
AWK		=3D /bin/awk
SED		=3D /bin/sed
TAR		=3D /bin/tar
ZIP		=3D /bin/gzip
MAKE		=3D /usr/bin/gmake
ECHO		=3D echo
SORT		=3D /bin/sort
LN_S		=3D ln -s
SHELL		=3D /bin/sh
LIBTOOL		=3D $(SHELL) $(top_builddir)/libtool
MAKEDEPEND	=3D gcc -MM

MSGFMT		=3D /usr/bin/msgfmt
MSGMERGE	=3D /usr/bin/msgmerge
XGETTEXT	=3D /usr/bin/xgettext
LOCALIZED_FILES	=3D  $(TOPDIR)/./copy/xfs_copy.c $(TOPDIR)/./repair/dir2.c =
$(TOPDIR)/./repair/incore.c $(TOPDIR)/./repair/phase7.c $(TOPDIR)/./repair/=
threads.c $(TOPDIR)/./repair/phase6.c $(TOPDIR)/./repair/xfs_repair.c $(TOP=
DIR)/./repair/avl64.c $(TOPDIR)/./repair/incore_bmc.c $(TOPDIR)/./repair/at=
tr_repair.c $(TOPDIR)/./repair/agheader.c $(TOPDIR)/./repair/progress.c $(T=
OPDIR)/./repair/phase2.c $(TOPDIR)/./repair/btree.c $(TOPDIR)/./repair/dino=
de.c $(TOPDIR)/./repair/globals.c $(TOPDIR)/./repair/phase4.c $(TOPDIR)/./r=
epair/incore_ino.c $(TOPDIR)/./repair/incore_ext.c $(TOPDIR)/./repair/phase=
3.c $(TOPDIR)/./repair/dino_chunks.c $(TOPDIR)/./repair/phase1.c $(TOPDIR)/=
./repair/prefetch.c $(TOPDIR)/./repair/sb.c $(TOPDIR)/./repair/init.c $(TOP=
DIR)/./repair/versions.c $(TOPDIR)/./repair/rt.c $(TOPDIR)/./repair/avl.c $=
(TOPDIR)/./repair/phase5.c $(TOPDIR)/./repair/scan.c $(TOPDIR)/./repair/bma=
p.c $(TOPDIR)/./rtcp/xfs_rtcp.c $(TOPDIR)/./libxlog/xfs_log_recover.c $(TOP=
DIR)/./libxlog/util.c $(TOPDIR)/./logprint/log_print_trans.c $(TOPDIR)/./lo=
gprint/log_copy.c $(TOPDIR)/./logprint/logprint.c $(TOPDIR)/./logprint/log_=
dump.c $(TOPDIR)/./logprint/log_print_all.c $(TOPDIR)/./logprint/log_misc.c=
 $(TOPDIR)/./libxfs/xfs_inode_fork.c $(TOPDIR)/./libxfs/gen_crc32table.c $(=
TOPDIR)/./libxfs/xfs_attr_leaf.c $(TOPDIR)/./libxfs/xfs_da_btree.c $(TOPDIR=
)/./libxfs/xfs_dir2.c $(TOPDIR)/./libxfs/trans.c $(TOPDIR)/./libxfs/xfs_sb.=
c $(TOPDIR)/./libxfs/xfs_dir2_data.c $(TOPDIR)/./libxfs/xfs_ialloc_btree.c =
$(TOPDIR)/./libxfs/xfs_ialloc.c $(TOPDIR)/./libxfs/xfs_inode_buf.c $(TOPDIR=
)/./libxfs/xfs_symlink_remote.c $(TOPDIR)/./libxfs/xfs_bmap.c $(TOPDIR)/./l=
ibxfs/xfs_btree.c $(TOPDIR)/./libxfs/xfs_log_rlimit.c $(TOPDIR)/./libxfs/xf=
s_rtbitmap.c $(TOPDIR)/./libxfs/xfs_alloc_btree.c $(TOPDIR)/./libxfs/xfs_di=
r2_block.c $(TOPDIR)/./libxfs/xfs_bmap_btree.c $(TOPDIR)/./libxfs/xfs_dir2_=
node.c $(TOPDIR)/./libxfs/darwin.c $(TOPDIR)/./libxfs/xfs_dir2_sf.c $(TOPDI=
R)/./libxfs/util.c $(TOPDIR)/./libxfs/radix-tree.c $(TOPDIR)/./libxfs/logit=
em.c $(TOPDIR)/./libxfs/linux.c $(TOPDIR)/./libxfs/freebsd.c $(TOPDIR)/./li=
bxfs/xfs_alloc.c $(TOPDIR)/./libxfs/xfs_dir2_leaf.c $(TOPDIR)/./libxfs/xfs_=
dquot_buf.c $(TOPDIR)/./libxfs/xfs_attr.c $(TOPDIR)/./libxfs/init.c $(TOPDI=
R)/./libxfs/xfs_trans_resv.c $(TOPDIR)/./libxfs/crc32.c $(TOPDIR)/./libxfs/=
kmem.c $(TOPDIR)/./libxfs/rdwr.c $(TOPDIR)/./libxfs/xfs_attr_remote.c $(TOP=
DIR)/./libxfs/irix.c $(TOPDIR)/./libxfs/cache.c $(TOPDIR)/./growfs/xfs_grow=
fs.c $(TOPDIR)/./libhandle/jdm.c $(TOPDIR)/./libhandle/handle.c $(TOPDIR)/.=
/libxcmd/help.c $(TOPDIR)/./libxcmd/input.c $(TOPDIR)/./libxcmd/paths.c $(T=
OPDIR)/./libxcmd/quit.c $(TOPDIR)/./libxcmd/command.c $(TOPDIR)/./libxcmd/p=
rojects.c $(TOPDIR)/./estimate/xfs_estimate.c $(TOPDIR)/./libdisk/xvm.c $(T=
OPDIR)/./libdisk/fstype.c $(TOPDIR)/./libdisk/evms.c $(TOPDIR)/./libdisk/pt=
type.c $(TOPDIR)/./libdisk/md.c $(TOPDIR)/./libdisk/drivers.c $(TOPDIR)/./l=
ibdisk/lvm.c $(TOPDIR)/./libdisk/dm.c $(TOPDIR)/./db/help.c $(TOPDIR)/./db/=
symlink.c $(TOPDIR)/./db/dir2.c $(TOPDIR)/./db/field.c $(TOPDIR)/./db/type.=
c $(TOPDIR)/./db/debug.c $(TOPDIR)/./db/sig.c $(TOPDIR)/./db/convert.c $(TO=
PDIR)/./db/text.c $(TOPDIR)/./db/check.c $(TOPDIR)/./db/strvec.c $(TOPDIR)/=
./db/flist.c $(TOPDIR)/./db/input.c $(TOPDIR)/./db/io.c $(TOPDIR)/./db/btbl=
ock.c $(TOPDIR)/./db/attrset.c $(TOPDIR)/./db/agi.c $(TOPDIR)/./db/fprint.c=
 $(TOPDIR)/./db/dquot.c $(TOPDIR)/./db/attrshort.c $(TOPDIR)/./db/bmroot.c =
$(TOPDIR)/./db/output.c $(TOPDIR)/./db/inode.c $(TOPDIR)/./db/quit.c $(TOPD=
IR)/./db/agf.c $(TOPDIR)/./db/hash.c $(TOPDIR)/./db/echo.c $(TOPDIR)/./db/a=
gfl.c $(TOPDIR)/./db/write.c $(TOPDIR)/./db/command.c $(TOPDIR)/./db/print.=
c $(TOPDIR)/./db/freesp.c $(TOPDIR)/./db/block.c $(TOPDIR)/./db/sb.c $(TOPD=
IR)/./db/init.c $(TOPDIR)/./db/metadump.c $(TOPDIR)/./db/malloc.c $(TOPDIR)=
/./db/bit.c $(TOPDIR)/./db/addr.c $(TOPDIR)/./db/frag.c $(TOPDIR)/./db/attr=
.c $(TOPDIR)/./db/bmap.c $(TOPDIR)/./db/dir2sf.c $(TOPDIR)/./db/faddr.c $(T=
OPDIR)/./mdrestore/xfs_mdrestore.c $(TOPDIR)/./quota/free.c $(TOPDIR)/./quo=
ta/quot.c $(TOPDIR)/./quota/quota.c $(TOPDIR)/./quota/state.c $(TOPDIR)/./q=
uota/edit.c $(TOPDIR)/./quota/darwin.c $(TOPDIR)/./quota/util.c $(TOPDIR)/.=
/quota/project.c $(TOPDIR)/./quota/path.c $(TOPDIR)/./quota/linux.c $(TOPDI=
R)/./quota/report.c $(TOPDIR)/./quota/freebsd.c $(TOPDIR)/./quota/init.c $(=
TOPDIR)/./quota/irix.c $(TOPDIR)/./mkfs/maxtrres.c $(TOPDIR)/./mkfs/xfs_mkf=
s.c $(TOPDIR)/./mkfs/fstyp.c $(TOPDIR)/./mkfs/proto.c $(TOPDIR)/./io/parent=
.c $(TOPDIR)/./io/seek.c $(TOPDIR)/./io/file.c $(TOPDIR)/./io/madvise.c $(T=
OPDIR)/./io/resblks.c $(TOPDIR)/./io/freeze.c $(TOPDIR)/./io/fsync.c $(TOPD=
IR)/./io/mmap.c $(TOPDIR)/./io/fadvise.c $(TOPDIR)/./io/prealloc.c $(TOPDIR=
)/./io/inject.c $(TOPDIR)/./io/fiemap.c $(TOPDIR)/./io/sendfile.c $(TOPDIR)=
/./io/pwrite.c $(TOPDIR)/./io/link.c $(TOPDIR)/./io/getrusage.c $(TOPDIR)/.=
/io/sync_file_range.c $(TOPDIR)/./io/pread.c $(TOPDIR)/./io/readdir.c $(TOP=
DIR)/./io/shutdown.c $(TOPDIR)/./io/mincore.c $(TOPDIR)/./io/open.c $(TOPDI=
R)/./io/init.c $(TOPDIR)/./io/imap.c $(TOPDIR)/./io/truncate.c $(TOPDIR)/./=
io/attr.c $(TOPDIR)/./io/bmap.c $(TOPDIR)/./fsr/xfs_fsr.c

RPM		=3D /bin/rpm
RPMBUILD	=3D /usr/bin/rpmbuild
RPM_VERSION	=3D 4

ENABLE_SHARED	=3D yes
ENABLE_GETTEXT	=3D yes
ENABLE_EDITLINE	=3D no
ENABLE_READLINE	=3D no
ENABLE_BLKID	=3D yes

HAVE_ZIPPED_MANPAGES =3D false

HAVE_FADVISE =3D yes
HAVE_MADVISE =3D yes
HAVE_MINCORE =3D yes
HAVE_SENDFILE =3D yes
HAVE_GETMNTENT =3D yes
HAVE_GETMNTINFO =3D=20
HAVE_FALLOCATE =3D yes
HAVE_FIEMAP =3D yes
HAVE_PREADV =3D yes
HAVE_SYNC_FILE_RANGE =3D yes
HAVE_READDIR =3D yes

GCCFLAGS =3D -funsigned-char -fno-strict-aliasing -Wall=20
#	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl

ifeq ($(PKG_PLATFORM),linux)
PCFLAGS =3D -D_GNU_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=3D500 -D_FILE_OFFSE=
T_BITS=3D64 $(GCCFLAGS)
ifeq ($(HAVE_UMODE_T),yes)
PCFLAGS +=3D -DHAVE_UMODE_T
endif
DEPENDFLAGS =3D -D__linux__
endif
ifeq ($(PKG_PLATFORM),gnukfreebsd)
PCFLAGS =3D -D_GNU_SOURCE $(GCCFLAGS)
endif
ifeq ($(PKG_PLATFORM),darwin)
PCFLAGS =3D -traditional-cpp $(GCCFLAGS)
DEPENDFLAGS =3D -D__APPLE__
endif
ifeq ($(PKG_PLATFORM),irix)
PLDLIBS =3D -ldisk -lgen
DEPENDFLAGS =3D -D__sgi__
endif
ifeq ($(PKG_PLATFORM),freebsd)
PLDLIBS =3D -L/usr/local/lib -lintl
PCFLAGS =3D -I/usr/local/include $(GCCFLAGS)
DEPENDFLAGS =3D -D__FreeBSD__
endif

GCFLAGS =3D $(OPTIMIZER) $(DEBUG) \
	  -DVERSION=3D\"$(PKG_VERSION)\" -DLOCALEDIR=3D\"$(PKG_LOCALE_DIR)\"  \
	  -DPACKAGE=3D\"$(PKG_NAME)\" -I$(TOPDIR)/include

ifeq ($(ENABLE_GETTEXT),yes)
GCFLAGS +=3D -DENABLE_GETTEXT
endif

# First, Global, Platform, Local CFLAGS
CFLAGS +=3D $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)

include $(TOPDIR)/include/buildmacros

endif

#
# For targets that should always be rebuilt,
# define a target that is never up-to-date.
# Targets needing this should depend on $(_FORCE)
_FORCE =3D __force_build

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="platform_defs.h"

/* include/platform_defs.h.  Generated from platform_defs.h.in by configure.  */
/*
 * Copyright (c) 2000-2005 Silicon Graphics, Inc.
 * All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it would be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write the Free Software Foundation,
 * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * @configure_input@
 */
#ifndef __XFS_PLATFORM_DEFS_H__
#define __XFS_PLATFORM_DEFS_H__

#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <assert.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <pthread.h>
#include <ctype.h>
#include <sys/types.h>
#include <limits.h>
#include <stdbool.h>

#define HAVE___U32 1
#ifdef HAVE___U32
#include <asm/types.h>
#else
typedef unsigned char		__u8;
typedef signed char		__s8;
typedef unsigned short		__u16;
typedef signed short		__s16;
typedef unsigned int		__u32;
typedef signed int		__s32;
typedef unsigned long long int	__u64;
typedef signed long long int	__s64;
#endif

#ifdef __CHECKER__
#define __bitwise		__attribute__((bitwise))
#define __force			__attribute__((force))
#else
#define __bitwise
#define __force
#endif

typedef __u16	__bitwise	__le16;
typedef __u32	__bitwise	__le32;
typedef __u64	__bitwise	__le64;

typedef __u16	__bitwise	__be16;
typedef __u32	__bitwise	__be32;
typedef __u64	__bitwise	__be64;

typedef struct filldir		filldir_t;

#if defined(__linux__)
#include <xfs/linux.h>
#elif defined(__FreeBSD__)
#include <xfs/freebsd.h>
#elif defined(__FreeBSD_kernel__)
#include <xfs/gnukfreebsd.h>
#elif defined(__APPLE__)
#include <xfs/darwin.h>
#elif defined(__sgi__) || defined(__sgi)
#include <xfs/irix.h>
#else
# error unknown platform... have fun porting!
#endif

/* long and pointer must be either 32 bit or 64 bit */
#define SIZEOF_LONG 8
#define SIZEOF_CHAR_P 8
#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)

/* Check if __psint_t is set to something meaningful */
/* #undef HAVE___PSINT_T */
#ifndef HAVE___PSINT_T
# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
typedef int __psint_t;
# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
#  if BITS_PER_LONG == 64
typedef long __psint_t;
#  else
/* This is a very strange architecture, which has 64 bit pointers but */
/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
typedef long long __psint_t;
#  endif
# else
#  error Unknown pointer size
# endif
#endif

/* Check if __psunsigned_t is set to something meaningful */
/* #undef HAVE___PSUNSIGNED_T */
#ifndef HAVE___PSUNSIGNED_T
# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
typedef unsigned int __psunsigned_t;
# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
#  if BITS_PER_LONG == 64
typedef long __psunsigned_t;
#  else
/* This is a very strange architecture, which has 64 bit pointers but */
/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
typedef unsigned long long __psunsigned_t;
#  endif
# else
#  error Unknown pointer size
# endif
#endif

/* Check whether to define umode_t ourselves. */
#ifndef HAVE_UMODE_T
typedef unsigned short umode_t;
#endif

/* Define if you want gettext (I18N) support */
/* #undef ENABLE_GETTEXT */
#ifdef ENABLE_GETTEXT
# include <libintl.h>
# define _(x)                   gettext(x)
# define N_(x)			 x
#else
# define _(x)                   (x)
# define N_(x)			 x
# define textdomain(d)          do { } while (0)
# define bindtextdomain(d,dir)  do { } while (0)
#endif
#include <locale.h>

#ifdef DEBUG
# define ASSERT(EX)	assert(EX)
#else
# define ASSERT(EX)	((void) 0)
#endif

/*
 * sparse kernel source annotations
 */
#ifndef __user
#define __user
#endif

#define IRIX_DEV_BITSMAJOR      14
#define IRIX_DEV_BITSMINOR      18
#define IRIX_DEV_MAXMAJ         0x1ff
#define IRIX_DEV_MAXMIN         0x3ffff
#define IRIX_DEV_MAJOR(dev)	((int)(((unsigned)(dev) >> IRIX_DEV_BITSMINOR) \
					& IRIX_DEV_MAXMAJ))
#define IRIX_DEV_MINOR(dev)	((int)((dev) & IRIX_DEV_MAXMIN))
#define IRIX_MKDEV(major,minor)	((xfs_dev_t)(((major) << IRIX_DEV_BITSMINOR) \
					| (minor&IRIX_DEV_MAXMIN)))
#define IRIX_DEV_TO_KDEVT(dev)	makedev(IRIX_DEV_MAJOR(dev),IRIX_DEV_MINOR(dev))

/* ARM old ABI has some weird alignment/padding */
#if defined(__arm__) && !defined(__ARM_EABI__)
#define __arch_pack __attribute__((packed))
#else
#define __arch_pack
#endif

#ifndef min
#define min(a,b)	(((a)<(b))?(a):(b))
#define max(a,b)	(((a)>(b))?(a):(b))
#endif

#endif	/* __XFS_PLATFORM_DEFS_H__ */

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--zhXaljGHf11kAtnf--
