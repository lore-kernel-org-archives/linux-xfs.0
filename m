Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E32B59B4B
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 12:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714654116; cv=none; b=Dk64kmv5kPH0gggy3S0W6DygXAuW8inIpBB4eWp8j4DX94nvqALgvDaFelP9C78PxP5iRu6AioQ25WkwyEQHSXpBKWmmf98PERNUHeT4MEmuuBlK7blPTmgl2Rt1SfmqsfhcFeedyjGr1Yx0oQa7ARYO15YlIdhQmcQ4MaQX1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714654116; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWRP9HkhtF4ZZUttDLK4V1n61LWvVj05mfyQ357ykCc/K2Wnc+ZjJXxzsAIFXnuL1rSk37+wK0A0H0gKVugdYy8vPHS29W9CSH98zPSfMLdhoTRhCH5hy6NwfQiP49bG1yLwPnu2FyvTFxQ17t024Lu7iQSbiB0gBGhDD9U0gBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1202B227A87; Thu,  2 May 2024 14:48:29 +0200 (CEST)
Date: Thu, 2 May 2024 14:48:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: Clear W=1 warning in
 xfs_iwalk_run_callbacks()
Message-ID: <20240502124828.GA20481@lst.de>
References: <20240502100826.3033916-1-john.g.garry@oracle.com> <20240502100826.3033916-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502100826.3033916-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

