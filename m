Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE8F2FDC53;
	Tue, 12 Aug 2025 18:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024901; cv=none; b=N1P4XtXcs4kswGWgv+58bputGQhugPmpRHo5FYSCnzT9AZ62D1R2R0/iCfDWUdeGRgaDJO/9mcFv0xRBxbaXchXTHrQKcoP2tgPdal23vQZrUshKltkw8AhWlkeBmoWNuDvbakmmRn1ODLzEQ8xCJawrJtW+myVgS46K17D4bno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024901; c=relaxed/simple;
	bh=V9sBIR22oHJEEtewmgtnm/kHMIsalxE31RouJZumOBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+zpKdQB8aGzLEGVYvyuM6uzo4GgvF1CG/IydDFBOQUJW5FPCVZa3CBLw+PiuhFxfQAX+5ZRzT8nF6w9t9IgOyoWRndcXJxlySrogaCbDW9Lmxrt+C80IE0HVQcgPQQOyNm1R42X6C+0cGETpowJMBoy1Cy0WYcU08WmwYS3noI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RkO0HD82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkO0HD82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994ADC4CEF0;
	Tue, 12 Aug 2025 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755024900;
	bh=V9sBIR22oHJEEtewmgtnm/kHMIsalxE31RouJZumOBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RkO0HD82lgx4CCFUOX0T7YKJyFv74sC0vy1/GsX5TORxELGebLgqwHrvPDlId29wO
	 uYIgeNGfM2kUsNbg1ypUm9JMSvTBqP1pyr2o5m6eEzAu4UavutTLQLlhASGCdDtkwb
	 xT8SufHKivZ8yIYS8BWhw47HWH+xiMo2GWZcaj/MwcJTakdlhwl9QiijNRNNduj8G+
	 V6PhTwkXj+ci2A73PyZrz9xIksfoYRclJT3SNtE5tj5tlYm/gfCDkP5og4i41OEQ9l
	 rnpSFtLQ9X/58F3yigLhBUB/b7I1CVbvFfCFNKqqTIB74o2lcnA5N9QCxA0d7sbQAh
	 yYTLYA2wf7URg==
Date: Tue, 12 Aug 2025 11:54:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <20250812185459.GB7952@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
 <aIopyOh1TDosDK1m@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIopyOh1TDosDK1m@infradead.org>

On Wed, Jul 30, 2025 at 07:18:48AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 29, 2025 at 01:08:46PM -0700, Darrick J. Wong wrote:
> > The pwrite failure comes from the aio-dio-eof-race.c program because the
> > filesystem ran out of space.  There are no speculative posteof
> > preallocations on a zoned filesystem, so let's skip this test on those
> > setups.
> 
> Did it run out of space because it is overwriting and we need a new
> allocation (I've not actually seen this fail in my zoned testing,
> that's why I'm asking)?  If so it really should be using the new
> _require_inplace_writes Filipe just sent to the list.

I took a deeper look into what's going on here, and I think the
intermittent ENOSPC failures are caused by:

1. First we write to every byte in the 256M zoned rt device so that
   0x55 gets written to the disk.
2. Then we delete the huge file we created.
3. The zoned garbage collector doesn't run.
4. aio-dio-eof-race starts up and initiates an aiodio at pos 0.
5. xfs_file_dio_write_zoned calls xfs_zoned_write_space_reserve
6. xfs_zoned_space_reserve tries to decrement 64k from XC_FREE_RTEXTENTS
   but gets ENOSPC.
7. We didn't pass XFS_ZR_GREEDY, so we error out.

If I make the test sleep until I see zonegc do some work before starting
aio-dio-eof-race, the problem goes away.  I'm not sure what the proper
solution is, but maybe it's adding a wake_up to the gc process and
waiting for it?

diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 1313c55b8cbe51..dfd0384f8e3931 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -223,15 +223,25 @@ xfs_zoned_space_reserve(
        unsigned int                    flags,
        struct xfs_zone_alloc_ctx       *ac)
 {
+       int                             tries = 5;
        int                             error;
 
        ASSERT(ac->reserved_blocks == 0);
        ASSERT(ac->open_zone == NULL);
 
+again:
        error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
                        flags & XFS_ZR_RESERVED);
        if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
                error = xfs_zoned_reserve_extents_greedy(mp, &count_fsb, flags);
+       if (error == -ENOSPC && !(flags & XFS_ZR_GREEDY) && --tries) {
+               struct xfs_zone_info    *zi = mp->m_zone_info;
+
+               xfs_err(mp, "OI ZONEGC %d", tries);
+               wake_up_process(zi->zi_gc_thread);
+               udelay(100);
+               goto again;
+       }
        if (error)
                return error;
 
This fugly patch makes the test failures go away.  On my system we
rarely go below "OI ZONEGC 2" after 100x runs.

> If now we need to figure out what this depends on instead of adding
> random xfs-specific hacks to common code.

<nod> I saw the "this tests speculative posteof preallocations" and
thought that didn't sound like an interesting test on a zoned fs. ;)

--D
