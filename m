Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A5A2F865
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 18:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCv2XScr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3435C433C9;
	Mon,  4 Dec 2023 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701714713;
	bh=2LRvl5B1oljlcwBex2pkNT4A8jnTBmPCqDacIYzd/PU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BCv2XScrOyv27TGs5mnDGqXY9JKAqRguPDTfmSOtxtoT3qg1DDr6er/ZWFYnb2VHP
	 B1edJ8K/rpIaqNV1nILiTSoaCCasow/jkWZQz6zwa3w0aTx3W9hjkmkKdxejGgqxkM
	 hqpIsZ3BzMGAlGEtn6ksqAZgFLaz0EHXU4Epm+xcRQ5u42OxbH/5Oty0714NkQ3+OV
	 vvT7vt97FqKtd4swJURi8O9IldLLQmLBNKTSKmHhWDt6P2uQPqOh9GsaghoRYKiR6U
	 Jt7VOLuQ5FVSoEBy5GmDOxdL4/bWUpJwN2J9YgcJa2I2hNi188UnDAYZJl5IenggSI
	 90lwvHakqvu5Q==
Date: Mon, 4 Dec 2023 10:31:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, leo.lilong@huawei.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: pass the xfs_defer_pending object to iop_recover
Message-ID: <20231204183153.GX361584@frogsfrogsfrogs>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs>
 <170162989753.3037528.15154705573817500020.stgit@frogsfrogsfrogs>
 <20231204050426.GE26073@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204050426.GE26073@lst.de>

On Mon, Dec 04, 2023 at 06:04:26AM +0100, Christoph Hellwig wrote:
> Not sure if I missed it in my first round of review, or if this is new
> in this version, but this now generats a warning when asserts are
> disabled, given that the lip variable in xlog_recover_process_intents
> is only used in asserts.  We'll need to remove it and just open code
> the dereference in the two asserts that use it.

Yeah, that's the last patch, and I forgot to address that warning
because the kbuild robot only sends email to my Outlook now.  Clearly
I'm not doing CONFIG_XFS_DEBUG=n builds on my development box...

--D
