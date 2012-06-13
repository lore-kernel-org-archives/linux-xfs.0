Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D0CJZg056094 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 19:12:19 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id S8bh6QQ34ODaYqhg
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 17:12:18 -0700 (PDT)
Message-ID: <4FD7DAE1.8010501@hardwarefreak.com>
Date: Tue, 12 Jun 2012 19:12:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl>
In-Reply-To: <4FD766A7.9030908@xsnews.nl>
Reply-To: stan@hardwarefreak.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthew Whittaker-Williams <matthew@xsnews.nl>
Cc: xfs@oss.sgi.com

On 6/12/2012 10:56 AM, Matthew Whittaker-Williams wrote:

>          =                       sunit=0      swidth=0 blks

> RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
> Size                : 40.014 TB
> Strip Size          : 64 KB
> Number Of Drives    : 24

This may or may not be directly related to your issue as you describe
the problem workload as primarily read oriented.  But I should point out
you've got a stripe size of 22*64K = 1408KB, yet you're doing 4KB
unaligned writeout.  An unaligned XFS typically leaves a lot of
performance on the table, and can have disastrous results with parity
RAID RMW cycles.  Though with 4KB writeout you're probably not going to
hit the same problem as with misalignment due to incorrect stripe
offset, such as specifying an effective stripe size of 1344 when the
hardware stripe is 1408 (off by 1 spindle).

Is there a particular reason you didn't create these two filesystems with:

~$ mkfs.xfs -d su=64k,sw=22 /dev/sdX

Surely I'm missing something.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
