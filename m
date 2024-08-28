Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B3E18030
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818776; cv=none; b=fq8CS/6RkDogrGIH2kxaCyM7Njdcax48BAUr7aslH8isSzubHdZ+MiRjGjtR+1NuLqjCzItSP0oYsNt1hxwr8UMzSWQJ9U38RktBm8UVZtDZz2A1qE8umKZeC9Q2iVsQIfsgzVKyVx6TM1EnjTqN2W2d/8pxPKhWxd06pYzV2jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818776; c=relaxed/simple;
	bh=EyU1XOSk8di23llYhRy7ze/+7FBIaieAFG/B7QVrxmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVpj2LlIJ9s3ONOAN3e1cpOFL1hHP3Ne1djo3W0qwHwtT4DKFs6rn7aMFPRmaG10u23udlIVEwlVM84ef/jbOeeB40PrxrSx+M/Ygx9ziwHvbpsh/8DJ4HQkrYg0lznC+gjsNWVGAUWFq0xAycVi7lEbeMj34CDi++1lvgCf6/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43EE3227A88; Wed, 28 Aug 2024 06:19:30 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:19:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/10] xfs: refactor creation of bmap btree roots
Message-ID: <20240828041929.GH30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131627.2291268.8798821424165754100.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131627.2291268.8798821424165754100.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Loks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

If xfs_bmbt_iroot_alloc return the if_rot value,
xfs_bmap_extents_to_btree could make use of that, though.

