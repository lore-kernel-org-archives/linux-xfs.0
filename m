Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840F02E859
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/X84eag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CDBC433C7;
	Mon,  4 Dec 2023 18:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701715429;
	bh=X4vFRL7HPFjoC3KEcv8kHtlsxJFKjWfqO3OcV/8eb0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P/X84eagAYtRONA+lixIMlxXQJCwGv7WNhFOiBGB4K6XfFzOtoaHdMi7csFTSEBmS
	 h/3CD7Ut3mh9TjNM1MLVlKdiILgMevI5UqCfAW44xFWHhQBe8/jSMdxb8o/6Q0CWg/
	 ulO5TKlgamDuXhXqTEYy0W/ZUNLzY0MmXl+LfZtgQ9ucxZGkdTrZQpEd2cxyPPjAkl
	 8Ce5+WUzButxRjV3Pxl8Iu7gXWVeRJ/g6xYokjcBZbfuA0rR2S0BI2Bvs8+vphwAGA
	 HKDI3ryYBzaKbrr2o9kaRBqF108kIWN3WA7fNJUZXFcB+ukX3TuVnXrCz/XxfGCLl4
	 JtrDt/dMlosuw==
Date: Mon, 4 Dec 2023 10:43:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: don't set XFS_TRANS_HAS_INTENT_DONE when
 there's no ATTRD log item
Message-ID: <20231204184348.GY361584@frogsfrogsfrogs>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
 <170162990183.3037772.16569536668272771929.stgit@frogsfrogsfrogs>
 <20231204050803.GI26073@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204050803.GI26073@lst.de>

On Mon, Dec 04, 2023 at 06:08:03AM +0100, Christoph Hellwig wrote:
> On Sun, Dec 03, 2023 at 11:02:57AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS_TRANS_HAS_INTENT_DONE is a flag to the CIL that we've added a log
> > intent done item to the transaction.  This enables an optimization
> > wherein we avoid writing out log intent and log intent done items if
> > they would have ended up in the same checkpoint.  This reduces writes to
> > the ondisk log and speeds up recovery as a result.
> > 
> > However, callers can use the defer ops machinery to modify xattrs
> > without using the log items.  In this situation, there won't be an
> > intent done item, so we do not need to set the flag.
> 
> Understanding the logged attrs code is till on my TODO list, but
> the patch looks obviously correct in that we shouldn't set
> XFS_TRANS_HAS_INTENT_DONE if there is no done items.  I'm still
> confused how it can log an intent item without a done item,
> though.

Dave and Allison and I at some point realized that the defer ops
machinery works even if ->create_intent and ->create_done return NULL.
You'd lose the ability to restart the operation after a crash, but if
the upper layers can tolerate a half-finished operation
(e.g.  ATTR_INCOMPLETE) then that should be ok.

Obviously you wouldn't touch any such *existing* code except as part of
adapting it to be capable of using log items, and that's exactly what
Allison did.  She refactor the old xattr code to track the state of the
operation explicitly, then moved all that into the ->finish_item
implementation.  Now, if the setattr operation does not set the LOGGED
flag (the default), the behavior should be exactly the same as before.
If they do set LOGGED (either because the debug knob is set; or because
the caller is parent pointers) then ->create_{intent,done} actually
create log intent and done items.

It should never create an intent item and not the done item or the other
way 'round, obviously.  Either both functions return NULL, or they both
return non-NULL.

--D

> Cautiously and superficially:

Thanks! :)

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
