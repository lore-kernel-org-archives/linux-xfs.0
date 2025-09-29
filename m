Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F26A239E63;
	Mon, 29 Sep 2025 06:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759128043; cv=none; b=Al/Xruw/JYsXFw+GnjfEhOi4mdmCJ9M1DAQX9h8zxGrxb/REyxaXh8kQJAZ/Iu7jBCQTFKQcOUYmm5GqS4B+vdCllsF8As9zgX8N3+qG+ygWTe2ObVatibBdMLcqEIBHLzaO0JTcuIu2MbzqZy9U9G/AkbyN3dx6XAiKFv2oJao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759128043; c=relaxed/simple;
	bh=YacQbj1YmkiJVhrtk3+KVfBFzhjCzjCVTO6GT84rzec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QaMQdJHoXJzvEy3qBG7zJEAmjZrZzU8RF9JBJO8cDVyhaa1emDOBJciCFR36JnQFqNpStdkqKc2VJWrNoEWZ8HROaMFVAob262MPMscc2AVgfb4VEfNED9pDMalA/stjG+HQSrB5UH8ldAkpkLZvvMY0Dn8bo7RNyPok3Or+c1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b4e8nJQX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b4e8nJQX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YacQbj1YmkiJVhrtk3+KVfBFzhjCzjCVTO6GT84rzec=; b=b4e8nJQXOeW+6CokvZQpUpX5YN
	v1Xa/jLEtCpGBcZrEmKuTYpfa+RbISQjDEfwwqwBYXMIMkBKLLrt1iRfrbd5pCYHSEOUqa2YLpSFN
	Hxf+spZ0GkJ2MGJmyjpaiaLmdwHGDRd8QdE0Rqv5h25j26GBq4yl8OkbTtsCxhuUhDzZUbZFNwZyS
	/3c/ZVOfu/u1Kl2L4Mpr2s+HqR9Y47zTpV7V5WAnNRjenrA89Pa/WHgimhsqwF6WRCq8pXQex6DUA
	dsm9aZFA0BFVAYTSx3MokPjZjAGRjDmi0ZW9b6Q+Unt7n0vh24/+DqS/3Mnt3Xd+VgKzzPLvWnBoe
	A+ndfkZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v37Yn-00000001VVX-0STq;
	Mon, 29 Sep 2025 06:40:33 +0000
Date: Sun, 28 Sep 2025 23:40:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
	byungchul@sk.com, cem@kernel.org, david@fromorbit.com,
	david@redhat.com, gourry@gourry.net, harry.yoo@oracle.com,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	matthew.brost@intel.com, mhocko@suse.com,
	penguin-kernel@i-love.sakura.ne.jp, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
	willy@infradead.org, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
Message-ID: <aNop4ZBrfuqrX40Y@infradead.org>
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <68d973fc.a00a0220.102ee.002b.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d973fc.a00a0220.102ee.002b.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This looks like slub turning a < PAGE_SIZE allocation into a order > 0
folio allocation, which the page allocator then complains about.

We'll either need to make slab not propagate < PAGE_SIZE allocations
to order > 0 page allocation, or make the page allocator handle the
latter.

And XFS shouldn't need the NOFAIL allocation here, but this will break
things elsewhere as well.

