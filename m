Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2C225C80E;
	Wed, 18 Feb 2026 06:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771395438; cv=none; b=vBtYPNCzYOf6usgMjpxQOc2DIHE0Jxaue3NkXRno6OK96feDT0gBDgfgvTC50QGXV7bc561o7zteNSLkzRWNAcusDaY9CyThz5S93AppBcU8KeZzocRUybIYn5F6o36JZcHQ/jVx4XMrPekqIII2aH9n600VEspYncwLjslu8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771395438; c=relaxed/simple;
	bh=T24N2iF4bv2pKSLlYCmBuzux6mdMFFXnFQYfBSmYN4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBDSjCDAhbGgBO6oQTC6AVILMWcGDFBDqTwlMa9CsMnuijU09BDXns1gDmboBM9+f69ufVYzQrpi+8gi5aT05veg+ggd1hiZRd7MAQ//gWPfK6HQyUnPcFsQ8a2OyVx96hj2s8R42tn5RzX8pOinw+AO6OudLQu2CC/SLKmUoBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 80D1E68B05; Wed, 18 Feb 2026 07:17:07 +0100 (CET)
Date: Wed, 18 Feb 2026 07:17:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 03/35] fsverity: add consolidated pagecache offset
 for metadata
Message-ID: <20260218061707.GA8416@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-4-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 18, 2026 at 12:19:03AM +0100, Andrey Albershteyn wrote:
> Filesystems implementing fsverity store fsverity metadata on similar
> offsets in pagecache. Prepare fsverity for consolidating this offset to
> the first folio after EOF folio. The max folio size is used to guarantee
> that mapped file will not expose fsverity metadata to userspace.
> 
> So far, only XFS uses this in futher patches.

This would need a kerneldoc comment explaining it.  And unless we can
agree on a common offset and have the translation in all file systems,
it probably makes sense to keep it in XFS for now.   If you have spare
cycles doing this in common code would be nice, though.

