Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8120D28E7;
	Tue, 21 May 2024 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309395; cv=none; b=Gy7RMpDr+/+SqYdkyt3iaTm1FLK6fK1KYu7j7YXUR7kDpKOYRsll/6YhQmRpyI1P2FM5jCpW9KOIFNvHIyQyuqa0Md/uQDzvYtrcoSesup5+gvOjdzxclq5A7wtQ2osb4CKxnJsEH+nYuseyA63NXWoaiz8nejpuL8TJi5omfUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309395; c=relaxed/simple;
	bh=vMZm4QoQ1oag7g+ltwfiBTYUO50A7cQ8XG7QVfZE1a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AX0EdifCz9U8H1n4yO9m+TrEgyQNUuA0s8WbD+xVE19sAARaMfh41hyBSGmQuJx0ocIr9QI4oe9Y9qdzEzggvY2+0uGq6SIfc36nykdFJr/VxYEm6ACmj8gOpLle/ZGwxuIXVRUqzC7czBzSTWQHn+idP4OtV8/erITODYXdY9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sfqYPtUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sfqYPtUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC66C2BD11;
	Tue, 21 May 2024 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716309395;
	bh=vMZm4QoQ1oag7g+ltwfiBTYUO50A7cQ8XG7QVfZE1a0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sfqYPtUNw239+WsbshczqJlLkiVO9cggY4XamqX0V5IfDh94j4SGiWhg+OG96wwZ0
	 v4tQpepbfGp7D2c9mbR5S9M/J3YySJvYIatgGKY+KZO+c2FT1lnsCO0RgH5EvNKlRy
	 4f4fCEXmhBAYGun1JDjYaaXNmdW7PhUd6k0NMszo1jZm+T/Spy6Vpvj6RO3w6jnfph
	 nZoVecJujEnWniqqZVnA+ABdmArFBZ4kUrtPnoNKxYye0EFznNWjAwtywgspJaqBf3
	 KLc1zIuxyFxT/vVJGlrNi648uJRPR+q3t6Q9xdlGVyd7VlX2fAJOuY9/Gu20HfABR4
	 bAsObcqz8hUYQ==
Date: Tue, 21 May 2024 09:36:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Daniel Gomez <da.gomez@samsung.com>
Cc: "hughd@google.com" <hughd@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	"dagmcr@gmail.com" <dagmcr@gmail.com>,
	"yosryahmed@google.com" <yosryahmed@google.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"chandan.babu@oracle.com" <chandan.babu@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"brauner@kernel.org" <brauner@kernel.org>
Subject: Re: [PATCH 11/12] shmem: add file length arg in shmem_get_folio()
 path
Message-ID: <20240521163634.GT25518@frogsfrogsfrogs>
References: <20240515055719.32577-1-da.gomez@samsung.com>
 <CGME20240515055738eucas1p15335a32c790b731aa5857193bbddf92d@eucas1p1.samsung.com>
 <20240515055719.32577-12-da.gomez@samsung.com>
 <20240517161741.GY360919@frogsfrogsfrogs>
 <65qj4iqgdzebrg5cqwaocjzswenzzgoifdnewrhoipieqi3d5v@bxxupemsgsbs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65qj4iqgdzebrg5cqwaocjzswenzzgoifdnewrhoipieqi3d5v@bxxupemsgsbs>

On Tue, May 21, 2024 at 11:38:33AM +0000, Daniel Gomez wrote:
> On Fri, May 17, 2024 at 09:17:41AM -0700, Darrick J. Wong wrote:
> > On Wed, May 15, 2024 at 05:57:36AM +0000, Daniel Gomez wrote:
> > > In preparation for large folio in the write and fallocate paths, add
> > > file length argument in shmem_get_folio() path to be able to calculate
> > > the folio order based on the file size. Use of order-0 (PAGE_SIZE) for
> > > read, page cache read, and vm fault.
> > > 
> > > This enables high order folios in the write and fallocate path once the
> > > folio order is calculated based on the length.
> > > 
> > > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > > ---
> > >  fs/xfs/scrub/xfile.c     |  6 +++---
> > >  fs/xfs/xfs_buf_mem.c     |  3 ++-
> > >  include/linux/shmem_fs.h |  2 +-
> > >  mm/khugepaged.c          |  3 ++-
> > >  mm/shmem.c               | 35 ++++++++++++++++++++---------------
> > >  mm/userfaultfd.c         |  2 +-
> > >  6 files changed, 29 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> > > index 8cdd863db585..4905f5e4cb5d 100644
> > > --- a/fs/xfs/scrub/xfile.c
> > > +++ b/fs/xfs/scrub/xfile.c
> > > @@ -127,7 +127,7 @@ xfile_load(
> > >  		unsigned int	offset;
> > >  
> > >  		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> > > -				SGP_READ) < 0)
> > > +				SGP_READ, PAGE_SIZE) < 0)
> > 
> > I suppose I /did/ say during LSFMM that for the current users of xfile.c
> > and xfs_buf_mem.c the order of the folio being returned doesn't really
> I not sure if I understood you well. Could you please elaborate on this?

Yes, I'll restate what I said in the session last week for those who
weren't there:

Currently, xfile.c and xfs_buf_mem.c are only used by online repair to
stage a recordset while rebuilding an ondisk btree index.  IOWs, they're
ephemeral, so we don't care or need to optimize folio sizing.  Some day
they might be adapted for longer-term usage though, so we might as well
try not to leave too many papercuts.

xfs_buf_mem.c creates in-memory btrees that mimic the ondisk btrees,
albeit with blocksize == PAGE_SIZE, regardless of the fs blocksize.
For this case we probably aren't ever going to care about large folios.

xfile.c is currently used to store fixed-size recordsets, names for
rebuilding directories, and name/value pairs for rebuilding xattr
structures.  Records aren't allowed to be larger than PAGE_SIZE, names
cannot be larger than MAXNAMELEN (255), and xattr values can't be larger
than 64k.

For that last case maybe it might be nice to get a large folio to reduce
processing overhead, but huge xattrs aren't that common.

> > matter, but why wouldn't the last argument here be "roundup_64(count,
> > PAGE_SIZE)" ?  Shouldn't we at least hint to the page cache about the
> > folio order that we actually want instead of limiting it to order-0?
> 
> For v2, I'll include your suggestions. I think we can also enable large folios
> in xfile_get_folio(), please check below:
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 8cdd863db585..df8b495b4939 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -127,7 +127,7 @@ xfile_load(
>                 unsigned int    offset;
> 
>                 if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> -                               SGP_READ) < 0)
> +                               SGP_READ, roundup_64(count, PAGE_SIZE)) < 0)
>                         break;
>                 if (!folio) {
>                         /*
> @@ -197,7 +197,7 @@ xfile_store(
>                 unsigned int    offset;
> 
>                 if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> -                               SGP_CACHE) < 0)
> +                               SGP_CACHE, roundup_64(count, PAGE_SIZE)) < 0)
>                         break;
>                 if (filemap_check_wb_err(inode->i_mapping, 0)) {
>                         folio_unlock(folio);
> @@ -268,7 +268,8 @@ xfile_get_folio(
> 
>         pflags = memalloc_nofs_save();
>         error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> -                       (flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
> +                       (flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ,
> +                       roundup_64(i_size_read(inode), PAGE_SIZE));

I'm not sure why you picked i_size_read here; the xfile could be several
gigabytes long.  xfile_get_folio want to look at a subset of the xfile,
not all of it.

roundup_64(len, PAGE_SIZE) perhaps?

Also, should the rounding be done inside the shmem code so that callers
don't have to know about that detail?

>         memalloc_nofs_restore(pflags);
>         if (error)
>                 return ERR_PTR(error);
> 
> > 
> > (Also it seems a little odd to me that the @index is in units of pgoff_t
> > but @len is in bytes.)
> 
> I extended the shmem_get_folio() with @len to calculate folio order based on
> size (bytes). This is sent to ilog2() although I'm planning to use get_order()
> instead (after fixing the issues mentioned during the discussion). @index is
> used for __ffs() (same as in filemap).
> 
> Would you use lofft for @len instead? Or what's your suggestion?

I was reacting to @index, not @len.  I might've shifted @index to
"loff_t pos" but looking at the existing callsites it doesn't seem worth
the churn.

--D

> Thanks,
> Daniel
> 
> > 
> > >  			break;
> > >  		if (!folio) {
> > >  			/*
> > > @@ -197,7 +197,7 @@ xfile_store(
> > >  		unsigned int	offset;
> > >  
> > >  		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> > > -				SGP_CACHE) < 0)
> > > +				SGP_CACHE, PAGE_SIZE) < 0)
> > >  			break;
> > >  		if (filemap_check_wb_err(inode->i_mapping, 0)) {
> > >  			folio_unlock(folio);
> > > @@ -268,7 +268,7 @@ xfile_get_folio(
> > >  
> > >  	pflags = memalloc_nofs_save();
> > >  	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> > > -			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
> > > +			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ, PAGE_SIZE);
> > >  	memalloc_nofs_restore(pflags);
> > >  	if (error)
> > >  		return ERR_PTR(error);
> > > diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> > > index 9bb2d24de709..784c81d35a1f 100644
> > > --- a/fs/xfs/xfs_buf_mem.c
> > > +++ b/fs/xfs/xfs_buf_mem.c
> > > @@ -149,7 +149,8 @@ xmbuf_map_page(
> > >  		return -ENOMEM;
> > >  	}
> > >  
> > > -	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE);
> > > +	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE,
> > > +				PAGE_SIZE);
> > 
> > This is ok unless someone wants to use a different XMBUF_BLOCKSIZE.
> > 
> > --D
> > 
> > >  	if (error)
> > >  		return error;
> > >  
> > > diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> > > index 3fb18f7eb73e..bc59b4a00228 100644
> > > --- a/include/linux/shmem_fs.h
> > > +++ b/include/linux/shmem_fs.h
> > > @@ -142,7 +142,7 @@ enum sgp_type {
> > >  };
> > >  
> > >  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
> > > -		enum sgp_type sgp);
> > > +		enum sgp_type sgp, size_t len);
> > >  struct folio *shmem_read_folio_gfp(struct address_space *mapping,
> > >  		pgoff_t index, gfp_t gfp);
> > >  
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 38830174608f..947770ded68c 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1863,7 +1863,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
> > >  				xas_unlock_irq(&xas);
> > >  				/* swap in or instantiate fallocated page */
> > >  				if (shmem_get_folio(mapping->host, index,
> > > -						&folio, SGP_NOALLOC)) {
> > > +						    &folio, SGP_NOALLOC,
> > > +						    PAGE_SIZE)) {
> > >  					result = SCAN_FAIL;
> > >  					goto xa_unlocked;
> > >  				}
> > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > index d531018ffece..fcd2c9befe19 100644
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -1134,7 +1134,7 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
> > >  	 * (although in some cases this is just a waste of time).
> > >  	 */
> > >  	folio = NULL;
> > > -	shmem_get_folio(inode, index, &folio, SGP_READ);
> > > +	shmem_get_folio(inode, index, &folio, SGP_READ, PAGE_SIZE);
> > >  	return folio;
> > >  }
> > >  
> > > @@ -1844,7 +1844,7 @@ static struct folio *shmem_alloc_folio(gfp_t gfp, struct shmem_inode_info *info,
> > >  
> > >  static struct folio *shmem_alloc_and_add_folio(gfp_t gfp,
> > >  		struct inode *inode, pgoff_t index,
> > > -		struct mm_struct *fault_mm, bool huge)
> > > +		struct mm_struct *fault_mm, bool huge, size_t len)
> > >  {
> > >  	struct address_space *mapping = inode->i_mapping;
> > >  	struct shmem_inode_info *info = SHMEM_I(inode);
> > > @@ -2173,7 +2173,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
> > >   */
> > >  static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> > >  		struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
> > > -		struct vm_fault *vmf, vm_fault_t *fault_type)
> > > +		struct vm_fault *vmf, vm_fault_t *fault_type, size_t len)
> > >  {
> > >  	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
> > >  	struct mm_struct *fault_mm;
> > > @@ -2258,7 +2258,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> > >  		huge_gfp = vma_thp_gfp_mask(vma);
> > >  		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
> > >  		folio = shmem_alloc_and_add_folio(huge_gfp,
> > > -				inode, index, fault_mm, true);
> > > +				inode, index, fault_mm, true, len);
> > >  		if (!IS_ERR(folio)) {
> > >  			count_vm_event(THP_FILE_ALLOC);
> > >  			goto alloced;
> > > @@ -2267,7 +2267,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> > >  			goto repeat;
> > >  	}
> > >  
> > > -	folio = shmem_alloc_and_add_folio(gfp, inode, index, fault_mm, false);
> > > +	folio = shmem_alloc_and_add_folio(gfp, inode, index, fault_mm, false,
> > > +					  len);
> > >  	if (IS_ERR(folio)) {
> > >  		error = PTR_ERR(folio);
> > >  		if (error == -EEXIST)
> > > @@ -2377,10 +2378,10 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> > >   * Return: 0 if successful, else a negative error code.
> > >   */
> > >  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
> > > -		enum sgp_type sgp)
> > > +		enum sgp_type sgp, size_t len)
> > >  {
> > >  	return shmem_get_folio_gfp(inode, index, foliop, sgp,
> > > -			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
> > > +			mapping_gfp_mask(inode->i_mapping), NULL, NULL, len);
> > >  }
> > >  EXPORT_SYMBOL_GPL(shmem_get_folio);
> > >  
> > > @@ -2475,7 +2476,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
> > >  
> > >  	WARN_ON_ONCE(vmf->page != NULL);
> > >  	err = shmem_get_folio_gfp(inode, vmf->pgoff, &folio, SGP_CACHE,
> > > -				  gfp, vmf, &ret);
> > > +				  gfp, vmf, &ret, PAGE_SIZE);
> > >  	if (err)
> > >  		return vmf_error(err);
> > >  	if (folio) {
> > > @@ -2954,6 +2955,9 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
> > >  	struct folio *folio;
> > >  	int ret = 0;
> > >  
> > > +	if (!mapping_large_folio_support(mapping))
> > > +		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
> > > +
> > >  	/* i_rwsem is held by caller */
> > >  	if (unlikely(info->seals & (F_SEAL_GROW |
> > >  				   F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))) {
> > > @@ -2963,7 +2967,7 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
> > >  			return -EPERM;
> > >  	}
> > >  
> > > -	ret = shmem_get_folio(inode, index, &folio, SGP_WRITE);
> > > +	ret = shmem_get_folio(inode, index, &folio, SGP_WRITE, len);
> > >  	if (ret)
> > >  		return ret;
> > >  
> > > @@ -3083,7 +3087,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > >  				break;
> > >  		}
> > >  
> > > -		error = shmem_get_folio(inode, index, &folio, SGP_READ);
> > > +		error = shmem_get_folio(inode, index, &folio, SGP_READ, PAGE_SIZE);
> > >  		if (error) {
> > >  			if (error == -EINVAL)
> > >  				error = 0;
> > > @@ -3260,7 +3264,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
> > >  			break;
> > >  
> > >  		error = shmem_get_folio(inode, *ppos / PAGE_SIZE, &folio,
> > > -					SGP_READ);
> > > +					SGP_READ, PAGE_SIZE);
> > >  		if (error) {
> > >  			if (error == -EINVAL)
> > >  				error = 0;
> > > @@ -3469,7 +3473,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
> > >  			error = -ENOMEM;
> > >  		else
> > >  			error = shmem_get_folio(inode, index, &folio,
> > > -						SGP_FALLOC);
> > > +						SGP_FALLOC,
> > > +						(end - index) << PAGE_SHIFT);
> > >  		if (error) {
> > >  			info->fallocend = undo_fallocend;
> > >  			/* Remove the !uptodate folios we added */
> > > @@ -3822,7 +3827,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
> > >  	} else {
> > >  		inode_nohighmem(inode);
> > >  		inode->i_mapping->a_ops = &shmem_aops;
> > > -		error = shmem_get_folio(inode, 0, &folio, SGP_WRITE);
> > > +		error = shmem_get_folio(inode, 0, &folio, SGP_WRITE, PAGE_SIZE);
> > >  		if (error)
> > >  			goto out_remove_offset;
> > >  		inode->i_op = &shmem_symlink_inode_operations;
> > > @@ -3868,7 +3873,7 @@ static const char *shmem_get_link(struct dentry *dentry, struct inode *inode,
> > >  			return ERR_PTR(-ECHILD);
> > >  		}
> > >  	} else {
> > > -		error = shmem_get_folio(inode, 0, &folio, SGP_READ);
> > > +		error = shmem_get_folio(inode, 0, &folio, SGP_READ, PAGE_SIZE);
> > >  		if (error)
> > >  			return ERR_PTR(error);
> > >  		if (!folio)
> > > @@ -5255,7 +5260,7 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
> > >  	int error;
> > >  
> > >  	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
> > > -				    gfp, NULL, NULL);
> > > +				    gfp, NULL, NULL, PAGE_SIZE);
> > >  	if (error)
> > >  		return ERR_PTR(error);
> > >  
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index 3c3539c573e7..540a0c2d4325 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -359,7 +359,7 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
> > >  	struct page *page;
> > >  	int ret;
> > >  
> > > -	ret = shmem_get_folio(inode, pgoff, &folio, SGP_NOALLOC);
> > > +	ret = shmem_get_folio(inode, pgoff, &folio, SGP_NOALLOC, PAGE_SIZE);
> > >  	/* Our caller expects us to return -EFAULT if we failed to find folio */
> > >  	if (ret == -ENOENT)
> > >  		ret = -EFAULT;
> > > -- 
> > > 2.43.0
> > > 
