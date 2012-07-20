Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6K856OL096342 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 03:05:06 -0500
Message-ID: <5009112D.4090106@sgi.com>
Date: Fri, 20 Jul 2012 10:05:01 +0200
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs: prevent xfs_bmap_extsize_align() to exceed maximum
	extent size.
References: <20120712154554.377970666@sgi.com> <4FFFF3D8.7060001@sgi.com>
	<50059437.6070705@sgi.com> <20120719033027.GD23387@dastard>
	<5007C33B.5010603@sgi.com> <20120720014454.GI23387@dastard>
In-Reply-To: <20120720014454.GI23387@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 12-07-20 03:44 AM, Dave Chinner wrote:
>
>>>
>> If you look in the function where I put this code is it AFTER the
>> head/len alignment so the HEAD is already align so I do not need to
>> account for it.
> No need to shout. I did look at the code, and IMO you do need to
> account for both head and tail extension and you definitely can't do
> it there.....
Sorry for the cap I did not intend to shout.

However the problem does exist. the len limitation in xfs_bmapi_write is 
not sufficient
if you set the extsize.

Here is what I see.

xfs_bmapi_write() <= lenght limited to MAXEXTLEN;
     xfs_bmapi_allocate()
           xfs_bmap_alloc()
                 xfs_bmap_btalloc()
                       xfs_bmap_extsize_align()  <== Align the offest / len

Since the alignment is outward like you explain bellow we return len > 
MAXEXTLEN
causing failure to report ENOSPC.

You can reproduce the problem the following way.

# uname -r
3.5.0-rc1-0.2-default+

# mkfs.xfs -f -b size=512 -d agcount=1,size=4294967296 /dev/sdb5

meta-data=/dev/sdb5              isize=256    agcount=1, agsize=8388608 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=512    blocks=8388608, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=512    blocks=20480, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount /dev/sdb5 /a

# xfs_io -f -c "extsize 2m" -c "resvsp 0 1g" /a/data1
XFS_IOC_RESVSP64: No space left on device


So Maybe the fix is to limit the bma.length in xfs_bmapi_write to MAXEXTLEN 
- (2 * extsz - 1) like you do in xfs_bmapi_reserve_delalloc().


Hope this is making sense.




-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
