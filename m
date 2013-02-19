Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 440757F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 20:46:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2423D8F8037
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 18:46:28 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RxfGM9JCE2Hlg81D for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 18:46:26 -0800 (PST)
Date: Tue, 19 Feb 2013 13:46:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: increase prealloc size to double that of the
	previous extent
Message-ID: <20130219024624.GE10731@dastard>
References: <1361231827-58766-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361231827-58766-1-git-send-email-bfoster@redhat.com>
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

On Mon, Feb 18, 2013 at 06:57:07PM -0500, Brian Foster wrote:
> The updated speculative preallocation algorithm becomes less
> effective in situations with a high number of concurrent,
> sequential writers. In running 32 sequential writers on a system
> with 32GB RAM, preallocs become fixed at a value of around 128MB.
> Update the heuristic to base the size of the prealloc on double
> the size of the preceding extent. This preserves the original
> aggressive speculative preallocation behavior at a slight cost of
> increasing the size of preallocated data regions following holes of
> sparse files.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

You probably want to mention that it is the writeback bandwidth
slicing (for fairness across all dirty inodes) that is resulting in
the pattern of allocation that you saw. Hence different machines
with different amounts of RAM and write throughput will therefore
see different results.

> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 912d83d..45a382d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -362,7 +362,7 @@ xfs_iomap_eof_prealloc_initial_size(
>  	if (imap[0].br_startblock == HOLESTARTBLOCK)
>  		return 0;
>  	if (imap[0].br_blockcount <= (MAXEXTLEN >> 1))
> -		return imap[0].br_blockcount;
> +		return imap[0].br_blockcount << 1;
>  	return XFS_B_TO_FSB(mp, offset);
>  }

Works for me. Thanks Brain.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
