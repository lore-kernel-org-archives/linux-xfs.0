Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86315A10B
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 21:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzkrngpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F6AC433C8;
	Thu, 30 Nov 2023 21:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701380905;
	bh=XRx77zJFkMS0invWKb4FTdxXW8ab3lW9uJCwDOOpHYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nzkrngpJGlS5ariMdKQ4GU0GIDHRGX4Bfd2lQnrum3Hm5b8ImuWooXQI+YZyS8ifD
	 53vr1+EASJPUCiie6yylE1f4i/RGWUzLPwsnqgujM1QL4gP58+RQDr46ZmmQvZmyCI
	 EPBZ9mM1tBTPoni0YnKFMxMaK8h2wCuV4LcRhc5YtustJKC0IKjCVZ9b2RFpp3Lbx6
	 YALR7NtW8NGWHpPdq6qTVsTrM3Avyled5E/Gf4xQUn/CNkCJErWodI0mR8JGoHqe3H
	 fcvb4c+jQSWKE45Iq2sjwLLimQfuSpR4EPu32Hi7jC4u6TfrO3TJ1XUpL4f3N8e4aN
	 11YhqY05lXCHg==
Date: Thu, 30 Nov 2023 13:48:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: reintroduce reaping of file metadata blocks to
 xrep_reap_extents
Message-ID: <20231130214824.GQ361584@frogsfrogsfrogs>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927926.2771366.6168941084200917015.stgit@frogsfrogsfrogs>
 <ZWgVPxNT80LFzvx+@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWgVPxNT80LFzvx+@infradead.org>

On Wed, Nov 29, 2023 at 08:53:19PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:53:09PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Reintroduce to xrep_reap_extents the ability to reap extents from any
> > AG.  We dropped this before because it was buggy, but in the next patch
> > we will gain the ability to reap old bmap btrees, which can have blocks
> > in any AG.  To do this, we require that sc->sa is uninitialized, so that
> > we can use it to hold all the per-AG context for a given extent.
> 
> Can you expand a bit on why it was buggy, in what commit is was dropped
> and what we're doing better this time around?

Oh!  We merged that one!  Let me change the commit message:

"Back in commit a55e07308831b ("xfs: only allow reaping of per-AG
blocks in xrep_reap_extents"), we removed from the reaping code the
ability to handle bmbt blocks.  At the time, the reaping code only
walked single blocks, didn't correctly detect crosslinked blocks, and
the special casing made the function hard to understand.  It was easier
to remove unneeded functionality prior to fixing all the bugs.

"Now that we've fixed the problems, we want again the ability to reap
file metadata blocks.  Reintroduce the per-file reaping functionality
atop the current implementation.  We require that sc->sa is
uninitialized, so that we can use it to hold all the per-AG context for
a given extent."

> 
> > 
> >  #endif /* __XFS_SCRUB_REAP_H__ */
> > diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > index 70a6b18e5ad3c..46bf841524f8f 100644
> > --- a/fs/xfs/scrub/repair.h
> > +++ b/fs/xfs/scrub/repair.h
> > @@ -48,6 +48,7 @@ xrep_trans_commit(
> >  
> >  struct xbitmap;
> >  struct xagb_bitmap;
> > +struct xfsb_bitmap;
> 
> Your might need the forward declaration in reap.h, but definitively
> not here :)
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
