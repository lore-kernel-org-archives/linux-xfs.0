Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375DB368974;
	Tue, 10 Mar 2026 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773132346; cv=none; b=q+0uR09aRxeTRAGMkAzK3snv2hbaYEbTM7jv0jJzfVyQwYeIOntZSG6YaAnmIqRsoSX93WcH71gCfS3z3y4nmzgyfpP/FnIZjxhTUms/D58IVaafX4CrduDH4U3ZQt8r3+oJ8NQSKZf/VsFhXK0BHApd4oIDoHgNBaeXr21htls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773132346; c=relaxed/simple;
	bh=2GTo/UKEXmNc6/moESIzVvtsJWPxVqrpeu18Y9/uTE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBxteSA3+nQHcc/iIOycmh7tB8aeOLzjKak8z3g8z+TG5otaVu24+QNVtctfjwzi95X3sibNb+CSE27wEEgBCKoGmPryjnkz9QxdumoinUieC/5ItADg7nhbiAXWWbjLwm88o8zJMcpQyEkLOCYYcOelr2f74LemkJ1xtLUam+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA0EC68D07; Tue, 10 Mar 2026 09:45:42 +0100 (CET)
Date: Tue, 10 Mar 2026 09:45:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v4 09/25] iomap: issue readahead for fsverity merkle
 tree
Message-ID: <20260310084542.GC17112@lst.de>
References: <20260309192355.176980-1-aalbersh@kernel.org> <20260309192355.176980-10-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-10-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 09, 2026 at 08:23:24PM +0100, Andrey Albershteyn wrote:
> Issue reading of fsverity merkle tree on the fsverity inodes. This way
> metadata will be available at I/O completion time.

The change itself looks good, but we'll also need this for
iomap_readahead and not just iomap_read_folio.
