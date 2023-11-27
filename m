Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545C33AC21
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqXCBpDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF7C433C8;
	Mon, 27 Nov 2023 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701109454;
	bh=e7NN+1RAnFkJo3jFabvsTh4M/sZOd8vGgUd+ib84ig8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OqXCBpDFvtHB8D/Dg/1UH2CbErR64CAy4DqsLtTPT293s9h2ZPssI2tq5nQ2cPRgx
	 F0Xyk05fKToWuDdx+t59fbqNpVa/W0DoM3d7BEhtYLLadQl0c2xy45AVMuc/anDLPK
	 jnRckdXkDwfGoQ9ZkATTHYGfC7q/S9MaJUvhpTysQr7T/QXuYMDvFBevhZmZYoUWQ7
	 g0FvCT2Nwo0HXCmnqHgf6tMQDgjNiU1x/yEaCLSroHpuhlWQ0TKP2YPBJJGxkvs95b
	 mnLnXZBGVpfqlj0JCTqlieVExeRegZPXx1F84LLJCblUYzMwyuwbG7OCjiurJOWiuk
	 Yyp6h8CNLkh2w==
Date: Mon, 27 Nov 2023 10:24:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs_db: report the device associated with each io
 cursor
Message-ID: <20231127182414.GC2766956@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069443096.1865809.13119575401747000666.stgit@frogsfrogsfrogs>
 <ZV70BSL4TBfVZdVA@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV70BSL4TBfVZdVA@infradead.org>

On Wed, Nov 22, 2023 at 10:41:09PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 22, 2023 at 03:07:10PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When db is reporting on an io cursor, have it print out the device
> > that the cursor is pointing to.
> 
> This looks very useful.  But I wonder if it risks breaking a lot
> of scripts?

<shrug> There's nothing in fstests that depends on the output of the
'stack' command, and debian code search didn't come up with any hits.

--D

> 
> 
