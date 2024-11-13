Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8701E4C81
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 12:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731502591; cv=none; b=Q7b17Yv208YnBVxdD62ivC6KYVl+xnPjbHt78V90DqjzmjdTZjuvbjoqWsB+Itkk44H0EQ0BqK0sWYBLzxE9k+9jQ5VGjwAquOVJa3U0kSrE+Ze21lLJJ00/lFi3z8UjEHmvEfGKcXwk/iFw8JUrzM1fTOs77wW/fE5elGqLMT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731502591; c=relaxed/simple;
	bh=h2cFVtiks4HjbxfgNM7/lN0FN2jvC+qyf0C7URYZ5AY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osDiiuv1m4dqdiupbe0FEdBeB7VkAyReh+9DTsu8rVyrCCsH/9YdS7p9myncIDzfRkR1k+t918+ZhPBo0CiPbIJUvYwRktz2UqXQnDr0oJKj8Sc6jQnmC3tDYS5M4OeRqeS47TZr9aBYt93ewkd/AVwX34azYDHA5yUJZtcuWRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGJfEIC3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGJfEIC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02BBC4CECD;
	Wed, 13 Nov 2024 12:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731502591;
	bh=h2cFVtiks4HjbxfgNM7/lN0FN2jvC+qyf0C7URYZ5AY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TGJfEIC3WzMKiZi9Vu9xD7ZvHZxmmENcyiEji/hYJF6M4I6BMzKRdRQQP9E0plzME
	 bD53ida4dKwIUuW0Twms5mSSiPjwmU0zMtNYZFrus+YqNOFkeKBlMM5hl7mju39kof
	 qzJVSX3JIhJmbjlomIvlsQWEdBn13Hs4Kh9cTG3mtP2QN2owpN0UBPBKc3vWnx+Bl8
	 U5+PN2BljP/FaEZZ7tAw1/USvZKGh1MFIB6WkCq1Api/8hBR8+ws0zDWokbKSrD1y7
	 hf9frVSvoFRy6WBwsN+4ojgqb6/SgTBm5UmAs1gwLHQFMqEvEZ6mOuSNRfZ0qyqvCa
	 WrbCeW4odNKVg==
Date: Wed, 13 Nov 2024 13:56:25 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org, 
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <atzsisjwt76y3oshdgq6ggjc22i3uo2q7lefoe2x4z4um6zpnx@ydyzgv4uwudi>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <w4k3mpaiidxrzbbv3pfi3rilea32cm4r577bgkpq4jfm7rrg3k@zyhssogtpsmq>
 <ZzSPuw572D2Pi4Tm@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzSPuw572D2Pi4Tm@localhost.localdomain>

On Wed, Nov 13, 2024 at 07:38:35PM +0800, Long Li wrote:
> On Wed, Nov 13, 2024 at 10:44:08AM +0100, Carlos Maiolino wrote:
> > On Wed, Nov 13, 2024 at 05:19:06PM +0800, Long Li wrote:
> > > During concurrent append writes to XFS filesystem, zero padding data
> > > may appear in the file after power failure. This happens due to imprecise
> > > disk size updates when handling write completion.
> > > 
> > > Consider this scenario with concurrent append writes same file:
> > > 
> > >   Thread 1:                  Thread 2:
> > >   ------------               -----------
> > >   write [A, A+B]
> > >   update inode size to A+B
> > >   submit I/O [A, A+BS]
> > >                              write [A+B, A+B+C]
> > >                              update inode size to A+B+C
> > >   <I/O completes, updates disk size to A+B+C>
> > >   <power failure>
> > > 
> > > After reboot, file has zero padding in range [A+B, A+B+C]:
> > > 
> > >   |<         Block Size (BS)      >|
> > >   |DDDDDDDDDDDDDDDD0000000000000000|
> > >   ^               ^        ^
> > >   A              A+B      A+B+C (EOF)
> > > 
> > >   D = Valid Data
> > >   0 = Zero Padding
> > > 
> > > The issue stems from disk size being set to min(io_offset + io_size,
> > > inode->i_size) at I/O completion. Since io_offset+io_size is block
> > > size granularity, it may exceed the actual valid file data size. In
> > > the case of concurrent append writes, inode->i_size may be larger
> > > than the actual range of valid file data written to disk, leading to
> > > inaccurate disk size updates.
> > > 
> > > This patch changes the meaning of io_size to represent the size of
> > > valid data in ioend, while the extent size of ioend can be obtained
> > > by rounding up based on block size. It ensures more precise disk
> > > size updates and avoids the zero padding issue.  Another benefit is
> > > that it makes the xfs_ioend_is_append() check more accurate, which
> > > can reduce unnecessary end bio callbacks of xfs_end_bio() in certain
> > > scenarios, such as repeated writes at the file tail without extending
> > > the file size.
> > > 
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > 
> > 
> > How does this differs from V1? Please, if you are sending a new version, add the
> > changes you've made since the previous one, so nobody needs to keep comparing
> > both.
> > 
> > Carlos
> >  
> 
> Thank you for pointing these out. I missed the change information from
> v1 to v2. I will be more careful to avoid such omissions in the future.
> Let me add it:
> 
> V1->V2: Changed the meaning of io_size to record the length of valid data,
>         instead of introducing an additional member io_end. This results
> 	in fewer code changes.

Thanks!

Carlos

> 
> > > ---
> > >  fs/iomap/buffered-io.c | 21 +++++++++++++++------
> > >  include/linux/iomap.h  |  7 ++++++-
> > >  2 files changed, 21 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > index ce73d2a48c1e..a2a75876cda6 100644
> > > --- a/fs/iomap/buffered-io.c
> > > +++ b/fs/iomap/buffered-io.c
> > > @@ -1599,6 +1599,8 @@ EXPORT_SYMBOL_GPL(iomap_finish_ioends);
> > >  static bool
> > >  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> > >  {
> > > +	size_t size = iomap_ioend_extent_size(ioend);
> > > +
> > >  	if (ioend->io_bio.bi_status != next->io_bio.bi_status)
> > >  		return false;
> > >  	if ((ioend->io_flags & IOMAP_F_SHARED) ^
> > > @@ -1607,7 +1609,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> > >  	if ((ioend->io_type == IOMAP_UNWRITTEN) ^
> > >  	    (next->io_type == IOMAP_UNWRITTEN))
> > >  		return false;
> > > -	if (ioend->io_offset + ioend->io_size != next->io_offset)
> > > +	if (ioend->io_offset + size != next->io_offset)
> > >  		return false;
> > >  	/*
> > >  	 * Do not merge physically discontiguous ioends. The filesystem
> > > @@ -1619,7 +1621,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> > >  	 * submission so does not point to the start sector of the bio at
> > >  	 * completion.
> > >  	 */
> > > -	if (ioend->io_sector + (ioend->io_size >> 9) != next->io_sector)
> > > +	if (ioend->io_sector + (size >> 9) != next->io_sector)
> > >  		return false;
> > >  	return true;
> > >  }
> > > @@ -1636,7 +1638,7 @@ iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends)
> > >  		if (!iomap_ioend_can_merge(ioend, next))
> > >  			break;
> > >  		list_move_tail(&next->io_list, &ioend->io_list);
> > > -		ioend->io_size += next->io_size;
> > > +		ioend->io_size = iomap_ioend_extent_size(ioend) + next->io_size;
> > >  	}
> > >  }
> > >  EXPORT_SYMBOL_GPL(iomap_ioend_try_merge);
> > > @@ -1736,7 +1738,7 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos)
> > >  		return false;
> > >  	if (wpc->iomap.type != wpc->ioend->io_type)
> > >  		return false;
> > > -	if (pos != wpc->ioend->io_offset + wpc->ioend->io_size)
> > > +	if (pos != wpc->ioend->io_offset + iomap_ioend_extent_size(wpc->ioend))
> > >  		return false;
> > >  	if (iomap_sector(&wpc->iomap, pos) !=
> > >  	    bio_end_sector(&wpc->ioend->io_bio))
> > > @@ -1768,6 +1770,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
> > >  {
> > >  	struct iomap_folio_state *ifs = folio->private;
> > >  	size_t poff = offset_in_folio(folio, pos);
> > > +	loff_t isize = i_size_read(inode);
> > > +	struct iomap_ioend *ioend;
> > >  	int error;
> > >  
> > >  	if (!wpc->ioend || !iomap_can_add_to_ioend(wpc, pos)) {
> > > @@ -1778,12 +1782,17 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
> > >  		wpc->ioend = iomap_alloc_ioend(wpc, wbc, inode, pos);
> > >  	}
> > >  
> > > -	if (!bio_add_folio(&wpc->ioend->io_bio, folio, len, poff))
> > > +	ioend = wpc->ioend;
> > > +	if (!bio_add_folio(&ioend->io_bio, folio, len, poff))
> > >  		goto new_ioend;
> > >  
> > >  	if (ifs)
> > >  		atomic_add(len, &ifs->write_bytes_pending);
> > > -	wpc->ioend->io_size += len;
> > > +
> > > +	ioend->io_size = iomap_ioend_extent_size(ioend) + len;
> > > +	if (ioend->io_offset + ioend->io_size > isize)
> > > +		ioend->io_size = isize - ioend->io_offset;
> > > +
> > >  	wbc_account_cgroup_owner(wbc, folio, len);
> > >  	return 0;
> > >  }
> > > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > > index f61407e3b121..2984eccfa213 100644
> > > --- a/include/linux/iomap.h
> > > +++ b/include/linux/iomap.h
> > > @@ -330,7 +330,7 @@ struct iomap_ioend {
> > >  	u16			io_type;
> > >  	u16			io_flags;	/* IOMAP_F_* */
> > >  	struct inode		*io_inode;	/* file being written to */
> > > -	size_t			io_size;	/* size of the extent */
> > > +	size_t			io_size;	/* size of valid data */
> > >  	loff_t			io_offset;	/* offset in the file */
> > >  	sector_t		io_sector;	/* start sector of ioend */
> > >  	struct bio		io_bio;		/* MUST BE LAST! */
> > > @@ -341,6 +341,11 @@ static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
> > >  	return container_of(bio, struct iomap_ioend, io_bio);
> > >  }
> > >  
> > > +static inline size_t iomap_ioend_extent_size(struct iomap_ioend *ioend)
> > > +{
> > > +	return round_up(ioend->io_size, i_blocksize(ioend->io_inode));
> > > +}
> > > +
> > >  struct iomap_writeback_ops {
> > >  	/*
> > >  	 * Required, maps the blocks so that writeback can be performed on
> > > -- 
> > > 2.39.2
> > > 
> > 
> 
