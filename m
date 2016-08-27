Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E711F7CB1
	for <xfs@oss.sgi.com>; Sat, 27 Aug 2016 17:55:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB95F8F8037
	for <xfs@oss.sgi.com>; Sat, 27 Aug 2016 15:55:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Xm5GYoP62O39QiCT for <xfs@oss.sgi.com>;
	Sat, 27 Aug 2016 15:55:22 -0700 (PDT)
Date: Sun, 28 Aug 2016 08:55:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS discards more data than it writes
Message-ID: <20160827225519.GI19025@dastard>
References: <20160827014537.GA4119@Juns-MacBook-Pro.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160827014537.GA4119@Juns-MacBook-Pro.local>
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
To: Jun He <jhe@cs.wisc.edu>
Cc: xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 08:45:37PM -0500, Jun He wrote:
> Hi all,
> 
> I find that, with '-o discard', XFS sometimes discards more data than it
> writes. This may slow down XFS more on slow-discard SSDs. Also, could
> problematic discard implementation lead to data loss?
> 
> Setup to reproduce: 
> - Linux 4.5.4
> - Workload: LevelDB
> 
> $ mkfs.xfs  -K -f -s size=4096 -b size=4096 /dev/sdc1
> $ mount -o discard /dev/sdc1 /mnt/fsonloop
> $ leveldb/db_bench --benchmarks=overwrite --num=3000000 --db=/mnt/fsonloop/leveldb_data0 --threads=1 --use_existing_db=0
> 
> I found that XFS discarded ~2.4GB while only wrote ~1.4GB,
> by blktrace. (This is not due to the mkfs discarding the
> whole disk.)

Yup. Discard covers extents being freed, not ranges being written.
So there's metadata, preallocated (unwritten) regions, speculative
prealloc beyond EOF, etc, all of which won't be counted in "writes"
but will be counted in "discards".

> Some visual https://github.com/junhe/xfs-bug-report/blob/master/xfs-double-discard.png 
> Some spaces are discarded twice in this case.
> 
> Is it a bug?

No.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
