Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0645A1848
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6kIlpQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CF6C433C8;
	Wed,  3 Jan 2024 01:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704245182;
	bh=/2FZS95SIxrchJMvR32tB8AF8SR4qVnOYEG5ATdfHuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W6kIlpQdiJJGWgBIWfnuYWUptBCfC4/L8Sl8a6Ac5vrQ5UTMWaGF+3x9c7412O9bT
	 F+ix25okZutgxX15PF1C2k4/56EDm7Tp8t3J2pKAYsfZ3UI3622vigGSgSEETHSuMt
	 i21VOtMXJDOqaDWFCFOxrdXpUCF+8Un/4LLYWE8XVpGlJf9Rt091QR9SzIuPDfWhSj
	 FkVAdv1/9PrTEu1pSAgBwtmy/yX7my0DMuNCuiYTyRZ8PkNoTjiFFBEBFHIy37FZjm
	 KXtfBBhCq2gg4ZkdIfEq0B6GX11Fpvg32NGdNYkiZrgI4Kt2gGZoFsbCbCdROu/N9V
	 liqhyVwcfaYJg==
Date: Tue, 2 Jan 2024 17:26:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, Neal Gompa <neal@gompa.dev>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v29.0 34/40] xfs_scrub: fixes for systemd services
Message-ID: <20240103012621.GF361584@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
 <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
 <20240102104804.GA9125@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102104804.GA9125@lst.de>

On Tue, Jan 02, 2024 at 11:48:04AM +0100, Christoph Hellwig wrote:
> Can we somehow expedite these plumbing fixes for the next xfsprogs
> release instead of just hiding them in the giant patchbomb?

I was planning to do that, though I don't think cem has merged any of
the 4 pull requests I've already sent him for xfsprogs 6.6. :/

(Granted everyone has been on vacation for weeks, myself included, so I
wasn't expecting much progress...)

--D
