Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5328BF5
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 02:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePH/0tlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DABC433C8;
	Wed,  3 Jan 2024 02:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704249101;
	bh=jqcEYrwhfQl0Ho/Hqd90QItq+6SOoi9tlEQ8OEbYU8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ePH/0tlJUvvrw46L373Rsn6shwbAVtGe+RwNn0vouPcWFLkEWwsj+AjEVkqcbU8kl
	 otPy/NN564E4dxKNoFMJkk6NEDHfZ7ks1qw9Kr4HXXJlTOuR/d0ARvb+RoPWZQSljl
	 spdlOWaYrDMyfW/9z32Iih1tV62bKpQ2Bdlfd0N138zjkI9FOVoWfes2Gr8+yt8Jzp
	 0RYCwHGIYApfa4xr9O3qTmdMkYN5hSFZCmKXozHBflOfx8PGkLQFvVJTWsH/jrouiV
	 OD8bNmp+czzd+He8docYgm32zA6Qs+l+m+ReL2chVi0By8RUA5yP7zk9vtwroa6Z0l
	 S38Rw9EpDsNdQ==
Date: Tue, 2 Jan 2024 18:31:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: port refcount repair to the new refcount bag
 structure
Message-ID: <20240103023140.GL361584@frogsfrogsfrogs>
References: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
 <170404831070.1749557.18013766870623858132.stgit@frogsfrogsfrogs>
 <ZZPo41xL8LRDcX44@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPo41xL8LRDcX44@infradead.org>

On Tue, Jan 02, 2024 at 02:43:47AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:20:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Port the refcount record generating code to use the new refcount bag
> > data structure.
> 
> This could again use some comments on why you're doing that.  My strong
> suspicion is that it will be a lot faster and/or memory efficient, but
> please document this for future readers of the commit logs.

The new implementation is less memory efficient (because now we have
btree headers and internal nodes) but makes it a lot faster.  If I turn
my reply to patch #2 into the commit message, will that work?

--D
