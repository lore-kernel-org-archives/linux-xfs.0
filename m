Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 22:38:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6L5c4DW025905
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 22:38:16 -0700
Date: Fri, 21 Jul 2006 15:37:19 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: Problems cross compiling xfsprogs
Message-ID: <20060721153719.E1998769@wobbly.melbourne.sgi.com>
References: <20060720114406.0fdf557a@XEONBOX>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060720114406.0fdf557a@XEONBOX>; from jjones@2wire.com on Thu, Jul 20, 2006 at 11:44:06AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jackson Jones <jjones@2wire.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 20, 2006 at 11:44:06AM -0700, Jackson Jones wrote:
> xfs@oss.sgi.com, Nathan,
> 
> Hi, my name is Jackson Jones, I am working on an embedded linux project. We are
> using XFS for our filesystem. I am updating our toolchain to a 2.6.12 kernel
> (from a 2.4.25).
> 
> We were using xfsprogs-2.6.25 (which did fine against the 2.4.25 kernel. When
> compiling against the 2.6.12 kernel, I got the following error(the entire build
> log is attached)
>....
> fadvise.o: In function `fadvise_f':
> /home/jjones/depot/mp/exp-perf/output/mipsel/build/debug/xfsprogs/io/fadvise.c:122:
> undefined reference to `posix_fadvise64'

This sounds like you have an ancient libc... is that possible?

> I moved up to xfsprogs-2.7.11 and got (entire log is attached).
> -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64
> --tag=gcc -c bit.c libtool: compile: unable to infer tagged configuration
> libtool: compile: specify a tag with `--tag' gmake[2]: *** [bit.lo] Error 1
> make[1]: *** [default] Error 2 make[1]: Leaving directory

Urgh, I have no idea - libtool Just Works (TM) for me, so I
don't mess with it... if you need to pass more options in,
bounce us a patch implementing that I guess.

> Is there a version (of xfsprogs, which you recommend, or where in the build
> script should I insert the --tag=gcc option after the mode=compile? I am

Dunno.

> guessing the libtool is confused since our compiler is called
> mipsel-linux-gcc.

Did setting CC in the environment before running configure have
any effect?  (not sure, I've not done it, but maybe..)

cheers.

-- 
Nathan
