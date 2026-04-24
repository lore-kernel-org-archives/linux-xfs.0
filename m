Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6112F851;
	Fri, 24 Apr 2026 04:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777005782; cv=none; b=AKNH/UKeHUus7iaj71UhZ0INqL7XkBb1gErbyTQ0WNpmqRJV1rlrQI8ZAjsn1w+HZt7OxquuTpDYlX0wqlIY/6yy+SgVU0kwCPspCObnFwtt0w0SC6fM15DBGyRXW8DRWYAi4Mu1UCrx0fDt7zic79K0VdTC27sQJiLUCuLOz+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777005782; c=relaxed/simple;
	bh=Nyj2WsHXFPwctrSxcnhOp/0wk9Vt/byD37DZzhUxKVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLaJv/Lns5Ti1GXB24lBfjCopden6nQajHO12XgMytSXDdk9S2Kte4TLZw0EvRpU0C6a7hJf20seGt+gwzm8EJC3az17WS+MmT48WgbVFrU95F5bU1JDJPCeaG00C2uVFh//kDhSkOFBZsEgA4kpPaoqO1pk1XeWlq6tDp9+ZCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kbiijk54; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kbiijk54"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Nyj2WsHXFPwctrSxcnhOp/0wk9Vt/byD37DZzhUxKVI=; b=Kbiijk54PXxY9Ic1GyBHL2Yey3
	AnpgsWSdVfsYADBnW798Z0yD9n+uxJcSg81PbynvU29s92MTtg6TKeAIgqSEja5M+jcIv2Ur3Vjly
	PoF+Z7Eryc23YXBnPcjYby9Um6qo2A3z08r5pdO4vOwHS9+ZIPTSKb3FUTvZj74p58u1/3/D3v3gO
	UUe84dT9hpyj3yKPDQV7Jz4iodNoD3kd0UZ22kCwjPPB1hTS6ZYLc9acDa95Zl8byDi5eGyifENq1
	M2KCT7AVDuQwIJmwFJGRFhrMsRDq3h+NwXzdwj3lL7TB5kiGGuUUnYbC3QhwRc5htVUvMTPI/KmGp
	ADYnoHeg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wG8NF-0000000EaFn-2Mtw;
	Fri, 24 Apr 2026 04:42:41 +0000
Date: Fri, 24 Apr 2026 05:42:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, hch@lst.de,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aer0wd2Ig0hjN3R0@casper.infradead.org>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <wlxxrx10.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wlxxrx10.ritesh.list@gmail.com>

On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
> We were thinking if it is possible to extend the Buffered Atomic Write
> session into two "continuous" halves of 30mins each (total of 60mins)?

This is painful because you've requested me, plus both Storage and FS.
FS has lots of space, but I don't, and Storage is also pretty full.

Do you need me for the full hour or just half of it?

