Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2f6pUD9w"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D606FA2
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IOQPzBLBkMFQeYGXyFbQ6hEyP7N0Ulztu4/Ev5jjfYw=; b=2f6pUD9wRdR3yHvHCrtnlvWYjH
	akDF43MFjpyURS7qAu101MljzMZFBDSRTZLdUIsZ5A4kKioD1YnRAyPJEbcNXoyQs8jYlGnve++Dr
	Df8Wl64Dpz5f8zTFXFiGhSZ2qE0V8TNB0qZ6XF6LYiHMrG2wn8Oc8ZMU4/Y1yYj+tdgvusKbWZivk
	Nkkv3RGoERruVSDo029/tg6yzpMH9HaGLYtmHao4U0qYWyanx0VYS4szAwBjT1SLRiLm70hW4VWDf
	xDKwcPIxkC7NdBm41rMGSMWldHEl53YKsBEtNczVILp2erwFWoCJbGbwKlLPISmPBYc5vjeps3hVz
	FCXW7o2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Fk-003uj9-2Q;
	Thu, 23 Nov 2023 06:31:56 +0000
Date: Wed, 22 Nov 2023 22:31:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_scrub: handle spurious wakeups in scan_fs_tree
Message-ID: <ZV7x3LFMC2jM99on@infradead.org>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
 <170069447457.1867812.1581024114980726743.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069447457.1867812.1581024114980726743.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 03:07:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Coverity reminded me that the pthread_cond_wait can wake up and return
> without the predicate variable (sft.nr_dirs > 0) actually changing.
> Therefore, one has to retest the condition after each wakeup.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
