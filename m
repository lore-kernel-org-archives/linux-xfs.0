Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D6329E6F
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 06:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765176585; cv=none; b=OWtb2aZH8HKR7KBZmOnlCY7tCJaFrvheX6ptBMucvDOzk7hX+8YbybN3FDH1snWBPI7tQU+UtLVkzlNHhQp4bmKSDWUR2sYOgFaTLJViLRGXZhfa/aamxJAG6c8FtrmrGVJFDkNS1uFIT1gfX+qyxxs2SjiS6l8UaZ77na81kFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765176585; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjqS0/qXZZStj6gXqst3o4RtM6agl5ytZiDwssbijETECWzMaZDDANDrNcArZ5KE9rdyXhLCjTI1BR8egN07GxD8a72W948X02ajNXTHDjeiz4e/s0UAQ5/danU326t+H5rEUndafLA3oAG3zeBCGShFW2MiFQ97LMr759HhcV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EAB6868AA6; Mon,  8 Dec 2025 07:49:30 +0100 (CET)
Date: Mon, 8 Dec 2025 07:49:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, hch@lst.de, preichl@redhat.com
Subject: Re: [PATCH v2 0/34] xfsprogs: libxfs sync v6.18
Message-ID: <20251208064930.GA24958@lst.de>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

