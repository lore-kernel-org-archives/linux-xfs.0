Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 14:47:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FLldbm032633
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 14:47:41 -0700
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id 9FB0D40195B9
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 17:47:42 -0400 (EDT)
Date: Sun, 15 Jul 2007 17:47:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Fwd: Re: xfs_fsr and null byte areas in files (fwd)
Message-ID: <Pine.LNX.4.64.0707151747390.21990@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com



---------- Forwarded message ----------
Date: Sun, 15 Jul 2007 23:39:18 +0200
From: Martin Steigerwald <Martin@lichtvoll.de>
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Fwd: Re: xfs_fsr and null byte areas in files


Hi Dave!

Here is the info about my build problems, that have not gone to the list
yet. Maybe there has been work on it while I was trying. I will try on
another day again.

Just to let you know that I tried building xfsqa in order to reproduce
that strange file data corruption that happened here.

Ciao,
Martin


----------  Weitergeleitete Nachricht  ----------

Subject: Fwd: Re: xfs_fsr and null byte areas in files
Date: Sonntag 15 Juli 2007
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>


Hi Justin,

here is mail one of those who didn't get through to the list for whatever
reason. My postfix claims delivery and I did not yet a delivery failure
report back. I tried this one at least three times.

Could you please forward it, if it doesn't appear till tomorrow?

----------  Weitergeleitete Nachricht  ----------

Subject: Re: xfs_fsr and null byte areas in files
Date: Sonntag 15 Juli 2007
From: Martin Steigerwald <Martin@lichtvoll.de>
To: xfs@oss.sgi.com


Okay, trying once again. This time just with xfs@oss.sgi.com (no CC, no
nothing) as according to my test mail that seems to work best.

Well maybe my build problem is already fixed. I will try on another day.

Am Dienstag 10 Juli 2007 schrieb David Chinner:
> On Mon, Jul 09, 2007 at 11:13:48PM +0200, Martin Steigerwald wrote:

>> 1) Is there an XFS qa test available for xfs_fsr? If so I could use
>> that one. Are there some hints on how to get started on XFS qa?
>
> Yes, test 042. Download it from CVS, build it (installing all the
> bits it asks for ;), edit common.config to add your test and scratch

Hi,

Do I need both partitions for test 42? On the notebook I have only one
free partition and since it is a primary partition and all primary
partitions are used up, I cannot split it.

I can try with an external USB harddrive and hope that this test setup is
similar enough to the situation that yielded my xfs_fsr problems.

> partitions (both volatile) and the 'check -l 042' to run test 042.

In order to test xfs_fsr on my laptop I tried compiling XFS qa, but I get
a compiler error in dmapi. I do not know what dmapi is, well I read
something about "Data Management API runtime environment" on google and
thought I may not need it to run test 42. But I do not find any option
in "./configure" to disable buildin it.

I am using:

---------------------------------------------------------------------
shambala:~#1> apt-show-versions | grep xfs
xfsprogs/sid uptodate 2.9.0-1
xfslibs-dev/sid uptodate 2.9.0-1
xfsdump/sid uptodate 2.2.45-1
---------------------------------------------------------------------

Do I need more recent versions (from CVS eventually)?

These are the compiler errors I get:

---------------------------------------------------------------------
martin@shambala:Quelltext/xfs-cmds/xfstests#2> LANG=C make
=== include ===
make[1]: Nothing to be done for `default'.
=== lib ===
make[1]: Nothing to be done for `default'.
=== ltp ===
make[1]: Nothing to be done for `default'.
=== src ===
make[1]: Nothing to be done for `default'.
=== m4 ===
make[1]: Nothing to be done for `default'.
=== dmapi ===
Making all in src
Making all in common
Making all in lib
if /bin/sh ../../../libtool --mode=compile --tag=CC
gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE=\"dmapi_tests\" -DVERSION=\"1.1\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -I. -I.   -I../../../src/common  -g -O2 -MT
find_session.lo -MD -MP -MF ".deps/find_session.Tpo" -c -o
find_session.lo find_session.c; \
         then mv -f ".deps/find_session.Tpo" ".deps/find_session.Plo"; else
rm -f ".deps/find_session.Tpo"; exit 1; fi

gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE=\"dmapi_tests\" -DVERSION=\"1.1\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -I. -I. -I../../../src/common -g -O2 -MT
find_session.lo -MD -MP -MF .deps/find_session.Tpo -c
find_session.c  -fPIC -DPIC -o .libs/find_session.o
In file included from ../../../src/common/lib/hsm.h:35,
                  from find_session.c:19:
../../../src/common/lib/dmport.h:315:19: error: dmapi.h: No such file or
directory
In file included from ../../../src/common/lib/hsm.h:35,
                  from find_session.c:19:
../../../src/common/lib/dmport.h:339: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:347: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:357: error: expected ')' before 'oldsid'
../../../src/common/lib/dmport.h:363: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:370: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:374: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:387: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:395: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:406: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:419: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:433: error: expected declaration
specifiers or '...' before 'dm_config_t'
../../../src/common/lib/dmport.h:434: error: expected declaration
specifiers or '...' before 'dm_size_t'
../../../src/common/lib/dmport.h:441: error: expected declaration
specifiers or '...' before 'dm_eventset_t'
../../../src/common/lib/dmport.h:446: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:458: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:469: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:479: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:488: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:497: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:507: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:517: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:524: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:534: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:545: error: expected declaration
specifiers or '...' before 'dm_sessid_t'
../../../src/common/lib/dmport.h:550: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:573: error: expected '=', ',', ';', 'asm'
or '__attribute__' before 'dm_handle_is_valid'
../../../src/common/lib/dmport.h:588: error: expected declaration
specifiers or '...' before 'dm_fsid_t'
../../../src/common/lib/dmport.h:594: error: expected declaration
specifiers or '...' before 'dm_igen_t'
../../../src/common/lib/dmport.h:600: error: expected declaration
specifiers or '...' before 'dm_ino_t'
../../../src/common/lib/dmport.h:614: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:626: error: expected ')' before '*' token
../../../src/common/lib/dmport.h:632: error: expected ')' before '*' token
../../../src/common/lib/dmport.h:640: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:650: error: expected ')' before 'srcsid'
../../../src/common/lib/dmport.h:657: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:664: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:671: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:690: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:696: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:707: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:716: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:724: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:730: error: expected '=', ',', ';', 'asm'
or '__attribute__' before 'dm_read_invis'
../../../src/common/lib/dmport.h:741: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:748: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:757: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:766: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:775: error: expected ')'
before 'targetsid'
../../../src/common/lib/dmport.h:782: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:791: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:802: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:811: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:820: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:829: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:839: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:848: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:859: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:866: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:872: error: expected '=', ',', ';', 'asm'
or '__attribute__' before 'dm_write_invis'
In file included from find_session.c:19:
../../../src/common/lib/hsm.h:68: error: expected specifier-qualifier-list
before 'dm_eventtype_t'
../../../src/common/lib/hsm.h:77: error: expected specifier-qualifier-list
before 'dm_right_t'
../../../src/common/lib/hsm.h:87: error: expected declaration specifiers
or '...' before 'dm_off_t'
../../../src/common/lib/hsm.h:90: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:91: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:93: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:95: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:98: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:106: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:110: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:123: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:128: error: expected ')' before 'emask'
../../../src/common/lib/hsm.h:134: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:137: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:140: error: expected '=', ',', ';', 'asm'
or '__attribute__' before 'ev_name_to_value'
../../../src/common/lib/hsm.h:145: error: expected ')' before 'event'
../../../src/common/lib/hsm.h:150: error: expected declaration specifiers
or '...' before 'dm_right_t'
../../../src/common/lib/hsm.h:154: error: expected ')' before 'right'
find_session.c: In function 'session_compare':
find_session.c:60: error: 'dm_sessid_t' undeclared (first use in this
function)
find_session.c:60: error: (Each undeclared identifier is reported only
once
find_session.c:60: error: for each function it appears in.)
find_session.c:60: error: expected expression before ')' token
find_session.c:60: error: expected expression before ')' token
find_session.c: At top level:
find_session.c:65: error: expected ')' before '*' token
make[4]: *** [find_session.lo] Error 1
make[3]: *** [all-recursive] Error 1
make[2]: *** [all-recursive] Error 1
make[1]: *** [all-recursive] Error 1
make: *** [default] Error 2
---------------------------------------------------------------------

I used

---------------------------------------------------------------------
export CVSROOT=':pserver:cvs@oss.sgi.com:/cvs'
cvs checkout xfs-cmds
---------------------------------------------------------------------

to get xfsqa, then changed to the "xfs-cmds/xfs-tests" directory and
typed "make".

I tried "cvs up" and got some new files. Is someone working there atm? If
so I better try later.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

-------------------------------------------------------

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

-------------------------------------------------------

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
