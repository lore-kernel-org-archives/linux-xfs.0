Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952CD3016E0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782797684; cv=none; b=bzRS0le5FhVLVgQhtmpxaZohzf1nGWsvfpwAYNVbf3NHakc6bDUiQpNviNV/z8DggsouHEYvIw6+kxnc6//8wLi1bWAnV57ZS1XEnf9ei8POwSwDgXLHtFana27AOxrAEQoD5JTgkJXaMPKmpt64n+DkiFVikLgU7ji5ZVskKeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782797684; c=relaxed/simple;
	bh=k35bhPDjbyWJiMWolLbuSR+OUXGasdFapxqMv7Dcrgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9hDulE2NYj45KVtQdoE3jzkK7QKr/F66sh5qBfPee4CencuyUcD0xXtfl+sMGizRWPBtfooNXGE7BJ2kYqBNnYZVTvej860zg+KKoxK4SVhZYN+s5SCnoDdjAiVHYzTy55ftY2TR+3wx/XVNWEYmXV4vZJoAwJnUSp9ELcu28s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 82FA368C4E; Tue, 30 Jun 2026 07:34:40 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:34:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/6] mkfs: fix symlink target length check in
 create_nondir_inode
Message-ID: <20260630053440.GC21007@lst.de>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs> <178278129861.858323.4909937638621779858.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129861.858323.4909937638621779858.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:03:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex complains about the way this function tries to detect symlink
> targets that are so long that the new filesystem cannot handle them.
> Specifically, it complains about the confusion between
> XFS_SYMLINK_MAXLEN and PATH_MAX.
> 
> To be clear, XFS cannot handle targets longer than XFS_SYMLINK_MAXLEN
> bytes.  PATH_MAX is irrelevant here.  The manpage for readlink(3) says
> that it returns the number of bytes copied into the buffer and does not
> say that it null-terminates the buffer.  Therefore, the only way to
> detect the overflow condition is to declare a buffer larger than
> XFS_SYMLINK_MAXLEN and see if readink returns a value greater than
> XFS_SYMLINK_MAXLEN.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

