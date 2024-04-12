Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A05E6AB8
	for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2024 00:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712881294; cv=none; b=quIgT8MMR5UM+XQmr/L7Ox68TD8/E8BzYDgdmCJYH4oGrec2LusJnTBu7YLtM04vS7JMFKAVL6HLPgel/ijTrLYGcwdXr22F8qvuOP+ZDzjRK4E3+sSSCIKMGXbPbkuQPJLQR8C2TiRmgZJqmZyu5IOEHc/m7fD48CqOgSivp+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712881294; c=relaxed/simple;
	bh=Lmi0PlgpS6X3AJQUPK0lT5lDa55kxQCilYS27faIaww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkCSvDrcK0Kr/VVLYHMDLQTizZJ8wwb7sqiWf5Pi0cHgNHR4IRVuU9WN0QCc85EmR7rEHZV5RR6d9LYctVInlmCZ6eu9c8QBmMOCqG1jdN/cM2QcXfeOCZc5C2+6gO4CGFR1RW325mVg0eZzWuJ7hmn6eMDMMpsaf81PWX9zAow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0A2rf8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0A2rf8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A72C072AA;
	Fri, 12 Apr 2024 00:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712881294;
	bh=Lmi0PlgpS6X3AJQUPK0lT5lDa55kxQCilYS27faIaww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S0A2rf8SBPNMFpH5PJkOuO+AsTsPFXlZsUoXanH9RBUYVl3NX2vli7BmCcA065jfz
	 MnAXrIVTMRh06b+ej7dA9VsFfwqMFjDyuYzwVlc/rJP8AczNVOFa1UGDMOckXoEmHp
	 MHJvMPDrGIydcPsZfeg5X9cBf9DplrsRtyHMatS7fg4oCOjQrlxfauUrsdZHPeA65F
	 Qc2KBD6OagIWnnryOvSh4nRK4FNOoES+PziXGawa2n4IFySpdkrvjHhzls/I2CNz5P
	 pyeLO9sZ8p2wYtXRp7kNa53al3j74Njl1HRBiRg0C3tBAjjYp4B1wQSzVYrmBrXgys
	 wtMepVhLrUchQ==
Date: Thu, 11 Apr 2024 17:21:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <20240412002133.GZ6390@frogsfrogsfrogs>
References: <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
 <Zhdd01E-ZNYxAnHO@infradead.org>
 <20240411044132.GW6390@frogsfrogsfrogs>
 <ZhdsmeHfGx7WTnNn@infradead.org>
 <20240411045645.GX6390@frogsfrogsfrogs>
 <Zhdu3zJTO3d9gHLO@infradead.org>
 <20240411052107.GY6390@frogsfrogsfrogs>
 <ZhftX0w0X0XQOor3@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhftX0w0X0XQOor3@infradead.org>

On Thu, Apr 11, 2024 at 07:02:07AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 10:21:07PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 10, 2024 at 10:02:23PM -0700, Christoph Hellwig wrote:
> > > On Wed, Apr 10, 2024 at 09:56:45PM -0700, Darrick J. Wong wrote:
> > > > > Well, someone needs to own it, it's just not just ext4 but could us.
> > > > 
> > > > Er... I don't understand this?        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > If we set current->journal and take a page faul we could not just
> > > recurse into ext4 but into any fs including XFS.  Any everyone
> > > blindly dereferences is as only one fs can own it.
> > 
> > Well back before we ripped it out I had said that XFS should just set
> > current->journal to 1 to prevent memory corruption but then Jan Kara
> > noted that ext4 changes its behavior wrt jbd2 if it sees nonzero
> > current->journal.  That's why Dave dropped it entirely.
> 
> If you are in a fs context you own current->journal_info.  But you
> also must make sure to not copy from and especially to user to not
> recurse into another file system.  A per-thread field can't work any
> other way.  So what ext4 is doing here is perfectly fine.  What XFS
> did was to set current->journal_info and then cause page faults, which
> is not ok.  I'm glad we fixed it.
> 
> > > That seems a bit dangerous to me.  I guess we rely on the code inside
> > > the transaction context to never race with unmount as lack of SB_ACTIVE
> > > will make the VFS ignore the dontcache flag.
> > 
> > That and we have an open fd to call the ioctl so any unmount will fail,
> > and we can't enter scrub if unmount already starte.
> 
> Indeed.
> 
> So I'm still confused on why this new code keeps the inode around if an
> error happend, but xchk_irele does not.  What is the benefit of keeping
> the inode around here?  Why des it not apply to xchk_irele?

OH!  Crap, I forgot that some years ago (after the creation of the
vectorized scrub patch) I cleaned up that behavior -- previously scrub
actually did play games with clearing dontcache if the inode was sick.

Then Dave pointed out that we could just change reclaim not to purge the
incore inode (and hence preserve the health state) until unmount or the
fs goes down, and clear I_DONTCACHE any time we notice bad metadata.
Hopefully the incore inode then survives long enough that anyone
scanning for filesystem health status will still see the badness state.

Therefore, we don't need the set_dontcache variable in this patch:

	/*
	 * If we're holding the only reference to an inode opened via
	 * handle, mark it dontcache so that we don't pollute the cache.
	 */
	if (handle_ip) {
		if (atomic_read(&VFS_I(handle_ip)->i_count) == 1)
			d_mark_dontcache(VFS_I(handle_ip));
		xfs_irele(handle_ip);
	}

> I also don't understand how d_mark_dontcache in
> xfs_ioctl_setattr_prepare_dax is supposed to work.  It'll make the inode
> go away quicker than without, but it can't force the inode by itself.

That's correct.  You can set the ondisk fsdax iflag and then wait
centuries for the incore fsdax to catch up.  I think this is a very
marginal design, but thankfully the intended design is that you set
daxinherit on the parent dir or mount with dax=always and all new files
just come up with both fsdax flags set.

> I'm also lot on the interaction of that with the scrub inodes due to
> both above.  I'd still expect any scrub iget to set uncached for
> a cache miss.  If we then need to keep the inode around in transaction
> context we just keep it.  What is the benefit of playing racing
> games with i_count to delay setting the dontcache flag until irele?

One thing I don't like about XFS_IGET_DONTCACHE is that a concurrent
iget call without DONTCACHE won't clear the state from the inode, which
can lead to unnecessary evictions.  This racy thing means we only set it
if we think the inode isn't in use anywhere else.

At this point, though, I think we could add XFS_IGET_DONTCACHE to all
the iget calls and drop the irele dontcache thing.

> And why does the DAX mess matter for that?

fsdax doesn't matter, it merely slurped up the functionality and now
we're tangled up in it.

> Maybe I'm just thick and this is all obvious, but then it needs to
> be documented in detailed comments.

No, it's ... very twisty and weird.  I wish dontcache had remained our
private xfs thing.

--D
