Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CtthR+l/"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82907B9
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 23:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gYVkNDfZNgi5hKUtnyVqysoT8T/3Jr2SHjQZkoK15v0=; b=CtthR+l/aj4igz/UYNH8MyolVY
	/9BWyCf7bAZfMbgUP2UAoUn22XeNsPVfcMG9B9wlUy/1FHeI0JCw/7MLHuUntC0vjYp1Gw8/xcLQd
	xg6+3N4IwzYBZaqSQ+bKae51s8tyMo57w2RcbR/r3o8CpUFzDYymOE+6UGwgyY1HjvzQvuG5Lr8SK
	FCcn0A54/JJhuHz1Rg9O8/eIxem5XsoqnhZH70saqvWvs4CHrsrLiASw/qPotbgGMvLtrT82lmC3c
	WW7WPsjhe4IAuCnFqiFMSLv+fwrGoOFeZxllVxOIxqRPdzvBwpqTXEMBCh6cqmbn973Gc2/prCvcC
	qHuLUGQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8bZJ-00A6iW-0q;
	Thu, 30 Nov 2023 07:34:41 +0000
Date: Wed, 29 Nov 2023 23:34:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: don't leak recovered attri intent items
Message-ID: <ZWg7EbskvSLWvwNQ@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120319438.13206.6231336717299702762.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120319438.13206.6231336717299702762.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 12:26:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If recovery finds an xattr log intent item calling for the removal of an
> attribute and the file doesn't even have an attr fork, we know that the
> removal is trivially complete.  However, we can't just exit the recovery
> function without doing something about the recovered log intent item --
> it's still on the AIL, and not logging an attrd item means it stays
> there forever.
> 
> This has likely not been seen in practice because few people use LARP
> and the runtime code won't log the attri for a no-attrfork removexattr
> operation.  But let's fix this anyway.
> 
> Also we shouldn't really be testing the attr fork presence until we've
> taken the ILOCK, though this doesn't matter much in recovery, which is
> single threaded.
> 
> Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")

No useful comment here as the attr logging code is new to me, but what
is the LARP mode?  I see plenty of references to it in commit logs,
a small amount in the code mostly related to error injection, but it
would be really good to expand the acronym somehwere as I can't find
any explanation in the code or commit logs..
