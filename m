Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E03D411A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 07:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333326; cv=none; b=XtD+me/MCLOhHVxHVcy9XhnMZkG05V57R4gTmAiiCckbS7erNgYTgOhGeH0udAJZKa2sVMj2P7S1sDT/8iPHtsJUlMrWGR6MWtOlr+pCpNXeAZfqLB7mB8a4hf54ZvX1mOugP4cUs1NMuxaha5m0cXhj8S7ElPSRcXr3676tB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333326; c=relaxed/simple;
	bh=KJcqmyYRq8apcEI5wmtoCUXOLcmkMvGh7XsNZY5b87g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3wti5mY1wNi3/KXkrN8r5LZlZb5Nj/4QQgw/yNvnO16IyyYXJN0m2uK0IzA2AhnGYzcvUOV78XmLl/d6/DZWxrQXjjfUCURj68XDDuRJdqag7sAVQSbDekVW3KrpvJMwjPrLvdyGz+rLrf2QsOmY/gwpwFBIDnZkKKMkEefHYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8A7D68BEB; Wed,  2 Sep 2026 09:15:18 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:15:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: move healthmon event merge tracepoint
Message-ID: <20260902071517.GA25977@lst.de>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs> <178832750309.3507776.2729420337141667342.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750309.3507776.2729420337141667342.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 10:46:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the tracepoint into the predicate function so that the list
> conversion in the next patch is easier.

I would have called the label "out_merge" or even just "merge" instead of 
"out_true", but the changes otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

