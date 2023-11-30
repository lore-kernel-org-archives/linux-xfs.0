Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642875FEFB
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtqPBHJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF3BC433C8;
	Thu, 30 Nov 2023 21:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701380229;
	bh=hoEpESyaUxC8iFQpNmMZk5NQTEk8Yoxtb/wn/7RxjKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NtqPBHJUqcEB9Kc+t51F41fSKjUCbcs5NRCVPG1FhzRI8YhNFKqnQibb1MQjgCgxl
	 6l4yfACF5i/0J/P713QQibGpBYd7lKXT3g5ugOM/4V7gDIMW7ReFdUDhYk9m58SXQm
	 orpO5wsqzZ4WK5CnkoiPIFdY2dFlPfINmwrCE5iwahemAKBNwoRACZzDQomnCXXw5B
	 fErrYQyGobxKcOKxAlNsq79p9x0dajgHFUS4A7344/SY0C7QZRdjJipx8RFbyv8iWQ
	 V3f6bXLuHNEMlyI4TXX1s1ruwKxxqgBUoFR3bHgaFkStU+n+Sts+VLl3WKbvBKuCbU
	 sTkyDVRqcxtxw==
Date: Thu, 30 Nov 2023 13:37:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: abort directory parent scrub scans if we
 encounter a zapped directory
Message-ID: <20231130213709.GP361584@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927520.2771142.16263878151202910889.stgit@frogsfrogsfrogs>
 <ZWgT5u9GwGC+R7Rm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWgT5u9GwGC+R7Rm@infradead.org>

On Wed, Nov 29, 2023 at 08:47:34PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:52:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In the previous patch, we added some code to perform sufficient repairs
> > to an ondisk inode record such that the inode cache would be willing to
> > load the inode.
> 
> This is now a few commits back.  My adjust this to be less specific.
> 
> > If the broken inode was a shortform directory, it will
> > reset the directory to something plausible, which is to say an empty
> > subdirectory of the root.  The telltale signs that something is
> > seriously wrong is the broken link count.
> > 
> > Such directories look clean, but they shouldn't participate in a
> > filesystem scan to find or confirm a directory parent pointer.  Create a
> > predicate that identifies such directories and abort the scrub.
> > 
> > Found by fuzzing xfs/1554 with multithreaded xfs_scrub enabled and
> > u3.bmx[0].startblock = zeroes.
> 
> This kind of ties into my comment on the previous comment, but needing
> heuristics to find zapped inodes or inode forks just seems to be asking
> for trouble.  I suspect we'll need proper on-disk flags to notice the
> corrupted / half-rebuilt state.

Hmm.  A single "zapped" bit would be a good way to signal to
xchk_dir_looks_zapped and xchk_bmap_want_check_rmaps that a file is
probably broken.  Clearing that bit would be harder though -- userspace
would have to call back into the kernel after checking all the metadata.

A simpler way might be to persist the entire per-inode sick state (both
forks and the contents within, for three bits).  That would be more to
track, but each scrubber could clear its corresponding sick-state bit.
A bit further on in this series is a big patchset to set the sick state
every time the hot paths encounter an EFSCORRUPTED.

IO operations could check the sick state bit and fail out to userspace,
which would solve the problem of keeping programs away from a partially
fixed file.

The ondisk state tracking like an entire project on its own.  Thoughts?

--D
