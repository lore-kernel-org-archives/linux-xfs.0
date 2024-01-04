Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB14286AF
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyFPHd7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D42FC433C8;
	Thu,  4 Jan 2024 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704389108;
	bh=nwnDiXO82C9pR7YZQyvCYE6Jwr88yWk96exyJXsYXXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IyFPHd7zAlgYsonQFV1ZzM0mnxxYw6Ruby49GqkufQOFJrrKYnnsZcnPbcjx15ptG
	 ZaBtzu3O3xTPd3pJTECYRT+pArmInxR+/fBvonWzTzSxOrDIE3phT75mCNfWdtiVxa
	 bxgeRgMUJ0ML9pAvIzVuGgeyqyY7Un0ex9Jb22hO/7ukPRmcjVPzk9G9inZ5X4f4tC
	 2hKwuJOqpb8GlEsqFFV8qAXt6Q8F9wywrAnJkFX4XgZ/jVs3DOFEXmXHON4HHkz2tg
	 X++kw8LpZjW32bzUcy9ARHRgp6EKiGm3ydPrELYCfGw1vMMpLTvQpI2bXatS1gFLEP
	 mCplw2u4IpUEQ==
Date: Thu, 4 Jan 2024 09:25:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: remove the in-memory btree header block
Message-ID: <20240104172507.GG361584@frogsfrogsfrogs>
References: <20240103203836.608391-1-hch@lst.de>
 <20240103203836.608391-2-hch@lst.de>
 <20240104012405.GN361584@frogsfrogsfrogs>
 <20240104062725.GG29215@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104062725.GG29215@lst.de>

On Thu, Jan 04, 2024 at 07:27:25AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 05:24:05PM -0800, Darrick J. Wong wrote:
> > Originally it was kinda nice to be able to dump the xfbtree contents
> > including the root pointer.  That said, it really /does/ complicate
> > things.
> 
> Doesn't any kind of dump need to talk the btree anyway?

Not if you're willing to stare at the output from xfile_dump() ;)

--D
