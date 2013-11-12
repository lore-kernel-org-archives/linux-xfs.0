Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A25E97F69
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 18:24:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46568AC00A
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 16:24:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HiqUsq856qcpVPSL for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 16:24:47 -0800 (PST)
Message-ID: <5281754D.3060102@sandeen.net>
Date: Mon, 11 Nov 2013 18:24:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>	<1383280040-21979-6-git-send-email-david@fromorbit.com>	<527D2BA0.7000504@sandeen.net>
	<20131111224559.GW6188@dastard>
In-Reply-To: <20131111224559.GW6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/11/13, 4:45 PM, Dave Chinner wrote:
> On Fri, Nov 08, 2013 at 12:21:20PM -0600, Eric Sandeen wrote:
>> On 10/31/13, 11:27 PM, Dave Chinner wrote:
>>> So, this patch removes most of the performance and CPU usage
>>> differential between v4 and v5 filesystems on traversal related
>>> workloads.

...

>> Just thinking out loud here: So this is runtime only; nothing on disk sets
>> the cluster size explicitly (granted, it never did).
>>
>> So moving back and forth across newer/older kernels will create clusters 
>> of different sizes on the same filesystem, right?
> 
> No - inodes are allocated in chunks, not clusters. Inode clusters
> are the unit of IO we read and write inodes in.

Hohum, confused that fundamental difference.  Sorry.  Kind of
invalidates my other questions doesn't it.

>> (In the very distant past, this same change could have happened if
>> the amount of memory in a box changed (!) - see commit
>> 425f9ddd534573f58df8e7b633a534fcfc16d44d; prior to that we set
>> m_inode_cluster_size on the fly as well).
> 
> Right, I think I've already pointed that out.
> 
>> But sb_inoalignmt is a mkfs-set, on-disk feature.  So we might start with
>> i.e. this, where A1 are 8k alignment points, and 512 byte inodes, in clusters
>> of size 8k / 16 inodes:
>>
>> A1           A1           A1           A1           
>> [ 16 inodes ][ 16 inodes ]             [ 16 inodes ]
> 
> Ok, here's where you go wrong. Inode chunks are always 64 inodes,
> and so what you have on disk after any inode allocation is:
> 
> A1           A1           A1           A1
> [ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ]
> 
> and sb_inoalign determines where A1 lands in terms of filesystem
> blocks. With sb_inoalign = 2 and a 4k filesystem block size, you can
> only align inode *chunks* to even filesystem blocks like so:
> 
> ODD   EVEN   ODD   EVEN   ODD   EVEN   ODD   EVEN   ODD   EVEN
>       A1           A1           A1           A1		  A1
>       [ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ]
> 

<snip a few examples>

> To be able to bump up the inode cluster size, what we have to
> guarantee is that the inode chunks align to the the larger cluster
> size like so:
> 
> A2                        A2
> A1           A1           A1           A1
> [ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ] <--- existing
> [        32 inodes       ][       32 inodes        ] <--- new
> 
> i.e. inode chunk allocation needs to be aligned to A2, not A1 for
> the correct alignment of the larger clusters.
> 
> If we align to A1, then this will happen:
> 
> A2                        A2                        A2
> A1           A1           A1           A1           A1
>              [ 16 inodes ][ 16 inodes ][ 16 inodes ][ 16 inodes ]
> [        32 inodes       ][       32 inodes        ] <--- new
> 
> And that is clearly broken. Hence, to ensure we can use larger inode
> clusters, we have to ensure that the inode chunks are aligned
> appropriately for those cluster sizes. If the chunks are
> appropriately aligned for larger inode clusters (e.g. sb_inoalign =
> 4), then they are also appropriately aligned for inode cluster sizes
> older kernels support.

*nod*  Ok.

>> So the only other thing I wonder about is when we are handling
>> pre-existing, smaller-than m_inode_cluster_size clusters.
>>
>> i.e. xfs_ifree_cluster() figures out the number of blocks &
>> number of inodes in a cluster, based on the (now not
>> constant) m_inode_cluster_size.
>>
>> What stops us from going off the end of a smaller cluster?
> 
> The fact that we calculate the number of inodes to process per
> cluster based on the size of the cluster buffer (in blocks)
> multiplied by the number of inodes per block. If the code didn't
> work, we'd have found out a long time ago ;)

And I was rather stupidly confusing clusters & chunks, so never mind...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
