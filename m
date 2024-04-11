Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70C714E2DF
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712844131; cv=none; b=HMu9gHObo3mOOtdG3PiFyxhNc1JrYzl9TlcmTVnciigf7TaA0nxoFrIEk5ye8YV70k0xtTK3q66Ree05v5YF44hjS+Ybb6ah0LtqXmoI+AOEp1vdYj3U5U/iNnwOMx5Nx/gAU0QrfkA0FsT8blWI4uBsy4/6lCs3tovjvVNaSmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712844131; c=relaxed/simple;
	bh=5r6AX4jpEb3mc3NeluquP5ZdgWxT2CtxAzlyHKU8pcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHYUbgIjOl6jhlpR2LEBq4ucGM3VE0gtxiqlM6VLcETsJ5zby8e7FOu78VkTC9OLJHWo29PxJqDZMOGc7lBg7nKp1ToaG9YTUvWZ5GrYGDVB6D/NGN58VUragS0iafVi9UUKCLJWx2p5ajLRngmYlzUsUnFw+nfLl0gB01l24iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n6zfOP17; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n6zfOP17"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QopyNy2JSZcbl7DNjJOWzsCgDT+sytvczhsXkj3zbdQ=; b=n6zfOP17csk2uZ9kG37EuwUtU+
	GTcNzLYeOUcGBJhnuBMDXZq9HJeolf6yAZflbPL5EkOcDRodJFsNSLlHno/XyDku9eLef9TTMbCNu
	FOcP73PQJ8J03mUuOPUNkTIfO2P2HDbRXQfQt9Z5RwOTAYZgymRdu7UJ0dF0iisANKgjqUKvpZYVk
	0EMmob2AJpXpZaTsPDl6wj6MCwa8zkV5JHZSgCNIBVVOQEzlHHbEGC9uMYve3o02DpFf1/SQX6Nou
	8cj2RrTCHd9JG147tGhY1jauVEssDvKW88kN7e5D3iSBIQHXpl2jeLK7Cfrbd6XH8njKeg/gmkJ8D
	mGX0ZsmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruv0B-0000000CKkN-2noO;
	Thu, 11 Apr 2024 14:02:07 +0000
Date: Thu, 11 Apr 2024 07:02:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <ZhftX0w0X0XQOor3@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
 <Zhdd01E-ZNYxAnHO@infradead.org>
 <20240411044132.GW6390@frogsfrogsfrogs>
 <ZhdsmeHfGx7WTnNn@infradead.org>
 <20240411045645.GX6390@frogsfrogsfrogs>
 <Zhdu3zJTO3d9gHLO@infradead.org>
 <20240411052107.GY6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411052107.GY6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 10:21:07PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 10, 2024 at 10:02:23PM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 10, 2024 at 09:56:45PM -0700, Darrick J. Wong wrote:
> > > > Well, someone needs to own it, it's just not just ext4 but could us.
> > > 
> > > Er... I don't understand this?        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > If we set current->journal and take a page faul we could not just
> > recurse into ext4 but into any fs including XFS.  Any everyone
> > blindly dereferences is as only one fs can own it.
> 
> Well back before we ripped it out I had said that XFS should just set
> current->journal to 1 to prevent memory corruption but then Jan Kara
> noted that ext4 changes its behavior wrt jbd2 if it sees nonzero
> current->journal.  That's why Dave dropped it entirely.

If you are in a fs context you own current->journal_info.  But you
also must make sure to not copy from and especially to user to not
recurse into another file system.  A per-thread field can't work any
other way.  So what ext4 is doing here is perfectly fine.  What XFS
did was to set current->journal_info and then cause page faults, which
is not ok.  I'm glad we fixed it.

> > That seems a bit dangerous to me.  I guess we rely on the code inside
> > the transaction context to never race with unmount as lack of SB_ACTIVE
> > will make the VFS ignore the dontcache flag.
> 
> That and we have an open fd to call the ioctl so any unmount will fail,
> and we can't enter scrub if unmount already starte.

Indeed.

So I'm still confused on why this new code keeps the inode around if an
error happend, but xchk_irele does not.  What is the benefit of keeping
the inode around here?  Why des it not apply to xchk_irele?

I also don't understand how d_mark_dontcache in
xfs_ioctl_setattr_prepare_dax is supposed to work.  It'll make the inode
go away quicker than without, but it can't force the inode by itself.

I'm also lot on the interaction of that with the scrub inodes due to
both above.  I'd still expect any scrub iget to set uncached for
a cache miss.  If we then need to keep the inode around in transaction
context we just keep it.  What is the benefit of playing racing
games with i_count to delay setting the dontcache flag until irele?
And why does the DAX mess matter for that?

Maybe I'm just thick and this is all obvious, but then it needs to
be documented in detailed comments.
