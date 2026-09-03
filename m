Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5FB390223
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 05:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788413765; cv=none; b=hlAx6vD0BayEhIBUOoprkDDAfwPWd4CP0Ix/gi90KxqOfysSdQ7sFVlOPdFs96CXhA2eMiVaWPKdwtNlExiglCjVa91ZjPJ75wnsdtOeKooJ0KbUtwBrsz2B4aLXLIkOTRYDZlrsY0sDKHQC/9lFzEJTiJA8NjSp8FY9sXu54e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788413765; c=relaxed/simple;
	bh=k/LxJV4N3QO5hY/FgL4jHxdKQdbtXsUoCvv6vBWHmH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwvIxGIXjCFFkBsj2XLmr4OGCj6i01pKt2GhfSjuo0fvBxxzI5SxB12SKB8O1hbPaYhaCPmNfurAUYc4Xq0smrgxbi6KD6N5ESWjAV3hap4rEZsdTC+qfOGMgsHZf5LEBHSp6cMBOCx/97+Xc804QVNK2aVLaVyfSa3kdwbFFUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54AA26732A; Thu,  3 Sep 2026 07:35:57 +0200 (CEST)
Date: Thu, 3 Sep 2026 07:35:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org
Subject: Re: [PATCH] libxfs: report device open errors during topology
 probing
Message-ID: <20260903053557.GD16469@lst.de>
References: <20260827112855.70037-1-hans.holmberg@wdc.com> <20260831071039.GA25070@lst.de> <32e910c2-28b1-4df5-99aa-8bf13801ca1e@wdc.com> <20260902055954.GA24431@lst.de> <20260902162025.GU1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902162025.GU1933798@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 09:20:25AM -0700, Darrick J. Wong wrote:
> AFAICT hidden sysfs doesn't seem to break libbkid's probing of devices:

Great.  So *knocking on wood*, let's go with Hans's patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>

