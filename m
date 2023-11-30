Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XP/JVg7V"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88D810D4
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UB6ucsJU+rsmRNxeE2wQg4j2OONm7FHftsf+ac1LKJA=; b=XP/JVg7V6ikXKWpsa3n/VBds0r
	u1Aq68KPZNLUq4aSPvL/yHQixelfTsEqyxISU4vHrWamADo94Zaz/pcmM3T6dQuuypZWsykHGyG58
	xjpAOQAZ5nTEwkJkn13x2rkQRzoLRcuo4nS1fVzHS5Q+xaa1nBGJ1v9Q7nQXZmo0M4X8y6CHB5rOH
	L/CBAvitEsRDmeN2RarkTPUkCrpvqXIZbid9zsLxoQsskg/6zg5n+YPOe4V4AQJ8XT90nqbApxTSV
	YkobOmUz9PJMpEC7DQy9MkvPaUuZISF6ZJKknle+cr3Nt8wgG8Htyk2A7ZP678UZrcC9aaaxQh29Y
	RGq9K8CQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Yxa-009vyD-2G;
	Thu, 30 Nov 2023 04:47:34 +0000
Date: Wed, 29 Nov 2023 20:47:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: abort directory parent scrub scans if we
 encounter a zapped directory
Message-ID: <ZWgT5u9GwGC+R7Rm@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927520.2771142.16263878151202910889.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927520.2771142.16263878151202910889.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:52:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the previous patch, we added some code to perform sufficient repairs
> to an ondisk inode record such that the inode cache would be willing to
> load the inode.

This is now a few commits back.  My adjust this to be less specific.

> If the broken inode was a shortform directory, it will
> reset the directory to something plausible, which is to say an empty
> subdirectory of the root.  The telltale signs that something is
> seriously wrong is the broken link count.
> 
> Such directories look clean, but they shouldn't participate in a
> filesystem scan to find or confirm a directory parent pointer.  Create a
> predicate that identifies such directories and abort the scrub.
> 
> Found by fuzzing xfs/1554 with multithreaded xfs_scrub enabled and
> u3.bmx[0].startblock = zeroes.

This kind of ties into my comment on the previous comment, but needing
heuristics to find zapped inodes or inode forks just seems to be asking
for trouble.  I suspect we'll need proper on-disk flags to notice the
corrupted / half-rebuilt state.

