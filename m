Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698959;
	b=PviS8vnxNXtuabux0YC+oSRWSHnJ7tJdCHd214/iFrs7pk5AqrEEQlZ0/W9l1EJyEp67
	 Pv2AJUMhho0wchwuGRs4Xz1ak7vXHAvsrKxuWIju1/I9KAJaTuiP4WsYgowpYmzJGOylv
	 XUqOuRVhseZ7u90hg4TQbDsLGfV02IiY8AlOFjyEL1H2EH7or+MA8y70u2SDWXnLUMtFA
	 Ga5Mns2Rwy5AdX/fSD58A7zCj21466mHjEg2rHo264T4KB/Vhg0eAEUjurbb+xx2rPrT9
	 psG03Koe7hSKmmDwXzZwQUiDK2sNkYkz7ckcijtb8dx7k9707tREvrX+It7e/829cPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698959;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=tRckYhEm01TcJIgmdPRGzucKcZGUoZ6kE4uU5usEpYM=;
	b=3TRIbZoOs8VR+iSLMNA9FiQD8g9OPSXMApVS82eNgbyo6FLxiG7dAaVDjK2qfCyIgdkY
	 v4gtf8DYp3a/DQaKmcwhtUYM0sFwm2KERZL7gVUqNRTTCIEDCR+fYySmC/7fAzZf9m9xy
	 ha9ElKePTlZdC1TlM/ZTDinjUHfboDbHkOTan3Lh5pCK3OK/JMchxrFsq9sgSt7tviIz8
	 GpZWAAP6hXXt7alg7GQU2+XtJeL5IhMh5AMFfduv42v7eAH4cbUtgIj4IG7eM9JvzRvP6
	 Cw8shoUAiNVvghCeMfgrpFwO63b3HFGPvi5hLhJx97E6RqjyloExSU7eNCSwUogRUbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="x/58y1CV";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25011606A326;
	Tue,  3 Nov 2026 09:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25011606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=x/58y1CV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tRckYhEm01TcJIgmdPRGzucKcZGUoZ6kE4uU5usEpYM=; b=x/58y1CV2k3/KzseumV3XDdp6z
	PXjYU05Qpx6BGmeZQscHQG9rLuTCZzkGAl8EPEAWWOvP7Si+2cZAX6AwhIq41avn62fGgROOlspzW
	uzMwnftxZSQ3uM3lXs0NMncqW51bxBQQPkM25U9SYLiBm7uNQuUh+BhO5p4iBKwUULN5HVCzklJNV
	q0EN6RpBGApZZAh6K3BS67+jgN9znf+0SMofeNS+oxSAI+aCSMbyGWdH27NnvLY+urk01D+UZvSJD
	P40zUJGY8cse8eU0AcL3e2eIFMCrNR/wZ8Ys1Fyl3QVExDT63L1e90H007/sfew0B619iVff0qjWW
	EAoyXTUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOB2M-00000001mob-3JNa;
	Tue, 03 Nov 2026 09:42:38 +0000
Date: Tue, 3 Nov 2026 01:42:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 08/15] xfs: don't remove written extents past EOF on
 fsverity inodes
Message-ID: <aumsjkUtvGXMyS_R@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-9-aalbersh@kernel.org>
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
In-Reply-To: <20261102144147.2393369-9-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 02, 2026 at 03:41:38PM +0100, Andrey Albershteyn wrote:
> xfs_free_eofblocks() removes all extents past EOF unless the
> XFS_DIFLAG_PREALLOC or XFS_DIFLAG_APPEND flags are set. This is
> undesired for fsverity as it stores metadata beyond EOF. However, while
> merkle tree is being built, delayed preallocation and unwritten extents
> are used. After metadata construction is done, fsverity inodes becomes
> read-only and won't be changed anymore, none of these unwritten extents
> or preallocations in post EOF region will be used.
> 
> Let xfs_free_eofblocks() be called on fsverity inode as usual to remove
> anything which is not written extent. However, inodes which are
> undergoing merkle tree construction need to be skipped in case reclaim
> takes place.

The Sashiko comment about the enabled flag here looks correct to me,
or am I misisng something?

