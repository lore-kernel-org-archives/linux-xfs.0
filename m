Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878373A900B;
	Tue, 10 Mar 2026 03:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773115040; cv=none; b=ael1dGqUERjGkb5ZXJZNMoAVdyjhnMZcOOFyOkxlU8D57B0FVmFUrPWVdNIhLtDRzZecrygq7iyr+xmZ3ugivl1Ppo0lyPUJ8xtm54i5sA0XEo8vJrekD+T0emvc2ukTYKBD4qmYDZrNUotg0sXNxBg/egl+cDnZuwmNZ4NtuSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773115040; c=relaxed/simple;
	bh=IjbEklTo5LvRbm8faKaRvrfzXD/Dc9aoP3u4JUtVXbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/KDvN9KDhi8qO79rFF4s6x1R4BBgwsV9miRmfa5KoRlj7Rdr6sPSbhMQkkn0ZMrf8J8yh1LvsJZ6f46IxhCQGaxBkEXTChcT1Na/HUvGgbjP6gmdpBbkvQ+XHt8GY/jlmKXf0FU4QuKON6HxDxY0YlBL98FUBP8GeZktF6CIu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwzSxHxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwzSxHxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10671C19423;
	Tue, 10 Mar 2026 03:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773115040;
	bh=IjbEklTo5LvRbm8faKaRvrfzXD/Dc9aoP3u4JUtVXbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KwzSxHxp/cmSEmHx9QUdse9iMEUg9sh7aKu0+sHUSUK/7Lrf2HOGCRnTaVzpn0t4C
	 JuJSY6do2bJyIOnr6WAs3H1fNFFmkJahun2G2le5eQ8fryNOAv5KHvKPF9C7a1937W
	 jV+ps4jekxKFKBjreeO2VeuO4Wfpqa5gMzENPdZCBSesedrsvdtR7/7YdT5oPalFrs
	 LEfRW5Vl64TLW0tpDRTJ93d0Zdj7l38/Rg78NZ2SMIzo8P2AzMlcQ7EsUuPM91Pyx7
	 3YduepDozPOGe7c9+nRa/PYDQc4ZpsfOpxnTaLQ0QK1MZ6cV3eGgh617E8oD1aqF1b
	 n7kAOd0x2D9AQ==
Date: Mon, 9 Mar 2026 20:57:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, jack@suse.cz,
	Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
	p.raghav@samsung.com, andres@anarazel.de,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] iomap: Enable stable writes for RWF_WRITETHROUGH inodes
Message-ID: <20260310035719.GI1105363@frogsfrogsfrogs>
References: <cover.1773076216.git.ojaswin@linux.ibm.com>
 <3704b81046b11f8b8da0367c7c8ad8767f42e5df.1773076216.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3704b81046b11f8b8da0367c7c8ad8767f42e5df.1773076216.git.ojaswin@linux.ibm.com>

On Mon, Mar 09, 2026 at 11:04:32PM +0530, Ojaswin Mujoo wrote:
> Currently, RWF_WRITETHROUGH writes wait for writeback to complete
> on a folio before performing the writethrough. This serializes
> writethrough with each other and the writeback path. However, it is also
> desirable have similar guarantees between RWF_WRITETHROUGH and non
> writethrough writes.
> 
> Hence, ensure stable writes are enabled on an inode's mapping as
> long as a writethrough write is ongoing. This way, all paths will
> wait for RWF_WRITETHROUGH to complete on a folio before proceeding.
> 
> To track inflight writethrough writes, we use an atomic counter in the
> inode->i_mapping. This struct was chosen because (i) writethrough is an
> operation on the folio and (ii) we don't want to add bloat to struct
> inode.

What if we just set it whenever someone successfully initiates a
RWF_WRITETHROUGH write?  Then we wouldn't need all this atomic counter
machinery.

Also: What if some filesystem (not xfs, obviously) finds a need to
change the stablepages bit while there might be writethrough writes in
progress?  It's a little awkward to have a flag /and/ a counter; why not
change mapping_{set,clear}_stable_pages to inc and dec the counter and
base the test off that?

--D

> Suggested-by: Dave Chinner <dgc@kernel.org>
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  fs/inode.c             |  1 +
>  fs/iomap/buffered-io.c | 35 +++++++++++++++++++++++++++++++++--
>  fs/iomap/direct-io.c   |  2 ++
>  include/linux/fs.h     |  2 ++
>  include/linux/iomap.h  |  2 ++
>  5 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index cc12b68e021b..5b779c112ff8 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -280,6 +280,7 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
>  	mapping->flags = 0;
>  	mapping->wb_err = 0;
>  	atomic_set(&mapping->i_mmap_writable, 0);
> +	atomic_set(&mapping->i_wt_count, 0);
>  #ifdef CONFIG_READ_ONLY_THP_FOR_FS
>  	atomic_set(&mapping->nr_thps, 0);
>  #endif
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index ab169daa1126..9d4d459af1a0 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1150,11 +1150,41 @@ static bool iomap_writethrough_checks(struct kiocb *iocb, size_t off, loff_t len
>  	return true;
>  }
>  
> +/**
> + * inode_writethrough_begin - signal start of a RWF_WRITETHROUGH request
> + * @inode: inode the writethrough happens on
> + *
> + * This is called when we are about to start a writethrough on an inode.
> + * If it is the first writethrough, set the mapping as stable to ensure
> + * other folio operations wait for writeback to finish.
> + *
> + * To avoid a race, just set the mapping stable first and then increment
> + * writethrough count, so that the stable writes are enforced as soon as
> + * writethrough count becomes non zero.
> + */
> +inline void inode_writethrough_begin(struct inode *inode)
> +{
> +	mapping_set_stable_writes(inode->i_mapping);
> +	atomic_inc(&inode->i_mapping->i_wt_count);
> +}
> +
> +/**
> + * inode_writethrough_end - signal finish of a RWF_WRITETHROUGH request
> + * @inode: inode the writethrough I/O happened on
> + *
> + * This is called once we've finished processing a writethrough request
> + */
> +inline void inode_writethrough_end(struct inode *inode)
> +{
> +	if (atomic_dec_and_test(&inode->i_mapping->i_wt_count))
> +		mapping_clear_stable_writes(inode->i_mapping);
> +}
> +
>  /*
>   * With writethrough, we might potentially be writing through a partial
>   * folio hence we don't clear the dirty bit (yet)
>   */
> -static void folio_prepare_writethrough(struct folio *folio)
> +static void folio_prepare_writethrough(struct inode *inode, struct folio *folio)
>  {
>  	if (folio_test_writeback(folio))
>  		folio_wait_writeback(folio);
> @@ -1167,6 +1197,7 @@ static void folio_prepare_writethrough(struct folio *folio)
>  		/* Refer folio_clear_dirty_for_io() for why this is needed */
>  		folio_mark_dirty(folio);
>  
> +	inode_writethrough_begin(inode);
>  }
>  
>  /**
> @@ -1203,7 +1234,7 @@ static int iomap_writethrough_begin(struct kiocb *iocb, struct folio *folio,
>  	bool fully_written;
>  	u64 zero = 0;
>  
> -	folio_prepare_writethrough(folio);
> +	folio_prepare_writethrough(iter->inode, folio);
>  
>  	wt_ctx->bvec = kmalloc(sizeof(struct bio_vec), GFP_KERNEL | GFP_NOFS);
>  	if (!wt_ctx->bvec)
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index f4d8ff08a83a..12680d97d765 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -140,6 +140,8 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  		kiocb_invalidate_post_direct_write(iocb, dio->size);
>  
>  	inode_dio_end(file_inode(iocb->ki_filp));
> +	if (dio->flags & IOMAP_DIO_BUF_WRITETHROUGH)
> +		inode_writethrough_end(file_inode(iocb->ki_filp));
>  
>  	if (ret > 0) {
>  		iocb->ki_pos += ret;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ca291957140e..6b7491fdd51a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -456,6 +456,7 @@ extern const struct address_space_operations empty_aops;
>   *   memory mappings.
>   * @gfp_mask: Memory allocation flags to use for allocating pages.
>   * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
> + * @i_wt_count: Number of RWF_WRITETHROUGH writes ongoing in mapping.
>   * @nr_thps: Number of THPs in the pagecache (non-shmem only).
>   * @i_mmap: Tree of private and shared mappings.
>   * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
> @@ -474,6 +475,7 @@ struct address_space {
>  	struct rw_semaphore	invalidate_lock;
>  	gfp_t			gfp_mask;
>  	atomic_t		i_mmap_writable;
> +	atomic_t		i_wt_count;
>  #ifdef CONFIG_READ_ONLY_THP_FOR_FS
>  	/* number of thp, only for non-shmem files */
>  	atomic_t		nr_thps;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index b96574bb2918..6d08b966ceaf 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -630,6 +630,8 @@ struct iomap_writethrough_ops {
>  ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
>  				      const struct iomap_writethrough_ops *wt_ops,
>  				      void *private);
> +inline void inode_writethrough_begin(struct inode *inode);
> +inline void inode_writethrough_end(struct inode *inode);
>  
>  #ifdef CONFIG_SWAP
>  struct file;
> -- 
> 2.52.0
> 
> 
