Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5B93BADA6;
	Mon, 23 Mar 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279784; cv=none; b=rzYeWbWUuoQosktwW+rHIM2CRCd8i8CSpvLNmQRtSq00tR7O/gKkuflOcVE2JC+rZ+w40f1tayjfSEQLUeAbKYMqyt2D4mS0lxaY33Xk2TZXghR2I4Non/upROyvdRihTmU5buf1Qpeg7vptbfgSfkcnsCgaqdbJD3kS9mJGyDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279784; c=relaxed/simple;
	bh=9lta+tyRm/gU47+8BBid2B7jJDSrye7R27Jln0AXetI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCEqJ1d4y2AHDeIjBBBStUqz8UZRt+R92PYnVAPPH64w3Isq7JF3z3GVxhk8bGAgDf613O080QRYew/sWdjPsGVFNBZiSqOO1Jk+U5fsTS0emNqScBwwU0XyiC/BkfqkOfk79e8K8Avrek+yqQLr55pcWDEFG6zM7BAoE0b4xgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rasG51Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rasG51Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CEBC4CEF7;
	Mon, 23 Mar 2026 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774279783;
	bh=9lta+tyRm/gU47+8BBid2B7jJDSrye7R27Jln0AXetI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rasG51Ui2W3fDtHZhLw8ky6R37Z4HXcSUA4MmyqI6uQ/XGjOVYOkMKvvklqnSJZfc
	 34TqDcMhUHJXvHua3VMvA12FhNnSmA78otdA/xf4C3+Cb9WM7FRgGQ4ot5TNtw1+Rk
	 49Ntc13gHwGRoZLbmLZq1p8bnujJyNBhusZrqYvrfaHcSSQXL2SMbj/HuTPSzqz9kr
	 JB6JXnzWihVujw0qadjKOGSPK6y+6fU8xATZ00RdtZyeahvHpyxwa4BP+eEt+pIKJK
	 yQilOQu5PoAO1AEYAELI6sNJ/UJSfCr3AxqvsmaG+5yfEEtNKu/RSs1H5Yzz7LkGLh
	 9NTgY4e58BgxA==
Date: Mon, 23 Mar 2026 08:29:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Anand Jain <asj@kernel.org>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <20260323152943.GH6223@frogsfrogsfrogs>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323041624.GA11453@mac.lan>

On Sun, Mar 22, 2026 at 11:16:24PM -0500, Theodore Tso wrote:
> On Sat, Mar 21, 2026 at 07:55:19PM +0800, Anand Jain wrote:
> > statfs() currently reports f_fsid derived from the on-disk UUID.
> > Cloned block devices share the same UUID, so distinct ext4 instances
> > can return identical f_fsid values. This leads to collisions in
> > fanotify.
> > 
> > Encode sb->s_dev into f_fsid instead of using the superblock UUID.
> > This provides a per-device identifier and avoids conflicts when
> > filesystem is cloned, matching the behavior with xfs.
> 
> As I observed in [1] this leads to collisions when for removable block
> devices which can be used to mount different file systems.
> 
> [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/
> 
> > Place this change behind the new mount option "-o nouuid" for ABI
> > compatibility.
> 
> I *really* hate this mount option.  It's not at all obvious what it
> means for a system administrator who hasn't had the context of reading
> the e-mail discussion on this subject.

I don't love 'nouuid' either, because it means something completely
different in XFS.  'fsid_from_dev' or something would at least be
clearer about what it's doing...

> As I stated in [1], I think the f_fsid is a terrible interface that
> was promulgated by history, and future usage should be strongly
> discouraged, and the wise programmer won't use it because it has
> significant compatibility issues.
> 
> As such, my personal preference is that we not try to condition it on
> a mount option, which in all likelihood almost no one will use, and
> instead just change it so that we hash the file system's UUID and
> block device number together and use that for ext4's f_fsid.

...but why not just set fsid to some approximation of the dev_t like
XFS and be done with it?

	st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev))

There are a few other single-bdev filesystems that do this.

--D

> Thoughts, comments?
> 
> 						- Ted
> 
