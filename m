Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0013221FCF
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773844704; cv=none; b=J416ssXDRg3zyTLKb2gPDI+CNZeL5IyX9qZs4sgicNIePId24VbGuF4ZEPNpWxj499lpAdBWjnxZyQVlzK51CWeVOMR3cpTHxfgvo2Grbk158s8oa9lh6kLobTdyQTBHnVAtN6F711sURx5Jli+6m2lerBaz3ksjsxIRz9JXcnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773844704; c=relaxed/simple;
	bh=5Dw7E3mcDpm2eq+cThkrdXHkRFxk9K6z7I8TKdXMriw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tf2mgxSoV/2CKxxxi1nScti99avI57AMWA1yBPLe4vXv4lEz4M3U7G1H65/XIaazfNIOXHYClhJR057GaFMP31ZlVY5aVMydIH2L27c0nPZfUFExkob/KGtikB70VW+IvbPcacUxxHA4ENgd5ict/037dF5ujJPH0O2RNsmRw9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 40E2C68BFE; Wed, 18 Mar 2026 15:38:13 +0100 (CET)
Date: Wed, 18 Mar 2026 15:38:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/4] xfs: don't keep a reference for buffers on the LRU
Message-ID: <20260318143812.GA21119@lst.de>
References: <20260317134110.1691097-1-hch@lst.de> <20260317134110.1691097-2-hch@lst.de> <abnIqhTZXZxIb6VS@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abnIqhTZXZxIb6VS@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 18, 2026 at 08:33:30AM +1100, Dave Chinner wrote:
> The jump with the lock held is kinda nasty. The lock scope can be
> straight-lined by inverting the logic like so:

The current code keeps things most straight by keeping all the
non-default code in a barnch.  The above with more unlocks in
multiple branches feels a lot harder to follow.

