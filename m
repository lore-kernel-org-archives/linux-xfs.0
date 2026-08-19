Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F553AB47B;
	Wed, 19 Aug 2026 23:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787181585; cv=none; b=h8K2cTbQ6L6L4mhEVBAkqDTyyp6XwjMtqS2GL77gxC1q0yT/viUFdRn+JQbkgV+3kc0ybZ4K/qg1Hk0BBQSTA6Hn/1blzDafUKkRYAO8ma9DIBJGj4KexIdmaQrmBeq4P+mEVFFjVEqI31CleXrJqhgb6rEjLMy0B3ICsqojiak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787181585; c=relaxed/simple;
	bh=q14QiZ+J/mSkdx56aIXd4q8w4z7zfzBiFoGTqxcaq74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdVXY47R0Hbigf4HP3L8aYIpWJOGeiLG40UN71yU43XSbGeZlgNdt6iHU4wZVWGY2kB9k6mZ/ySQWWpM6+ViSSlA3yvjgTl6qBb7AXlG5d9hsngWTAAT/OT+yAk0VI3Jxhm8bSTeFakzrwjxhG1hb9OMtAzG1zuRrsSnCSB0SPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TN18Q3N1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TN18Q3N1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 448FE1F000E9;
	Wed, 19 Aug 2026 23:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181584;
	bh=Q2s2LsHLIyU0MtjsOuA12m0HrfmxaeE8nX71yD1TRg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TN18Q3N1Q7QfhpqFGoX9Zf4qBNs9Y+oQWPbzhKILDCT7ei6UMdWRvGpjNF4MemZYt
	 5z3o4IHlh2bg15Y/oKXvsvPAYqF4y8wq54MVFtgqfQt4O938fd9ThdvtylUyFcQRwK
	 yD03wmZWV3RpFXZZxNqKmsXorBwq4vMvaZGT13NB8CGHqIPtpOAwde1kd8AP9jQxfo
	 NnPQvZU1sY4y6X766WxmU+x92KKuzw139dYhwnYX//NOnqCgqVbWlYBetQnXsrbtmY
	 3ZjFajvWXQPK0VLRwzqK7D0Uj5pDsgvKHU8w3QW+DWne3iaQpIY7nj5csCphpimluP
	 UoDtbhqjR73vA==
Date: Wed, 19 Aug 2026 16:19:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap
 filesystems
Message-ID: <20260819231943.GD6072@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861897.833922.17703139818760252058.stgit@frogsfrogsfrogs>
 <aoVKR4HmS3Hi7WBg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoVKR4HmS3Hi7WBg@infradead.org>

On Tue, Aug 18, 2026 at 11:16:39PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 12, 2026 at 10:25:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It's possible to construct an in-memory rtrmap btree for filesystems
> > that don't have the rmap feature enabled.  The kernel doesn't do this,
> > but xfs_repair will, if asked to reindex a filesystem that has rtreflink
> > enabled but not rtrmap.  Therefore, we must create the cursor with
> > enough levels to handle a maximally sized btree possible.
> 
> Should repair initialize m_rtrmap_maxlevels instead of overallocating
> in the kernel?

I'd prefer not to because (a) m_rtrmap_maxlevels is used in various
places (like computing transaction reservations) outside of creating
in-memory btrees and that would be weird on a non-rmap filesystem; (b)
the regular rmap code in xfs_repair already allocates biggish cursors
for in-memory btrees this way; and (c) I don't think it matters much
even in the kernel because if we're that low on memory then we're not
going to be able to create a replacement rmap record set in memory to
stage the rmapbt regeneration anyway.

That said, a more targetted way would be to add a maxlevels parameter to
xfs_{rt,}rmapbt_mem_cursor() and let the caller figure out the optimal
setting for their context -- online repair can use
mp->m_{rt,}rmap_maxlevels because it only creates in-memory rmap btrees
when rmap is enabled; and xfs_repair can use
xfs_{rt,}rmap_maxlevels_ondisk() for the weird (reflink && !rmap) case.

How does that sound?

--D
