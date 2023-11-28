Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AB51C2E
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bv0yQbcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295DBC433C9;
	Tue, 28 Nov 2023 01:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701135285;
	bh=3YXj6R/GQCa34tR3wTIGeHvsbDQVWrHSN9wdlAPOLKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bv0yQbcMW8Yeh+cQTodcP5HMP482uKhsOZBj5br2JTe8eqq0jleDvS/7rCndDfSwF
	 InciB+UmzMvj90IXhLbXpw10FK6TBENbHD/n1Qy59fbMpXJa92/9KK8dJ+0119yFKR
	 Ida1iDvLEouekFQqEyyCqjoONguzfip3h5khVTp+uCcymYQ0f6CSsPwsrJ64D4UmTR
	 SEmnl5F0hAemwEaPUe+Es7ZDylMHXg9GM3FtUQ11xIG9YTcWrVb1BqOco2q/mVHNkT
	 NSMUYa9JJxYPSi1LR4pk3w0OhrOX7Nil7v8rp/BV8phauCXRcJCTDzQXjHpDKwjD1I
	 wnujK7UugkrCw==
Date: Mon, 27 Nov 2023 17:34:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: create separate structures and code for u32
 bitmaps
Message-ID: <20231128013444.GM2766956@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927011.2770967.5667556103424812308.stgit@frogsfrogsfrogs>
 <ZWGMz5WYlUGpv7OQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGMz5WYlUGpv7OQ@infradead.org>

On Fri, Nov 24, 2023 at 09:57:35PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:50:02PM -0800, Darrick J. Wong wrote:
> > Create a version of the xbitmap that handles 32-bit integer intervals
> > and adapt the xfs_agblock_t bitmap to use it.  This reduces the size of
> > the interval tree nodes from 48 to 36 bytes and enables us to use a more
> > efficient slab (:0000040 instead of :0000048) which allows us to pack
> > more nodes into a single slab page (102 vs 85).
> 
> The changes themsleves looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Q: should we rename the existing xbitmap to xbitmap64 for consistency?

Yes.  Done.

> Also why are the agb_bitmap* wrappers in bitmap.h?  Following our
> usual code organization I'd expect bitmap.[ch] to just be the
> library code and have users outside of that.  Maybe for later..

Those wrappers are trivial except for the enhanced typechecking, so I
didn't think it was a big deal to cram them into bitmap.h.

--D
