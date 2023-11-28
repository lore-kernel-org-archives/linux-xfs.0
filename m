Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3984412
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 17:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qvOlVz9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77399C433C7;
	Tue, 28 Nov 2023 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701191255;
	bh=BeR4ShMPV+uabufTCle2lZICBOl9SNsReJ8ntNfuDHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qvOlVz9aewc+i1+dW/kIQH9QDTBI2UxcFKrwNTGYeLnCNiAHHdZykBjh9/VIfnqBK
	 h538woOwMLn2wqyiUi+CLPorkK57U6lOq2QtV+H+SR2klyFMCXFJmdH0ATYAkOGqR8
	 HUd2dAykbVM/+Np/RD09Be09+xoo9CtLieVplawWYmCcMXT/J2IXrodxZPzoMsnNFN
	 1XMcaOBmKowwayUWtKdKmP/LSYxUbfSpt6cirhWzUET2mAfJwVsxkq5H+DPh1eFmXp
	 /FWK4rJyqcVPMSlAnoRKbBmBkJ8Y2TF3tHOG0LON99NnzVf2LdbRWbwa9288I4YAwM
	 i2hUNA2gZ6zSQ==
Date: Tue, 28 Nov 2023 09:07:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <20231128170734.GZ2766956@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926593.2770816.5504104328549141972.stgit@frogsfrogsfrogs>
 <ZWGK6Ig752wdBvwF@infradead.org>
 <20231128015041.GO2766956@frogsfrogsfrogs>
 <ZWWTJGq1ldOm6inW@infradead.org>
 <ZWYEvqZHj4KX4wqj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWYEvqZHj4KX4wqj@infradead.org>

On Tue, Nov 28, 2023 at 07:18:22AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 27, 2023 at 11:13:40PM -0800, Christoph Hellwig wrote:
> > > Every time I revisit this patch I wonder if DELWRI_Q is misnamed -- does
> > > it mean "b_list is active"?  Or does it merely mean "another thread will
> > > write this buffer via b_list if nobody gets there first"?  I think it's
> > > the second, since it's easy enough to list_empty().
> > 
> > I think it is misnamed and not clearly defined, and we should probably
> > fix that.  Note that least the current list_empty() usage isn't quite
> > correct either without a lock held by the delwri list owner.  We at
> > least need a list_empty_careful for a racey but still save check.
> > 
> > Thinking out loud I wonder if we can just kill XBF_DELWRI_Q entirely.
> > Except for various asserts we mostly use it in reverse polarity, that is
> > to cancel delwri writeout for stale buffers.  How about just skipping
> > XBF_STALE buffers on the delwri list directly and not bother with
> > DELWRI_Q?  With that we can then support multiple delwri lists that
> > don't get into each others way using say an allocating xarray instead
> > of the invase list and avoid this whole mess.
> > 
> > Let me try to prototype this..
> 
> Ok, I spent half the day prototyping this and it passes basic sanity
> checks:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/xfs-multiple-delwri-lists
> 
> My conclusions from that is:
> 
>  1) it works
>  2) I think it is the right to do
>  3) it needs a lot more work
>  4) we can't block the online repair work on it
> 
> so I guess we'll need to go with the approach in this patch for now,
> maybe with a better commit log, and I'll look into finishing this work
> some time in the future.

<nod> I think an xarray version of this would be less clunky than
xfs_delwri_buf with three pointers.

Also note Dave's comments on the v25 posting of this series:
https://lore.kernel.org/linux-xfs/ZJJa7Cnni0mb%2F9sN@dread.disaster.area/

--D
