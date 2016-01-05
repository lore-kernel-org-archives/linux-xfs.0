Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEF9A29DFA
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 14:58:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA98C8F8040
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:58:29 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Uds1yvG6CQK6Hzn4 for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2016 12:58:25 -0800 (PST)
Date: Wed, 6 Jan 2016 07:58:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0
Message-ID: <20160105205811.GA21461@dastard>
References: <20151214180048.GA15690@glen> <20151214195422.GM26718@dastard>
	<20151214201526.GA25152@glen> <20151214212220.GO26718@dastard>
	<20151215091145.GA19282@glen> <20160103204758.GW19802@dastard>
	<20160105163055.GA18111@glen>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160105163055.GA18111@glen>
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

On Tue, Jan 05, 2016 at 05:30:55PM +0100, Andrea Gelmini wrote:
> On Mon, Jan 04, 2016 at 07:47:58AM +1100, Dave Chinner wrote:
> > > I'm recompiling, to try it again.
> > > Maybe, in the meanwhile, you can do something with my files. You can find 'em here:
> > > http://mail.gelma.net/xfs_kasan
> >
> > Any update on this problem, Andrea?
> 
> Here we are!
> Reproduced right now.
> 
> So, just to avoid confusion:
> a) it's a vanilla kernel 4.4.0-rc8
> b) plus some btrfs patches
> c) plus some dri/intel/i915 patches
> d) at the same URL above you can find git_files.txt.gz, where you have each commit I
>    applied above vanilla kernel (anyway, nothing related to vfs/xfs of course)
> e) at the same URL you find the kernel binaries I used
> f) to catch it, I had to copy a few gigs of files on my /home partition (xfs over Luks)
> 
> Anyway, here what you asked me for:
> 
> (gdb) l *(xfs_iflush_cluster+0xb73/0xc10)
> 0xffffffff8184c550 is in xfs_iflush_cluster (fs/xfs/xfs_inode.c:3182).
> 3177
> 3178    STATIC int
> 3179    xfs_iflush_cluster(
> 3180            xfs_inode_t     *ip,
> 3181            xfs_buf_t       *bp)
> 3182    {
> 3183            xfs_mount_t             *mp = ip->i_mount;
> 3184            struct xfs_perag        *pag;
> 3185            unsigned long           first_index, mask;
> 3186            unsigned long           inodes_per_cluster;
> (gdb)

Ok, so that tells us nothing about where the problem lies - the
function call is out of the preamble code that kasan instrumentation
adds to the function. I'll have a further think about this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
