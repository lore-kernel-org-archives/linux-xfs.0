Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852DA345741
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 09:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776851614; cv=none; b=PyCBS+rqzhtyi7Znnox/YsAwpacfHGWq4puHPkbW5QYoO7lHno6O989jMJx2dpdWcJaUEl3imsdk1u5xtIbYSg9oAvuDYxSOq414TgwlI2rH4FBF3YRA+OFK+kHnBTwGt6zxcpm51eTZJ+Is2YBlOun5630P9LXJ5Pww3uTeYfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776851614; c=relaxed/simple;
	bh=lrWhu/NaIugD0/tCBCT1tJhTyCS/9CZXYkzcHN75nQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QC/j4Ye7++DEc/wdibjymMkSdg44+PB3pgV3qilzFjsxKFneyeXkDJT4vn7suevUAK3ldBO3++uJEfyZ+zvBeCoR4CJog3G0lgMvlbLhwsn4z8UoCRRJMuJ7w05lYzryPR8lz7bRM5ZTeSb2iPimwd19PLEjIolx5ViAR0KVvn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYLEuEXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYLEuEXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F52C19425;
	Wed, 22 Apr 2026 09:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776851614;
	bh=lrWhu/NaIugD0/tCBCT1tJhTyCS/9CZXYkzcHN75nQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BYLEuEXvJsws+e4S1tK9fNn0YU1Q5GRV3uaiCZCgIs6xjJrtC8QjPwdF8f63VoANa
	 pMqCkTnXlpNKdudnvPZ35+lZvgwf+uj24S/xRkjf1caCqkUXmvAYQyhA9JCzGH3h4a
	 ZxNczx+jf1EfxUfXPLHXecIc8lK3IV87ZZQkJI88FCNomomx9SLfPhk9nZ/L7SOhLK
	 04vSHvTrY+wteGUadUePpTs9c2uGTJ2p9ZV85RSlCQxn/5g7ON+QlK4bUE2W18K7LM
	 QNryZlRpInDbN9WqCudxY3vg0tjl73emMFx8yfyl37pMmc1QFeX0/O6CrCkh3fqKri
	 4TsM8DW2fl/CA==
Date: Wed, 22 Apr 2026 11:53:30 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: add additional zoned sysfs attributes
Message-ID: <aeiamtqB7c4J9NA_@ryzen>
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260422060228.GB5391@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422060228.GB5391@lst.de>

On Wed, Apr 22, 2026 at 08:02:28AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 20, 2026 at 03:50:12PM +0200, Niklas Cassel wrote:
> > Hello all,
> > 
> > This series adds:
> > /sys/fs/xfs/<dev>/zoned/nr_free_zones
> > and
> > /sys/fs/xfs/<dev>/zoned/zonegc_required
> > 
> > These values are already available in /proc/<pid>/mountstats, however,
> > mountstats will unconditionally print the stats for all mounted zoned XFS
> > filesystems.
> > 
> > Making the same information in /sys/fs/xfs/<dev>/zoned/ makes it easier
> > for monitoring tools software to read the values for a specific filesystem.
> 
> What monitoring tools software are you aiming for?

Like Damien said: home made benchmarking scripts that sample these values
in order to know when to kick off a new benchmark, such that each benchmark
will have as similar starting conditions as possible wrt. GC.


Kind regards,
Niklas
