Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CCD047F3F
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 15:56:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EC9530406A
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 13:56:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	E71G1hVo2oGfoGO4 for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 13:56:08 -0700 (PDT)
Date: Wed, 23 Jul 2014 06:56:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem building xfsprogs
Message-ID: <20140722205605.GJ20518@dastard>
References: <20140722160641.GU17967@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140722160641.GU17967@beardog.cce.hp.com>
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
To: scameron@beardog.cce.hp.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

[cc xfs@oss.sgi.com - list for XFS issues]

On Tue, Jul 22, 2014 at 11:06:41AM -0500, scameron@beardog.cce.hp.com wrote:
> 
> I'm trying to build xfsprogs (in order to run xfstests), and I'm running into this:
> 
> [scameron@localhost xfsprogs]$ git log --oneline | head -1
> ba24eb7 logprint: Fix printing of AGF and AGI buffers
> [scameron@localhost xfsprogs]$ git pull
> Already up-to-date.
> [scameron@localhost xfsprogs]$ git diff
> [scameron@localhost xfsprogs]$ ./configure
> checking build system type... x86_64-unknown-linux-gnu
> checking host system type... x86_64-unknown-linux-gnu
> checking for gcc... gcc
> checking for C compiler default output file name... a.out
> 
> [...snip...]
> 
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
> config.status: include/platform_defs.h is unchanged
> config.status: executing libtool commands
> [scameron@localhost xfsprogs]$ make
> Building include

Nothing built in the include directory - is this a clean build area?

> Building libxfs
> gmake[2]: *** No rule to make target `.ltdep', needed by `ltdepend'.  Stop.
> gmake[1]: *** [libxfs] Error 2
> make: *** [default] Error 2
> 
> Any ideas what's wrong here?

The automatic dependency generation failed to generate the .ltdep
file. But it can't be a clean build area, because the libxfs build
rule is:

default: crc32selftest ltdepend $(LTLIBRARY)

and I don't see the crc32selftest rule being executed before the
dependencies are generated. It shoul dlook something like:

$ make
....
configure: creating ./config.status
config.status: creating include/builddefs
config.status: creating include/platform_defs.h
config.status: executing libtool commands
Building include
    [LN]     xfs
    [LN]     disk
Building libxfs
    [CC]     gen_crc32table
    [GENERATE] crc32table.h
    [TEST]    CRC32
CRC_LE_BITS = 32
crc32: tests passed, 225944 bytes in 131 usec
crc32c: tests passed, 225944 bytes in 131 usec
    [CC]     cache.lo
....

So the first thing I'd do is run 'make realclean; make' to restart
the build for a clean workarea first. If that doesn't fix the
problem, then I'll need to know versions of libtool, gcc, etc that
you are using and you'll need to post the output of "make realclean;
make Q=" so we can see the command line that is actually failing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
