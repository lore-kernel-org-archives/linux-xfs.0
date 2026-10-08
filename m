Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38864D9F6C;
	Thu,  8 Oct 2026 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791474264; cv=none; b=qGF2BSuoZP8SyO1a2xRWZSUw2NOnYWHdzUv79cGzYBZtysCOt9Eq+ElJPLzUKR/ZgKSj3KEmDse38QiLjeVA1A4zGK9GKn+ixsQryg79Fc6dJwEuWmPL3CxgsfoUPq8YoSAP7jh/v1YsfcepSUplVcmeVrfA/1GY/ZaVkeyZ4ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791474264; c=relaxed/simple;
	bh=MIfma0GB6wN1243IK1x8pB5v7ZJgbogXm7SYLU9JkNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UX0R2ofo3jLtDa6zIaV9tFZCHddjdytq9ZKQX2+wjS3UMeGUDXcz0Zq3vF4BqrhZyAVvVZs3N16zFn/TOsiPvy5ETc7UzoZWi94xICP2QYTNW2rFfZBhKSRvCLpAzqpPsgHHn/9B+l/O7gLTCmujHzTRPHOiNpl7TshfYL6hmAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcIrEB6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcIrEB6Z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 843E51F000FF;
	Thu,  8 Oct 2026 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791474263;
	bh=u2g3DtRX73+T8pISpK5W/aly7TLyWdpOx3RTXnl6Hc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fcIrEB6ZNEjugRAsDYD4OLwoso2niMhnDnP02ASDQnF7rqDK5/wDaYO85roTOQyJs
	 ZQMT/ogBWQtwne4uiSFJdO53OHGsbx+CqKCh/A1klhol9MKzYEbufsrMMtN6MNgDL/
	 TzI3SbNZ8ODejKkNeYJUYimefmlSpkO7yfWi/Gq5aa1BiPP4hze96oe/8yhDy7ysIj
	 6l3oYPnyJjo7KgmvM1e8AijR/eOpGEygqB+2S4zieZrJPhLkDhyb5CG2vnYOaPPVhv
	 1KcsJMO99AKMqY/PMFvwtyZFkzc20vgLqcvaonKJ6UbDN0nweQAeebxpdGablAXGVJ
	 EOrzMwYw9OEGQ==
Date: Thu, 8 Oct 2026 08:44:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: don't subtract excess usage twice when
 computing agf_btreeblks
Message-ID: <20261008154423.GQ2705364@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521299.2728617.2877901149807191718.stgit@frogsfrogsfrogs>
 <aseEZKG8wACedf9W@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aseEZKG8wACedf9W@infradead.org>

On Thu, Oct 08, 2026 at 04:54:12AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 07, 2026 at 10:55:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that the free space btree repair code calculates
> > agf_btreeblks from the number of blocks we wrote to rebuild the free
> > space btrees (minus the roots).  That's correct.  However, it observes
> > that we subtract the "excess" reservation, which is not correct.  Fix
> > this accounting problem.
> 
> xrep_newbt_unused_blocks is unused now.

Oh, heh, I'll get rid of it then, thanks for pointing that out.

--D
