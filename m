Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11238C2D0;
	Mon,  7 Sep 2026 05:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760742; cv=none; b=cZi2Og4fTY4DRdazgbk/zvBG5WasotHbLW7qGAb1qjIv2yp4PaOvLcw9pHmLipxWhH09aU7fUFP5lbrZlzn+Tq1b/vQ2bnQt16TXVnIzRWYPAaMO0pCQWA80jtOlAzT7F2uAAIKFOlwASVHTDDnm/FM0VT6l/mnGpjY5xBPvImE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760742; c=relaxed/simple;
	bh=ZmRbsWaLsO5T7oV/p/IdM0xwjUnbT/EIQQSJfrO6bTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUgDowO0RFJi+x6XFCAqPKgDLI/2BpqIcMAM/U47cKuUd0j09pN9XhAUSC/q8mXw7o+u6mPyXPKcGczimjvmX5+9GNkHKV29a8+kO+7mB7AhYaYLA7BSdaSvGAz/Aa+YOfbT2HXwPpUsgRbPm8FJl3Afl1ifURRELW7A3apASCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5789C68D07; Mon,  7 Sep 2026 07:58:57 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:58:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: report healthy filesystem events in scrub
 stats
Message-ID: <20260907055857.GB31753@lst.de>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs> <178850312540.1198660.5374727427398156944.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312540.1198660.5374727427398156944.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 03, 2026 at 11:26:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM also notices that I forgot to expose the "clean bill of health"
> scrub stats.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

