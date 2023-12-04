Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C705226AC9
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHURJAp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C00C433C7;
	Mon,  4 Dec 2023 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701722662;
	bh=+b88aAQFsFeh0VWUciSInJQ4k8+K38eK8G5KcRM4/Vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mHURJAp2LdfaidNjmWWWV6CcugdArS2qXgMrSRTthZ3rnNZTwvFFJFADYkXqOzjpp
	 2kwND6419TL5aUM1rP0mBCynwYxfOoiCW4u2INbtQsM3/7Qb7zaBncbuNazsSB7lYF
	 n5p+5RcLK8ZgE80Rk76g/Uj/Dmp13LsdMIWywSsQV53msa0UaLrPjD2sXXOE4JoINO
	 k45Le7E29pTSC78LsjzRLTviqMJXGuNJmYdLZ3kdHUOOmXyr76/HzPeKp3xq53ggbZ
	 7lYSVaa5Y7lXTUkz1ctdgNytheCyGZcAOBf0NumJmF+nlUsD5Cvg/2R+gaI0wg2+We
	 y2XXgxhp02rvw==
Date: Mon, 4 Dec 2023 12:44:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: abort directory parent scrub scans if we
 encounter a zapped directory
Message-ID: <20231204204421.GH361584@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927520.2771142.16263878151202910889.stgit@frogsfrogsfrogs>
 <ZWgT5u9GwGC+R7Rm@infradead.org>
 <20231130213709.GP361584@frogsfrogsfrogs>
 <ZW1YZanmEFilB5cv@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW1YZanmEFilB5cv@infradead.org>

On Sun, Dec 03, 2023 at 08:41:09PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 30, 2023 at 01:37:09PM -0800, Darrick J. Wong wrote:
> > Hmm.  A single "zapped" bit would be a good way to signal to
> > xchk_dir_looks_zapped and xchk_bmap_want_check_rmaps that a file is
> > probably broken.  Clearing that bit would be harder though -- userspace
> > would have to call back into the kernel after checking all the metadata.
> 
> Doesn't sound too horrible to have a special scrub call just for that.
> 
> > A simpler way might be to persist the entire per-inode sick state (both
> > forks and the contents within, for three bits).  That would be more to
> > track, but each scrubber could clear its corresponding sick-state bit.
> > A bit further on in this series is a big patchset to set the sick state
> > every time the hot paths encounter an EFSCORRUPTED.
> 
> That does sound even better.
> 
> > IO operations could check the sick state bit and fail out to userspace,
> > which would solve the problem of keeping programs away from a partially
> > fixed file.
> > 
> > The ondisk state tracking like an entire project on its own.  Thoughts?
> 
> Incore for now sounds fine to me.

Excellent!  I'll go work on that for v28.2 or v29 or whatever the next
version number is.

--D
