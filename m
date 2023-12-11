Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sVumfydf"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82C0B3
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 11:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TxzoFViaBe1zhZYefE24X/1AFDniAR1M59tase46F4M=; b=sVumfydftTxnwfEfHSm2zpnxc2
	e0SiS2DkSnojvJxYMaJ0OhPN8noo9kQDBLNp6sO/k2t4LH0IAileAH4t5q1m6RZLLGERmONaU+Pte
	zQOdsDJMecQzaXeza2IE08SBlMeufePdBIOagh4EDBp5Lhdy4OCCCnFr1Qm03vSe8HgIXfqCaRkIa
	6DYLhGM7uNfSqC1UqrZ4vtRA/kUTWCQYSsE1WZd9ssIDBu5yopF+AqmMcNaIk0rjPbTnHg3tNPjqY
	ktZXT+sCy3EpVCNCV9/VcvfgVnNdKP77BVcwQnnxUGa9fx5g05NeBJiTcV/HIEjPssxC4gV27Jm5P
	BaFLylbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rCm1P-007ZVJ-2l;
	Mon, 11 Dec 2023 19:32:55 +0000
Date: Mon, 11 Dec 2023 11:32:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: repair free space btrees
Message-ID: <ZXdj5xIxTCfdYzBs@infradead.org>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
 <170191665696.1181880.11729945955309868067.stgit@frogsfrogsfrogs>
 <ZXFYa7v7m1vkuwnY@infradead.org>
 <20231211191530.GS361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211191530.GS361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 11, 2023 at 11:15:30AM -0800, Darrick J. Wong wrote:
> Er... assuming you are asking for a link to the file in the kernel tree
> from which the HTML is generated so as /not/ to require internet access,
> I'll add:
> 
> "Link: Documentation/filesystems/xfs-online-fsck-design.rst"
> 
> That said, I couldn't find any particular precedent in Documentation/
> for having Link: tags in patches that point to paths underneath
> Documentation/ so I guess I'll just make s*** up like always, then wait
> and see how many auto-nag emails I get about how I've broken some random
> rule somewhere. :P

I'd avoid the formal tag, e.g.

Rebuild the free space btrees from the gaps in the rmap btree.  Refer to
Documentation/filesystems/xfs-online-fsck-design.rst for more details.

