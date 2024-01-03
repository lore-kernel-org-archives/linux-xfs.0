Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D11F1D52E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 20:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DcvaXGs5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b5dh4hUTUSFIAjgzm2rHKI5QISH6w8H8nNp2dUkuLD4=; b=DcvaXGs5o3IY8HW8NoX2YaVPtj
	AHLFDYWq3XpdCBsbIg62ptyyba7NV4xHlettvtVx0gVASNfqBKm7elcxF4HfqSDQjDi9wex8GWPMV
	F0dvcRmjBf7LdnNhKwNp5QiAToDCOWkH30Ng0Crr6xFg9DT2vWAlcz2nvAbD7iCHwiv/usJG/7h8D
	/6sHgwq88a6shH9gc0CDfJdHth6gMzJOHaW9MvEJLtrSRAPhKaVK7t1ZFPcM9QvlSR6wgphiID4ET
	itn7Hny0mtkxqzhgD8/GnW+7axaTXOEs2MzgnA37UnxTPhYKBZmDLOjGKXvru2meA5SLauXZM6YO0
	vCjkGbWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rL7xr-00C45i-05;
	Wed, 03 Jan 2024 20:35:47 +0000
Date: Wed, 3 Jan 2024 12:35:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: encode the default bc_flags in the btree ops
 structure
Message-ID: <ZZXFIziiyd7qUHJq@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830543.1749286.11160204982000220762.stgit@frogsfrogsfrogs>
 <ZZPmflimTzsSzH76@infradead.org>
 <20240103011511.GB361584@frogsfrogsfrogs>
 <20240103195826.GT361584@frogsfrogsfrogs>
 <20240103200050.GU361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103200050.GU361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 12:00:50PM -0800, Darrick J. Wong wrote:
> *or* I could define a separate struct xfs_btree_ops for the
> bnobt/cntbt/inobt/bmbt for V4 filesystems.

That actually sounds nice, and might allow for some pre-calculation
of maxrec/minxrec eventually.

