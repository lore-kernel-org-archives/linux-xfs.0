Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FDB36CE1D;
	Wed, 21 Jan 2026 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979039; cv=none; b=lN4ea4iGwhvz2xD0Nb11s+lCfR7H6L8nh7Mh51jt4BujMSTpLqKtYkkdVP8Fm/A5X5aWbTMYjCOC6LURbfxnivXnW9XwnEOfqyMLiUmHxFIS+r14dzk/naKeZIxzA2NCNsWR9TuQ2uBbXcoTfxb/jUIzrvCr2Zgz58sckXd0krQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979039; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCrQeIKzTngGuv02iZf9zNriByAPtsT0HZlv2aZImRM8Zj08JMvLt6lmcg9+GpfHQ4XaxwPc8WxgJDrKVR1rWiPUDQxjLXD+UB0gHL79YzO04k8pMsmdiajSdZJjWzyuEKZudJHDKE2OXFKF29wliTk62jqtQihv1jCqWCNwlkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 005C2227AAF; Wed, 21 Jan 2026 08:03:51 +0100 (CET)
Date: Wed, 21 Jan 2026 08:03:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: check return value of xchk_scrub_create_subord
Message-ID: <20260121070351.GB11640@lst.de>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs> <176897723608.207608.5078916310150765504.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897723608.207608.5078916310150765504.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

