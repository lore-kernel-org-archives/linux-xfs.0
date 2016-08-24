Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32B477CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 20:19:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD7C4AC003
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 18:19:30 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mqrPytPoQHtI0yPp for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2016 18:19:27 -0700 (PDT)
Date: Wed, 24 Aug 2016 11:19:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
Message-ID: <20160824011911.GA19025@dastard>
References: <cover.1471107858.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 13, 2016 at 07:04:18PM +0200, Felix Janda wrote:
> This patch series does several things related to large file support.
> 
> Patches 1-3 enable transparent LFS in the build system and make it
> mandatory.
> 
> Patches 4-9 and 12 replace *64 function and structure aliases.
> 
> Patches 10 and 11 disable fsr on Mac OS X and do cleanup to enable
> Patch 12. Further cleanup of the portability code is possible later.
> 
> Patch 13 makes tranparent LFS also mandatory for all users of libxfs.
> 
> Patch 14 finally replaces off64_t by off_t.
> 
> 
> In comparison to v1:
> 
> Patches 1, 3 and 14 are identical to previous patches. Patches 4-8 are
> identical to previous patches, except that some of them are merged.
> Patch 9 was previously send separately from the patch series. Patch
> 13 is identical to a previous patch except for the commit message. The
> other patches are new, grown out of review by Christoph Hellwig.
> 
> Felix Janda (14):
>   configure: use AC_SYS_LARGEFILE
>   configure: error out when LFS does not work
>   remove unecessary definitions of _FILE_OFFSET_BITS
>   replace [fl]stat64 by equivalent [fl]stat
>   replace ftruncate64 by equivalent ftruncate
>   replace lseek64 by equivalent lseek
>   replace pread64/pwrite64 by equivalent pread/pwrite
>   replace sendfile64 by equivalent sendfile
>   fadvise.c: replace posix_fadvise64 by equivalent posix_fadvise
>   Makefile: disable fsr for Mac OS X
>   fsr: remove workaround for statvfs on Mac OS X
>   replace statvfs64 by equivalent statvfs
>   xfs.h: require transparent LFS for all users
>   platform: remove use of off64_t

So, the patches are fine, and everything works. Problem is, it
screws up xfstests because it changes all the error messages
that are output to stderr and captured by the test harness.
There are quite a few tests that this causes failures for,
and because it's stderr, it's not as simple as just adding a new
filter to do 'sed -e "s/^\(.*\)64\(: .*$\)/\1\2/"' on stderr.

Further, errors returned change, which further screws up xfstests.
e.g. old code gives EFBIG when we try to use offsets beyond the
supported range, this patchset returns EINVAL.  That further
complicates any sort of error filtering we'll need to do.

I don't have the time or patience to fix up xfstests for every
change that people want to make and this series is a non-critical
cleanup, so I'm dropping this until the fixups for xfstests are
worked out. I'm not going to get to this for weeks at the current
rate patches are being thrown at me for inclusion, so I'm not
breaking xfstests for everyone while I'm bottlenecked on other,
higher priority changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
