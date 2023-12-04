Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cPAMgHdV"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C10E6
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w05aUvj8gLE5VWoY2rZSWhpjAJUs9uTp6PbpYFIU3gw=; b=cPAMgHdVr2P8QFzCcoiEAPHM04
	NrwoxF68ZYOzXapuKmUr31nano42fMCOPxGG68PgZJIU1yPeGQkjIkf5i+d+mb7x0zreNrko+ajyh
	paaBaGwG/N4c0m7UzEP5dBeIGvNtCp9DN84HUe3Z1D/t3OA2SDzEGPwT2tU0Eg+SoPRc/CrN8cr10
	h4qqafsDIpNWthDrdaXRSfLIUmhJP4fLylS9pSZ3c9N+S/iNXiPHbelJcQjzsuHmTa1zxyswXZxbo
	1uE0sGkj4xYN2/HCVa0P0uHmXCiaz4auemVC2/9gskKD2Tomkxs4UTYgijbjeKLuv5U2CgyM9a+oX
	/528pKaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0u8-0030QT-17;
	Mon, 04 Dec 2023 04:50:00 +0000
Date: Sun, 3 Dec 2023 20:50:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, leo.lilong@huawei.com,
	chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: don't leak recovered attri intent items
Message-ID: <ZW1aeCsUCALiW9SN@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120319438.13206.6231336717299702762.stgit@frogsfrogsfrogs>
 <ZWg7EbskvSLWvwNQ@infradead.org>
 <20231130170236.GH361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130170236.GH361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 09:02:36AM -0800, Darrick J. Wong wrote:
> > No useful comment here as the attr logging code is new to me, but what
> > is the LARP mode?  I see plenty of references to it in commit logs,
> > a small amount in the code mostly related to error injection, but it
> > would be really good to expand the acronym somehwere as I can't find
> > any explanation in the code or commit logs..
> 
> LARP == Logged extended Attributes via Replay Persistence
> 
> (IOWs, a silly developer acronym for writing attr log intent items.)

We should probably spell it out somewhere.  I also found comments it's
a debug only feature, which also confuses me.

