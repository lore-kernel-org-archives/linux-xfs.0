Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3DE5C7F6A
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 16:46:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30FA3304032
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 14:46:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	x5D8q0wThkZHtymF for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 14:46:06 -0800 (PST)
Date: Tue, 12 Nov 2013 09:45:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20131111224559.GW6188@dastard>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-6-git-send-email-david@fromorbit.com>
	<527D2BA0.7000504@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <527D2BA0.7000504@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Nov 08, 2013 at 12:21:20PM -0600, Eric Sandeen wrote:
> On 10/31/13, 11:27 PM, Dave Chinner wrote:
> > So, this patch removes most of the performance and CPU usage
> > differential between v4 and v5 filesystems on traversal related
> > workloads.
> 
> We already have some issues w/ larger inode clusters & freespace
> fragmentation resulting in the inability to create new clusters,
> right?

Yes, we do.

> How might this impact that problem?  I understand that it may be
> a tradeoff.

It will make the problem slightly worse for workloads that already
suffer from this problem. For those that don't, it should have no
noticeable effect.

> > @@ -718,8 +719,22 @@ xfs_mountfs(
> >  	 * Set the inode cluster size.
> >  	 * This may still be overridden by the file system
> >  	 * block size if it is larger than the chosen cluster size.
> > +	 *
> > +	 * For v5 filesystems, scale the cluster size with the inode size to
> > +	 * keep a constant ratio of inode per cluster buffer, but only if mkfs
> > +	 * has set the inode alignment value appropriately for larger cluster
> > +	 * sizes.
> >  	 */
> >  	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> 
> Just thinking out loud here: So this is runtime only; nothing on disk sets
> the cluster size explicitly (granted, it never did).
> 
> So moving back and forth across newer/older kernels will create clusters 
> of different sizes on the same filesystem, right?

No - inodes are allocated in chunks, not clusters. Inode clusters
are the unit of IO we read and write inodes in.

> (In the very distant past, this same change could have happened if
> the amount of memory in a box changed (!) - see commit
> 425f9ddd534573f58df8e7b633a534fcfc16d44d; prior to that we set
> m_inode_cluster_size on the fly as well).

Right, I think I've already pointed that out.

> But sb_inoalignmt is a mkfs-set, on-disk feature.  So we might start with
> i.e. this, where A1 are 8k alignment points, and 512 byte inodes, in clusters
> of size 8k / 16 inodes:
> 
> A1           A1           A1           A1           
> [ 16 inodes ][ 16 inodes ]             [ 16 inodes ]

Ok, here's where you go wrong. Inode chunks are always 64 inodes,
and so what you have on disk after any inode allocation is:

A1           A1           A1           A1
[ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ]

and sb_inoalign determines where A1 lands in terms of filesystem
blocks. With sb_inoalign = 2 and a 4k filesystem block size, you can
only align inode *chunks* to even filesystem blocks like so:

ODD   EVEN   ODD   EVEN   ODD   EVEN   ODD   EVEN   ODD   EVEN
      A1           A1           A1           A1		  A1
      [ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ]

If we have 1kb filesystem blocks, then the equivalent sb_inoalign
value to give this same inode *chunk* layout is 8:

# mkfs.xfs -f -b size=1024 -i size=512 /dev/vdb
.....
# xfs_db -c "sb 0" -c "p inoalignmt" /dev/vdb
inoalignmt = 8
#

i.e:

45 6 70 1 2 345 6 70 1 2 345 6 70 1 2 345 6 70 1 2 345 6 70 1 2 ...
      A1           A1           A1           A1		  A1
      [ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ]

And with the larger inode cluster sizes:

# mkfs.xfs -f -b size=1024 -i size=512 -m crc=1 /dev/vdb
.....
# xfs_db -c "sb 0" -c "p inoalignmt" /dev/vdb
inoalignmt = 16
#

And, yes, that's not actually out of the range we commonly test -
512 byte block size with 256 byte inodes:

# mkfs.xfs -f -b size=512 /dev/vdb
.....
# xfs_db -c "sb 0" -c "p inoalignmt" /dev/vdb
inoalignmt = 16
#

So we definitely already handle and test these inode alignment
configurations all the time....

> and in this case we couldn't bump up m_inode_cluster_size, lest we
> allocate a larger cluster on the smaller alignment & overlap:
> 
> A1           A1           A1           A1           
> [ 16 inodes ][ 16 inodes ]             [ 16 inodes ] <--- existing
>                          [        32 inodes        ] <--- new

To be able to bump up the inode cluster size, what we have to
guarantee is that the inode chunks align to the the larger cluster
size like so:

A2                        A2
A1           A1           A1           A1
[ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ] <--- existing
[        32 inodes       ][       32 inodes        ] <--- new

i.e. inode chunk allocation needs to be aligned to A2, not A1 for
the correct alignment of the larger clusters.

If we align to A1, then this will happen:

A2                        A2                        A2
A1           A1           A1           A1           A1
             [ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ]
[        32 inodes       ][       32 inodes        ] <--- new

And that is clearly broken. Hence, to ensure we can use larger inode
clusters, we have to ensure that the inode chunks are aligned
appropriately for those cluster sizes. If the chunks are
appropriately aligned for larger inode clusters (e.g. sb_inoalign =
4), then they are also appropriately aligned for inode cluster sizes
older kernels support.

> So the only other thing I wonder about is when we are handling
> pre-existing, smaller-than m_inode_cluster_size clusters.
> 
> i.e. xfs_ifree_cluster() figures out the number of blocks &
> number of inodes in a cluster, based on the (now not
> constant) m_inode_cluster_size.
> 
> What stops us from going off the end of a smaller cluster?

The fact that we calculate the number of inodes to process per
cluster based on the size of the cluster buffer (in blocks)
multiplied by the number of inodes per block. If the code didn't
work, we'd have found out a long time ago ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
