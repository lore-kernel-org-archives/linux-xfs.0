Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBC40756E
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 18:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792002255; cv=none; b=fyFAxf478zKswKw8a4fEWiC2OryMXnff/wXzd5I95aZJRjQRDgFGqG1LiAn1kU6+te4uZ7lWZt1Oya5g+kV5BDsoz+l/DQ6RJw9DqnvdF0/Y/T4elRXhkTn2R2O5TktZuHuLZKNLDmTNCy4gZWBDPS0VrUUzUpRr7nDQ0O+zK6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792002255; c=relaxed/simple;
	bh=hwP1rhDGa25hz5qv5vocsMB5oWJNVeX5Xr0QzK+nwNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XTnrshcGbN1NpKIKPtyS2I0shwojxyyllOxm9s/g9tJV/A/DgSKetVnGSoIeLmyWl4vHOfOVzTT/QoxaXT8n5KlQEaTIeZWfiyqbIaLTq4k5puHb7rJPfiomD3B5xWduRwI21nKa3PQJ2a0SUxBoh5AupmHx4c0Zngq59lGKo4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xZKNFKX4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xZKNFKX4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=RAZymBeAp5xBcgTfI0ZqWm/SagmSABIGB9k07jz6fmw=; b=xZKNFKX4DPHAYUvXPY/0hfrao6
	lPbLjUebPUfc6H3/gEWHk1lRdAQh0s93uDrE1LG4AxUYwfXH+/S7JTLr8RnqPEUI8jK31CZI7sRZE
	k5v0G7SEujOSlgvWQYL1ZPhVWQg7aW7yW1IX0V7wAaeH6bgLx3ZF3S9tz1OoMWWjACdPCCLmwlS+G
	YlTvTzj6eeJS9OuCUiTKVCsOGfYP4sBk+VZ8D0C+IR1gNsPjNs7ousxro0SH9SsArEPGUxVKUz9rE
	vOp4sHtvLNn3NjsGIF4xWmtHMbCbO+2qUYWlG5n6wb6Gg/6fl0196UhaxVtu3ZwG7w3e4GOteeVuS
	QGp8G0Bw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xH3e5-0000000G9AN-1jeW;
	Wed, 14 Oct 2026 18:24:09 +0000
Date: Wed, 14 Oct 2026 11:24:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix compilation errors
Message-ID: <as_IydSHaWCYgnLJ@infradead.org>
References: <20261014174442.GK2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261014174442.GK2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 14, 2026 at 10:44:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add includes to eliminate warnings from -Werror=missing-prototypes.
> It's not a good idea to let the compiler apply the default function
> declaration.

What do I need to do to see these warnings?  I'm getting a few warnings
at the moment (and plan to look into them), but they are entirely
different:

xfs_alloc.c: In function '__xfs_free_extent':
xfs_alloc.c:4017:41: warning: variable 'busy_flags' set but not used [-Wunused-but-set-variable=]
 4017 |         unsigned int                    busy_flags = 0;
      |                                         ^~~~~~~~~~
xfs_bmap.c: In function 'xfs_bmapi_convert_one_delalloc':
xfs_bmap.c:4360:33: warning: variable 'flags' set but not used [-Wunused-but-set-variable=]
 4360 |         uint16_t                flags = 0;
      |                                 ^~~~~
xfs_log_rlimit.c: In function 'libxfs_log_get_max_trans_res':
xfs_log_rlimit.c:162:33: warning: variable 'i' set but not used [-Wunused-but-set-variable=]
  162 |         unsigned int            i;
      |                                 ^
2345 translated messages.
3139 translated messages.
prefetch.c: In function ‘do_inode_prefetch’:
prefetch.c:1027:33: warning: variable ‘queues_started’ set but not used [-Wunused-but-set-variable=]
 1027 |         int                     queues_started = 0;
      |                                 ^~~~~~~~~~~~~~
btheight.c: In function ‘construct_records_per_block’:
btheight.c:158:11: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
  158 |         p = strchr(tag, ':');

