Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 805977F4E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 15:48:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44AC28F8033
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 13:48:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gEuRhASHUuA9oPX8 for <xfs@oss.sgi.com>;
	Tue, 19 Feb 2013 13:48:45 -0800 (PST)
Date: Wed, 20 Feb 2013 08:48:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/7] xfs: cap prealloc size to free space before shift
Message-ID: <20130219214842.GG10731@dastard>
References: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
	<1361291851-24714-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361291851-24714-4-git-send-email-bfoster@redhat.com>
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

On Tue, Feb 19, 2013 at 11:37:27AM -0500, Brian Foster wrote:
> With the addition of quota preallocation throttling, we want to
> support a general algorithm that considers the maximum allowable
> prealloc size and recommended shift modifier from various sources
> (i.e., global fs state and all applicable quotas for an inode).
> 
> Update the current global free space throttle algorithm to cap the
> preallocation size to the free space available in the filesystem.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_iomap.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index daa08f6..3b41c18 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -412,6 +412,9 @@ xfs_iomap_prealloc_size(
>  		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
>  			shift++;
>  	}
> +	if (alloc_blocks > freesp)
> +		alloc_blocks = freesp;
> +
>  	if (shift)
>  		alloc_blocks >>= shift;

This is redundant with the previous additions of the trailing

	while (alloc_blocks >= freesp)
		alloc_blocks >>= 4;

code. Effectively adding the check will result in preventing the
existing loop from working as alloc_blocks will be brought down to
just under freespc by things like power of 2 rounding, rather than
being thottled to a small fraction of the remaining free space...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
