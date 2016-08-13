Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 600777CA0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:04:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA89BAC001
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:04:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6po1zAnMo5EZfgzG for <xfs@oss.sgi.com>;
	Sat, 13 Aug 2016 16:04:49 -0700 (PDT)
Date: Sun, 14 Aug 2016 09:04:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/224 triggers infinite "page discard on page xxx" on 512
	block size XFS with 4.8-rc1 kernel
Message-ID: <20160813230426.GC16044@dastard>
References: <20160813073839.GY27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160813073839.GY27776@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Sat, Aug 13, 2016 at 03:38:39PM +0800, Eryu Guan wrote:
> Hi all,
> 
> I've hit generic/224 flooding dmesg on 512 block size XFS, 4.8-rc1
> kernel, with the following message:
> 
> ...
> [   98.146091] XFS (sda6): page discard on page ffffea0002f7e780, inode 0xe3a87, offset 1085214720.
> [   98.147431] XFS (sda6): page discard on page ffffea00023c3800, inode 0xe3a87, offset 1085218816.
> [   98.148743] XFS (sda6): page discard on page ffffea0002247700, inode 0xe3a87, offset 1085222912.
> [   98.150136] XFS (sda6): page discard on page ffffea0002f8d000, inode 0xe3a87, offset 1085227008.
> [   98.151496] XFS (sda6): page discard on page ffffea0002c58840, inode 0xe3a87, offset 1085231104.
> [   98.152794] XFS (sda6): page discard on page ffffea0002e65340, inode 0xe3a87, offset 1085235200.
> ...
> 
> The inode number is always the same, only the page address and offset
> are changing.
> 
> This is triggered by this dd command in generic/224:
> 
> dd if=/dev/zero of=$SCRATCH_MNT/testfile.$i bs=4k conv=notrunc
> 
> and it won't return until you kill it.

It's not infinite. It just does it for every page and 1000 processes
all trying to write 256,000 pages is a lot.... We have a fix
pending for it and I'm aiming to get it to Linus later this week.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
