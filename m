Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC91154C0F
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894791; cv=none; b=crS+7SItG1wj7PfiQcPNEl3bZQunTLptD/x2x63K30QT9XamYuelCN5nbouFkaxQ4cfhPzZu+yRjYfdxnoDsGDTx4mjTNedVBCSZmHfM6Chmwu08++WaG7atNJ3yQCaAHiE8+dA18RH/aQPsvDioGQNvyX973aVfk5yQJkuHBmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894791; c=relaxed/simple;
	bh=KTz7/uYFS05WvE6k+tpdI2okC7HXUY3YdgRava+hXXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFc/1KDBvkd73oVN/vKAFq830ny3D8M7BLQdRljC3c3BmwnqDMQj/wy1LTqjV48rQBaGxi+uHBbqgOMBym4wQzcDveXfdqM+W34lSU5VvlUjgLalKUZT2gB0VtmfgwAdLYoZdIK1TWD+GZCYF+EDJweoB+oJCN71A57VLieqMvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iFKp1P9v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iFKp1P9v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=VlYkb75yjfOod0EnQ67K6muQrIJBpqt2ZpjH4T825Tc=; b=iFKp1P9vwCW3NO5jiM9S+bErw3
	Uo9WOe8GV0P9kBL4IfxZjhet7sHxGgTkL/aAQ9AEvzVawnudEcuK8rO/L8RJJJIO2aqR4gsIf1Gej
	Fyy7Y7nbnRYeHKY0EGca4Manjl9WgH+SVNziVjt3Oeb7QJ9BTwge654EdER1Y5r42t4Uw/1QEAGEg
	o9W+EbJ2OiN5odBpAlwLTccig4sJs0BMNEAkMkFsI+nfyGWKfpx6SdMMtoKKramQWej5RrtFmA0fT
	eNs/C+ZzL0CEJfoMDJ4jWEemDVO8FvwBQ+qnaOU19HMb1NXLteFpyyoisIioM4IfKGXTAsWi/aKNy
	ocuKrMvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GVp-00000004IMt-459x;
	Mon, 14 Oct 2024 08:33:09 +0000
Date: Mon, 14 Oct 2024 01:33:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: [PATCH 10/36] xfs: export the geometry of realtime groups to
 userspace
Message-ID: <ZwzXRdcbnpOh9VEe@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644412.4178701.5633521217539140453.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <172860644412.4178701.5633521217539140453.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 06:04:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> +	__u32 rg_number;	/* i/o: rtgroup number */
> +	__u32 rg_length;	/* o: length in blocks */
> +	__u32 rg_capacity;	/* o: usable capacity in blocks */

So the separate length vs capacity reporting was needed for my previous
implementation of zoned devices with LBA gaps.  Now that RT groups
always use segmented addressing we shouldn't need it any more.

That being said Hans was looking into using the capacity field to
optimize data placement in power users like RockѕDB, and one thing
that might be useful for that is to exclude known fixed metadata from
the capacity field, which really is just the rtsb on rtgroup 0.

Should we just deduct that from the capacity field?  Or have a
user_capacity one?

