Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01027691B;
	Fri, 12 Jan 2024 16:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Podx8yVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8D5C433F1;
	Fri, 12 Jan 2024 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705077731;
	bh=q+OAfihxHcHlDqqKxwSwi0yZby1rD7tpUBdlRzA+xyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Podx8yVCRthLvMIkVfzrtwLFgR4inr223hIWtIqQRSHOO9Aqben4HgAn2asveWr3m
	 WHVyyIGkRLDJ6U9KlPuJ9N3MIo1gSS4mgJtolJlvdczxm+K/CVkwKmVWN5ZgwLrgop
	 FemPHgs8GbUQWU9OcgN0YwrrLLNd0rte3TZ3cwkeaUJXHlpPXTrZxLRzWOGlst67+8
	 25++NzwkaK7szGAGx0qLQOZvz1JSBGobn3/C1zrT0dAg3BTX5HtwB8XbdQwqmYbOWb
	 VzJda8IIDSken+iJgrPu9ZHSqYI0a3jCeMuwFbVATT1o6v4Zm1eAOiNA/XWn2i9yeF
	 Hz8Pv9v9nIYow==
Date: Fri, 12 Jan 2024 08:42:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add a _scratch_require_xfs_scrub helper
Message-ID: <20240112164210.GR722975@frogsfrogsfrogs>
References: <20240112050833.2255899-1-hch@lst.de>
 <20240112050833.2255899-3-hch@lst.de>
 <20240112133205.yvdeh27in7l4qzu2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240112141410.GB5876@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112141410.GB5876@lst.de>

On Fri, Jan 12, 2024 at 03:14:10PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 12, 2024 at 09:32:05PM +0800, Zorro Lang wrote:
> > Usually we name a require helper as _require_xxxxxxxx, you can find that
> > by running `grep -rsn scratch_require common/` and `grep -rsn require_scratch common/`.
> > 
> > So better to change this name to _require_scratch_xfs_scrub. That's a simple
> > change, I can help to change that when I merge this patchset.
> 
> Fine with me.  I just took the name that Darrick suggested.

Either name is fine with me, so go with what the maintainer recommends.
Sorry for the churn :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> 
