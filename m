Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 18:09:59 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1J29q3g021121
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 18:09:56 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68167E5B2AD
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 18:10:17 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id W8ovRZHqna7HhcR1 for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 18:10:17 -0800 (PST)
Date: Tue, 19 Feb 2008 03:10:19 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080219014619.GY155407@sgi.com>
Message-ID: <Pine.LNX.4.63.0802190301110.20408@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
 <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk>
 <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk> <20080219002059.GX155407@sgi.com>
 <Pine.LNX.4.63.0802190209490.20408@alienAngel.home.sk> <20080219014619.GY155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 19 Feb 2008, David Chinner wrote:

> I did not use a patched mkfs - just my patch that does correction.
> I think I need to test this on an x86_64 box and see if i can
> reproduce it locally because it's not obviously operator error
> or clearly an 32/64bit problem...

Ok. 
Will you have possibility to test it in near future or should I rather
recreate my FS's with lazy-count=0 to keep the data safe?

Maybe this information can be useful. Kernel and userspace tools were
compiled with:
# gcc -v
Using built-in specs.
Target: x86_64-suse-linux
Configured with: ../configure --enable-threads=posix --prefix=/usr
--with-local-prefix=/usr/local --infodir=/usr/share/info
--mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.2.1
--enable-ssp --disable-libssp --disable-libgcj --with-slibdir=/lib64
--with-system-zlib --enable-shared --enable-__cxa_atexit
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch
--program-suffix=-4.2 --enable-version-specific-runtime-libs
--without-system-libunwind --with-cpu=generic --host=x86_64-suse-linux
Thread model: posix
gcc version 4.2.1 (SUSE Linux)

Cheers,
 
jan


-- 
