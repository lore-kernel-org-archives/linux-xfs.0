Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151C81632DF
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 06:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740032378; cv=none; b=chtTsardEvwTji/UH2iqM7MpgOoIIfWp1qoFwRmgf2im/wiCzxge0w5yW5SSFtglbrm8pKvVub5fEhUhtFf3xjh31ZUx3jpG1i8CdkGmuLIfK2n8BNxDdjvNiL2DT/rHmOrKThWwqj5PihUeAj5JgFKTbxFdVwbd8peJMPkLuZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740032378; c=relaxed/simple;
	bh=4FFwJVRo9L89igMgsqxBKBPPwl4HYUTjUWhbxt1ggs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mY7lYKhiWQ5a51M6O1RFT7Z7wIGwpHooSKw0RQ5LeQAlvif/+Yo138Srs3YHnhebZZ0BiYYZbdI2cSax2iKW0JsIG+QVcdS9FV79Gv14wINo2z3+JgnoKJNNbQ/VEjE78SzMVy02+IQMQ0Hsp8OV0Ttobjvmk6w2amBO2rzvgiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iXRU4913; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iXRU4913"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4FFwJVRo9L89igMgsqxBKBPPwl4HYUTjUWhbxt1ggs0=; b=iXRU4913qCESfpfxmpOTe9C4WG
	+fZdzSeeL5KpnW4Y7z92Ct6a3gP9zgcLuohtQJxEHwUs4FpcHbE7qexzwgJhapaHJtvdXaCuK7Jfe
	Fig8uswVmeupqfGyV8bN8K2hyxWpvFybRzRD+mo2AsR6NgIs1vCRdWeI79rve0YjFcfcFjm+uxYHZ
	njJYeHBF4apPNBu++Y80S495I5F97M+Kr1KmrksEaYTkI5oN2B6pmwlxTO12zSCfGfo7SK+swFsr5
	oTPREH4WVnQdxj0qa12eLOk5ibYbkcSSqxg0y243R5KnGV5exeRi+FXq1wi/4fmIJtz7dRWg3lPyJ
	GiCW+sfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkzuK-0000000Guzt-05Oy;
	Thu, 20 Feb 2025 06:19:36 +0000
Date: Wed, 19 Feb 2025 22:19:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
Message-ID: <Z7bJd0aluMnJNlpf@infradead.org>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
 <Z7RGkVLW13HPXAb-@infradead.org>
 <37ea5fed-c9ad-4731-9441-de50351a90d7@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ea5fed-c9ad-4731-9441-de50351a90d7@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 19, 2025 at 12:04:36PM -0600, Eric Sandeen wrote:
> Christoph, can you say more about why you're eager for the functionality?

Trying to read data from a file system on a system without real root
privileges, e.g. in a random container or multi-user system.

