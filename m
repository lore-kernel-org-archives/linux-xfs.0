Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EC73CD8BE;
	Thu, 23 Apr 2026 05:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776920980; cv=none; b=HS+mlbqwIRr1cBW0ZK3uxkl+VsVan7rhWbGyx/7a+SsEygQS8XB73qFMlFkHdiZ0E4p8ZcG+0p5/rDGF53ToQCwB+wxhacevfU07dY7JqGS7GjNq70dTQ4OCIiDE8scgwvRIXNc4j0IcH19CEIzDGLzbAPbM3XEKwkCUhzGpGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776920980; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwV0fyVjwMkxmvJ19jMqD0ShQxiQXxfYAMQ/Z9obq9ypfeWsaLgysDejxRgDDKeUo4vnpmEm66pdOFqqUVpPwBzFvOjLZUR1j3lyMqlQ1tKUP8tIW9QSajyNJd3xYXsdgzLpxxesxXVdYYIPcwAxLdJf8MT9cBIJRRWOk3zlpKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EEEE368B05; Thu, 23 Apr 2026 07:09:33 +0200 (CEST)
Date: Thu, 23 Apr 2026 07:09:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
	djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com,
	cem@kernel.org
Subject: Re: [PATCH v3] xfs: flush delalloc blocks on ENOSPC in
 xfs_trans_alloc_icreate
Message-ID: <20260423050933.GA27896@lst.de>
References: <20260422073959.10056-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422073959.10056-1-ravising@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

