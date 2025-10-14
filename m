Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CF11E47CA
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476534; cv=none; b=BSIErX94W9xCCVmW83kyAhvG/ybWeIvCQfZQh5Dg4Cl/RlbU8JT7cpfCMewIW8NDf0hXiJyECuyjAyXqBJahTNHH0JI90M9EHm9mXzZD2e538t/ArHQQSRgqqE+Uu+QnT+qvANX8oekDBbnchTkH5Rm2rDFjOVnfrIAA0ogeDSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476534; c=relaxed/simple;
	bh=z/m/Yq1xWxy/UgfR2IWZjCsVB8PmfhcPDCei2kcwbu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+BBhvvL3Kzd8NQMwUE6gYbp1fBoKk/7TGknHPldJiLjaOB6JVlsR+Z3i/sBU35/2k3hP8aaW3JTSHzSFyNPebFeNEgKVC+2UKU6pGs2Nv7o0UfrOYPfhQcfdrLw3AXnmYnxv1EuBrmMTdVP9y6mO9AWofb/cfDDkYYi0eEdikU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vNgrCLNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vNgrCLNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37019C4CEE7;
	Tue, 14 Oct 2025 21:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760476534;
	bh=z/m/Yq1xWxy/UgfR2IWZjCsVB8PmfhcPDCei2kcwbu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vNgrCLNcHLHeS74YIWEcYbC4bawc3vGWcbqcMscLaSzFN7bJB0sa8gdE0/AZXCCG5
	 vz0G4GJAhJuNAR2i+WMAgnB7EphoaYLbM8Ykgb8s5bedJSur6apHKUyUzAoYOWMJO5
	 RxnSGpfq8AEanMGjEt02XH76UN61jVvviBVD+sh7XnwqE3PrLrl1LTWo+90hRdu2QG
	 0oKQtbHxLsDVc2rHl494As9L4iGvxpVGVVyKw+fLlRWHPTRRqwLW5QlNsz3C3/8spC
	 wVV6+EwtdGgLoj2aLa01iroi73csmlyBHvMQSPR9hL/mwdayQjkDd1JxnbycIULK+p
	 jSUsOoJrMMG8g==
Date: Tue, 14 Oct 2025 14:15:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: lukas@herbolt.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20251014211532.GF6188@frogsfrogsfrogs>
References: <20251002122823.1875398-2-lukas@herbolt.com>
 <aN-Aac7J7xjMb_9l@infradead.org>
 <20251004040020.GC8096@frogsfrogsfrogs>
 <aOCfus7PgLl812qf@infradead.org>
 <dee6b75856d013f8aa6de1c17ff0f20a@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dee6b75856d013f8aa6de1c17ff0f20a@herbolt.com>

On Tue, Oct 14, 2025 at 10:10:51AM +0200, lukas@herbolt.com wrote:
> On 2025-10-04 06:16, Christoph Hellwig wrote:
> > On Fri, Oct 03, 2025 at 09:00:20PM -0700, Darrick J. Wong wrote:
> > > > > -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> > > > > +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> > > > > +		if (!bdev_write_zeroes_unmap_sectors(inode->i_sb->s_bdev))
> > > 
> > >      		                         not correct ^^^^^^^^^^^^^^^^^^^
> > > 
> > > You need to find the block device associated with the file because XFS
> > > is a multi-device filesystem.
> > 
> > Indeed. xfs_inode_buftarg will do the work, but we'll need to ensure
> 
> Thanks for xfs_inode_buftarg pointer.
> 
> > the RT bit doesn't get flipped, i.e. it needs to hold a lock between
> > that check and allocation the blocks if there were none yet.
> 
> I am having bit of trouble with that. If I get it right we should hold
> the XFS_ILOCK_EXCL but this lock is then grabbed in the
> xfs_trans_alloc_inode.
> 
> So I would need to release before and there would be again a small window
> where the RT flag can be flipped.
> 
> Looking at the xfs_alloc_file_space, there is also check for the RT bit
> without
> lock, so this also need an attention.
>     rt = XFS_IS_REALTIME_INODE(ip);
>     extsz = xfs_get_extsz_hint(ip);
> 
> Or the xfs_trans_alloc_inode would need to check if we are a;ready holding
> the
> lock Is there a way how to check the current thread is the owner of the
> xfs_ilock rw_sem?

Hm?  The VFS takes inode_lock in vfs_fileattr_set prior to changing the
rt status bit, and and __xfs_file_fallocate takes the same lock (aka the
IOLOCK) before calling xfs_falloc_*.

IOWs, a call to xfs_inode_buftarg would see a stable realtime flag and
return the correct results.

--D

> 
> Something like?
> ---
> static inline bool is_current_writer(struct rw_semaphore *sem)
> {
>     /* The rwsem_owner() helper can be used to get the owner */
>     return sem->owner == current;
> }
> ---
> 
