Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF6584D29
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431426; cv=none; b=rVWQdtkfufFs4/mwRS5mjQG9F23OScF+C7fKQWROqZKc++nMyQz5dnJyoYxC/tultdhs8ocaSkRHdEYpo6d2w9lHJae/oklP8ajhrdOadhEHgN70NwydD5PlIa4o00vBNHjcme7ofWsOJfxQq3+56257ZMxy/cTWHI2RfOAiqYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431426; c=relaxed/simple;
	bh=mltql3a2TQ9Pj64Vta48x+p6vNpud6DTRDkteAIgldA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=feR/zx5BARGOkY9Imneh+YwsIVSvYI5r3hagznTuVeUjBG6zCEZDdZyfAr2VRoVbPWiS9EYhDyGLD971Qsz+BSpNyC0QSF0bepKSdRBL3H+x1QwpTDYWzaNrQUrPtCq2ykEk1eKboACnhL7WFYzgQBa1eHzfuPuO7p9zJ6RZBfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pSpVPSjV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pSpVPSjV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fCFtNeY8K3t5XSilkxRpGSBEtjS7dCGkIxLVr7c0Xqw=; b=pSpVPSjVkXTHPk4T5kVkm+xCms
	rPgWvMaaZSqCMSE+adBEMeILrB0hjS7F823J18IttREiGZi0Gu5QwbOTv1URgUaY8+TgPeGa5gJzZ
	yDicypmFlE0YD5r442wv2gtWSnNgqaSrZK1QQBL/QXsK6b1fW9A9IDvgFtoZX+3rfTlZok97spvq5
	A/Z+41XbLEh8prKnUK4sSFZPC0dAq9nEQuHe6hHEsp/c7AomXlQMFszFE10GgyI8JnN4G1jg7C1yV
	pU8WhGCANQ7MQIc++epdRHQTuqYvhG5FfTntNWtKPOQUr8za3dJTU/bbSgGRF5l+UCOgtTp1ob1rR
	qu+46law==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozUf-000000039nA-16EO;
	Tue, 26 Mar 2024 05:37:05 +0000
Date: Mon, 25 Mar 2024 22:37:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 089/110] libxfs: add xfile support
Message-ID: <ZgJfAQ0viwnfyK1P@infradead.org>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Oh, and xfile_stat is only used in xfile_bytes, might be worth to
just fold it into that and simplify the code.

And while we're at it - the partition_bytes field seems oddly named
to me.  This really just is maxbyes, isn't it?
