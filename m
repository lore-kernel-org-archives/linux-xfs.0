Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34C83B7B6C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676639; cv=none; b=bzgHZDjbbg9+es5LMZ1SNxVPgf35B42WpBlZcH1q6RHp4ciJLctRnJ9CZ8RnqC9lgHRs9RdqeOV9YITfmF0eNI/t7DMg2ShCUKZvYGR6FsScdSPVy8v/RFeghpfyWFLawnjxi5YhtbJV9eOray6lLizE82rf1B57HVToINRq7ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676639; c=relaxed/simple;
	bh=u/+F1q+tjbtteiDM0kncXMbL7jRZZUOjJjx7sTojyWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=klszx2K0N0Ky9XLliBBZ/STBM2UnknvQiIAOW+m4/Nw0CmeqQd0iXlHMt/Ob6fBKVKC1Jd6cdMUWYSixSCC9veGEMh8qz1My5ofezQOLlOCQ29qNZWBxkXYSfDD0Hwj1ivuw/4Z3iaydw25Vz2PcrL4cQAgnFbjS0SK+LxAl++Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 753B068BFE; Mon, 16 Mar 2026 16:57:15 +0100 (CET)
Date: Mon, 16 Mar 2026 16:57:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH v2 3/4] xfs: display more zone related information in
 mountstats
Message-ID: <20260316155714.GC18936@lst.de>
References: <20260316114020.753228-1-dlemoal@kernel.org> <20260316114020.753228-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316114020.753228-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
