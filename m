Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61783DFC7F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388938; cv=none; b=ayfkv/4/37wgXHmeVk+oJKR9wcof63P+Cv/LtUQsKtD8IEksFWMcPW5yM3aWIXXPVNvnMd0xY8fTaMHEbP9lHIe+TYfOug4dTlH7ZmWTGMXP8mCwYZ0KxJKIMfyOr/ckvK4IA7kYUpA7tMk2USYnInp6UqmiN8rCtPk9JprMpCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388938; c=relaxed/simple;
	bh=9BkAZS7ukNRe+MlHn4jhaCQBz//Bg8Ra2hbnTq1csfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjGmF0xt9422qWZ68vCCn3HT51xTDaYcMTT/J/rhVgWQ67P35mBQJxRX3LfLl/8482JM7zF7YJYLq3LrySILDgvTDdVw00pCYaFc1LKtSTXJmkamLCkSApqhNJy2JIFdDLKrMvOb8ApIyqO5rn3/bb1qfUpxEbsgbmy6nD5xP1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6025168B05; Thu, 25 Jun 2026 14:02:13 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:02:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs_scrub: track inode scan abort state with an
 enum
Message-ID: <20260625120213.GE18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484512.915780.15261436223285476643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484512.915780.15261436223285476643.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:15:33AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Change this from a boolean to an enum so that we can handle scan
> cancellations correctly in the next patch.

Where that means adding a new member to the enum I guess?  I'd probaby
merge the patches for easier understanding, but the change itself does
look ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>
