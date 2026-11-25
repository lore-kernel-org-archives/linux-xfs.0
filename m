Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585821;
	b=lOwOGOGB2g722dWXd4nxVZjsenp5wdy2NjS4BHYTNxSi72nqiKYbc49CrL2PG0214zQ0
	 wK/K5jwVMjSelaA+mu/ZuzX+FwL7WV8UdD8yEOzzTLLiBrS5o9Jg6iEN6Ou0H1vG8LoSE
	 A6Pu5Xu6cL82JBXWrk67ijTrTMx2l0w3n2dfIUnUEp+scyAjJy3HIlmmPxTBs8q19YjBb
	 U3l33a4xV2niq7lZ4ch2KD6SLHYwyyqoBQhouQTdUQqGl+ZUIY2hTT46y31otO7SJXvlp
	 i8FS/rh3NXO4YhS68GbicnxX1p2kT6zXo7jXP4H34HurACBInj+H9F8jOiQPKRb9Xqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585821;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=xGMhY5z0c1DMeG/mIPYle/oEUgNUMAi1+t56E25+IUA=;
	b=iYlwwGNfFe6uhHUiPHEd/PYt7o9eyvjXQrZvtIndwBhVJHkyiH7HPUrSxVkhl3zrdryt
	 5c5WJVrstA5cN6BK5vRUa6prUG+sq5re+/jnZHRCgDRC6RaRElolWLWLN+7pQ9786u7Ze
	 CD/rWa2QGMhVjI147CEKQNNswg4Y6NY8BufeK9SwTFLma/diJDepUxrBIiFOA0GDWipUl
	 aw/j8VmL3Qg0RVCFYGcKWLOGnk2tliDxECEOcmTQhOdxmIPTuXt/0Uf4vdb7BuiG1Bnqi
	 My+ynYBtWOXInpLCJzt3RTvF5JV9BtRrzR7V7XoGr2zOwLBzZLoqG2wrK3r/Kf5t8vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E07606A329;
	Wed, 25 Nov 2026 05:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9E07606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 871D568AFE; Wed, 25 Nov 2026 06:50:16 +0100 (CET)
Date: Wed, 25 Nov 2026 06:50:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: ernest.borowski.git@proton.me
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
	Baolin Liu <liubaolin12138@163.com>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 02/11] iomap: add a helper to mark a range of a
 folio dirty
Message-ID: <20261125055016.GB20604@lst.de>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me> <20261124-b4-ntfs-delalloc-fixes-v2-2-f394c800ec03@proton.me>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-b4-ntfs-delalloc-fixes-v2-2-f394c800ec03@proton.me>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 24, 2026 at 11:49:36PM +0100, Ernest Borowski via B4 Relay wrote:
> +void iomap_dirty_folio_range(struct folio *folio, size_t off, size_t len)
> +{
> +	struct address_space *mapping = folio->mapping;
> +
> +	ifs_alloc(mapping->host, folio, 0);
> +	iomap_set_range_dirty(folio, off, len);
> +	filemap_dirty_folio(mapping, folio);
> +}
> +EXPORT_SYMBOL_GPL(iomap_dirty_folio_range);

If we end up with this, iomap_dirty_folio should be rewritten
to call this instead of duplicating the logic.

But I'm a little sceptical the use of this can be correct.  I'll try
to look into it, but it might take some time to understand the ntfs
code.

