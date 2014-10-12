Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 236DA7F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 01:58:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1028530405F
	for <xfs@oss.sgi.com>; Sat, 11 Oct 2014 23:58:07 -0700 (PDT)
Received: from mailuogwhop.emc.com (mailuogwhop.emc.com [168.159.213.141]) by
	cuda.sgi.com with ESMTP id pfaE92t2pn3SCzew (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 11 Oct 2014 23:58:03 -0700 (PDT)
Received: from maildlpprd01.lss.emc.com (maildlpprd01.lss.emc.com
	[10.253.24.33])
	by mailuogwprd01.lss.emc.com (Sentrion-MTA-4.3.0/Sentrion-MTA-4.3.0)
	with ESMTP id s9C6w10c025688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 02:58:02 -0400
Received: from mailusrhubprd03.lss.emc.com (mailusrhubprd03.lss.emc.com
	[10.253.24.21]) by maildlpprd01.lss.emc.com (RSA Interceptor)
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 02:57:36 -0400
Received: from mxhub13.corp.emc.com (mxhub13.corp.emc.com [128.222.70.234])
	by mailusrhubprd03.lss.emc.com (Sentrion-MTA-4.3.0/Sentrion-MTA-4.3.0)
	with ESMTP id s9C6vpgU004347
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 02:57:51 -0400
From: "Kaul, Yaniv" <Yaniv.Kaul@emc.com>
Date: Sun, 12 Oct 2014 02:58:50 -0400
Subject: Can't build RPM of xfstests
Message-ID: <648473255763364B961A02AC3BE1060D03C7940C13@MX19A.corp.emc.com>
Content-Language: en-US
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I'm getting the sources from https://kernel.googlesource.com/pub/scm/fs/xfs/xfstests-dev (as I can't use git directly, only over HTTP(s) due to company policy)
I'm trying to compile the RPM on either CentOS 6.5 or 7, both fail identically. Log snippets:

== dist, log is Logs/dist
make: Entering directory `/var/jenkins/workspace/xfstests-build/build'
/bin/tar: xfstests-1.1.1/m4/general_headers.m4: Cannot stat: No such file or directory
/bin/tar: Exiting with failure status due to previous errors
Wrote: /var/jenkins/workspace/xfstests-build/build/xfstests-1.1.1.src.tar.gz
=== install ===
gmake[1]: Entering directory `/var/jenkins/workspace/xfstests-build'
Building include
Building lib
Building ltp
Building src
Building aio-dio-regress
Building m4
Building common
Building tests
/usr/bin/gmake --no-print-directory Q=@ -C include install
...
gmake[1]: Leaving directory `/var/jenkins/workspace/xfstests-build'
=== tar ===
Wrote: /var/jenkins/workspace/xfstests-build/build/tar/xfstests-1.1.1.tar.gz
=== rpm ===
/bin/sed -e's|@pkg_name@|xfstests|g' \
	    -e's|@pkg_version@|1.1.1|g' \
	    -e's|@pkg_release@|1|g' \
	    -e's|@pkg_distribution@|Linux|g' \
	    -e's|@build_root@|/tmp/34943|g' \
	    -e'/^BuildRoot: *$/d' \
	    -e's|@make@|/usr/bin/gmake|g' < xfstests.spec.in > xfstests.spec
/usr/bin/rpmbuild -ba --rcfile ./rpm-4.rc xfstests.spec
error: File /root/rpmbuild/SOURCES/xfstests-1.1.1.src.tar.gz: No such file or directory
gmake[1]: *** [dist] Error 1




OK, I manually copy the file over, and then try again:
usr/bin/gmake --no-print-directory Q= default
/usr/bin/gmake --no-print-directory Q= include lib ltp src m4 common tests
Building include
/usr/bin/gmake --no-print-directory Q= -q -C include || /usr/bin/gmake --no-print-directory Q= -C include
Building lib
/usr/bin/gmake --no-print-directory Q= -q -C lib || /usr/bin/gmake --no-print-directory Q= -C lib
    [LTDEP]
if [ -n "$( echo dataascii.c databin.c datapid.c file_lock.c forker.c pattern.c open_flags.c random_range.c string_to_tokens.c str_to_bytes.c tlibio.c write_log.c random.c)" ]; then \
	    gcc -MM -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.1\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall  dataascii.c databin.c datapid.c file_lock.c forker.c pattern.c open_flags.c random_range.c string_to_tokens.c str_to_bytes.c tlibio.c write_log.c random.c | \
	    /bin/sed -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep; \
	else \
	    cp /dev/null .ltdep; \
	fi
file_lock.c:28:23: error: file_lock.h: No such file or directory
forker.c:104:20: error: forker.h: No such file or directory
open_flags.c:91:24: error: open_flags.h: No such file or directory
str_to_bytes.c:20:26: error: str_to_bytes.h: No such file or directory
    [CC] dataascii.lo
/usr/bin/libtool --quiet --tag=CC --mode=compile gcc -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.1\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall   -c dataascii.c
    [CC] databin.lo
/usr/bin/libtool --quiet --tag=CC --mode=compile gcc -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.1\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall   -c databin.c
    [CC] datapid.lo
/usr/bin/libtool --quiet --tag=CC --mode=compile gcc -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.1\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall   -c datapid.c
    [CC] file_lock.lo
/usr/bin/libtool --quiet --tag=CC --mode=compile gcc -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.1\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall   -c file_lock.c
file_lock.c:28:23: error: file_lock.h: No such file or directory
gmake[5]: *** [file_lock.lo] Error 1
gmake[4]: *** [lib] Error 2
gmake[3]: *** [default] Error 2
gmake[2]: *** [default] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.MrYMY7 (%build)




My job is simple:
yum -y install libuuid-devel xfsprogs xfsprogs-qa-devel xfsprogs-devel libattr-devel libacl-devel gcc autoconf libtool libaio-devel openssl-devel rpm-build e2fsprogs-devel
mkdir -p /var/lib/xfstests/ltp /var/lib/xfstests/src
make realclean
./Makepkgs verbose rpm

Any ideas?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
