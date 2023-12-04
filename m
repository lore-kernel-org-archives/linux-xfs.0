Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBA82EAFA
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 18:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JaX3kgAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8145C433C7;
	Mon,  4 Dec 2023 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701715962;
	bh=WcBS+W7aeh1CTuSfTyTPfOPDJmh94NpTYb7loD3AgKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JaX3kgAnBQABvWUbKvPgGQDjlIpuZnXvg/H3AOWgjrzlmr/NwDYmYz+PTM+Q0x76V
	 30jO/JE2/WZjxy2M4QNtqQKeTuuFpW9H1Bk9oIvjMZKFZfSDopPC4Qpj5tiIk+HyLe
	 chsjuE0ChavGoRY6XAxkB+rbrh/CAbH0yMJ+ww3LH5eNrPNXQYV0K0L6V7w6eDhsP8
	 lr5BW2DjVKcz2zQzgvd4sbsgNMHMiFX+slUtsKd5Rz0WHH9DsKRoYf823YnOQyJLak
	 4+08t7vHAegxEjRUHLuFiuBvM++A816lfRUPlfbGNqPUG05/CdHPbktaD/clak65AX
	 nVPBsPgvY6wkQ==
Date: Mon, 4 Dec 2023 10:52:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make rextslog computation consistent with mkfs
Message-ID: <20231204185242.GA361584@frogsfrogsfrogs>
References: <170162990622.3038044.5313475096294285406.stgit@frogsfrogsfrogs>
 <170162990643.3038044.15276614586917381582.stgit@frogsfrogsfrogs>
 <20231204045526.GA26073@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204045526.GA26073@lst.de>

On Mon, Dec 04, 2023 at 05:55:26AM +0100, Christoph Hellwig wrote:
> > + */
> > +uint8_t
> > +xfs_compute_rextslog(
> > +	xfs_rtbxlen_t		rtextents)
> > +{
> > +	return rtextents ? xfs_highbit32(rtextents) : 0;
> 
> It might just be a personal pet peeve, but I find a good old if much
> more readable for this:
> 
> 	if (!rtextents)
> 		return 0;
> 	return xfs_highbit32(rtextents);
> 
> Otherwise looks good:

Same here.  I'll adjust it in the next patch, since this one is the
copypastahappy hoist.

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
