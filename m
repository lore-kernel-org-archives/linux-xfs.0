Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D58142911
	for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2024 11:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726831594; cv=none; b=aLAbyO7yqQkq4Cp+XZCIK6KAsFjOv+yg19oNUkb61Kgc3k5a/0YPFK+e4IJwB+AEzwOlBWnr8cZO09h/8H+DxQAFupWxr2E5q+bpp5v2Mprl3l3U4N2fzey+ZjXlCMl/hXnt3XoO38OrGWn0aViOU2LQ5dS/b257spcebi6z+TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726831594; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJwxX1tgXHC8nz/kMOD2g1QYdpniAfcENMfWmv+mYakxG6tzvUjasQnWveo/1adDIgytnucUdiVLbjWxSRq7OHdHzJ5yD66vqGRQxV8ycmAVW5S4Ji02/0sH8AmvNh2W/1+vPkuZ/f9dApqGTitqrPNgh2IlaOUWGD+gk4sS17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1F040227AA8; Fri, 20 Sep 2024 13:26:21 +0200 (CEST)
Date: Fri, 20 Sep 2024 13:26:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] misc: clean up code around attr_list_by_handle
 calls
Message-ID: <20240920112620.GA24193@lst.de>
References: <172678988199.4013721.16925840378603009022.stgit@frogsfrogsfrogs> <172678988217.4013721.10321131196439907338.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172678988217.4013721.10321131196439907338.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
