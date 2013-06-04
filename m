Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A6687F37
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 23:36:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83C078F8033
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 21:36:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6FhOptNF34B21AJW for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 21:36:12 -0700 (PDT)
Date: Tue, 4 Jun 2013 14:36:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: XFS rootfs corruption
Message-ID: <20130604043610.GH29466@dastard>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
	<131268379.10596360.1370246946902.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <131268379.10596360.1370246946902.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 04:09:06AM -0400, CAI Qian wrote:
[snip]

> :/# xfs_repair -L  /dev/mapper/rhel_ibm--p720--01--lp4-root
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
....

Now that you've repaired the filesystem, can you reproduce the
problem?

It looks somewhat like the same bug we fixed in 3.8-rc4 that Dave
Jones hit (37f1356 xfs: recalculate leaf entry pointer after
compacting a dir2 block), but if you've never repaired the damage on
disk that this problem caused then you'll just keep tripping over
it.

So, can you reproduce the problem now on this machine/filesystem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
