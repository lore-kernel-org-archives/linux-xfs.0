Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6EC25B0AC
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 04:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784090403; cv=none; b=J3aWZpqq+2pFSWdN3r1pN/JkgBAoHbA9pUOh1OImCLpA6fmhrY/H4FgjHalhJgRw2vw+axjcM6lGWJqRbaSSASVriIgXZCYvXtQmJS7W50hg5spW83bFjJ7rWXsZFaaaedFomgpkJHllY1qM8OW11gmaoqc5iU63Np7H6cbtjGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784090403; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiQcfssfq1OX+jRzJEkQpvvN4FezZEtjOZusvB7fYmSKsj+IFc2uWPr08TjMy2RiBQepxz7ArJgHNH3bFYXIHsA/8b858L+9ynfdpcxskQUqLyieCa+oDTGqtkhbp5lqz+Qm/c9iXWk4ehJiih+ujbwUhMSm5yV3Ustqew5eMKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8341368B05; Wed, 15 Jul 2026 06:39:57 +0200 (CEST)
Date: Wed, 15 Jul 2026 06:39:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: aalbersh@kernel.org, pankaj.raghav@linux.dev, hch@lst.de,
	Zhang Yi <yi.zhang@huaweicloud.com>, gost.dev@samsung.com,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3] fiemap: add a nosync option
Message-ID: <20260715043957.GC15746@lst.de>
References: <20260714203206.520348-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714203206.520348-1-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

