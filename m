Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cC8AZTnR"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D291A3
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 21:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pKiVnKlwpbKmSJ7936iktUoAEEoPBbs4HehK8xfb1Xo=; b=cC8AZTnR68OYuWSBt+eyLFoDpo
	bjxUHrPU/4QAtpMP886IczLmkqadkTnBLT4fr9D3aT2rPYWPcbdxHD27c4b0J7WbME+k4JB7+7Vta
	t91DWCYWUlU6efttujQNWEHVShOzvSfmCiAAzIDNNnGXZxQY4B4tctvsUbzTKCzub409JUsthQedo
	GNOR3ViJFFx/FHrdHcto0r1PTaQYFR85mCdQx3vfsiaosfdbd3vkcGlRdy596OTtEFIbcZm+KAbLl
	dUGOkvfIDMOJImVCF1QQtOMEdNxFb6U6T23fkrt/bFxZaOPYfvjdo88TQIKID9xzRiBEp2kWWLNVO
	mPFSoKeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8DT1-0078Q8-2z;
	Wed, 29 Nov 2023 05:50:35 +0000
Date: Tue, 28 Nov 2023 21:50:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: constrain dirty buffers while formatting a
 staged btree
Message-ID: <ZWbRK5SWtoW9sn1E@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926640.2770816.12781452338907572006.stgit@frogsfrogsfrogs>
 <ZWGL4tBoNDoGND7F@infradead.org>
 <20231127225631.GI2766956@frogsfrogsfrogs>
 <20231128201133.GA4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128201133.GA4167244@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 12:11:33PM -0800, Darrick J. Wong wrote:
> And now that I've dug further through my notes, I've realized that
> there's a better reason for this unexplained _get_buf -> _read_buf
> transition and the setting of XBF_DONE in _delwri_queue_here.
> 
> This patch introduces the behavior that we flush the delwri list to disk
> every 256k.

Where "the delwri list" is the one used for writing stage btrees I
think.

> Flushing the buffers releases them, which means that
> reclaim could free the buffer before xfs_btree_bload_node needs it again
> to build the next level up.

Oh, indeed.

> If that's the case, then _get_buf will get
> us a !DONE buffer with zeroes instead of reading the (freshly written)
> buffer back in from disk.  We'll then end up formatting garbage keys
> into the node block, which is bad.

Yeah.

> 		/*
> 		 * Read the lower-level block in case the buffer for it has
> 		 * been reclaimed.  LRU refs will be set on the block, which is
> 		 * desirable if the new btree commits.
> 		 */
> 		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
> 				&child_bp);
> 
> The behavior of setting XBF_DONE in xfs_buf_delwri_queue_here is an
> optimization if _delwri_submit releases the buffer and it is /not/
> reclaimed.  In that case, xfs_btree_read_buf_block will find the buffer
> without the DONE flag set and reread the contents from disk, which is
> unnecessary.

Yeah.  I still find it weird to set it in the delwri_submit_here helper,
but maybe that's a discussion for the other thread.
