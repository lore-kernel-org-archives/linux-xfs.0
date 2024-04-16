Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31B6137C23
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293489; cv=none; b=C9HQlt+DLx5V+a6HQQ0z+tE0lHD27kGSTcEFXpdB4Uy8ic8dLu15zY+XBVXzN9yX9AaItLDKryQOcn32Q+Q01+8erS8g2GqCDku5h1aKC3sOrBGCEBl3kQ2SUw/5Y+ow7cuXk9GMcAVV7f0oezI3cdwqqLLnKXk+Wr6q2QZVzcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293489; c=relaxed/simple;
	bh=5LwwQ9XcNs/3ic/SjPBfVxVJp4YZAx61xjR9QVvxQcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXkWbXhmVGX0Ss/s4vdwZEu2iwleCDxV49L+A0Kh9zLyoEdljRHnIt6tlVCE7GJB6Em1zqIHcX5xGiVcJgNCIBV3BC8vvm5GzcXmzXqgiOAkjTOzp5idqydPX2sbntvQ6Epo3u0nrMNAfFgXPDg7xrvpMpxKpvswNdFDPKLvFGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oKFqYEFi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oKFqYEFi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5LwwQ9XcNs/3ic/SjPBfVxVJp4YZAx61xjR9QVvxQcQ=; b=oKFqYEFiSpiR4hM9oesINz93a5
	kYRhzVbOK4Op+2VZK3E1eiVrR82GsNzqVqujJXLSKwl/f9+7zKU86k2CqkSQzH1UGMXGXzVNw6ss+
	8IHkVtW2+0sPp3YEwo7LXhDvalLicCTcj7PWwWOCAnujbA5LFk+6J1tcXSRwbxcpz8NfLiCWWmuFp
	Hg5+FVF374miMHVXoLHEtbuYJs9BiOwGj/7UiWILNaLjfdxJ/jEg+pt2+WTyCLM8X8d0v50SDcP37
	55382FYEtHnG0tRHcJXq6yYFo1UEdFWgOREdX7dC8x9Tm/Paz7atuLyG9yx6SnbZMxOrurmxv22h6
	01x1kNBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwntw-0000000DPpG-0mqv;
	Tue, 16 Apr 2024 18:51:28 +0000
Date: Tue, 16 Apr 2024 11:51:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling
 xfs_attr_set on pptrs
Message-ID: <Zh7IsJE1HJdzQSZJ@infradead.org>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
 <Zh4MtaGpyL0qf5Pa@infradead.org>
 <20240416160555.GI11948@frogsfrogsfrogs>
 <Zh6nGaPvk3tKf3gg@infradead.org>
 <20240416184110.GX11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416184110.GX11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This looks sensible to me.

