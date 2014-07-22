Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45D2B7F47
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 16:50:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 322A9304039
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 14:50:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7O6Vlq0GcBRIxM7Z for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 14:50:56 -0700 (PDT)
Message-ID: <53CEDCC0.1030907@sandeen.net>
Date: Tue, 22 Jul 2014 16:50:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problem building xfsprogs
References: <20140722160641.GU17967@beardog.cce.hp.com>	<20140722205605.GJ20518@dastard>
	<20140722210951.GE14599@beardog.cce.hp.com>
In-Reply-To: <20140722210951.GE14599@beardog.cce.hp.com>
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
To: scameron@beardog.cce.hp.com, Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

So you're on rhel6... I build xfstests there all the time, weird.

On 7/22/14, 4:09 PM, scameron@beardog.cce.hp.com wrote:
...

> checking if gcc supports -fno-rtti -fno-exceptions... no
> checking for gcc option to produce PIC... -fPIC -DPIC
> checking if gcc PIC flag -fPIC -DPIC works... yes
> checking if gcc static flag -static works... no

I get "yes" here - why wouldn't -static work?

> checking if gcc supports -c -o file.o... yes
> checking if gcc supports -c -o file.o... (cached) yes
> checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
> checking whether -lc should be explicitly linked in... no
> checking dynamic linker characteristics... GNU/Linux ld.so
> checking how to hardcode library paths into programs... immediate
> checking whether stripping libraries is possible... yes
> checking if libtool supports shared libraries... yes
> checking whether to build shared libraries... yes
> checking whether to build static libraries... yes
> checking for gcc... (cached) gcc
> checking whether we are using the GNU C compiler... (cached) yes
> checking whether gcc accepts -g... (cached) yes
> checking for gcc option to accept ISO C89... (cached) none needed
> checking for gcc... (cached) gcc
> checking whether we are using the GNU C compiler... (cached) yes
> checking whether gcc accepts -g... (cached) yes
> checking for gcc option to accept ISO C89... (cached) none needed
> checking for gmake... /usr/bin/gmake
> checking for tar... /bin/tar
> checking for gzip... /bin/gzip
> checking whether gcc -MM is supported... yes
> checking for awk... /bin/awk
> checking for sort... /bin/sort
> checking whether ln -s works... yes
> checking for msgfmt... /usr/bin/msgfmt
> checking for msgmerge... /usr/bin/msgmerge
> checking for xgettext... /usr/bin/xgettext
> checking for rpm... /bin/rpm
> checking for rpmbuild... /usr/bin/rpmbuild
> checking aio.h usability... yes
> checking aio.h presence... yes
> checking for aio.h... yes
> checking for lio_listio... no
> checking for lio_listio in -lrt... yes
> checking uuid.h usability... yes
> checking uuid.h presence... yes
> checking for uuid.h... yes

and here I get

+checking uuid.h usability... no
+checking uuid.h presence... no
+checking for uuid.h... no

> checking sys/uuid.h usability... no
> checking sys/uuid.h presence... no
> checking for sys/uuid.h... no
> checking uuid/uuid.h usability... yes
> checking uuid/uuid.h presence... yes
> checking for uuid/uuid.h... yes
> checking for uuid_compare... no
> checking for uuid_compare in -luuid... yes
> checking pthread.h usability... yes
> checking pthread.h presence... yes
> checking for pthread.h... yes
> checking for pthread_mutex_init in -lpthread... yes
> checking for fadvise ... yes
> checking for madvise ... yes
> checking for mincore ... yes
> checking for sendfile ... yes
> checking for getmntent ... yes
> checking for getmntinfo ... no
> checking for fallocate... yes
> checking for fiemap... yes
> checking for preadv... yes
> checking for sync_file_range... yes
> checking for library containing blkid_probe_all... -lblkid
> checking for blkid_probe_get_topology... yes
> checking for readdir... yes
> checking size of long... 8
> checking size of char *... 8
> checking for __psint_t ... no
> checking for __psunsigned_t ... no
> checking for __u32 ... yes
> checking for umode_t... yes
> configure: creating ./config.status
> config.status: creating include/builddefs
> config.status: creating include/platform_defs.h
> config.status: executing libtool commands
> make --no-print-directory Q= -C . default
> /usr/bin/gmake --no-print-directory Q= include libxfs libxlog libxcmd libhandle libdisk copy db estimate fsck fsr growfs io logprint mkfs quota mdrestore repair rtcp m4 man doc po debian
> Building include
> /usr/bin/gmake --no-print-directory Q= -q -C include || /usr/bin/gmake --no-print-directory Q= -C include
>     [LN]     xfs
> ln -s . xfs
>     [LN]     disk
> ln -s . disk
> Building libxfs
> /usr/bin/gmake --no-print-directory Q= -q -C libxfs || /usr/bin/gmake --no-print-directory Q= -C libxfs
>     [CC]     gen_crc32table
> gcc -g -O2 -I. -g -O2 -DNDEBUG -DVERSION=\"3.2.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT   -o gen_crc32table gen_crc32table.c
>     [GENERATE] crc32table.h

mine is building w/ some different flags:

+gcc -g -O2 -I. -g -O2 -DNDEBUG -DVERSION=\"3.2.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET
_BITS=64 -funsigned-char -fno-strict-aliasing -Wall   -o gen_crc32table gen_crc32table.c

those flags should have been picked up from include/builddefs -

ifeq ($(PKG_PLATFORM),linux)
PCFLAGS = -D_GNU_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
...

GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall

> ./gen_crc32table > crc32table.h
>     [TEST]    CRC32
> gcc -g -O2 -I. -g -O2 -DNDEBUG -DVERSION=\"3.2.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT   -D CRC32_SELFTEST=1 crc32.c -o crc32selftest
> ./crc32selftest
> CRC_LE_BITS = 32
> crc32: tests passed, 225944 bytes in 166 usec
> crc32c: tests passed, 225944 bytes in 173 usec
> gmake[3]: *** No rule to make target `.ltdep', needed by `ltdepend'.  Stop.
> gmake[2]: *** [libxfs] Error 2
> make[1]: *** [default] Error 2
> make: *** [default] Error 2
> [relliott@msablackburn xfsprogs]$ 

and I get past here just fine.  :(

TBH, the quickest path may be to grab xfsprogs.src.rpm from Rawhide
http://kojipkgs.fedoraproject.org/packages/xfsprogs/3.2.1/1.fc20/src/xfsprogs-3.2.1-1.fc20.src.rpm
rpmbuild --rebuild that, and install the 3 packages it creates.  That should get you over the xfsprogs hump.

But it'd be nice to know why your build fails, still...

-Eric

> Thanks.
> 
> -- steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
