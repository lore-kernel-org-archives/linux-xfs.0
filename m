Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29812DC76A;
	Thu, 30 Jul 2026 08:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399560; cv=none; b=UUjxsmVoc+HR5SNxFN1DDkZSi5qfISlLL3r3ANAuR5rG6x/6jP7IaJeOsOgBWTpWwDsbojPKTHe/+c1rUSCbK9yz0dfJfzmMceF/7K86khcyarK4WvYvkBOg4vOCwpvTvrinLXaZaLCUVFwzMQp09vKoCqAjVA4w1Myajlmkkq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399560; c=relaxed/simple;
	bh=Fp0fTQb3UGd26IoYuAE/2X0uQjyXY8N4H53kKbH/ebE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqKwRI+fFqHzfjMvM/zHmx/N/UyhngXJX8+MPO/OoFYIXLnvgjxsw3o1O8ZXEAznQaEWucf7v+/LnO0yke4J/Zrp5HqkexruC+IXQoS47bYwCogUXquX8ZB+HBOzv5qoUIyZGRNodL7JaF7n0w2+Zw8hcCJBAgp2MPORhIvkzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C6F068C4E; Thu, 30 Jul 2026 10:19:12 +0200 (CEST)
Date: Thu, 30 Jul 2026 10:19:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix short ifork reaping computation in
 xreap_bmapi_binval
Message-ID: <20260730081912.GB10558@lst.de>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs> <178538912922.4070956.12261164869640345760.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178538912922.4070956.12261164869640345760.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 10:26:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM got really confused about the update to imap->br_blockcount in
> xreap_bmapi_binval if xreap_inc_binval returns false.  The intent of
> this code is that we shorten the imap to whatever length of space we
> invalidated so that the next iteration through the loop will start
> wherever we left off.  Unfortunately, the calculation sets br_blockcount
> to the amount of *unfinished* work, which means that we pointlessly
> re-scan blocks that we already reaped.  This is benign, but we should
> fix the computation anyway.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
