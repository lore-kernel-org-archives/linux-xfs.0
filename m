Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016D8EB8
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 05:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgvCU5pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F6CC433F1;
	Tue,  9 Jan 2024 05:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704776929;
	bh=0E93FnTpwh7fgzB99xvQf/MxndrpURu7bnkEW2wOU48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KgvCU5pQrzwwSHVMv4UnGc/5OULK0XGS64skyPGbPjcd779UqyBDruwW+Luc3Gbbc
	 rG1PNpLOKB+47JiP7xVT98Ao081B7Mev3/7NKEOCcdNRyd61lgDg4Uq6y6pqsGPkGb
	 A4tNZ7KmFXn2j93Cuh0qJunb8Zh5VH2xMeKzTrzG15SKDI5ddakAdcmP2Kn3KmfgZ4
	 +Qj9AblUVtwdaw1TwvZZQsYWTs2iCF0285LJAgxnkqw1ffxJ2+UD08cIx/h2qMi5+Y
	 q+4RDiJfgDAQp8jBnBDJN5yEfzRNmdR9KKq3vICdJp9W5Ur0RsXyesjgQWJTz5UZN1
	 ndOH+D++NkvOg==
Date: Mon, 8 Jan 2024 21:08:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix backwards logic in xfs_bmap_alloc_account
Message-ID: <20240109050848.GD723010@frogsfrogsfrogs>
References: <20240109021734.GB722975@frogsfrogsfrogs>
 <ZZzNQ4/QkDxa0JIW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZzNQ4/QkDxa0JIW@infradead.org>

On Mon, Jan 08, 2024 at 08:36:19PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 08, 2024 at 06:17:34PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > We're only allocating from the realtime device if the inode is marked
> > for realtime and we're /not/ allocating into the attr fork.
> 
> Hmm, interesting how this survived all my rtalloc tests.  How did you
> find this?

I actually found it while reabasing the rt reflink patchset atop
for-next, because you unified the bmap allocator accounting functions
instead of copy-pasting them like I did.  Then I tried generic/476 and
it blew up the first time it encountered a reflink file.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!  Chandan, can we get this merged?

--D
