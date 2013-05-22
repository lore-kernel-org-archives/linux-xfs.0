Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF07F7CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:05:01 -0500 (CDT)
Message-ID: <519D4136.6080908@sgi.com>
Date: Wed, 22 May 2013 17:05:42 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: libhandle/Makefile - fix make install
References: <20130522205819.586978467@gulag1.americas.sgi.com>
	<519D3716.8080502@sandeen.net>
In-Reply-To: <519D3716.8080502@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 05/22/2013 04:22 PM, Eric Sandeen wrote:
> On 5/22/13 3:58 PM, rjohnston@sgi.com wrote:
>> In the default section of libhandle/Makefile, ltdepend prevented
>> libhandle.so from being installed properly so remove it.
>
> Can you explain how it prevented it?
>
> [sandeen@sandeen xfsprogs]$ grep ltdepend */Makefile
> libdisk/Makefile:default: ltdepend $(LTLIBRARY)
> libhandle/Makefile:default: ltdepend $(LTLIBRARY)
> libxcmd/Makefile:default: ltdepend $(LTLIBRARY)
> libxfs/Makefile:default: crc32selftest ltdepend $(LTLIBRARY)
> libxlog/Makefile:default: ltdepend $(LTLIBRARY)
>
> seems to exist in every subdir, why is this one causing trouble?
Because libhandle is the only one that is installed. ;)

make install
Installing include-install
gmake[1]: Nothing to be done for `install'.
Installing libxfs-install
gmake[1]: Nothing to be done for `install'.
Installing libxlog-install
gmake[1]: Nothing to be done for `install'.
Installing libxcmd-install
gmake[1]: Nothing to be done for `install'.
Installing libhandle-install
cd ../libhandle/.libs; ../../install-sh -o root -g root -m 755 -d 
/lib64; ../../install-sh -o root -g root -m 755 -T so_dot_version 
libhandle.lai /lib64; ../../install-sh -o root -g root -T so_dot_current 
libhandle.lai /lib64
Installing libdisk-install
gmake[1]: Nothing to be done for `install'.


make install-dev
Installing include-install-dev
../install-sh -o root -g root -m 755 -d /usr/include/xfs
../install-sh -o root -g root -m 644 handle.h jdm.h xqm.h xfs.h xfs_fs.h 
xfs_types.h linux.h /usr/include/xfs
../install-sh -o root -g root -m 644 platform_defs.h /usr/include/xfs
Installing libxfs-install-dev
gmake[1]: Nothing to be done for `install-dev'.
Installing libxlog-install-dev
gmake[1]: Nothing to be done for `install-dev'.
Installing libxcmd-install-dev
gmake[1]: Nothing to be done for `install-dev'.
Installing libhandle-install-dev
cd ../libhandle/.libs; ../../install-sh -o root -g root -m 755 -d 
/usr/lib64; ../../install-sh -o root -g root -m 644 -T old_lib 
libhandle.lai /usr/lib64; ../../install-sh -o root -g root -m 644 
libhandle.lai /usr/lib64/libhandle.la ; ../../install-sh -o root -g root 
-m 755 -d /lib64; ../../install-sh -o root -g root -T so_base 
libhandle.lai /lib64; if test "x/usr/lib64" != "x/lib64" ; then 
../../install-sh -o root -g root -S /usr/lib64/libhandle.a 
/lib64/libhandle.a; ../../install-sh -o root -g root -S 
/usr/lib64/libhandle.la /lib64/libhandle.la; ../../install-sh -o root -g 
root -S /lib64/libhandle.so /usr/lib64/libhandle.so; fi
Installing libdisk-install-dev
gmake[1]: Nothing to be done for `install-dev'.


[xfsprogs]$ grep -A 2 install lib*/Makefile
libdisk/Makefile:install: default
libdisk/Makefile-
libdisk/Makefile:install-dev: default
libdisk/Makefile-
libdisk/Makefile:install-qa: install-dev
libdisk/Makefile-
libdisk/Makefile--include .ltdep
--
libhandle/Makefile:install: default
libhandle/Makefile-	$(INSTALL_LTLIB)
libhandle/Makefile-
libhandle/Makefile:install-dev: default
libhandle/Makefile-	$(INSTALL_LTLIB_DEV)
libhandle/Makefile-
libhandle/Makefile:install-qa: install-dev
libhandle/Makefile-
libhandle/Makefile--include .ltdep
--
libxcmd/Makefile:install install-dev install-qa: default
libxcmd/Makefile-
libxcmd/Makefile--include .ltdep
--
libxfs/Makefile:install: default
libxfs/Makefile-
libxfs/Makefile:install-dev: default
libxfs/Makefile-
libxfs/Makefile:install-qa: default
libxfs/Makefile-
libxfs/Makefile--include .ltdep
--
libxlog/Makefile:install install-dev install-qa: default
libxlog/Makefile-
libxlog/Makefile--include .ltdep

I compared it to libdm/Makefile which removed it from the default: target.

default: $(LTLIBRARY)

include $(BUILDRULES)

install: default
	$(INSTALL_LTLIB)

install-dev: default
	$(INSTALL_LTLIB_DEV)


>
> /me goes off to dig around in makefiles
>
>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>> --
>> diff --git a/libhandle/Makefile b/libhandle/Makefile
>> index 865ca22..2f39173 100644
>> --- a/libhandle/Makefile
>> +++ b/libhandle/Makefile
>> @@ -15,7 +15,7 @@ LTLDFLAGS += -Wl,--version-script,libhandle.sym
>>   CFILES = handle.c jdm.c
>>   LSRCFILES = libhandle.sym
>>
>> -default: ltdepend $(LTLIBRARY)
>> +default: $(LTLIBRARY)
>>
>>   include $(BUILDRULES)
>>
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
