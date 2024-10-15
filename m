Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2CC154456
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 03:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962842; cv=none; b=cjBzyq1rVpAglB+vo3pPHNwoDdfGyy575XjAY2ZUFXpxmtCHb1MK65QuEr9LnLcn9rkQmXvgXQjEHECdMcepAncRPny+BKoBpwFfyuk4ub5U4/zWnsXaWfcMdcPDfUwspRgJwsvcxBEDZsFFENhSpCNIgYivkfy0JKTxHXBUUxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962842; c=relaxed/simple;
	bh=Ws/dosqL0v722njuh2NFUOQpWirNHgWeApbVI6474i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyEnncIAqyN/gtmFuO+4qEG5kBmbbYaOlMQ3F3lGwN7jdK4VHY76zsbESjcCkbZYHqhyBaTii+zH3S/SBCjihOxqqm/+3J1WZP5YKvPqnlvB47w9Vh0WF+YCNRywU3uSLzASw379V6WctupqJNnh+ia9V2s9pRnsESiZhhnl3Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EhoQj+Co; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EhoQj+Co"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pwEXUZLr8UdVFP6jzNRlmB863FeXtwHOc7MpvGc2/vw=; b=EhoQj+CoChirHcG9V1d9hVjJqk
	niE8AS9DTQigaXEC87O5XKijSXvqiaLhpC20Yw0PhWrQiPezcIBYNvP5RAS2JAI+Tz+4fFvDB0u4c
	LESdbX3/pLAQP1nTezRKGWmcXmwoOcDcAXQTLNRUsM8BKtGbZSc5eWE9I3Oy3okpCYLRksIjPzdHo
	xuWigr6+9HgdU7bgdxbafI41bTK5KNeG9dXX8e5YUW8XABCFN5nFU6yFSI9QhGPAZf5bTt0rXxRfA
	sl50bkxVBc7LBwIMBX7oA9QfMA2Yl+1vzxdtUjvQsAH9geYPzOMWMh9nnteAaDdqNxNgnxJUWxj2w
	flDzEZdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0YDM-00000006yi2-3Ptw;
	Tue, 15 Oct 2024 03:27:16 +0000
Date: Mon, 14 Oct 2024 20:27:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 30/36] xfs: move the group geometry into struct xfs_groups
Message-ID: <Zw3hFOr3C2eiYOlx@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644760.4178701.13593967456112695233.stgit@frogsfrogsfrogs>
 <ZwzRn1fEt0xHdel-@infradead.org>
 <20241015013315.GS21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015013315.GS21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 14, 2024 at 06:33:15PM -0700, Darrick J. Wong wrote:
> Grrrrr crap tools.  Sorry about that.  I probably force-imported this
> patch at some point and it tripped over all the free form text in a
> patch that looks like headers.

At least for me, the problem is usually git-rebase as it strips
authorship after conflict resultion, and I keep forgetting the manual
fixup.

