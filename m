Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DDC3009D2
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769579786; cv=none; b=CMZnjfAvoPQMutpjeuGnT2GwDztKl63YFc+oTTWy2dQfVnju9Ez7T61ngk7wNNvpnjmtCIhO7wyGEokQWYYXEYSeet/T+IPSulXGrw1PgC7HH2VKLrrFxI1/NfbtJ5pjtq+/twPNmxEWq+Gj4W1c3q02OQjVUkJoXM+oMhXk1wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769579786; c=relaxed/simple;
	bh=rF6lhr9Jty7isQdNUALqLXJQl48mKnds/xqg+vaPBvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RF7qo3VGwSfJW3fSFlzxiCjxlDZBrgc6jEebfuVGCzulT9s0mYUpexYHACTQ1XuXGBb45OZuLgHkWOPySHHwL2dXBEIRaLFblO4F4W17tCMh3xNLjp9pKykVjuAi0LhHnTC9liPP4aYWm4nRuGs9g+pNKuBcBwKkKn0ybo/gj8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D99C227A8E; Wed, 28 Jan 2026 06:56:23 +0100 (CET)
Date: Wed, 28 Jan 2026 06:56:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@meta.com>,
	Keith Busch <kbusch@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use a seprate member to track space availabe
 in the GC scatch buffer
Message-ID: <20260128055622.GA1925@lst.de>
References: <20260127151026.299341-1-hch@lst.de> <20260127151026.299341-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127151026.299341-2-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

... and I clearly can't spell "separate".  Carlos, if this goes
ahead, can you fix it up?  Otherwise I'll do it for the next version.

