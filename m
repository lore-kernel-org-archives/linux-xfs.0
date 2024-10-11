Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E776919AD87
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 16:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728665049; cv=none; b=eRy+iEwqsXXSoQXI8k6cSQVwLQrsEkEV/5IJWKT0AvSAK/F3hZdtCtq0Ex1Ox13ZZyD4aGzVgbj6taz+ll1Ku3rfyRbR2X1vbHKf/UnfjqvQV1mkMNWdAGhoiOMPxwEdOrcNqQ1eHDWWorip8yYAQkBsZwT8c9iTYQfjka+TMXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728665049; c=relaxed/simple;
	bh=9wsyyyi3XkAanKy3lRSRiJbd/OZ+zV5xJunbmtLGMIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKbDXZZohnbVZ6JNuTmQHi1fpwQRYbMnX9xUT7a0lhT+zh653TBaAacSAGLQqzbWEYEtxEFtZ+fwe+Qi9/TuKb/KTaYBVThjahGWtgPbH5w1Yh6Qs8S/rsqQv5x4UcmthTFJsQu98UJaf44UeRbhP2KWb/tQsHhfBYyA6NrcVWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ui+Vyoy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ui+Vyoy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28A5C4CEC3;
	Fri, 11 Oct 2024 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728665047;
	bh=9wsyyyi3XkAanKy3lRSRiJbd/OZ+zV5xJunbmtLGMIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ui+Vyoy+UyvOlUHbOsuAT5URNUsV6ZfVR6SLyhqIgjOiX8pW144BfVzJuUboPRqaT
	 arX06RZRW7hYuMYGZc4Xh01RVqlTJMLpCfHU9ux3fVxL9Ng4fxu6r17lGzhhj6+4hM
	 8pkKEog/8fmRF4abjV4t1AncUzq80Z6Fh9VDrb4F51or2Dvu5YxpYmjsjkovD6eR/e
	 x/vLCNO/f8NmOGqUFN0cM0NmTIaPCnr/FAXpg3nDXT6d/G1rHQZAV5bT1V2kQH+1qw
	 /IB9WRuOfzYGaZ0csh/iz4q3XCT3cGONXfWV8O6Juhq6Z0AcOiUC136DHBg3cDzCAf
	 npWkfgLSG+MyA==
Date: Fri, 11 Oct 2024 09:44:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241011164407.GZ21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <20241010190147.GU21853@frogsfrogsfrogs>
 <20241011075903.GD2749@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011075903.GD2749@lst.de>

On Fri, Oct 11, 2024 at 09:59:03AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 12:01:47PM -0700, Darrick J. Wong wrote:
> > What if instead this took the form of a new defer_ops type?  The
> > xfs_prepare_sb_update function would allocate a tracking object where
> > we'd pin the sb buffer and record which fields get changed, as well as
> > the new values.  xfs_commit_sb_update then xfs_defer_add()s it to the
> > transaction and commits it.  (The ->create_intent function would return
> > NULL so that no log item is created.)
> > 
> > The ->finish_item function would then bhold the sb buffer, update the
> > ondisk super like how xfs_commit_sb_update does in this patch, set
> > XFS_SB_TRANS_SYNC, and return -EAGAIN.  The defer ops would commit and
> > flush that transaction and call ->finish_item again, at which point it
> > would recompute the incore/cached geometry as necessary, bwrite the sb
> > buffer, and release it.
> > 
> > The downside is that it's more complexity, but the upside is that the
> > geometry changes are contained in one place instead of being scattered
> > around, and the incore changes only happen if the synchronous
> > transaction actually gets written to disk.  IOWs, the end result is the
> > same as what you propose here, but structured differently.  
> 
> That sounds overkill at first, but if we want to move all sb updates
> to that model more strutured infrastructure might be very useful.

<nod> We could just take this as-is and refactor it into the defer item
code once we're done making all the other sb geometry growfsrt updates.
I'd rather do that than rebase *two* entire patchsets just to get the
same results.

--D
