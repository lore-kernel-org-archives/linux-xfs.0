Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59A5402B87;
	Mon, 29 Jun 2026 12:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736286; cv=none; b=DirMaPs/9VhliylOicqlLzjGSTdVyK6sO5VzH91k6cTAUSXHLpBh0brqIqAyaSODlTdAw49gtjknxELJuDkikFzFkn2EvP6QPkpFcxYJQEx4fvB4gQfg3JhOk98psTASDmbr7R6sJ04Y6k1yqOxG9uvYDb5BSISid2eDO4rgW64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736286; c=relaxed/simple;
	bh=HsaGXWuRBiXrW1CoMqJrjqgWrsTqmrU8XzWd7w7BI9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHZn2rSQtfmDPBK/IR9xdBuCr8wFnWf06ZwxWz02qRxtDT1AciHTNP7mwehIWBYLMK1EWsoLRUA8nsvkGgmjMf/6fdMKbCULluqxKUqym3SlQeSvozgQRP4DIwvbOdnXu/22wEZz4iKMYQ6E0mqzyQBClyA3GDpq3yxlmnXgE+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F96C68B05; Mon, 29 Jun 2026 14:31:23 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:31:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org,
	hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] capability: unexport has_capability_noaudit
Message-ID: <20260629123122.GE21958@lst.de>
References: <20260626114533.102138-1-cem@kernel.org> <20260626114533.102138-5-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-5-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 01:45:23PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This has been originally exported to be used in xfs. Givin we are not
> using it anymore, unexport for consistency.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

