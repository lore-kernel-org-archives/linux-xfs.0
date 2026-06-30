Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBB835B62C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796864; cv=none; b=ru7z84cDqnX8LI8zgh/m6m9IuCXa1wg2Z2PZ0w1VKj+wUBd//j84OKS2TPXLZuZHjvAioo2TeDRVouNz8Q7m79jBpZ3UrIQ3D5xkb3Okm0Wq4Z27/f0pmb+LmhD2SDNzWTeERMOjNcRaPJIqAmhgBsUSTD0FycLm9QyIgdizzCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796864; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuIRMVpCKNPbgz1U7r5BUWK48o35emLiUjQPAGBRJrStN/iyjDfnNhBRdZlEy9xD8UIz5KaodJuVA6badcxYHbc/py1WmVJSxOhuQuduChu8DAP6eSJ9IL+CPFOJ/zJrMpV8RBbtZfkUgjmdvUGv4I4QZZKXyJgNysZl5F1NyjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 57BAF68C4E; Tue, 30 Jun 2026 07:21:01 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:21:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: fix type conversions
Message-ID: <20260630052101.GD20888@lst.de>
References: <178278130113.858605.5206441223016436305.stgit@frogsfrogsfrogs> <178278130137.858605.8332495915212788608.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278130137.858605.8332495915212788608.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

