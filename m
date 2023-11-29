Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E739A7462
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 05:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIGQcP2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6301BC433C7;
	Wed, 29 Nov 2023 05:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701236522;
	bh=bvLjkMMqdjrNDckFF3mAydJEi4lYipoBBvLxkuX5ieI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EIGQcP2wPrut7TojEB3VWGgzu8nsD4GUeFO84wGHSkTrcL1Y+1fOYHwWx9vIs68hF
	 3dwzYAPC5WbWmT5Se/1s4L8kmyrOABwA7BJYHaQmMyZ8UjyC0fX3ue4e/uZLCK3t2S
	 TbytVHmNz2Pgo+Sv4f9upO5pELSOO7Iwh7IjySfZ0aO6Qbu9NpkFihy/gZ7lNG9SDY
	 WOU/aUDtfdxDxE19/8HB+4eBnqwlOM9XgrtwVWOGDWzKaMnxwxI4zk/tFXb/p6Fjw6
	 WBJ9uvpjqa7IuCFTpnDiIlcZzMJntNHOD0mImL1Q8UpCOM1Ku1FL/VYUTycWOy9SVB
	 hvNd5Yvk3EBNg==
Date: Tue, 28 Nov 2023 21:42:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c
 helper
Message-ID: <20231129054201.GQ36211@frogsfrogsfrogs>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927959.2771366.6049466877788933461.stgit@frogsfrogsfrogs>
 <ZWX3I1B2nAS7gF3l@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWX3I1B2nAS7gF3l@infradead.org>

On Tue, Nov 28, 2023 at 06:20:19AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:53:41PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There are a couple of conditions that userspace can set to force repairs
> > of metadata.  These really belong in the repair code and not open-coded
> > into the check code, so refactor them into a helper.
> 
> Just ramblings from someone who is trying to get into the scrub and
> repair code:
> 
> I find this code organization where the check helpers are in foo.c,
> repair helpers in foo_repair.c and then both are used in scrub.c
> to fill out ops really annoying to follow.  My normal taste would
> expect a single file that has all the methods, and which then
> registers the ops vector.  But it's probably too late for that now..

Not really, in theory I could respin the whole series to move
FOO_repair.c into FOO.c surrounded by a giant #ifdef
CONFIG_XFS_ONLINE_REPAIR block; and change agheader_repair.c.

OTOH I thought it was cleaner to elide the repair code via Makefiles
instead of preprocessor directives that we could get lost in.

Longer term I've struggled with whether or not (for example) the
alloc.c/alloc_repair.c declarations should go in alloc.h.  That's
cleaner IMHO but explodes the number of files for usually not that much
gain.

--D
