Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4404E156C79;
	Mon,  9 Jun 2025 04:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444348; cv=none; b=nlQcmWpdauXY7Ou1MB6s2K5u1WqWz9waEgI01edj4LOIJ669jgxwwIAVo65u2xiA7XZa6F6dhaZTmSo9hT5U+TNvMU7TTjeIe/PSljkKkSp7Oxy/bBBoWPQfbQns37xqV4ZVZxXX8ho+fV1YbLuDL5mbSpQbLTWTeTfDttwBGGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444348; c=relaxed/simple;
	bh=LHS+zRHK8XIAStwy5gSInN3RiFeMbGADaYmV7Q84Z9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iz6bwnwNFjJOJ1ulLM+CYcBTckoJR/xWZ09smZ5uvILfh2QC49PRgFCz+HBDf3D9SEJZL7T1KQ6vMXkUgv/BY/1nZifaBWKXZFoyB44vI2PQtieyzaBnk94QVGmoNkf6cX04sJu8Xvw60eOSQWoLc/uX1eHVNAnOiChKi3hyyng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hUluAsga; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hUluAsga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LHS+zRHK8XIAStwy5gSInN3RiFeMbGADaYmV7Q84Z9o=; b=hUluAsgaLFcxyvQXa4Ss0r/x7x
	tg8raCDDRZnd1+DIVP/LzshTISk/332X89XN3hO1yxxZbgZrkQz07+bSg5BJvIfl1Xr8hLWEDZtqR
	xiCakk2pKEBROqV47WBPilPgP1I+Ay43QeMTAoN/g/6PzsSk4gIHNMEj7LEN0p/LzD5jAr9VMYYHD
	34zDqZY84KoN1/B4cF2/VOAIwtwrGwX8XnK5AOX6aF7idp+Ats/hMouS/qpgZo+wUbQueJ0kRqKdD
	MdYDZHbE8R3+DXmDY5WEkVhSkPf2W6pvHbhr9fD4dYfxPElDda5hx2pFp6Kqn2IBHTv+KHWU5hGxh
	mcKdsrnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOUOI-00000003R2L-2TL0;
	Mon, 09 Jun 2025 04:45:46 +0000
Date: Sun, 8 Jun 2025 21:45:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, djwong@kernel.org, brauner@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	bernd.schubert@fastmail.fm, kernel-team@meta.com
Subject: Re: [PATCH v1 2/8] iomap: add IOMAP_IN_MEM iomap type
Message-ID: <aEZm-tocHd4ITwvr@infradead.org>
References: <20250606233803.1421259-1-joannelkoong@gmail.com>
 <20250606233803.1421259-3-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606233803.1421259-3-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 06, 2025 at 04:37:57PM -0700, Joanne Koong wrote:
> Add a new iomap type, IOMAP_IN_MEM, that represents data that resides in
> memory and does not map to or depend on the block layer and is not
> embedded inline in an inode. This will be used for example by filesystems
> such as FUSE where the data is in memory or needs to be fetched from a
> server and is not coupled with the block layer. This lets these
> filesystems use some of the internal features in iomaps such as
> granular dirty tracking for large folios.

How does this differ from the naming of the existing flags?

Nothing here explains why we need a new type vs reusing the existing
ones.

