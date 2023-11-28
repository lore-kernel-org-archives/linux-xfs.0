Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qxB8ddw9"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863FCC1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 06:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lEECYNKEYHLhBIUeAjytCofUNXjkhzai4r2ubzrpzpg=; b=qxB8ddw99kw/nnAHwr4WGCRGhV
	LU4nSZNd5oEHcZOVC3LNcpwC3Yfr1ItNdGQU/8B8lYpPdFssL+eVU0m+QVcxXRfIt44fI+t0jLzGy
	hVRPllBwx8RlCwW9gtX1pw8nd7nF8hNGWYy1Hc628PJ1tFVKeIqQaLAuvagSPvembZsTatbSc1eS4
	oczv2tMkIz7+2I6tXK6Hmf56xuLBTOrYTBqjaO4wlkdDybNri451fGNBt7BlOtUUVK4uUkNthfT2+
	Ii+bePgZZZ76qCKdTUlsIZTDGrAwBKj3A9UqUaI2eCdqtlDYo+MQHLijL9azWZ9iGHDOygrOYPchJ
	Yhil30ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7ywl-005Usv-1J;
	Tue, 28 Nov 2023 14:20:19 +0000
Date: Tue, 28 Nov 2023 06:20:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c
 helper
Message-ID: <ZWX3I1B2nAS7gF3l@infradead.org>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927959.2771366.6049466877788933461.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927959.2771366.6049466877788933461.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:53:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a couple of conditions that userspace can set to force repairs
> of metadata.  These really belong in the repair code and not open-coded
> into the check code, so refactor them into a helper.

Just ramblings from someone who is trying to get into the scrub and
repair code:

I find this code organization where the check helpers are in foo.c,
repair helpers in foo_repair.c and then both are used in scrub.c
to fill out ops really annoying to follow.  My normal taste would
expect a single file that has all the methods, and which then
registers the ops vector.  But it's probably too late for that now..

