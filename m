Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA7E5FEE2
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqHKPQ2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C669C433C8;
	Thu, 30 Nov 2023 21:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701379136;
	bh=PlA8OPR7O/ubBsdmf0NoFD4ULnJ8Go9cFwlAG0kNPS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aqHKPQ2yM3ga7bgNQ54uaeWhHkdJvqRKgS5mTbnnVi4jFfQwrHolv3n9pRBq/hAPN
	 QAwnhkns/5LLskibgAkXg6kpuUyQd50QFH3G+f8rBjNQGTowZc+NH+qQUB0fbVtL4U
	 emB6aQieZhEUFqigESUkLqSYy/vVYtQ4sZWVqUzwLQrU+D89QTBGMcaqcenQ3RoL1G
	 XmBnDZAv57q1FqU65NVjjibIu3gJUyemylgC3dGLyIvVS52aviVHlAKG2Pduotf4bF
	 4UjdtF61Pt7rGmGGy3S/hk0UUSrFtVNWwNtZzSWVMC6cIzUT3tcv7i8Yqa7F9id76f
	 RJHTyd7xQohxw==
Date: Thu, 30 Nov 2023 13:18:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: repair obviously broken inode modes
Message-ID: <20231130211856.GO361584@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927551.2771142.12581005882564921107.stgit@frogsfrogsfrogs>
 <ZWgUYG+Hv/rO3upQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWgUYG+Hv/rO3upQ@infradead.org>

On Wed, Nov 29, 2023 at 08:49:36PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:52:54PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Building off the rmap scanner that we added in the previous patch, we
> > can now find block 0 and try to use the information contained inside of
> > it to guess the mode of an inode if it's totally improper.
> 
> Maybe I'm missing something important, but I don't see why a normal
> user couldn't construct a file that looks like an XFS directory, and
> that's a perfectly fine thing to do?

They could very well do that, and it might confuse the scanner.
However, I'd like to draw your attention to xrep_dinode_mode, which will
set the user/group to root with 0000 access mode.  That at least will
keep unprivileged users from seeing the potentially weird file until the
higher level repair functions can deal with it (or the sysadmin deletes
it).

Hmm.  That code really ought to zap the attr fork because there could be
ACLs attached to the file.  Let me go do that.

--D
