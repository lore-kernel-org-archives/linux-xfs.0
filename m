Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A2188CD9;
	Mon, 19 Aug 2024 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724093079; cv=none; b=Mdh+UTeoQTKIcYUHmlw2pdHqoytA21gFKSBSKu1CrzGqu5yrI4CO8RLPvggE2/TRH0YPE6BEd6EPuH8tWk82qDDsTiLcqdgAcWFvi4D7qTOo81qV/JMaoE0HTWAqB5t+Xi475P6CsJPW3LTc95ut021OwDV5Lmakqa6lj4U++zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724093079; c=relaxed/simple;
	bh=IKWmLhqc4HOpXiXkRyYaCMwW6DA4gOKTOvY5fmT89wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PVrqAFnxHycjADkT5R5CYqiOpEwv9kA2nu3vFTgg4iCiWMPsxHkKVMShl+WBtgRe9RbzoiE3OqorqEfZwWpBE2f8mq3HB7F/nuXuSRV1aMhg0lPuBeQPkkJFB3CaiH5Oy1sS3ZkdBsfMGQ0VO4U+7zp09TLa1XoHIMKot7u4dL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7ei5VKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7ei5VKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26B8C32782;
	Mon, 19 Aug 2024 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724093079;
	bh=IKWmLhqc4HOpXiXkRyYaCMwW6DA4gOKTOvY5fmT89wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K7ei5VKYMDzSGgV9i3asrWoMeBu383Lrjd2edttkn232HkXGW7Ez+FtOEaedNUT5N
	 BCynaXPpDAhxoTnukSFFV3MoFeHa3biDvdlpiwUeLVpPM8oDWPEzCDUXK98tjkU+C2
	 bWSVSmxFC2fz25AfEIPSN2WodpoqFOy6JX2KqcYftJGTdWs/FrcrDicjb19rE2Va1L
	 +dUcto/YO85GX9hFc9S7U+8F6cLoUgs2DZc6zQoqdSUr7/trlQuL437Jkf2vWVw4T3
	 xB6UmSavQDGeilqhbMklajFJVuYb/Yu/Hn59O2K6oOEIXhO9QGncrx94Yw+PEanw4X
	 luNDH0OSETuLQ==
Date: Mon, 19 Aug 2024 11:44:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V4 2/2] xfs: Fix missing interval for missing_owner in
 xfs fsmap
Message-ID: <20240819184438.GR865349@frogsfrogsfrogs>
References: <20240819005320.304211-1-wozizhi@huawei.com>
 <20240819005320.304211-3-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819005320.304211-3-wozizhi@huawei.com>

On Mon, Aug 19, 2024 at 08:53:20AM +0800, Zizhi Wo wrote:
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
> xfs_getfsmap_info. This records key[1].fmr_physical at the granularity of
> sector. If the current query is the last, the rec_daddr is end_daddr to
> prevent missing interval problems caused by shifting. We only need to focus
> on the last query, because xfs disks are internally aligned with disk
> blocksize that are powers of two and minimum 512, so there is no problem
> with shifting in previous queries.
> 
> After applying this patch, the above problem have been solved:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
>  EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
>    0: 253:16 [104..106]:      free space                        0  (104..106)           3
> 
> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/xfs_fsmap.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 3a30b36779db..4734f8d6303c 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -162,6 +162,7 @@ struct xfs_getfsmap_info {
>  	xfs_daddr_t		next_daddr;	/* next daddr we expect */
>  	/* daddr of low fsmap key when we're using the rtbitmap */
>  	xfs_daddr_t		low_daddr;
> +	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
>  	u64			missing_owner;	/* owner of holes */
>  	u32			dev;		/* device id */
>  	/*
> @@ -294,6 +295,19 @@ xfs_getfsmap_helper(
>  		return 0;
>  	}
>  
> +	/*
> +	 * For an info->last query, we're looking for a gap between the
> +	 * last mapping emitted and the high key specified by userspace.
> +	 * If the user's query spans less than 1 fsblock, then
> +	 * info->high and info->low will have the same rm_startblock,
> +	 * which causes rec_daddr and next_daddr to be the same.
> +	 * Therefore, use the end_daddr that we calculated from
> +	 * userspace's high key to synthesize the record.  Note that if
> +	 * the btree query found a mapping, there won't be a gap.
> +	 */
> +	if (info->last && info->end_daddr != LLONG_MAX)
> +		rec_daddr = info->end_daddr;
> +
>  	/* Are we just counting mappings? */
>  	if (info->head->fmh_count == 0) {
>  		if (info->head->fmh_entries == UINT_MAX)
> @@ -946,6 +960,7 @@ xfs_getfsmap(
>  
>  	info.next_daddr = head->fmh_keys[0].fmr_physical +
>  			  head->fmh_keys[0].fmr_length;
> +	info.end_daddr = LLONG_MAX;
>  	info.fsmap_recs = fsmap_recs;
>  	info.head = head;
>  
> @@ -966,8 +981,10 @@ xfs_getfsmap(
>  		 * low key, zero out the low key so that we get
>  		 * everything from the beginning.
>  		 */
> -		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
> +		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
>  			dkeys[1] = head->fmh_keys[1];
> +			info.end_daddr = dkeys[1].fmr_physical;

Another problem that I found while testing this out is that if
dkeys[1].fmr_physical extends a little bit beyond the end of what the
filesystem thinks is the device size, this change results in fsmap
reporting an "unknown" extent between that end point and whatever the
user specified as fmr_physical.

IOWs, let's say that the filesystem has 67G of space and 16G AGs.  This
results in 4x 16G AGs, and a runt AG 4 that is 3G long.  If you initiate
an fsmap query for [64G, 80G), it'll report "unknown" space between 67G
and 80G, whereas previously it did not report that.  I noticed this due
to a regression in xfs/566 with the rtgroups patchset applied, though it
also seems to happen with that same test if the underlying device has a
raid stripe configuration that causes runt AGs.

I think this can be fixed by constraining end_daddr to the minimum of
fmr_physical and XFS_FSB_TO_BB(dblocks/rblocks/logblocks).

--D

> +		}
>  		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
>  			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
>  
> -- 
> 2.39.2
> 
> 
