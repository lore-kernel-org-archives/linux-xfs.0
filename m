Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98A9801
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 05:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736918392; cv=none; b=HGBFG8eW+To/8t9mQHKGPthdAqdLAo/CjdXpeq9P2oiAXt01ECBHn4T14rRbOnk2MbDdn18QAJTPon8a7wnt/UhcW77R19jMPkP3lWydR8WSS763OoAEElX+Lj5jkEohEs3bDt1429ENrlNjGQsooQiEiY1WJXCI1mhM4Alm8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736918392; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSujwGhAqADd+/w5U7bi3K53jpER5RMua0A0e5mycL1dDLQxIhYig6sDoh8h8GSA1tvUrIgBi3KXjo3N666t5JPf6lHLVL11SOIOPy34kSM09w2w1hKMnL96ZO7UDR65FnCz64DjOSp5pJoP6NDCMYr+tMapv3PEUZ2VyfGZImQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0A19768B05; Wed, 15 Jan 2025 06:19:40 +0100 (CET)
Date: Wed, 15 Jan 2025 06:19:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/5] xfs_db: improve error message when unknown btree
 type given to btheight
Message-ID: <20250115051939.GA28609@lst.de>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs> <173689081897.3476119.13308060628733838470.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173689081897.3476119.13308060628733838470.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

