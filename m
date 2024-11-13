Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3391FF7BA
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 11:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498001; cv=none; b=PnlY95SzSqYP77btrnW/bTS/As2v4CaZ6Ys0faRnkUNnXVANXhNo1Pd8zS46jKOZIncCtRpu9Z/c2GKSqx5INwqyVqJDgbhNSwnXI+zzaDUNeN0elSyV3oATACfWfxx9OmylrkXMKi/vgyKBSvnrmLzG5so4NXYKh+X4on1cWjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498001; c=relaxed/simple;
	bh=5RzY9aiDp6KubKx2azcuF+/fe1WNvzs1qMq8kIPEoXw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMF6k6o7qooUf8vprxHNCz7L1nSNoh/oV0rjsaP04fRAlFfR3BddsA5u15MXIjgdsF6iIYzaOs8spDXmOuLJLRywc3S76910Zq/q6OiuHk5zBGbqBXXgHIldg2fFQE5ZGQmV/rGGiICOZ1JyNOXA+W8JzyWgKxiyziTri8JgeO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XpLrp0V76z21kG5;
	Wed, 13 Nov 2024 19:38:34 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 9ECFA1A0188;
	Wed, 13 Nov 2024 19:39:48 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Nov
 2024 19:39:48 +0800
Date: Wed, 13 Nov 2024 19:38:35 +0800
From: Long Li <leo.lilong@huawei.com>
To: Carlos Maiolino <cem@kernel.org>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzSPuw572D2Pi4Tm@localhost.localdomain>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <w4k3mpaiidxrzbbv3pfi3rilea32cm4r577bgkpq4jfm7rrg3k@zyhssogtpsmq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <w4k3mpaiidxrzbbv3pfi3rilea32cm4r577bgkpq4jfm7rrg3k@zyhssogtpsmq>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Wed, Nov 13, 2024 at 10:44:08AM +0100, Carlos Maiolino wrote:
> On Wed, Nov 13, 2024 at 05:19:06PM +0800, Long Li wrote:
> > During concurrent append writes to XFS filesystem, zero padding data
> > may appear in the file after power failure. This happens due to imprecise
> > disk size updates when handling write completion.
> > 
> > Consider this scenario with concurrent append writes same file:
> > 
> >   Thread 1:                  Thread 2:
> >   ------------               -----------
> >   write [A, A+B]
> >   update inode size to A+B
> >   submit I/O [A, A+BS]
> >                              write [A+B, A+B+C]
> >                              update inode size to A+B+C
> >   <I/O completes, updates disk size to A+B+C>
> >   <power failure>
> > 
> > After reboot, file has zero padding in range [A+B, A+B+C]:
> > 
> >   |<         Block Size (BS)      >|
> >   |DDDDDDDDDDDDDDDD0000000000000000|
> >   ^               ^        ^
> >   A              A+B      A+B+C (EOF)
> > 
> >   D = Valid Data
> >   0 = Zero Padding
> > 
> > The issue stems from disk size being set to min(io_offset + io_size,
> > inode->i_size) at I/O completion. Since io_offset+io_size is block
> > size granularity, it may exceed the actual valid file data size. In
> > the case of concurrent append writes, inode->i_size may be larger
> > than the actual range of valid file data written to disk, leading to
> > inaccurate disk size updates.
> > 
> > This patch changes the meaning of io_size to represent the size of
> > valid data in ioend, while the extent size of ioend can be obtained
> > by rounding up based on block size. It ensures more precise disk
> > size updates and avoids the zero padding issue.  Another benefit is
> > that it makes the xfs_ioend_is_append() check more accurate, which
> > can reduce unnecessary end bio callbacks of xfs_end_bio() in certain
> > scenarios, such as repeated writes at the file tail without extending
> > the file size.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> 
> 
> How does this differs from V1? Please, if you are sending a new version, add the
> changes you've made since the previous one, so nobody needs to keep comparing
> both.
> 
> Carlos
>  

Thank you for pointing these out. I missed the change information from
v1 to v2. I will be more careful to avoid such omissions in the future.
Let me add it:

V1->V2: Changed the meaning of io_size to record the length of valid data,
        instead of introducing an additional member io_end. This results
	in fewer code changes.

> > ---
> >  fs/iomap/buffered-io.c | 21 +++++++++++++++------
> >  include/linux/iomap.h  |  7 ++++++-
> >  2 files changed, 21 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index ce73d2a48c1e..a2a75876cda6 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1599,6 +1599,8 @@ EXPORT_SYMBOL_GPL(iomap_finish_ioends);
> >  static bool
> >  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> >  {
> > +	size_t size = iomap_ioend_extent_size(ioend);
> > +
> >  	if (ioend->io_bio.bi_status != next->io_bio.bi_status)
> >  		return false;
> >  	if ((ioend->io_flags & IOMAP_F_SHARED) ^
> > @@ -1607,7 +1609,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> >  	if ((ioend->io_type == IOMAP_UNWRITTEN) ^
> >  	    (next->io_type == IOMAP_UNWRITTEN))
> >  		return false;
> > -	if (ioend->io_offset + ioend->io_size != next->io_offset)
> > +	if (ioend->io_offset + size != next->io_offset)
> >  		return false;
> >  	/*
> >  	 * Do not merge physically discontiguous ioends. The filesystem
> > @@ -1619,7 +1621,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> >  	 * submission so does not point to the start sector of the bio at
> >  	 * completion.
> >  	 */
> > -	if (ioend->io_sector + (ioend->io_size >> 9) != next->io_sector)
> > +	if (ioend->io_sector + (size >> 9) != next->io_sector)
> >  		return false;
> >  	return true;
> >  }
> > @@ -1636,7 +1638,7 @@ iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends)
> >  		if (!iomap_ioend_can_merge(ioend, next))
> >  			break;
> >  		list_move_tail(&next->io_list, &ioend->io_list);
> > -		ioend->io_size += next->io_size;
> > +		ioend->io_size = iomap_ioend_extent_size(ioend) + next->io_size;
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(iomap_ioend_try_merge);
> > @@ -1736,7 +1738,7 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos)
> >  		return false;
> >  	if (wpc->iomap.type != wpc->ioend->io_type)
> >  		return false;
> > -	if (pos != wpc->ioend->io_offset + wpc->ioend->io_size)
> > +	if (pos != wpc->ioend->io_offset + iomap_ioend_extent_size(wpc->ioend))
> >  		return false;
> >  	if (iomap_sector(&wpc->iomap, pos) !=
> >  	    bio_end_sector(&wpc->ioend->io_bio))
> > @@ -1768,6 +1770,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
> >  {
> >  	struct iomap_folio_state *ifs = folio->private;
> >  	size_t poff = offset_in_folio(folio, pos);
> > +	loff_t isize = i_size_read(inode);
> > +	struct iomap_ioend *ioend;
> >  	int error;
> >  
> >  	if (!wpc->ioend || !iomap_can_add_to_ioend(wpc, pos)) {
> > @@ -1778,12 +1782,17 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
> >  		wpc->ioend = iomap_alloc_ioend(wpc, wbc, inode, pos);
> >  	}
> >  
> > -	if (!bio_add_folio(&wpc->ioend->io_bio, folio, len, poff))
> > +	ioend = wpc->ioend;
> > +	if (!bio_add_folio(&ioend->io_bio, folio, len, poff))
> >  		goto new_ioend;
> >  
> >  	if (ifs)
> >  		atomic_add(len, &ifs->write_bytes_pending);
> > -	wpc->ioend->io_size += len;
> > +
> > +	ioend->io_size = iomap_ioend_extent_size(ioend) + len;
> > +	if (ioend->io_offset + ioend->io_size > isize)
> > +		ioend->io_size = isize - ioend->io_offset;
> > +
> >  	wbc_account_cgroup_owner(wbc, folio, len);
> >  	return 0;
> >  }
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index f61407e3b121..2984eccfa213 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -330,7 +330,7 @@ struct iomap_ioend {
> >  	u16			io_type;
> >  	u16			io_flags;	/* IOMAP_F_* */
> >  	struct inode		*io_inode;	/* file being written to */
> > -	size_t			io_size;	/* size of the extent */
> > +	size_t			io_size;	/* size of valid data */
> >  	loff_t			io_offset;	/* offset in the file */
> >  	sector_t		io_sector;	/* start sector of ioend */
> >  	struct bio		io_bio;		/* MUST BE LAST! */
> > @@ -341,6 +341,11 @@ static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
> >  	return container_of(bio, struct iomap_ioend, io_bio);
> >  }
> >  
> > +static inline size_t iomap_ioend_extent_size(struct iomap_ioend *ioend)
> > +{
> > +	return round_up(ioend->io_size, i_blocksize(ioend->io_inode));
> > +}
> > +
> >  struct iomap_writeback_ops {
> >  	/*
> >  	 * Required, maps the blocks so that writeback can be performed on
> > -- 
> > 2.39.2
> > 
> 
