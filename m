Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87665733F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQNqwYi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5EEC433C8;
	Tue, 28 Nov 2023 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701214209;
	bh=VdPMaoyuSz+btb3czC1ZoP3hDJzrGB3q4EhTZGBiW74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bQNqwYi1denFkbU2+5sXZgPVXhgm1qJPL93H+Z/l34PNjLctExelvhXTfr37jm4Is
	 x9aHFrdjTeYhLfnU8qiesxpKS8t6Xz1oh5yqhxsGIa/mNantZr7FVKbIP5C8nq2qr7
	 eqqmYPUmJvqugWnP99yKOu3zQ5X3Q48og3/E4UpMN/0hPAs77cLy81S5PRTBraLqCG
	 YTYH4xE+quZqPXBkRS24ZbLMNi5wYmDDlEXOGghfYJa+2lxNG+AGgvJjRWkmveiQ0E
	 PSMVAeGB4tRQkPENCBqa+DPldMlNxQvGkuPcRvKa0Tcl6fT2iFdnJg6qv8Rl3/MVP3
	 br7xEMCahZKbg==
Date: Tue, 28 Nov 2023 15:30:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
Message-ID: <20231128233008.GF4167244@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
 <ZWXzvNHCV6QWeikg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWXzvNHCV6QWeikg@infradead.org>

On Tue, Nov 28, 2023 at 06:05:48AM -0800, Christoph Hellwig wrote:
> > +	/*
> > +	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
> > +	 * growfsrt trying to expand the summary or change the size of the rt
> > +	 * volume.  Hence it is safe to compute and check the geometry values.
> > +	 */
> > +	rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> > +	rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
> > +	rts->rsumlevels = rts->rextents ? xfs_highbit32(rts->rextents) + 1 : 0;
> > +	rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
> > +			rts->rbmblocks);
> > +	rts->rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
> 
> Same nitpick as for the last patch.

LOL so I just tried a 64k rt volume with a 1M rextsize and mkfs crashed.
I guess I'll go sort out what's going on there...

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
