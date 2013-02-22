Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7E6F7F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 11:07:48 -0600 (CST)
Message-ID: <5127A5E2.2070407@sgi.com>
Date: Fri, 22 Feb 2013 11:07:46 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/6] xfs: reorganize xfs_iomap_prealloc_size to remove
	indentation
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
	<1361373019-30891-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1361373019-30891-2-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 02/20/13 09:10, Brian Foster wrote:
> The majority of xfs_iomap_prealloc_size() executes within the
> check for lack of default I/O size. Reverse the logic to remove the
> extra indentation.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Ben Myers<bpm@sgi.com>
> ---
>   fs/xfs/xfs_iomap.c |   63 ++++++++++++++++++++++++++-------------------------
>   1 files changed, 32 insertions(+), 31 deletions(-)
>
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 912d83d..d914419 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -381,42 +381,43 @@ xfs_iomap_prealloc_size(
>   	int			nimaps)
>   {
>   	xfs_fsblock_t		alloc_blocks = 0;
> +	int			shift = 0;
> +	int64_t			freesp;

...

> +	freesp = mp->m_sb.sb_fdblocks;

...

> +	/*
> +	 * If we are still trying to allocate more space than is
> +	 * available, squash the prealloc hard. This can happen if we
> +	 * have a large file on a small filesystem and the above
> +	 * lowspace thresholds are smaller than MAXEXTLEN.
> +	 */
> +	while (alloc_blocks>= freesp)
> +		alloc_blocks>>= 4;


Hi Brian, I am looking at your speculative preallocation quota 
throttling series.

I know this code is from commit 4d559a3b. would this not be bad of 
freesp == 0?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
