Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F4757F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:22:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CE9A304048
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 13:22:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	L0kIFbP4AzEN4nQZ for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2015 13:22:35 -0800 (PST)
Date: Tue, 15 Dec 2015 08:22:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0
Message-ID: <20151214212220.GO26718@dastard>
References: <20151214180048.GA15690@glen> <20151214195422.GM26718@dastard>
	<20151214201526.GA25152@glen>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151214201526.GA25152@glen>
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
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 14, 2015 at 09:15:26PM +0100, Andrea Gelmini wrote:
> On Tue, Dec 15, 2015 at 06:54:22AM +1100, Dave Chinner wrote:
> > What line of code does this address correspond to in your kernel?
> > 
> > 	xfs_iflush_cluster+0x9d7
> 
> gelma@glen:~/dev/kernel/v4.4.x$ git grep -Iin xfs_iflush_cluster
> fs/xfs/xfs_inode.c:3179:xfs_iflush_cluster(
> fs/xfs/xfs_inode.c:3414:	error = xfs_iflush_cluster(ip, bp);

If that was what I needed, I wouldn't have needed to ask. :/

I need the translation of the memory address to line number, not the
line number of function call. This requires translation from your
built kernel object file. e.g. on a kernel I just built:

$ gdb vmlinux
....
(gdb) l *(xfs_iflush_cluster+0x9d7)
0xffffffff814df647 is in xfs_bulkstat_one_int (fs/xfs/xfs_itable.c:110).
105             buf->bs_dmevmask = dic->di_dmevmask;
106             buf->bs_dmstate = dic->di_dmstate;
107             buf->bs_aextents = dic->di_anextents;
108             buf->bs_forkoff = XFS_IFORK_BOFF(ip);
109
110             switch (dic->di_format) {
111             case XFS_DINODE_FMT_DEV:
112                     buf->bs_rdev = ip->i_df.if_u2.if_rdev;
113                     buf->bs_blksize = BLKDEV_IOSIZE;
114                     buf->bs_blocks = 0;

That's clearly not code in xfs_iflush_cluster() or any function that
xfs_iflush_cluster() calls. Indeed, xfs_iflush_cluster() is only
0x411 bytes long on that kernel, so there's more than 2x the amount
of code in that function in your instrumented kernel than mine.

Hence I need the address-to-line number translation from your kernel
to tell me what line of code is being tripped over.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
