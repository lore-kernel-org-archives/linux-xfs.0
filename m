Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154683B2D10
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796715; cv=none; b=iFJV04cnTMsMhsWLaRyvktdUQkLLpoKO5jjxU6P6g3jvsJq1v8j7xmfrQrd6IhbCW4K+hNlgQcD2YVDyLbuYviwuT4KdYZXwxetVhZP7ABx1w98IRL5pOwIdn6BOMMB3vbsR3gPN/paRPnpFVZMmwx709mZ5UMcWcPbFUgRce5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796715; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpuDz9nTp3sr7Ky0OEaXYogvk8FELf62Ugp64B8+VyW0ej6G52HKIHssm5tBnUMvXQlLk1oholYVZJeTmjtckVc2GVshkNYGLKhAxEQIxuuF9C9U1BusPCl1ki8ZTYmGzRf5nYctYe4r0YoQEYY1zGExsyPp4E/0SZj1HspJJZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 973A968C4E; Tue, 30 Jun 2026 07:18:31 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:18:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs_scrub: fix estimate of work items for phase 4
Message-ID: <20260630051831.GB20888@lst.de>
References: <178278129539.858187.11646178692582297659.stgit@frogsfrogsfrogs> <178278129582.858187.9031774884892983282.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129582.858187.9031774884892983282.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

