Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4028235BE2
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976631; cv=none; b=gv87/2vP4dRCyfDU4h+3GRaxVCODG0+F+6coe4Naz3pLGE7Pegx6xeUIHnulfgaXhi0QNcZXtFjoX/I57KJfSpuPhS+FhHqVP9ITws/9XeL/cilDsh9pdNktRWQwN1nRyPukEB2u3rR/Ml7mWRkhSODKXLK2hT3RvukscAV7qZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976631; c=relaxed/simple;
	bh=TTjWrjr+JIXLdqYivdONcbRXHbzC+qfAkO6M58fLdlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kAIdZGq7CB0exFB275gpjigw0v7hpwl9djGaZOF4Lqv4E8q/yLIuONis+d4jhsWwPvdnydtYLbY1q/AG2u9nHAo8ZVqbLZ6AKHZa5SRoybHvhg8Bppc39jYYiaP4sFO9txXNanRA9Fz1qUxSREBf7PwZ7wSyPolwBsyMFC/2Trg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D8CE227A8E; Fri,  9 Jan 2026 17:37:06 +0100 (CET)
Date: Fri, 9 Jan 2026 17:37:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-ID: <20260109163706.GA16131@lst.de>
References: <20260109151741.2376835-1-hch@lst.de> <20260109162911.GR15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109162911.GR15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 09, 2026 at 08:29:11AM -0800, Darrick J. Wong wrote:
> Blerrgh, xfs_attr3_leaf_lookup_int encoding results with error numbers
> makes my brain hurt every time I look at the xattr code...

Same.  I've been really tempted to pass a separate bool multiple times.
Maybe we should finally go for it?  That would also remove most (but
all of the issues) due to the block layer -ENODATA leak.

