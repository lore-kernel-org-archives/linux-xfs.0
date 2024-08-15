Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C8E84E0A;
	Thu, 15 Aug 2024 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723743750; cv=none; b=AUNbN51ZSE/2Kjx5ei20GocyEptz6JdCvx+SvW+hhbuEFy8TbGhKD7K+C8xkkfkxEOInRm4NK/zQU+nBbTRZ0iBxrpRF4jPThaSv7ml4vuwINDAmZv0ANLXcJdt5uKw7RK2FNEHmn1/n8oLdfGDH4R8g6zHQ6Pkk+MOmQDs0BFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723743750; c=relaxed/simple;
	bh=MNhO4E4MKhkv70C1X6YvebALLvnw3gkttx8/+8U/M/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O84kHBJuUrEXL7IiPYR5nyDxjzvfCCCpzresVIBHjYa9QyENnhgYK1lEW69YPXcKe1d0rsc5z4nBTDBdBCrHznvlUJXEohbRrpDa43hWV2koRIm/5lNKyXs1DsKkcK1kjU6zw+/iGPojZx2e1LXNS5hJBCnUoBjTZPkXyCKtFto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/3nlWgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/3nlWgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE47C32786;
	Thu, 15 Aug 2024 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723743750;
	bh=MNhO4E4MKhkv70C1X6YvebALLvnw3gkttx8/+8U/M/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D/3nlWgVC40U3fUda7qoVbsgb6w/g5otOSrAN5lvRvwfj1Eporj5XuSkGNOHBK+KN
	 FrFzAr6oR5p0EtY3diyMx8F56GBRWf1ylgFrtNpA9Tq0HfMlUPip3WcFPMSCSXKOHt
	 tEoqeULkqvkV/+LOXEhvI3FZOCOkbad5tuAbjw0mY7iYtwkIblbbbCeolt+dYx2anO
	 qpxhzSPbuuiD38Cin3hDVTEy+Qg5kbwEmUW5akLPgZbPQxSkBHsDWP9WrktZ/uF6A5
	 CgoeKLQBiw5gnIgGXx4jhRbdvd5sdRpZBVEBrQ1Y8xX3tdJl046natj2lfOQSz+gOa
	 oB4nGnsVKjUhg==
Date: Thu, 15 Aug 2024 10:42:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V3 2/2] xfs: Fix missing interval for missing_owner in
 xfs fsmap
Message-ID: <20240815174229.GI865349@frogsfrogsfrogs>
References: <20240812011505.1414130-1-wozizhi@huawei.com>
 <20240812011505.1414130-3-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812011505.1414130-3-wozizhi@huawei.com>

On Mon, Aug 12, 2024 at 09:15:05AM +0800, Zizhi Wo wrote:
> In the fsmap query of xfs, there is an interval missing problem:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
>  EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
>    0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
>    1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
>    2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
>    3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
>    4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
>    5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
>    6: 253:16 [104..127]:           free space                          0  (104..127)               24
>    ......
> 
> BUG:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
> [root@fedora ~]#
> Normally, we should be able to get [104, 107), but we got nothing.
> 
> The problem is caused by shifting. The query for the problem-triggered
> scenario is for the missing_owner interval (e.g. freespace in rmapbt/
> unknown space in bnobt), which is obtained by subtraction (gap). For this
> scenario, the interval is obtained by info->last. However, rec_daddr is
> calculated based on the start_block recorded in key[1], which is converted
> by calling XFS_BB_TO_FSBT. Then if rec_daddr does not exceed
> info->next_daddr, which means keys[1].fmr_physical >> (mp)->m_blkbb_log
> <= info->next_daddr, no records will be displayed. In the above example,
> 104 >> (mp)->m_blkbb_log = 12 and 107 >> (mp)->m_blkbb_log = 12, so the two
> are reduced to 0 and the gap is ignored:
> 
>  before calculate ----------------> after shifting
>  104(st)  107(ed)		      12(st/ed)
>   |---------|				  |
>   sector size			      block size
> 
> Resolve this issue by introducing the "end_daddr" field in
> xfs_getfsmap_info. This records |key[1].fmr_physical + key[1].length| at
> the granularity of sector. If the current query is the last, the rec_daddr
> is end_daddr to prevent missing interval problems caused by shifting. We
> only need to focus on the last query, because xfs disks are internally
> aligned with disk blocksize that are powers of two and minimum 512, so
> there is no problem with shifting in previous queries.
> 
> After applying this patch, the above problem have been solved:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
>  EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
>    0: 253:16 [104..106]:      free space                        0  (104..106)           3
> 
> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/xfs_fsmap.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index d346acff7725..4ae273b54129 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -162,6 +162,7 @@ struct xfs_getfsmap_info {
>  	xfs_daddr_t		next_daddr;	/* next daddr we expect */
>  	/* daddr of low fsmap key when we're using the rtbitmap */
>  	xfs_daddr_t		low_daddr;
> +	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */

This ought to be initialized to an obviously impossible value (e.g.
-1ULL) in xfs_getfsmap before we start walking btrees.

>  	u64			missing_owner;	/* owner of holes */
>  	u32			dev;		/* device id */
>  	/*
> @@ -294,6 +295,13 @@ xfs_getfsmap_helper(
>  		return 0;
>  	}
>  
> +	/*
> +	 * To prevent missing intervals in the last query, consider using
> +	 * sectors as the granularity.
> +	 */
> +	if (info->last && info->end_daddr)
> +		rec_daddr = info->end_daddr;

I think this needs a better comment.  How about:

	/*
	 * For an info->last query, we're looking for a gap between the
	 * last mapping emitted and the high key specified by userspace.
	 * If the user's query spans less than 1 fsblock, then
	 * info->high and info->low will have the same rm_startblock,
	 * which causes rec_daddr and next_daddr to be the same.
	 * Therefore, use the end_daddr that we calculated from
	 * userspace's high key to synthesize the record.  Note that if
	 * the btree query found a mapping, there won't be a gap.
	 */

> +
>  	/* Are we just counting mappings? */
>  	if (info->head->fmh_count == 0) {
>  		if (info->head->fmh_entries == UINT_MAX)
> @@ -973,8 +981,10 @@ xfs_getfsmap(
>  		 * low key, zero out the low key so that we get
>  		 * everything from the beginning.
>  		 */
> -		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
> +		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
>  			dkeys[1] = head->fmh_keys[1];
> +			info.end_daddr = dkeys[1].fmr_physical + dkeys[1].fmr_length;

dkeys[1].fmr_length is never used by anything in the fsmap code --
__xfs_getfsmap_datadev sets end_fsb using only dkeys[1].fmr_physical.
You shouldn't add it to end_daddr here because then they won't be
describing the same thing.

Anyway I'll figure out a reproducer for fstests and send the whole pile
back to the mailing list once it passes QA.  Thanks for finding the bug
and attempting a fix. :)

--D

> +		}
>  		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
>  			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
>  
> -- 
> 2.39.2
> 
> 
