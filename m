Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BB235EF5
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3pts9S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC03C433C7;
	Mon,  4 Dec 2023 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701722096;
	bh=OYWVsi0XG6OPJg4SupE6Byq+i6SZAWFe/jySUdUG5As=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F3pts9S0Zz5aKgC+lssOxxJELlEfOsqiSirJeaqq5GeT7deXjefW38A3d/bLMkUf3
	 y7NicffF7J1JR0LmVs6Ox/2GHYuZxryGd+dWw+UOBp+yV+26HEQ/BuNFo1KOWGfMuS
	 wpR59HhLzoe5+VILJgeyqGA6+YRASHXRotc/ERoDqk7lferwOm5T/VOtztr7CmF+l9
	 lTkNtAfbrdx+zlpnpBTXBoY7YBiUmshm1E1bzGNEXxs+cjJ0nVAdgKieSSH8qiMtnG
	 C0Wm36XobAISkXiwbpadbMf7NVzWKyQqN1w/leOKpCZsuR+Go2J/opo9LojmFQF2ds
	 zsjC1sq7tgisw==
Date: Mon, 4 Dec 2023 12:34:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: don't set XFS_TRANS_HAS_INTENT_DONE when
 there's no ATTRD log item
Message-ID: <20231204203456.GE361584@frogsfrogsfrogs>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
 <170162990183.3037772.16569536668272771929.stgit@frogsfrogsfrogs>
 <20231204050803.GI26073@lst.de>
 <20231204184348.GY361584@frogsfrogsfrogs>
 <20231204194445.GA17769@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204194445.GA17769@lst.de>

On Mon, Dec 04, 2023 at 08:44:45PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 04, 2023 at 10:43:48AM -0800, Darrick J. Wong wrote:
> > Dave and Allison and I at some point realized that the defer ops
> > machinery works even if ->create_intent and ->create_done return NULL.
> > You'd lose the ability to restart the operation after a crash, but if
> > the upper layers can tolerate a half-finished operation
> > (e.g.  ATTR_INCOMPLETE) then that should be ok.
> > 
> > Obviously you wouldn't touch any such *existing* code except as part of
> > adapting it to be capable of using log items, and that's exactly what
> > Allison did.  She refactor the old xattr code to track the state of the
> > operation explicitly, then moved all that into the ->finish_item
> > implementation.  Now, if the setattr operation does not set the LOGGED
> > flag (the default), the behavior should be exactly the same as before.
> > If they do set LOGGED (either because the debug knob is set; or because
> > the caller is parent pointers) then ->create_{intent,done} actually
> > create log intent and done items.
> > 
> > It should never create an intent item and not the done item or the other
> > way 'round, obviously.  Either both functions return NULL, or they both
> > return non-NULL.
> 
> It would be really good to document this, the name LARP and why it is
> considered a debug feature somewhere in the tree.  No need to hold
> up this series for that of course.

Yeah, that'll become a third cleanup series to add a comment and elide
tthe create_done thing. :)

--D
