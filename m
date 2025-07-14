Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4915D20C004;
	Mon, 14 Jul 2025 06:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752473587; cv=none; b=pU9TEEZu8/qmNbnpuKjTmKML00jTFLvrm0Owq0rPA+C/1qRbvM1gXE4OZOtSvatbUpLiTK6byO3MSC5JVZoIBZm8F/46/rOX5PBySl/ABLE8ivT349yekn9hzS7fdsSaoNDD3zcsCFdts28Dcj5jA+deFDjgARuzDtG6LS+nszM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752473587; c=relaxed/simple;
	bh=jpCKlLicgE2Z5Leib/BOsUFKl6Hs2q3+TGNIp+K4Xj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeYuHGjIHj3NTAmlZjLdpAo+vxqeYdCLTg7UpQU2ODf+2to13h0i5yV2LtXMmd5r7NUhqDjlNc0HUVPSs8nCHwq7F8T1dqI0Ykytn1fonYHwc0pu47kNgNR0QJKs2+ILsAEAT2VZc04foBWNgdpghoxsR4eOj3pRcVRnPnUHhzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0C77B67373; Mon, 14 Jul 2025 08:13:01 +0200 (CEST)
Date: Mon, 14 Jul 2025 08:13:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, John Garry <john.g.garry@oracle.com>,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, yukuai3@huawei.com, nilay@linux.ibm.com,
	axboe@kernel.dk, cem@kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org, ojaswin@linux.ibm.com,
	martin.petersen@oracle.com, akpm@linux-foundation.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
Message-ID: <20250714061300.GA13893@lst.de>
References: <20250711080929.3091196-1-john.g.garry@oracle.com> <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org> <20250714055338.GA13470@lst.de> <c71ce330-d7b5-45ea-ba46-97598516e9fc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c71ce330-d7b5-45ea-ba46-97598516e9fc@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 14, 2025 at 03:00:57PM +0900, Damien Le Moal wrote:
> Agreed, it would be nice to clean that up. BUT, the chunk_sectors sysfs
> attribute file is reporting the zone size today. Changing that may break
> applications. So I am not sure if we can actually do that, unless the sysfs
> interface is considered as "unstable" ?

Good point.  I don't think it is considered unstable.

