Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380631F926
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkD3+cWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B8AC433C7;
	Thu,  4 Jan 2024 06:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704351484;
	bh=Ct3/IBHmXYYDgzQNq6VGWbWP3rrbg9WpHkngjmYmp1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bkD3+cWGhrmwgRBQouYKWUSnW+Yp1BkILp0XnzBk7j33GvtJEHUGg9F68ImuMXppq
	 uA8tQCcCD4DIVbd7hu/r70XEu32zSAWBuS/XPyz4fj9L2gWxci0K9VmxrhOfIkTqew
	 cR5bQFbixA9rC0jDSI4arXkTC4ss/PSLMTXdHIT+vlAOmS7yH00WYvMkfo2MCLeCnL
	 BE9H0Fdiu2tnbfajiZ/awbPp8nN8THcpUCqsQSaqnneLqvQBn1gXq1bbjxLQ5GScxu
	 VREO20RLuAXW6FhX1E4t8Fjsc4rEPsIUBvVqOHCd80VYM87cK76BzlruCT8jg50GMk
	 yFz0g+Lx2VQEQ==
Date: Wed, 3 Jan 2024 22:58:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/15] xfs: remove the xfile_pread/pwrite APIs
Message-ID: <20240104065804.GW361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-6-hch@lst.de>
 <20240103234849.GY361584@frogsfrogsfrogs>
 <20240104061542.GC29011@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104061542.GC29011@lst.de>

On Thu, Jan 04, 2024 at 07:15:42AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 03:48:49PM -0800, Darrick J. Wong wrote:
> > "To support these cases, a pair of ``xfile_obj_load`` and ``xfile_obj_store``
> > functions are provided to read and persist objects into an xfile.  An errors
> > encountered here are treated as an out of memory error."
> 
> Ok.
> 
> > > -DEFINE_XFILE_EVENT(xfile_pwrite);
> > > +DEFINE_XFILE_EVENT(xfile_obj_load);
> > > +DEFINE_XFILE_EVENT(xfile_obj_store);
> > 
> > Want to shorten the names to xfile_load and xfile_store?  That's really
> > what they're doing anyway.
> 
> Fine with me.  Just for the trace points or also for the functions?

Might as well do them both, I don't think anyone really depends on those
exact names.  I don't. :)

> Also - returning ENOMEM for the API misuse cases (too large object,
> too large total size) always seemed weird to me.  Is there a really
> strong case for it or should we go for actually useful errors for those?

The errors returned by the xfile APIs can float out to userspace, so I'd
rather have them all turn into:

$ xfs_io -c 'scrub <fubar>' /
XFS_IOC_SCRUB_METADATA: Cannot allocate memory.

vs.

$ xfs_io -c 'scrub <fubar>' /
XFS_IOC_SCRUB_METADATA: File is too large.

So that users won't think that the root directory is too big or something.

--D
