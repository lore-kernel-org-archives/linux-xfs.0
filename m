Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0671A7F60
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 18:28:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8CEC30404E
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 16:28:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GHjF9uJKTzbIGHpk for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 16:28:02 -0700 (PDT)
Date: Wed, 30 Jul 2014 09:27:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 00/10] xfs_ioc_bulkstat code refactoring and
	consolidation
Message-ID: <20140729232748.GI26465@dastard>
References: <538D92B6.5050402@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538D92B6.5050402@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jun 03, 2014 at 05:17:42PM +0800, Jeff Liu wrote:
> Hi folk,
> 
> This is the revised patches for xfs_ioc_bulkstat consolidation and code
> refactoring. As per Christoph's comments, I'm not include the per AG
> inumber patch in this series given that I don't actually introduce the
> relevant inumbers interface now. Similar to that reason, I also dropped
> the per AG bulkstat patch, it would be included in parallel quota check
> series.
> 
> 
> v3->v2:
> - one major bug fix is at xfs_bulkstat_ag_ichunk() regarding the user buffer
>   pointer operations, it should be defined as a pointer-to-pointer since it
>   would be updated inside xfs_bulkstat_ag_ichunk().
> 
> - separate xfs_inumber consolidate patch into two patches, the first one
>   fix the formater function return value and consolidate the codes, another
>   one does the actual logic changes for better error handling.
> 
> - Add a separate patch to get rid of the redundant user buffer count
>   checks at xfs_bulkstat()
> 
> - fixed agino calculation issue at xfs_bulkstat_grab_ichunk().
> 
> v2: http://oss.sgi.com/archives/xfs/2014-04/msg00554.html
> v1: http://oss.sgi.com/archives/xfs/2013-12/msg00901.html
> 
> 
> Any comments are welcome!

Hi Jeff, I ported this to the current dev tree based on the
xfs-libxfs-restructure branch, and I keep seeing fsstress failing
with memory corruption after random bulkstat ioctls. I see regular
failures with generic/013, generic/068, xfs/167 and the other
fstress tests also randomly fail. The typical failure is glibc
detected memory heap corruption on freeing the bulkstat structure
after the ioctl:

generic/068 42s ...*** Error in `./ltp/fsstress': double free or corruption (!prev): 0x00007f0224000b70 ***
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(+0x7aa26)[0x7f022bce3a26]
/lib/x86_64-linux-gnu/libc.so.6(+0x7b7a3)[0x7f022bce47a3]
./ltp/fsstress[0x40260e]
./ltp/fsstress[0x402db5]
./ltp/fsstress[0x402359]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f022bc8a995]
./ltp/fsstress[0x402477]
======= Memory map: ========
00400000-0040c000 r-xp 00000000 08:01 511772                             /home/dave/src/xfstests-dev/ltp/fsstress
0060c000-0060d000 rw-p 0000c000 08:01 511772                             /home/dave/src/xfstests-dev/ltp/fsstress
0060d000-0062e000 rw-p 00000000 00:00 0                                  [heap]
7f0224000000-7f0224021000 rw-p 00000000 00:00 0 
7f0224021000-7f0228000000 ---p 00000000 00:00 0 
7f022ba53000-7f022ba68000 r-xp 00000000 08:01 244777                     /lib/x86_64-linux-gnu/libgcc_s.so.1
7f022ba68000-7f022bc68000 ---p 00015000 08:01 244777                     /lib/x86_64-linux-gnu/libgcc_s.so.1
7f022bc68000-7f022bc69000 rw-p 00015000 08:01 244777                     /lib/x86_64-linux-gnu/libgcc_s.so.1
7f022bc69000-7f022be0b000 r-xp 00000000 08:01 245384                     /lib/x86_64-linux-gnu/libc-2.17.so
7f022be0b000-7f022c00b000 ---p 001a2000 08:01 245384                     /lib/x86_64-linux-gnu/libc-2.17.so
7f022c00b000-7f022c00f000 r--p 001a2000 08:01 245384                     /lib/x86_64-linux-gnu/libc-2.17.so
7f022c00f000-7f022c011000 rw-p 001a6000 08:01 245384                     /lib/x86_64-linux-gnu/libc-2.17.so
7f022c011000-7f022c015000 rw-p 00000000 00:00 0 
7f022c015000-7f022c02c000 r-xp 00000000 08:01 245380                     /lib/x86_64-linux-gnu/libpthread-2.17.so
7f022c02c000-7f022c22b000 ---p 00017000 08:01 245380                     /lib/x86_64-linux-gnu/libpthread-2.17.so
7f022c22b000-7f022c22c000 r--p 00016000 08:01 245380                     /lib/x86_64-linux-gnu/libpthread-2.17.so
7f022c22c000-7f022c22d000 rw-p 00017000 08:01 245380                     /lib/x86_64-linux-gnu/libpthread-2.17.so
7f022c22d000-7f022c231000 rw-p 00000000 00:00 0 
7f022c231000-7f022c232000 r-xp 00000000 08:01 325472                     /lib/x86_64-linux-gnu/libaio.so.1.0.1
7f022c232000-7f022c431000 ---p 00001000 08:01 325472                     /lib/x86_64-linux-gnu/libaio.so.1.0.1
7f022c431000-7f022c432000 r--p 00000000 08:01 325472                     /lib/x86_64-linux-gnu/libaio.so.1.0.1
7f022c432000-7f022c433000 rw-p 00001000 08:01 325472                     /lib/x86_64-linux-gnu/libaio.so.1.0.1
7f022c433000-7f022c437000 r-xp 00000000 08:01 324661                     /lib/x86_64-linux-gnu/libattr.so.1.1.0
7f022c437000-7f022c636000 ---p 00004000 08:01 324661                     /lib/x86_64-linux-gnu/libattr.so.1.1.0
7f022c636000-7f022c637000 r--p 00003000 08:01 324661                     /lib/x86_64-linux-gnu/libattr.so.1.1.0
7f022c637000-7f022c638000 rw-p 00004000 08:01 324661                     /lib/x86_64-linux-gnu/libattr.so.1.1.0
7f022c638000-7f022c659000 r-xp 00000000 08:01 245381                     /lib/x86_64-linux-gnu/ld-2.17.so
7f022c844000-7f022c848000 rw-p 00000000 00:00 0 
7f022c855000-7f022c856000 rw-p 00000000 00:00 0 
7f022c856000-7f022c859000 rw-p 00000000 00:00 0 
7f022c859000-7f022c85a000 r--p 00021000 08:01 245381                     /lib/x86_64-linux-gnu/ld-2.17.so
7f022c85a000-7f022c85c000 rw-p 00022000 08:01 245381                     /lib/x86_64-linux-gnu/ld-2.17.so
7fffd18b7000-7fffd18d8000 rw-p 00000000 00:00 0                          [stack]
7fffd19fc000-7fffd19fe000 r-xp 00000000 00:00 0                          [vdso]
7fffd19fe000-7fffd1a00000 r--p 00000000 00:00 0                          [vvar]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]


I haven't been able to track down the issue yet, so could you pass
an eye over my updated patchset and see if you can spot the mistake
I made?  The patchset is in the xfs-bulkstat-refactor-NEEDS-FIXING
branch in the xfsdev repo which I just pushed. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
