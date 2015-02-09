Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB5B57F7E
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 18:02:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 990BE304043
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 16:02:34 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0AuXqas5PEjfnOxi for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 16:02:31 -0800 (PST)
Date: Mon, 9 Feb 2015 11:01:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 09/18] xfs: support min/max agbno args in block
	allocator
Message-ID: <20150209000112.GJ4251@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-10-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-10-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 06, 2015 at 02:52:56PM -0500, Brian Foster wrote:
> The block allocator supports various arguments to tweak block allocation
> behavior and set allocation requirements. The sparse inode chunk feature
> introduces a new requirement not supported by the current arguments.
> Sparse inode allocations must convert or merge into an inode record that
> describes a fixed length chunk (64 inodes x inodesize). Full inode chunk
> allocations by definition always result in valid inode records. Sparse
> chunk allocations are smaller and the associated records can refer to
> blocks not owned by the inode chunk. This model can result in invalid
> inode records in certain cases.
> 
> For example, if a sparse allocation occurs near the start of an AG, the
> aligned inode record for that chunk might refer to agbno 0. If an
> allocation occurs towards the end of the AG and the AG size is not
> aligned, the inode record could refer to blocks beyond the end of the
> AG. While neither of these scenarios directly result in corruption, they
> both insert invalid inode records and at minimum cause repair to
> complain, are unlikely to merge into full chunks over time and set land
> mines for other areas of code.
> 
> To guarantee sparse inode chunk allocation creates valid inode records,
> support the ability to specify an agbno range limit for
> XFS_ALLOCTYPE_NEAR_BNO block allocations. The min/max agbno's are
> specified in the allocation arguments and limit the block allocation
> algorithms to that range. The starting 'agbno' hint is clamped to the
> range if the specified agbno is out of range. If no sufficient extent is
> available within the range, the allocation fails. For backwards
> compatibility, the min/max fields can be initialized to 0 to disable
> range limiting (e.g., equivalent to min=0,max=agsize).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems sane on reading the implementation. I'll see if I still think
that way when I read the code that uses it ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
