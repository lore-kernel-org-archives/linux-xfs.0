Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D90B282F2A;
	Fri, 11 Sep 2026 11:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127192; cv=none; b=bm1vpErNCWOOJOMW+Ge6Z8ZgRZUYygrkar4GITQzCgWSweB7tuy7gDw60Vu8DN/bqVfgpzJNa3XqMbSXsl+DeXhqs+AhTkk8Yl8TN4Un0ySgeLnu/qQxX1Ze0+VZrX0PkZWOQFN+Lps9n+LKGr9MPT+9wZk2BbLClOZbsU+7uck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127192; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMuLcG559NtzgmpfMfDUMDY7yI6iav+ye4RBp8xWyYIbPDmVmgT3oHo5C/x39S6mCA0njMShCjF731r+mwDa7vnt+mxnV227IWgxgjbYwf68YSm90LJysg9anyp+tXx/DopwdPyX64VWK8O3JV16xrTKwwUBJC/6svRCWSZ/498=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7961668C7B; Fri, 11 Sep 2026 13:46:27 +0200 (CEST)
Date: Fri, 11 Sep 2026 13:46:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, dgc@kernel.org, floss@jetm.me, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 1/7] xfs: fix under-reservation of blocks when
 repairing sf directories
Message-ID: <20260911114627.GA22065@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs> <20260911044228.GA6265@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911044228.GA6265@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
