Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5421D1CD38
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440208; cv=none; b=U65lRzdld5MpiT3eieS1mSq1h5WNe2uI0VaP1aXctinoAAzHJCG08Y1tjkp9eSADbyXWGJnP30zDFxWziMyjdq8U0IQn6L5v18H8bhIv/2WcHLPXugdAhkkgeGy8FKwkfItK26ZmM/dyXn4VKu0KA1r+5pQE+hpOefd3YXV0TRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440208; c=relaxed/simple;
	bh=QfheUm6tJvHKtFgZwcvTF+AHvx8QfAmivuJF5HapDVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1KJD69LVEdjc7K5PZYvEIeCc3tBZxRYEwADISCdYdxitx3zMP7JtTS8qGntceXmEUg4wPMLTiujBPTwFIyf335ZCQUELTFHUBz3dyEYfs7Q0CjvxMH9AUGsU8YXJ3eiwenAUpdRXYrWA/iOcNC6BhguNy4N4F7MNqcW9Wvz5cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EP46DdC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EP46DdC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C1FC2BD10;
	Mon,  3 Jun 2024 18:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440207;
	bh=QfheUm6tJvHKtFgZwcvTF+AHvx8QfAmivuJF5HapDVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EP46DdC1b35x0QnVxtNgkLULg8kTPTprlZv86ZOn7h0VvLy+XsB2Lp/DYBXwBVSsA
	 MwspzTyWOErohMfsL5iz0GhUWlx2d6ERoerx1/yO27M2Vx2mc9IiVEEmlpQSQ1U6/b
	 bwVbRPCWEVnzXj+0fLKx32wtuoZ1DEunkTyCaSkUutUfAlUYk7RfXZrSwEBFOdIbAs
	 YkffRXthA89ioTrSTVmVwriNJT8axST7r0obDbVSrozAhlE/6ITKWMwZVqr1RzGpFi
	 PnFUF7g3gqlyO0oQpJVDl6O/m53CDqc0r3VU1LpwsHjtWKyVClR9eA/cwKEG6h1CeE
	 h8FnGyQTu2BoQ==
Date: Mon, 3 Jun 2024 11:43:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Message-ID: <20240603184327.GC52987@frogsfrogsfrogs>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
 <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
 <AEBF87C7-89D5-47B7-A01E-B5C165D56D8C@oracle.com>
 <A9F20047-4AD8-419F-9386-26C4ED281E29@oracle.com>
 <Zl0CKi9d34ci0fEh@dread.disaster.area>
 <39E20DD5-EDB2-4239-B6EE-237B228845F5@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39E20DD5-EDB2-4239-B6EE-237B228845F5@oracle.com>

On Mon, Jun 03, 2024 at 05:23:40PM +0000, Wengang Wang wrote:
> 
> 
> > On Jun 2, 2024, at 4:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Fri, May 31, 2024 at 03:44:56PM +0000, Wengang Wang wrote:
> >> Hi Dave,
> >> 
> >> Do you have further comments and/or suggestions? Or give a RB pls :D
> > 
> > Sorry, LSFMM intervened and I didn't notice your comment until now.
> > 
> No worries!
> 
> >>> On May 13, 2024, at 10:06 AM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> >>> 
> >>> Things is that we have a metadump, looking at the fdblocks from super block 0, it is good.
> >>> 
> >>> $ xfs_db -c "sb 0" -c "p" cust.img |egrep "dblocks|ifree|icount"
> >>> dblocks = 26214400
> >>> icount = 512
> >>> ifree = 337
> >>> fdblocks = 25997100
> >>> 
> >>> And when looking at the log, we have the following:
> >>> 
> >>> $ egrep -a "fdblocks|icount|ifree" cust.log |tail
> >>> sb_fdblocks 37
> >>> sb_icount 1056
> >>> sb_ifree 87
> >>> sb_fdblocks 37
> >>> sb_icount 1056
> >>> sb_ifree 87
> >>> sb_fdblocks 37
> >>> sb_icount 1056
> >>> sb_ifree 87
> >>> sb_fdblocks 18446744073709551604
> >>> 
> >>> # cust.log is output of my script which tries to parse the log buffer.
> >>> 
> >>> 18446744073709551604ULL == 0xfffffffffffffff4 or -12LL 
> >>> 
> >>> With upstream kernel (6.7.0-rc3), when I tried to mount (log recover) the metadump,
> >>> I got the following in dmesg:
> >>> 
> >>> [   52.927796] XFS (loop0): SB summary counter sanity check failed
> >>> [   52.928889] XFS (loop0): Metadata corruption detected at xfs_sb_write_verify+0x60/0x110 [xfs], xfs_sb block 0x0
> >>> [   52.930890] XFS (loop0): Unmount and run xfs_repair
> >>> [   52.931797] XFS (loop0): First 128 bytes of corrupted metadata buffer:
> >>> [   52.932954] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
> >>> [   52.934333] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>> [   52.935733] 00000020: c9 c1 ed ae 84 ed 46 b9 a1 f0 09 57 4a a9 98 42  ......F....WJ..B
> >>> [   52.937120] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
> >>> [   52.938515] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> >>> [   52.939919] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
> >>> [   52.941293] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
> >>> [   52.942661] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
> >>> [   52.944046] XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply+0x38b/0x3a0 [xfs] (fs/xfs/xfs_buf.c:1559).  Shutting down filesystem.
> >>> [   52.946710] XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> >>> [   52.948099] XFS (loop0): log mount/recovery failed: error -117
> >>> [   52.949810] XFS (loop0): log mount failed
> > 
> > And that's what should be in the commit message, as it explains
> > exactly how the problem occurred, the symptom that was seen, and
> > why the change is necessary. It also means that anyone else who sees
> > a similar problem and is grepping the commit history will see this
> > and recognise it, thereby knowing that this is the fix they need...
> > 
> 
> OK, got it.
> 
> >>> Looking at corresponding code:
> >>> 231 xfs_validate_sb_write(
> >>> 232         struct xfs_mount        *mp,
> >>> 233         struct xfs_buf          *bp,
> >>> 234         struct xfs_sb           *sbp)
> >>> 235 {
> >>> 236         /*
> >>> 237          * Carry out additional sb summary counter sanity checks when we write
> >>> 238          * the superblock.  We skip this in the read validator because there
> >>> 239          * could be newer superblocks in the log and if the values are garbage
> >>> 240          * even after replay we'll recalculate them at the end of log mount.
> >>> 241          *
> >>> 242          * mkfs has traditionally written zeroed counters to inprogress and
> >>> 243          * secondary superblocks, so allow this usage to continue because
> >>> 244          * we never read counters from such superblocks.
> >>> 245          */
> >>> 246         if (xfs_buf_daddr(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
> >>> 247             (sbp->sb_fdblocks > sbp->sb_dblocks ||
> >>> 248              !xfs_verify_icount(mp, sbp->sb_icount) ||
> >>> 249              sbp->sb_ifree > sbp->sb_icount)) {
> >>> 250                 xfs_warn(mp, "SB summary counter sanity check failed");
> >>> 251                 return -EFSCORRUPTED;
> >>> 252         }
> >>> 
> >>> From dmesg and code, we know the check failure was due to bad sb_ifree vs sb_icount or bad sb_fdblocks vs sb_dblocks.
> >>> 
> >>> Looking at the super block dump and log dump,
> >>> We know ifree and icount are good, what’s bad is sb_fdblocks. And that sb_fdblocks is from log.
> >>> # I verified that sb_fdblocks is 0xfffffffffffffff4 with a UEK debug kernel (though not 6.7.0-rc3)
> >>> 
> >>> So the sb_fdblocks is updated from log to incore at xfs_log_sb() -> xfs_validate_sb_write() path though
> >>> Should be may re-calculated from AGs.
> >>> 
> >>> The fix aims to make xfs_validate_sb_write() happy.
> > 
> > What about the sb_icount and sb_ifree counters? They are also percpu
> > counters, and they can return transient negative numbers, too,
> > right? If they end up in the log, the same as this transient
> > negative sb_fdblocks count, won't that also cause exactly the same
> > issue?
> > 
> 
> Yes, sb_icount and sb_ifree are also percpu counters. They have been addressed by
> commit 59f6ab40fd8735c9a1a15401610a31cc06a0bbd6, right?

icount and ifree don't go through xfs_mod_freecounter, which means that
they never do the "subtract and see if we went negative" dance that
fdblocks/frextents does.  percpu_counter_sum_positive isn't necessary.

--D

> > i.e. if we need to fix the sb_fdblocks sum to always be positive,
> > then we need to do the same thing with the other lazy superblock
> > per-cpu counters so they don't trip the over the same transient
> > underflow issue...
> > 
> 
> Agreed. While, I think we don’t have further percpu counters problems after this patch.  
> 
> Will send a new patch with line breakness.
> 
> Thanks,
> Wengang
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
