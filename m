Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4469F3AF644;
	Mon, 23 Mar 2026 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284287; cv=none; b=r53WQqhnzBuJAwwlcDYBHbUotR4OUgPyu/9SxiCIjjgDWjDwvxV7rhhcai1bKWpiFtWJ62kEFbzHCujr8bk86gYi2WqifJ+Q5E97UH/OGSv/+PNs+ZiQtzxuxNCb8wJu9e9udBAjIWnxLqLAEMFuowJ5ope5g9Ix4iMjhftJK7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284287; c=relaxed/simple;
	bh=1+A9z4oo4a20DVlIgkoPybZ1mZVXGZUNa9GfgN9BBcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlV6gExUuOYbDHEUFyV9XOuEYYB7aUrsjXSp5sTuxtxI25pV9zg07f8Ou60FjqG2G8o504ehsNx/k+wRh9PUghYz5EpvTF7DtDCIAhJS8TnWxhty+eTVk2vR2Pt/a1FJA36GTxwkLBZTYX1f3K7lMM21NHK39xfQMvbATjnwVeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQGZL9Ti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQGZL9Ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC788C2BC9E;
	Mon, 23 Mar 2026 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774284287;
	bh=1+A9z4oo4a20DVlIgkoPybZ1mZVXGZUNa9GfgN9BBcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sQGZL9TiRdrb/TBLkiNI/UjRydjZLNKysGdxkZ2nRGm6STTztk16h/O1g65zHBe/W
	 GEchgzv+k8u6cdutNdg/lL/4H5aL8uIfhBYqfp48qB+5iVesnqqwimaJc5oADL5njL
	 w1ajVIWg1Mka+H0F/qY01sgmWpJE0u78gGEGgtPrcCA3NaGZqsSBsV3EZSwgSeQ/CQ
	 Q5UEWVnKsQnEUJ8HxvXlfVUrYhROtgXNKdPShdjLp2y96P2PMRE8wjpM2cLWYnrdPz
	 Q/PT10W6eRzhr5Nf8T20+AJ6nRfIVTVYQcJGQe/vveMGrjGSnfg8mtYHhGrCg544L/
	 rCEci3+X0PTtw==
Date: Mon, 23 Mar 2026 09:44:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Anand Jain <asj@kernel.org>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <20260323164446.GB6212@frogsfrogsfrogs>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <20260323152943.GH6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323152943.GH6223@frogsfrogsfrogs>

On Mon, Mar 23, 2026 at 08:29:43AM -0700, Darrick J. Wong wrote:
> On Sun, Mar 22, 2026 at 11:16:24PM -0500, Theodore Tso wrote:
> > On Sat, Mar 21, 2026 at 07:55:19PM +0800, Anand Jain wrote:
> > > statfs() currently reports f_fsid derived from the on-disk UUID.
> > > Cloned block devices share the same UUID, so distinct ext4 instances
> > > can return identical f_fsid values. This leads to collisions in
> > > fanotify.
> > > 
> > > Encode sb->s_dev into f_fsid instead of using the superblock UUID.
> > > This provides a per-device identifier and avoids conflicts when
> > > filesystem is cloned, matching the behavior with xfs.
> > 
> > As I observed in [1] this leads to collisions when for removable block
> > devices which can be used to mount different file systems.
> > 
> > [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/
> > 
> > > Place this change behind the new mount option "-o nouuid" for ABI
> > > compatibility.
> > 
> > I *really* hate this mount option.  It's not at all obvious what it
> > means for a system administrator who hasn't had the context of reading
> > the e-mail discussion on this subject.
> 
> I don't love 'nouuid' either, because it means something completely
> different in XFS.  'fsid_from_dev' or something would at least be
> clearer about what it's doing...
> 
> > As I stated in [1], I think the f_fsid is a terrible interface that
> > was promulgated by history, and future usage should be strongly
> > discouraged, and the wise programmer won't use it because it has
> > significant compatibility issues.
> > 
> > As such, my personal preference is that we not try to condition it on
> > a mount option, which in all likelihood almost no one will use, and
> > instead just change it so that we hash the file system's UUID and
> > block device number together and use that for ext4's f_fsid.
> 
> ...but why not just set fsid to some approximation of the dev_t like
> XFS and be done with it?
> 
> 	st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev))
> 
> There are a few other single-bdev filesystems that do this.

/me reads the rest of both threads, realizes the answer is "because you
can eject media, mount another media with the same fs, and bizarrely
they produce the same fsid."

I'll point out that for the filesystems that base fsid off of a block
device, perhaps we should mix in the diskseq to prevent that problem?

But then someone said the magic words "IMA and fanotify also use fsid"
and /me backs away from yet another opportunity to argue about
open-coded file handles from legacy Unix.

--D
