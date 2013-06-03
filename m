Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9AF5C29DF8
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 20:42:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17C6CAC001
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 18:42:25 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JCSt4x3O9XcYCUIK for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 18:42:24 -0700 (PDT)
Date: Mon, 3 Jun 2013 11:42:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: latest xfsdump page allocation failure order:4 in 3.9.2
Message-ID: <20130603014220.GW29466@dastard>
References: <51ABEA86.9060008@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51ABEA86.9060008@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Jun 02, 2013 at 05:59:50PM -0700, Linda A. Walsh wrote:
> [123342.934683] xfsdump: page allocation failure: order:4, mode:0x10c0d0
> [123342.934689] Pid: 70466, comm: xfsdump Not tainted 3.9.2-Isht-Van #4
> [123342.934691] Call Trace:
> [123342.934701]  [<ffffffff810fdc3f>] warn_alloc_failed+0xdf/0x130
> [123342.934707]  [<ffffffff815f3f90>] ? __alloc_pages_direct_compact+0x1b9/0x1ca
> [123342.934711]  [<ffffffff81101a6f>] __alloc_pages_nodemask+0x81f/0xad0
> [123342.934716]  [<ffffffff814dd600>] ? __dm_destroy+0x210/0x250
> [123342.934720]  [<ffffffff8113c704>] alloc_pages_current+0xa4/0x160
> [123342.934723]  [<ffffffff810fcf79>] __get_free_pages+0x9/0x40
> [123342.934728]  [<ffffffff81143df9>] kmalloc_order_trace+0x29/0xe0
> [123342.934732]  [<ffffffff811468d6>] __kmalloc+0x146/0x1a0
> [123342.934737]  [<ffffffff8123e89c>] xfs_attrlist_by_handle+0x8c/0x110

Fixed in 3.10-rc1 by:

dd700d9 xfs: fallback to vmalloc for large buffers in xfs_attrlist_by_handle

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
