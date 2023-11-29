Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009BB7475
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 05:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jU6p3WQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A94AC433C8;
	Wed, 29 Nov 2023 05:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701237451;
	bh=hqziOGKq4tm8AmiNuS3DqD2FZn5MsjK03mU74P3pzT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jU6p3WQhAfTirfakWbyORS20D+5/RnlnqZEzEqBA/tSzKVicN1e9edsdDBus6ADab
	 FcObLYMW1KBJXqpeZxcFi8dL9ZD/ZjAdsCDCVkl9x9GM+JUXZo0DM71Gj0/NGoDt8E
	 JeH64pjiu/trmLy1ADpFUGQ2dChhrWjqnSyBOMDXV5/Mu9ucxAtOl5SrBXletea7Dj
	 MXE/U14ra8rUXuWtcnu1rm2yUbmjNKLCiSfh4FMQ9PYJqpbKiefss3se9VGQXQjn8b
	 ViYPXMOeLwpIggkUsccJSc5NgTjufQNoAvfIPGYX3ls6iD03+X7coC3reHnviwHXt1
	 tfcWKaBkh0UgA==
Date: Tue, 28 Nov 2023 21:57:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: constrain dirty buffers while formatting a
 staged btree
Message-ID: <20231129055730.GS36211@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926640.2770816.12781452338907572006.stgit@frogsfrogsfrogs>
 <ZWGL4tBoNDoGND7F@infradead.org>
 <20231127225631.GI2766956@frogsfrogsfrogs>
 <20231128201133.GA4167244@frogsfrogsfrogs>
 <ZWbRK5SWtoW9sn1E@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbRK5SWtoW9sn1E@infradead.org>

On Tue, Nov 28, 2023 at 09:50:35PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 12:11:33PM -0800, Darrick J. Wong wrote:
> > And now that I've dug further through my notes, I've realized that
> > there's a better reason for this unexplained _get_buf -> _read_buf
> > transition and the setting of XBF_DONE in _delwri_queue_here.
> > 
> > This patch introduces the behavior that we flush the delwri list to disk
> > every 256k.
> 
> Where "the delwri list" is the one used for writing stage btrees I
> think.

Correct.

> > Flushing the buffers releases them, which means that
> > reclaim could free the buffer before xfs_btree_bload_node needs it again
> > to build the next level up.
> 
> Oh, indeed.
> 
> > If that's the case, then _get_buf will get
> > us a !DONE buffer with zeroes instead of reading the (freshly written)
> > buffer back in from disk.  We'll then end up formatting garbage keys
> > into the node block, which is bad.
> 
> Yeah.
> 
> > 		/*
> > 		 * Read the lower-level block in case the buffer for it has
> > 		 * been reclaimed.  LRU refs will be set on the block, which is
> > 		 * desirable if the new btree commits.
> > 		 */
> > 		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
> > 				&child_bp);
> > 
> > The behavior of setting XBF_DONE in xfs_buf_delwri_queue_here is an
> > optimization if _delwri_submit releases the buffer and it is /not/
> > reclaimed.  In that case, xfs_btree_read_buf_block will find the buffer
> > without the DONE flag set and reread the contents from disk, which is
> > unnecessary.
> 
> Yeah.  I still find it weird to set it in the delwri_submit_here helper,
> but maybe that's a discussion for the other thread.

D'Oh!  XBF_DONE exists in userspace too, because libxfs uses it.  Well
then, the proper place for it is at the top of xfs_btree_bload_drop_buf.
I'll go change that tomorrow.

--D
