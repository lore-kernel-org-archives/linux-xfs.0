Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8B71FAB
	for <linux-xfs@vger.kernel.org>; Sat,  6 Jan 2024 00:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qL/LiCA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D355FC433C8;
	Sat,  6 Jan 2024 00:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704501270;
	bh=gV8Xm32lzi9aLgCH98iassLll9F6pY/FLdtL1wckvII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qL/LiCA/KUjhK2bxOHpfeP2tdjObUVfYXju+TUyW88Bu7Aj4yTVwVXVg6WgmGWIgx
	 0rD7uI4fjQhC8eurcQzNMHEpmh79j+lyD3PIZ54mvQzYY2ESniLFj4ddp93lAhNaqE
	 zFs+Hx8Lll0ghRKecCzDdAlyTCoNNTW7s4PtxKlr9dUjQfs+xFZHF52aC4x9ndsk/I
	 x5XuzONe1bG6NonWNpZoyd3n3b2SSvtxjRey5pLRJglubu4h2xBHUDS/9t349EMfWQ
	 s6+Mb1733FiWr35xVfdPOzxTakthM+led0/GWW2Kq+GO180zM5rpQmwI0EVekg3tzA
	 IdNOWhJn/JWJg==
Date: Fri, 5 Jan 2024 16:34:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub: add missing license and copyright
 information
Message-ID: <20240106003430.GJ361584@frogsfrogsfrogs>
References: <170404989091.1791307.1449422318127974555.stgit@frogsfrogsfrogs>
 <170404989121.1791307.11991700038288629059.stgit@frogsfrogsfrogs>
 <ZZeKgICWELWcwlIk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZeKgICWELWcwlIk@infradead.org>

On Thu, Jan 04, 2024 at 08:50:08PM -0800, Christoph Hellwig wrote:
> Given that the last patch moved to the -or-later SPDX variant shouldn't
> this also pick on of -only or -or-later?

Yeah, I suppose they should be licensed the same way as the rest of the
files.  Will fix.

--D
