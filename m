Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54D6A7F59
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 18:48:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 465DC304043
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 16:48:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gfU8AazsgOeOMUqY for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 16:48:41 -0700 (PDT)
Date: Tue, 28 Apr 2015 09:48:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: log record crc mismatch test
Message-ID: <20150427234839.GU21261@dastard>
References: <553E5505.4070804@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <553E5505.4070804@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 27, 2015 at 06:25:57PM +0300, Alexander Tsvetkov wrote:
> Added new test case for simulation of V5 filesystem
> log crc record corruption using of external log.
> 
> Signed-off-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>

Hi Alexander,

In future, can you please post xfstests patches to
fstests@vger.kernel.org? I've cc'd that list on my reply.

> ---
>  tests/xfs/005     | 28 ++++++++++++++++++++++++++--
>  tests/xfs/005.out |  3 +++
>  2 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/005 b/tests/xfs/005
> index fade4bb..ba0dcbb 100755
> --- a/tests/xfs/005
> +++ b/tests/xfs/005
> @@ -1,7 +1,7 @@
>  #! /bin/bash
>  # FS QA Test No. 005
>  #
> -# Test that a bad crc on a primary V5 superblock will fail the mount
> +# Test that a bad crc on a V5 filesystem will fail the mount
>  #
>  # 10e6e65 xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
>  # inadvertently caused primary SB CRC failures to not error out, this
> @@ -55,10 +55,12 @@ _supported_os Linux
> 
>  _require_scratch_nocheck
>  _require_xfs_mkfs_crc
> +_require_logdev
> +logsize=2560

As eric pointed out, this fundamentally changes the context of the
test, and so should be written as a new test rather than a change to
an existing test.

Also, you don't need an external log device to do this - you can use
xfs_db to zero parts of the internal log just fine.

$ sudo mkfs.xfs -f -m crc=1,finobt=1 /dev/ram0
meta-data=/dev/ram0              isize=512    agcount=4, agsize=250000 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1
data     =                       bsize=4096   blocks=1000000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo xfs_db -x /dev/ram0
xfs_db> sb 0
xfs_db> p logstart
logstart = 524296
xfs_db> a logstart
xfs_db> type data
xfs_db> write fill 0xa5a5a5a5 0 4096
xfs_db> p
000: a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5
020: a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5
.....
fe0: a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5 a5a5a5a5
xfs_db> q
$ sudo mount /dev/ram0 /mnt/test
[346491.179086] XFS (ram0): Mounting V5 Filesystem
[346491.180844] XFS (ram0): Log inconsistent or not a log (last==0, first!=1)
[346491.182946] XFS (ram0): empty log check failed
[346491.184403] XFS (ram0): log mount/recovery failed: error -22
[346491.186276] XFS (ram0): log mount failed
.....

Note that if you have an external log device, logstart will be zero,
and you'll need to use xfs_io to overwrite it so you'll need to
explicitly test for that case before calling xfs_db to modify the
log.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
