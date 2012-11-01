Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA11lOmS254749 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 20:47:24 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tyDCEmLNX4FC5Ysi for <xfs@oss.sgi.com>;
	Wed, 31 Oct 2012 18:49:14 -0700 (PDT)
Date: Thu, 1 Nov 2012 12:49:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest 179 ASSERT
Message-ID: <20121101014910.GO29378@dastard>
References: <50916CBA.7050602@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50916CBA.7050602@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 31, 2012 at 01:23:54PM -0500, Mark Tinguely wrote:
> OSS sources with the xfs: fix buffer shudown reference count mismatch
> patch and xfstest 179.
> 
> xfstest 179 started to have various asserts starting with the "move the
> workers" series, but mostly the b_hold count is zero assert.
> 
> Now that the b_hold count is fixed, the asert is:
> 
> XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
> file: /root/xfs/fs/xfs/xfs_mount.c, line: 273

The only way you are going to track this down is through tracing
perag gets and puts, and finding the object that is missing a put.
There are already tracepoints for these and they tell you the caller
function, so that should be sufficient to find what function has a
get without a put...

The other possibility is that there are buffers that have not be
freed properly (or leaked), but IIRC this failure pre-exists
attaching the perag to buffers....

> mount perag information:
>   m_perag_tree = {
>     height = 0x1,
>     gfp_mask = 0x20,
>     rnode = 0xffff8803124bb4b1
>   },
> crash> radix_tree_node ffff8803124bb4b0
> struct radix_tree_node {
>   height = 0x1,
>   count = 0x3,
>   {
>     parent = 0x0,
>     callback_head = {
>       next = 0x0,
>       func = 0xffffffff812384b0 <radix_tree_node_rcu_free>
>     }
>   },
>   slots = {0x0, 0xffff88034fd6f540, 0xffff88034fd6f840,
> 0xffff88034fd6f240, 0x0,
>  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x0, 0x0,
>  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x0, 0x0,
>  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x0, 0x0,
>  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
>   tags = {{0x0}, {0x0}, {0x0}}
> }
> 
> The inodes at 0xffff88034fd6f540, 0xffff88034fd6f840, 0xffff88034fd6f240
> don't look valid.

Those aren't inodes based on the addresses - they are all in the
same page, so the size is at most 0x300 bytes (768 bytes). An XFS
inode is larger than this, but a radix tree node is smaller (560
bytes and fits 7 to a page on my x86_64 machines), so I'm not sure
what you have there. how big does /proc/slabinfo tell you a radix
tree node is?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
