Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92320D26E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F91G6R5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010C7C433C7;
	Tue,  5 Dec 2023 05:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701755429;
	bh=yt51aXRshf6HbK5Wy+A4jwBl28QidvdfV5izSbsd7q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F91G6R5iZhE1XXG17ri+Y8FsYT7TVpouBUlm/ZRZhF0znXdKHKDKFtxWmAZFgeAiC
	 znmZQB8arnIopwvZckUE3AIgaOClaO6gVKwGnAsSe3+EQY6GhYv58y+dKv6jM4K6H7
	 yG4xUWxCko+BnRLIx+2B7J78+Y/l/wK8EmZ+ncljHxF2fEJWniesGNgmmGR/NJAGoo
	 jaMiszaPRyhITMzkV//vH6wTAIHY8WCTrKtFRkHbzo/qIBX97MePEAI0efim6mID5x
	 5CNNUg0FcvGBh0vDs6glGXtJGdF/lZpEyUS23K3gVbXQpzmt5ZEtsJe8/oEIKKAm+D
	 iMq/byoNNszhg==
Date: Mon, 4 Dec 2023 21:50:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: document what LARP means
Message-ID: <20231205055028.GL361584@frogsfrogsfrogs>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs>
 <170175456779.3910588.8343836136719400292.stgit@frogsfrogsfrogs>
 <20231205053842.GA30199@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205053842.GA30199@lst.de>

On Tue, Dec 05, 2023 at 06:38:42AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 04, 2023 at 09:36:07PM -0800, Darrick J. Wong wrote:
> > +/*
> > + * The "LARP" (Logged extended Attribute Recovery Persistence) debugging knob
> > + * sets the XFS_DA_OP_LOGGED flag on all xfs_attr_set operations performed on
> > + * V5 filesystems.  As a result, the intermediate progress of all setxattr and
> > + * removexattr operations are tracked via the log and can be restarted during
> > + * recovery.
> > + */
> 
> Can you also add a sentence on why we even have this code and why you'd
> want to set the flag?

How about these last couple of sentences?

/*
 * The "LARP" (Logged extended Attribute Recovery Persistence) debugging knob
 * sets the XFS_DA_OP_LOGGED flag on all xfs_attr_set operations performed on
 * V5 filesystems.  As a result, the intermediate progress of all setxattr and
 * removexattr operations are tracked via the log and can be restarted during
 * recovery.  This is useful for testing xattr recovery prior to merging of the
 * parent pointer feature which requires it to maintain consistency, and may be
 * enabled for userspace xattrs in the future.
 */

--D

