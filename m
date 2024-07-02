Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354302B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898713; cv=none; b=W1bpAWL3nV8PaPXzYjAJ9W4k5COTdQBbwEoeYcFr0GnjA1e+cUjfaB/f+xLJrIXgYBN4RNFnIyHEhl4vbe7ckXJGpPsxNTVkuZyJdkahZmk7V8M2iK0JN0fjQrXv/PD3x+B7LKnrA111qqLlVuV1iiC5VrUCUnHHZy0ZTTx1Mr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898713; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fy/sBfc8jafin+cL+QJoICq/qsdjID9m3HsFdtz0rD0+vofmA8fS8UbG8VFjKIlvWUT7jLGOrCAckcCct/qGrUO4JgtSM7V0IPvrBFf85Lx3BSp0bLL1MvGrFvC3f6vRJ0BCGrTW6EcwWC88K7CWBy3uB7waC9qyvCUWR/0KK0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 649E168B05; Tue,  2 Jul 2024 07:38:29 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:38:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs_scrub_all: only use the xfs_scrub@ systemd
 services in service mode
Message-ID: <20240702053829.GD23155@lst.de>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs> <171988119423.2008463.11698354867151927273.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119423.2008463.11698354867151927273.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

