Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45812A1DC
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 04:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712810493; cv=none; b=tCejw/OzLUFkBl7SyqKxWuqVfPHQH1Y9FK5uL5As2BbZqmy9akbhOoafhfpIowwxOFcZ9dth6s50fYDIywlAeFTMyP542gX0ci249IMFNbmQVaBqqbKqJAulOqLO5CohzyFr0ONBsxIPdG52/7FEHn9jA1TDCQ44JopWaISCVM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712810493; c=relaxed/simple;
	bh=u6nKJuOR9ogkwpUs9lC5WOQVriI2JDIMU2ihQrWGQA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+SCIkWIWLHiL/W/xcLl/7GWHU1DQwnK+pygETEAjw0FQGYtZxqVhcdS6wNf/bfQBAKcQL+Sf2Wb6ZHxR9pn8CixYbOD/4KeUaC5M9IFvcuHbQV7PW1f0GzC1Agsh8ETxev6RGarYILrJN2InRhLb6PExKtcfvqpm7eQnwCAVnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EehSnxUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EehSnxUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A809C433F1;
	Thu, 11 Apr 2024 04:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712810493;
	bh=u6nKJuOR9ogkwpUs9lC5WOQVriI2JDIMU2ihQrWGQA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EehSnxUr48cmQdzuJkYQAjipmdKCG/epNa8wXtUbrpKWTjfEJ0JHElQrMOnrqfRq6
	 3KpdR7G0VkROT1+vz5U4y7DPhGKQpBCzOgFXKi/+Rk0bGDSz3xc7wLmZ3JpXS1r3qp
	 ZLvt1wLVVol0N1eS7jXVU4cvYST0KXUgZwFpwW3fFauov9keec60F1kqZfSI0Gt6j4
	 qDTGCnXpn8Z2ykisJ4TLHgu1d0/+DJGgNZ/p51cjfrXvz854jiIlsmFpjm4NrassOG
	 qtYn/LI7Tubcu402E4rFCuwYuH7vjwBMLT/0pc/7wtA0Bg0TEA9SPfdUMIWoaRx7QP
	 Nw/J02wGK0KUQ==
Date: Wed, 10 Apr 2024 21:41:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <20240411044132.GW6390@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
 <Zhdd01E-ZNYxAnHO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zhdd01E-ZNYxAnHO@infradead.org>

On Wed, Apr 10, 2024 at 08:49:39PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 06:15:02PM -0700, Darrick J. Wong wrote:
> > > This looks a little weird to me.  Can't we simply use XFS_IGET_DONTCACHE
> > > at iget time and then clear I_DONTCACHE here if we want to keep the
> > > inode around?
> > 
> > Not anymore, because other threads can mess around with the dontcache
> > state (yay fsdax access path changes!!) while we are scrubbing the
> > inode.
> 
> You mean xfs_ioctl_setattr_prepare_dax?  Oh lovely, a completely
> undocumented d_mark_dontcache in a completely non-obvious place.
> 
> It sems to have appeared in
> commit e4f9ba20d3b8c2b86ec71f326882e1a3c4e47953
> Author: Ira Weiny <ira.weiny@intel.com>
> Date:   Thu Apr 30 07:41:38 2020 -0700
> 
>     fs/xfs: Update xfs_ioctl_setattr_dax_invalidate()
> 
> without any explanation either.  And I can't see any reason why
> we'd prevent inodes and dentries to be cached after DAX mode
> switches to start with.  I can only guess, maybe the commit thinks
> d_mark_dontcache is about data caching?

It's the horrible way that fsdax "supports" switching the address ops
and i_mapping contents at runtime -- set the ondisk iflag, mark the
inode/dentry for immediate explusion, wait for reclaim to eat the inode,
then reload it and *presto* new incore iflag and state!

(It's gross but I don't know of a better way to drain i_mapping and
change address ops and at this point I'm hoping I just plain forget all
that pmem stuff. :P)

> > 
> > >                Given that we only set the uncached flag from
> > > XFS_IGET_DONTCACHE on a cache miss, we won't have set
> > > DCACHE_DONTCACHE anywhere (and don't really care about the dentries to
> > > start with).
> > > 
> > > But why do we care about keeping the inodes with errors in memory
> > > here, but not elsewhere?
> > 
> > We actually, do, but it's not obvious...
> > 
> > > Maybe this can be explained in an expanded comment.
> > 
> > ...because this bit here is basically the same as xchk_irele, but we
> > don't have a xfs_scrub object to pass in, so it's opencoded.  I could
> > pull this logic out into:
> 
> Eww, I hadn't seen xchk_irele before.  To me it looks like
> I_DONTCACHE/d_mark_dontcache is really the wrong vehicle here.
> 
> I'd instead have a XFS_IGET_SCRUB, which will set an XFS_ISCRUB or
> whatever flag on a cache miss.  Any cache hit without XFS_IGET_SCRUB
> will clear it.
> 
> ->drop_inode then always returns true for XFS_ISCRUB inodes unless
> in a transaction.

How does it determine that we're in a transaction?  We just stopped
storing transactions in current->journal_info due to problems with
nested transactions and ext4 assuming that it can blind deref that.

>                    Talking about the in transaction part - why do
> we drop inodes in the transaction in scrub, but not elsewhere?

One example is:

Alloc transaction -> lock rmap btree for repairs -> iscan filesystem to
find rmap records -> iget/irele.

--D
