Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015BD3C694
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7C2RPWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BDCC433C7;
	Thu, 30 Nov 2023 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701363756;
	bh=dFbu/i/G5i9qLnghlSd72mHYE4k6e5pfJnbM4x/6xG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b7C2RPWoO8lzfTFuH6RK1omaQOgn53Z6/JBafsTB3IiMzB3c6rGE5Icg2wGTmn8Bq
	 nsAwGebYSf4SjgYsFmurRTVyB1jTjS7NSH05/xG6uwH70j1PlnSQca0D+RwWCaSWD6
	 mc7c4m8yhbWxz5JO/9GGgSxfvEEn1D3Xl+/h7boIXarqI9r+WFcIwQd6J++ky/7wJI
	 5bynN/Yg6WrWBa5qne1H1aYd5Vj82t4LiSW8DUVhLW86zi65HoKJMB47q7HdubdKww
	 2RNRFEhLBO+dfYHcOjudkMvgmBlq1TIukn9V9dxBMudrsYEWzagzTSYxGOsRJ4ndu2
	 sevr70TeqBw0Q==
Date: Thu, 30 Nov 2023 09:02:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: don't leak recovered attri intent items
Message-ID: <20231130170236.GH361584@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120319438.13206.6231336717299702762.stgit@frogsfrogsfrogs>
 <ZWg7EbskvSLWvwNQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWg7EbskvSLWvwNQ@infradead.org>

On Wed, Nov 29, 2023 at 11:34:41PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 12:26:34PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If recovery finds an xattr log intent item calling for the removal of an
> > attribute and the file doesn't even have an attr fork, we know that the
> > removal is trivially complete.  However, we can't just exit the recovery
> > function without doing something about the recovered log intent item --
> > it's still on the AIL, and not logging an attrd item means it stays
> > there forever.
> > 
> > This has likely not been seen in practice because few people use LARP
> > and the runtime code won't log the attri for a no-attrfork removexattr
> > operation.  But let's fix this anyway.
> > 
> > Also we shouldn't really be testing the attr fork presence until we've
> > taken the ILOCK, though this doesn't matter much in recovery, which is
> > single threaded.
> > 
> > Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
> 
> No useful comment here as the attr logging code is new to me, but what
> is the LARP mode?  I see plenty of references to it in commit logs,
> a small amount in the code mostly related to error injection, but it
> would be really good to expand the acronym somehwere as I can't find
> any explanation in the code or commit logs..

LARP == Logged extended Attributes via Replay Persistence

(IOWs, a silly developer acronym for writing attr log intent items.)

--D
