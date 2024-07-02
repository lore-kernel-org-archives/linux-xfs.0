Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B372A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898109; cv=none; b=dwX6a/ZTr7hMDEfeyyA3GdZKRZG5SHd7bpkGUOVOqB2NzJoW9C+PbP4kv9AGyRhAuthLsApSeWsD0EhfKmujFgVT9wt3+OM5JLNC4JBzSf7VcJjJg3o55S/PhCk5knEl9HMTcofiApP83TWd8QLPk2qR75A1ECQxssJCLQ4GIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898109; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m89of59TA1AduTpVu3ti1Pa306I1XIvJzLbryFVBtcXVqvgJmvc6YLZIkG8FK55N4I8pZ0/XHYvOpfpfnWKgRtLZEgjW3hgw4vxi3t/S1M2v/p93f2k8CJXuc4ID3MAuQyLNj7aqRAC9M9TynB/DdIHmSK2KU045RMN0tnSH5lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5997368B05; Tue,  2 Jul 2024 07:28:25 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:28:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/8] xfs_scrub: don't call FITRIM after runtime errors
Message-ID: <20240702052825.GF22804@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118222.2007602.19270694956927614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118222.2007602.19270694956927614.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

