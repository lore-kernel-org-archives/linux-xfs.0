Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5AB7473
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 06:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvV1a5Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF0AC433C7;
	Wed, 29 Nov 2023 06:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701238855;
	bh=Zo6mdRhnom4ndgbdVROya6hk/UGExyu7RY28D6+dvDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gvV1a5LfI6yRc7dfiokNyTsGFt0CdeqSWHdtScnkPDYyefG8q9Q73Df7CJIvKoMeB
	 JqSIWCHQqvKzwCBNZQsAzwSorwUy9nU+QtSi5mYTd36/L3Qj6g5HsIkk9TjDKn85lX
	 VbvxALGotgtKO/8jTkUcGt/G3fYJh6+Wsjfe+RzHtgOXMyDIXIbIzKpPKpvqzby5za
	 hMqYFTUNtv8NH+S+/+6Se/YQtXOcz92mwzZ7ETlvzYqFqaesxNs7azpZ7YwO9pBldn
	 asvAir8UuFeoxcALhsQMIxxlpwY1NbEbzJ9jkoAxvF87tZEy2BBzylVqQWNoLBC3d1
	 nvbC2uyLZc0eQ==
Date: Tue, 28 Nov 2023 22:20:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check rt bitmap file geometry more thoroughly
Message-ID: <20231129062054.GB361584@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928361.2771542.12276270495680939208.stgit@frogsfrogsfrogs>
 <ZWXzaiaUDQYrT/5x@infradead.org>
 <20231128232740.GE4167244@frogsfrogsfrogs>
 <ZWbUkgEfsjP4xNTI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbUkgEfsjP4xNTI@infradead.org>

On Tue, Nov 28, 2023 at 10:05:06PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 03:27:40PM -0800, Darrick J. Wong wrote:
> > > All these will be 0 if mp->m_sb.sb_rblocks, and rtb is zeroed allocation
> > > right above, so calculating the values seems a bit odd.  Why not simply:
> > > 
> > > 	if (mp->m_sb.sb_rblocks) {
> > > 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> > > 		rtb->rextslog = xfs_highbit32(rtb->rextents);
> > 
> > Well... xfs_highbit32 returns -1 if its argument is zero, which is
> > possible for the nasty edge case of (say) a 64k block device and a
> > realtime extent size of 1MB, which results in rblocks > 0 and
> > rextents == 0.
> 
> Eww.  How do we even allow creating a mounting that?  Such a
> configuration doesn't make any sense.

$ truncate -s 64k /tmp/realtime
$ truncate -s 1g /tmp/data
$ mkfs.xfs -f /tmp/data -r rtdev=/tmp/realtime,extsize=1m

Pre 4.19 mkfs.xfs would actually write out the fs and pre-4.19 kernels
would mount it (and ENOSPC).  Since then, due to buggy sb validation
code on my part now it just fails verifiers and crashes/doesn't mount.

--D

