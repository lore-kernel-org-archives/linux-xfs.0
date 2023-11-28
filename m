Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3EC187B
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfJKmt3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17C6C433C7;
	Tue, 28 Nov 2023 01:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701135877;
	bh=eWvtaldwxSaw1rl6Txz8ZhPNrST2lh3prjRORUz+Zec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kfJKmt3Ude1DoATKLzpVBVa0n/bw1vh7BISAV8tmEctZvOYjsBaqqMS6k8uZ91GdZ
	 9juOqnrqyNxj36mRuzctVb/LszcXESyZWT18a9qXy12pqqjsi39xR9vEXoiydPpwEl
	 y2jv37DC4UOuJavlXnExCS45TrJ85mqX53GTVW+f8zxejmt1PRIvvXel02gWV2EAF/
	 U3f+1nURcyIQXXEWoVVbO5RQZZBtUMxSwK57LOGS4hxutE5w7nQzPTJnERwrTYl5y4
	 O2K3fBJ96JJFZLz0KBWfB/bYyKZDPnVScdrZ2HIcDEaZPHCYaO6+duLBFG+djL7iQf
	 v/JTccWr+6YyQ==
Date: Mon, 27 Nov 2023 17:44:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <20231128014437.GN2766956@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926609.2770816.18279950636495716216.stgit@frogsfrogsfrogs>
 <ZWGLH786QzH5KpUj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGLH786QzH5KpUj@infradead.org>

On Fri, Nov 24, 2023 at 09:50:23PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:49:15PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add some debug knobs so that we can control the leaf and node block
> > slack when rebuilding btrees.
> 
> Maybe expand a bit on what these "debug knows" are useful for and how
> they work?

They're not generally useful for users, obviously.  For developers, it
might be useful to construct btrees of various heights by crafting a
filesystem with a certain number of records and then using repair+knobs
to rebuild the index with a certain shape.

Practically speaking, you'd only ever do that for extreme stress
testing.

--D
