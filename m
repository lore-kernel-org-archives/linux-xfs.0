Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31B45039
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XN5DAwNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523BAC433C7;
	Mon, 27 Nov 2023 22:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701125792;
	bh=HHLz7EZdKqRp6XdlxY9FakqC7c7IkbtEOMCys2dOVSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XN5DAwNYKu05iMGszmLAuLsCgCpcMxpfO5D//9R/wJJC4puTcrgc4Gd74WrtwORlX
	 s4+jhXJO7GISLZw0g3jAf1t2ONBb3aIMJVuX5SgAxAam4WvvV9O4JDUZTxNYat9Pu1
	 wDCYRZf7gCwkZ3y+rZ/oIBfTrW+FwGSBq7Ei1XYSEyVmm8Ls1KnFpYWIFjrgpadrTf
	 UUeCkKg01gz9Y8kppkiBmAyXDobSYJjblj0JzcMhUltf02Lwpdd25Qss9wTppNdJq4
	 WjwQ9rZnGE4x3by2LhYzLitoMmwaJ0Amf95VooI1YWiGok1i1dTsYZQ2pNsc3INZOu
	 BnBZaSBWEeK7Q==
Date: Mon, 27 Nov 2023 14:56:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: constrain dirty buffers while formatting a
 staged btree
Message-ID: <20231127225631.GI2766956@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926640.2770816.12781452338907572006.stgit@frogsfrogsfrogs>
 <ZWGL4tBoNDoGND7F@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGL4tBoNDoGND7F@infradead.org>

On Fri, Nov 24, 2023 at 09:53:38PM -0800, Christoph Hellwig wrote:
> > @@ -480,7 +500,7 @@ xfs_btree_bload_node(
> >  
> >  		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
> >  
> > -		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
> > +		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
> >  				&child_bp);
> 
> How is this (and making xfs_btree_read_buf_block outside of xfs_buf.c)
> related to the dirty limit?

Oh!  Looking through my notes, I wanted the /new/ btree block buffers
have the same lru reference count the old ones did.  I probably should
have exported xfs_btree_set_refs instead of reading whatever is on disk
into a buffer, only to blow away the contents anyway.

--D
