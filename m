Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC6214233;
	Wed, 19 Feb 2025 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985219; cv=none; b=Or+AuZuR7/rFSsxhyJh488gkH0CgOamRkXOX5Zz3DAnEmVBOAtp3TR8P6JspeXf/IJvorggqb+QD8q59dO2UAG/N2MMOIK4yLdPMm9f7uBm7B95kmZFnQ6D2NR9LVFnvWzgsxWtYKyYc6IVRwMll+NUbpNpLRVNNolRCs6iVtuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985219; c=relaxed/simple;
	bh=HjJP64nsT996BlEqWT55/byzilVFaLXvQZ5ljLJStXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DmmXoQiseUcObyxMhHHL3IeQe8XP/60IyqYxI8EpFIZSpl/glPKWg8XdBg8hcDiiP2DbbM9vuKZjx8NT9ti/VuP1d5sdQZXgi6moj+RRKtkFqYIKTXyynsieI+3GyFpLO39NFi21X8r+hfdo/uGCUsHlYsl4P48hOlw+fEGFdfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h75G5D0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h75G5D0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6298C4CED1;
	Wed, 19 Feb 2025 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739985218;
	bh=HjJP64nsT996BlEqWT55/byzilVFaLXvQZ5ljLJStXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h75G5D0UymxoHO0d+8Ht49GpaRKMZ7QmnE1VOw5ouMSMe/eEW7kHiV0ELzvjJZDhT
	 hBloLKoN720IMwkk28wzkU6w4QidRkq2nCfBcQGwq0xw4tj0V4KgvF3yXJJegl58pt
	 TkpU/f7TEJkvuOybS5R5MsY5VJU+q4PG0wQ3NappsvxF7UXoSKjySuRFd7lriXTNiN
	 XTGLcsIsXhhIC9CaKzk5WTWqFWSmEMliu1DQNn+P7xRFoJZa3Jr8u2qTpXPBBNW4K3
	 zGjecUha4/X9Sh5t9knz7Z0502lWf67sr7+6d+5QER1PbOmtkNTRIM++YwBzlXPA44
	 sLMyndXnt1+tA==
Date: Wed, 19 Feb 2025 09:13:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: skip tests if formatting small filesystem
 fails
Message-ID: <20250219171338.GQ21808@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591276.4080556.2717402179307349211.stgit@frogsfrogsfrogs>
 <Z7WIsZec_ZHIKKHQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7WIsZec_ZHIKKHQ@infradead.org>

On Tue, Feb 18, 2025 at 11:30:57PM -0800, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 05:05:59PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There are a few tests that try to exercise XFS functionality with an
> > unusually small (< 500MB) filesystem.  Formatting can fail if the test
> > configuration also specifies a very large realtime device because mkfs
> > hits ENOSPC when allocating the realtime metadata.  The test proceeds
> > anyway (which causes an immediate mount failure) so we might as well
> > skip these.
> 
> In this patch only a single test case is touched and not a few.  But
> I remember hitting a few more with the zoned testing.

Originally there were a few more, but most of the others I fixed by
making _scratch_mkfs_sized constrict the size of both the data and rt
volumes.  The 2022 version of this patch changed both xfs/104 and
xfs/291.

Oh, wait, the xfs/291 change became its own patch.

Right.  _scratch_mkfs_sized takes arguments now.  So this patch should
make create_scratch() use that instead of plain _scratch_mkfs_xfs.

--D
