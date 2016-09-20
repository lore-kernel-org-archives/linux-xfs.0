Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BED57CB5
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 15:15:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4FBE0304059
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 13:14:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ouE3gPTA2eLDyw3z for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2016 13:14:55 -0700 (PDT)
Date: Wed, 21 Sep 2016 06:14:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel BUG at fs/xfs/xfs_message.c:113!
Message-ID: <20160920201453.GH340@dastard>
References: <20160920163304.GA8999@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160920163304.GA8999@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Sep 20, 2016 at 10:33:04AM -0600, Ross Zwisler wrote:
> I'm consistently able to generate this kernel BUG with both v4.7 and v4.8-rc7.
> This bug reproduces both with and without DAX.
> Here is the BUG with v4.8-rc7, passed through kasan_symbolize.py:
> 
>   run fstests generic/026 at 2016-09-20 10:22:58
>   XFS (pmem0p2): Unmounting Filesystem
>   XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 309

It overran the block allocation reservation for the transaction.

> I started hitting this issue when I started setting extsize via xfs_io on both
> my TEST and SCRATCH xfstest directories.  Here's a quick snapshot of my
> xfstests setup:
> 
>   # parted -s -a optimal /dev/pmem0 mkpart Primary 2MiB 12GiB
>   # parted -s -a optimal /dev/pmem0 mkpart Primary 12GiB 16382MiB
>   # mkfs.xfs -f /dev/pmem0p1
>   # mkfs.xfs -f /dev/pmem0p2
>   # mount /dev/pmem0p1 /mnt/xfstests_test
>   # mount /dev/pmem0p2 /mnt/xfstests_scratch
>   # xfs_io -c 'extsize 2m' /mnt/xfstests_test
>   # xfs_io -c 'extsize 2m' /mnt/xfstests_scratch

The test dir is the one that matters here - I can reproduce it
locally so I'll have a look.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
