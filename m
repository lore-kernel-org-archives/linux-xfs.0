Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7904TBK062212 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 19:04:29 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38606537337
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 17:04:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AoIc7omko45MYYuq for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2011 17:04:28 -0700 (PDT)
Date: Tue, 9 Aug 2011 10:04:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: xfs_swap_extents needs to handle dynamic fork offsets
Message-ID: <20110809000417.GO3162@dastard>
References: <4E406ECD.2020708@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E406ECD.2020708@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Aug 08, 2011 at 04:18:37PM -0700, Linda A. Walsh wrote:
> I'm seeing several of these in 'dmesg':
> 
> [873569.328221] Filesystem dm-6: fs/xfs/xfs_dfrag.c: inode
> 0x8227a310 format is incompatible for exchanging.
> [873623.752724] Filesystem dm-6: fs/xfs/xfs_dfrag.c: inode
> 0x8227a310 format is incompatible for exchanging.
> [873669.721127] Filesystem dm-6: fs/xfs/xfs_dfrag.c: inode
> 0x8227a310 format is incompatible for exchanging.
> ...
> 
> ----
> am running 2.6.38.3,
> 
> & version 3.1.4-2.1 of 'xfsprogs'....

That's no surprise - there are still some formats of inodes that we
cannot exchange because the code in xfs_fsr cannot precisely control
the format of the inode forks from userspace. If you use the event
tracing to capture the before and after swap extent trace points, I
can tell you why they were incompatible for exchange, and whether
xfs_fsr can be further modified to enable those files to be
defragmented....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
