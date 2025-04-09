Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7EF21ABDA;
	Wed,  9 Apr 2025 10:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744195014; cv=none; b=pLRYyqsQ5xU1q+3+emGFil1ngKwHlBbawbCPHkkvNXLl6UbFEyx+NAqcch4R9Eg2p3hiYyULchMhkPcXkPt4nVyVZY8E+mLdQf/czaDAqeOrGWthAxWNSj5CdNgJZAlfT4NbCiqqZ9/B5Z1Bzf0EvdEhNAcdgyL7AJk0Z5vJdC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744195014; c=relaxed/simple;
	bh=SmWH+GEtWfnu763sRB2MLjkg1tp6eOYu5WvAKP4Ozgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIkM9tgDxk3yowW6k6zanoJHk5658O3HuC/Q1/vkvjnOgrUL2lY052ywlVs4uK7asG41FG2u+h+dss7EOKGKQihdNBEx7uKHbIqk/N9nsaMPoStebX4HhTI8Sr5s7hLptXWTiM73g6Jwh3rd0hE0YVSmmvZM8FHy2WIYRPdrW+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0342E68BFE; Wed,  9 Apr 2025 12:36:49 +0200 (CEST)
Date: Wed, 9 Apr 2025 12:36:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
	tytso@mit.edu, djwong@kernel.org, john.g.garry@oracle.com,
	bmarzins@redhat.com, chaitanyak@nvidia.com,
	shinichiro.kawasaki@wdc.com, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [RFC PATCH -next v3 09/10] block: factor out common part in
 blkdev_fallocate()
Message-ID: <20250409103648.GE4950@lst.de>
References: <20250318073545.3518707-1-yi.zhang@huaweicloud.com> <20250318073545.3518707-10-yi.zhang@huaweicloud.com> <20250409103629.GD4950@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409103629.GD4950@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 12:36:29PM +0200, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

.. although this really should go before the previous patch.
