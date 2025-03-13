Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B621C07D9;
	Thu, 13 Mar 2025 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741847457; cv=none; b=BPyyPQltpo+/LKZaSQ8Pi+G6B01uShuJLdVGMuGKJroh9V9sOGTFZ6Sv8UtBEIikmvoRRoLjOB4tqb3BLzd6LAvfQcyesXB3AfcBjOCI8mnwxaADLV+qJCAT58qoMRG+pRkwqvR8jEZvSa3OOcDtzuNLxqzvvu4nOGJyZgEM8Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741847457; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpXMfQz+1FbdtrJSl5zjleMbm1yKm0cpmCxiqB/9GqV+jqdd2dJG1Hl4UyCHRVeB4DEIy2cRybPGet+JELBUXuHZRrfScQRgTuZLQJwSY2McfBUqJQzkVnLNi0l6hDD4CX+IVEs00mwwlYgImtPSpM7iO3zxBrjxMdQSOHXKM9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8347A68D09; Thu, 13 Mar 2025 07:30:52 +0100 (CET)
Date: Thu, 13 Mar 2025 07:30:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH -next V2] xfs: remove unnecessary NULL check before
 kvfree()
Message-ID: <20250313063052.GA9840@lst.de>
References: <20250313032859.2094462-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313032859.2094462-1-nichen@iscas.ac.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
