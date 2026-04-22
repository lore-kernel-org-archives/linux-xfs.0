Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB282505AA
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 06:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776837762; cv=none; b=VXG1buax0kfzueJ+q9qA6nKktPoZ++nZUINRCBSR2cseIKqH+Vp3oP7Fvor/422ZLR6E8SLc+1/fPYwbFNFxa5l1hq7sy/G1P3SkQkUdTgttzinkZn5xn7dE73du6cNDdc0gcZH35SDzpip3fU1J0fPSeLYKJnm5Mr/r3eT9aBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776837762; c=relaxed/simple;
	bh=jVSRFFjqycC0C+cVUQNPwPQEgxsdQw4zapt2a2Zg9pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/ZLkEhjs4r2FGuZPLWuXEmWKRyPYNLISBViuqptM6sq9rC67PUF7uNGN7/LnFoOjD4XP+8QtRdEaxZAx5WUuYON/mts9L5QBcfLumOrTcieQB2FYnAekXkOdZFjbVwfmJ5766NK7MS1HSKmp/yQh8C3X6vvDzdqd4cwDhzgcx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D164668D0A; Wed, 22 Apr 2026 08:02:30 +0200 (CEST)
Date: Wed, 22 Apr 2026 08:02:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: add additional zoned sysfs attributes
Message-ID: <20260422060228.GB5391@lst.de>
References: <20260420135011.624587-4-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420135011.624587-4-cassel@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 20, 2026 at 03:50:12PM +0200, Niklas Cassel wrote:
> Hello all,
> 
> This series adds:
> /sys/fs/xfs/<dev>/zoned/nr_free_zones
> and
> /sys/fs/xfs/<dev>/zoned/zonegc_required
> 
> These values are already available in /proc/<pid>/mountstats, however,
> mountstats will unconditionally print the stats for all mounted zoned XFS
> filesystems.
> 
> Making the same information in /sys/fs/xfs/<dev>/zoned/ makes it easier
> for monitoring tools software to read the values for a specific filesystem.

What monitoring tools software are you aiming for?

