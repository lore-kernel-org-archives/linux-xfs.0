Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FFE4085D;
	Mon, 19 Aug 2024 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080813; cv=none; b=WJcD3lfs9n1TIqKnQZDEJNtHSuBoqshn+xpTgsv9RzCHHcl42EpDxlaSbUpk+KjuBvQpLhmFF509evV6v2NtFSKC1N6gbAkamGQsyUxrumcIqlhNBu8WfzgQ0MdZwuioksC39CBPD3hg0EP5fo+Bc8YkqGqWZVT3BwCtfC9zfmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080813; c=relaxed/simple;
	bh=h6ZyEj40vrQ4AuUi73bm+cVP/8XGhPDtdKPcZYyJzyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7gmFUASLcR12yWoYyvf6iHgLPW/RAXYfDE0BZF9CE1Xnd2c1H7st9y920fz8JfMaW2yteixf2hE6uTnLLE3zvIbj7tOdQ6YZoUsxO5YKBwEUlHTMbYR/pPDogfiamtCaF8f/9dyIbJ7/11Xym+8yhe+rq1pKn3bin0RHTAQVtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLfGl8vU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLfGl8vU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98FAC32782;
	Mon, 19 Aug 2024 15:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724080812;
	bh=h6ZyEj40vrQ4AuUi73bm+cVP/8XGhPDtdKPcZYyJzyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tLfGl8vUofwOv5OtuTkyELCrnPPGBAfG20gifLaHbJfRAV+4ARuej0NT/ERZDsM+w
	 uO8g7F7Bi2QYcD5S4n9cRCCXNJHbTuOOYx9A6ls+mYAk8lUBsfhj00E/cYAtox/sYk
	 9otCf8MZob1YiFR7Wd/MTqkj4us9SL7a5MscRESxWYubNthLmu8Adi8F/HHQvQqsJ+
	 ngdQyODagSQUxDJXfrKaW2QT2BaTDztSGdiatiHbjm2imB4YfakxC0OKxjUI4wESiA
	 fddQMm2Dh6/VTeNI3aJqWD8miV+Q4asD3Skv9veCcxChBDKrUjbqeYGNbB8K0xiVPI
	 j+HVCAB29Gb9g==
Date: Mon, 19 Aug 2024 08:20:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V4 2/2] xfs: Fix missing interval for missing_owner in
 xfs fsmap
Message-ID: <20240819152012.GQ865349@frogsfrogsfrogs>
References: <20240819005320.304211-1-wozizhi@huawei.com>
 <20240819005320.304211-3-wozizhi@huawei.com>
 <20240819052123.GM865349@frogsfrogsfrogs>
 <f3f955cf-18b7-4a50-bacd-ea13e35bf72d@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3f955cf-18b7-4a50-bacd-ea13e35bf72d@huawei.com>

On Mon, Aug 19, 2024 at 02:24:58PM +0800, Zizhi Wo wrote:
> 
> 
> 在 2024/8/19 13:21, Darrick J. Wong 写道:
> > On Mon, Aug 19, 2024 at 08:53:20AM +0800, Zizhi Wo wrote:
> > > In the fsmap query of xfs, there is an interval missing problem:
> > > [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
> > >   EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
> > >     0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
> > >     1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
> > >     2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
> > >     3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
> > >     4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
> > >     5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
> > >     6: 253:16 [104..127]:           free space                          0  (104..127)               24
> > >     ......
> > > 
> > > BUG:
> > > [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
> > > [root@fedora ~]#
> > > Normally, we should be able to get [104, 107), but we got nothing.
> > > 
> > > The problem is caused by shifting. The query for the problem-triggered
> > > scenario is for the missing_owner interval (e.g. freespace in rmapbt/
> > > unknown space in bnobt), which is obtained by subtraction (gap). For this
> > > scenario, the interval is obtained by info->last. However, rec_daddr is
> > > calculated based on the start_block recorded in key[1], which is converted
> > > by calling XFS_BB_TO_FSBT. Then if rec_daddr does not exceed
> > > info->next_daddr, which means keys[1].fmr_physical >> (mp)->m_blkbb_log
> > > <= info->next_daddr, no records will be displayed. In the above example,
> > > 104 >> (mp)->m_blkbb_log = 12 and 107 >> (mp)->m_blkbb_log = 12, so the two
> > > are reduced to 0 and the gap is ignored:
> > > 
> > >   before calculate ----------------> after shifting
> > >   104(st)  107(ed)		      12(st/ed)
> > >    |---------|				  |
> > >    sector size			      block size
> > > 
> > > Resolve this issue by introducing the "end_daddr" field in
> > > xfs_getfsmap_info. This records key[1].fmr_physical at the granularity of
> > > sector. If the current query is the last, the rec_daddr is end_daddr to
> > > prevent missing interval problems caused by shifting. We only need to focus
> > > on the last query, because xfs disks are internally aligned with disk
> > > blocksize that are powers of two and minimum 512, so there is no problem
> > > with shifting in previous queries.
> > > 
> > > After applying this patch, the above problem have been solved:
> > > [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
> > >   EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
> > >     0: 253:16 [104..106]:      free space                        0  (104..106)           3
> > > 
> > > Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> > > Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> > > ---
> > >   fs/xfs/xfs_fsmap.c | 19 ++++++++++++++++++-
> > >   1 file changed, 18 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > > index 3a30b36779db..4734f8d6303c 100644
> > > --- a/fs/xfs/xfs_fsmap.c
> > > +++ b/fs/xfs/xfs_fsmap.c
> > > @@ -162,6 +162,7 @@ struct xfs_getfsmap_info {
> > >   	xfs_daddr_t		next_daddr;	/* next daddr we expect */
> > >   	/* daddr of low fsmap key when we're using the rtbitmap */
> > >   	xfs_daddr_t		low_daddr;
> > > +	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
> > >   	u64			missing_owner;	/* owner of holes */
> > >   	u32			dev;		/* device id */
> > >   	/*
> > > @@ -294,6 +295,19 @@ xfs_getfsmap_helper(
> > >   		return 0;
> > >   	}
> > > +	/*
> > > +	 * For an info->last query, we're looking for a gap between the
> > > +	 * last mapping emitted and the high key specified by userspace.
> > > +	 * If the user's query spans less than 1 fsblock, then
> > > +	 * info->high and info->low will have the same rm_startblock,
> > > +	 * which causes rec_daddr and next_daddr to be the same.
> > > +	 * Therefore, use the end_daddr that we calculated from
> > > +	 * userspace's high key to synthesize the record.  Note that if
> > > +	 * the btree query found a mapping, there won't be a gap.
> > > +	 */
> > > +	if (info->last && info->end_daddr != LLONG_MAX)
> > 
> > XFS_BUF_DADDR_NULL (and yes, I know the rest of the file is wildly
> > inconsistent, I'll send a patch to fix that too...)
> > 
> > --D
> 
> From what I understand, you mean that info->end_daddr is initialized to
> XFS_BUF_DADDR_NULL, correct?
> 
> Then, regarding this specific issue, are you going to propose a fix
> patch to address it, or is the fix patch you mentioned intended to fix
> other file contiguity problems in fsmap? I'm a bit unclear about that.

You change this patch to use XFS_BUF_DADDR_NULL instead of LLONG_MAX,
and then I'll send a followup to fix the other users of -1ULL in
xfs_fsmap.c.

--D

> Thanks,
> Zizhi Wo
> 
> > 
> > > +		rec_daddr = info->end_daddr;
> > > +
> > >   	/* Are we just counting mappings? */
> > >   	if (info->head->fmh_count == 0) {
> > >   		if (info->head->fmh_entries == UINT_MAX)
> > > @@ -946,6 +960,7 @@ xfs_getfsmap(
> > >   	info.next_daddr = head->fmh_keys[0].fmr_physical +
> > >   			  head->fmh_keys[0].fmr_length;
> > > +	info.end_daddr = LLONG_MAX;
> > >   	info.fsmap_recs = fsmap_recs;
> > >   	info.head = head;
> > > @@ -966,8 +981,10 @@ xfs_getfsmap(
> > >   		 * low key, zero out the low key so that we get
> > >   		 * everything from the beginning.
> > >   		 */
> > > -		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
> > > +		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
> > >   			dkeys[1] = head->fmh_keys[1];
> > > +			info.end_daddr = dkeys[1].fmr_physical;
> > > +		}
> > >   		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
> > >   			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
> > > -- 
> > > 2.39.2
> > > 
> > > 
> > 
> 
