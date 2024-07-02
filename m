Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1AE2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897422; cv=none; b=vERYCOHn83gQSt6ZHlQks+SjB+qBjExpPP1Syr0xJjy4QbJfexGyxPpxkAi7lQUkZirUrgPfv6pmLiBG2iBz52C8YFdBy6cLnC/DeHHcvujkAHKidLoaT+S5npC7TIDaIj6l1xjaCc2dvbjbOEtLI45NKc9KSpMsmyPfQZX/dU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897422; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RX5VIL7JutDfoRnuS/Qiqd8BoimVJd8a2IkeTpuEp8f2q1gsRttVJWcpIWwVFc1h6vMIf8CRWWZzVb9MmG37POIodkr8H4iDY5zZ+D4ItCtmHgmIH2rsk4oDVIdy6k3bp2p03u+YypMdxPRu+snxUsUYg0QcU2qyNtphvMiiUj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3DAD968B05; Tue,  2 Jul 2024 07:16:58 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:16:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] libxfs: port the bumplink function from the kernel
Message-ID: <20240702051658.GB22536@lst.de>
References: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs> <171988117255.2006964.327302486814604596.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117255.2006964.327302486814604596.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

