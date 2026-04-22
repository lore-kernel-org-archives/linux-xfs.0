Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570EB33B95E
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 10:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776853758; cv=none; b=knUCf0C8i4TwsCK+V7SROUG2VePKjQSqwQB7lxPoN9h2OGPMYcOWmdEs3R1jiShhb4zv0U5g+Vkqsa6akFfwCBT4OZiQCaARd0JgL0x2F7gxz7UZK8WwFKk+8lyOcvO3SxvV3pvWl/Tig7/tIsnof7UboapAG9la/DUHHt+y0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776853758; c=relaxed/simple;
	bh=bC91og24Yu+v7uo1YVroZmzZDI6MzVlg3pNCLTYx8Nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uskKbvKxTrEXEi2jX5C7acdBwUDF+tUptzxPuBzkLtp1YeBQeT9ncpLUBPaw9NuNsEHnpbThvG3bV5uGD6680ugAe9C3tdNvz9H4ASF4iv1pmXksHmoOwPTEYNhIk72FghBz8h7nzGmc6dBwLAM7SiSNfa7674c/KCZHRCQrVxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJZR9ln7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJZR9ln7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DFDC19425;
	Wed, 22 Apr 2026 10:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776853758;
	bh=bC91og24Yu+v7uo1YVroZmzZDI6MzVlg3pNCLTYx8Nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJZR9ln7/Hw8S3IRA4qSMomU8oQC9o0vpdpn2ks0PvdVajIiutxgBB4qk9nR+VLgy
	 iNEVFETp3rDtj8lQMfvSYS4Ec9F/lVi+BGHtrP1mATOAAkJGG+ezJvfHhzmhq3FfrS
	 dkr7tCnERsGTGMyiObh2a4GhertjwQBiUHUwkgpqJgZVAeYp9D7IQi6Bpe4C+/SEMS
	 NGvV/tmU1Rax8OOFKc9BmXr+jBokyr46KFwmlQ0uWF5+1Cq9lsNjUtxGUdaCKdORm9
	 5+RzICQMk0YDVKx/iM3AjnSNqLjIADg+lr03TEkuAXtJ60VqHroKkVRbF1LS/Vnlg3
	 W83Nay5sMU2Eg==
Date: Wed, 22 Apr 2026 12:29:14 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: expose the number of free zones in sysfs
Message-ID: <aeii-qIyPawexQci@ryzen>
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260420135011.624587-5-cassel@kernel.org>
 <20260422060322.GC5391@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422060322.GC5391@lst.de>

On Wed, Apr 22, 2026 at 08:03:22AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 20, 2026 at 03:50:13PM +0200, Niklas Cassel wrote:
> > The number of free zones is currently available in /proc/<pid>/mountstats
> > (which contains stats for all mounted zoned XFS filesystems), under
> > "free zones:".
> > 
> > Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/nr_free_zones for the same.
> > This makes it trivial for monitoring software to read the value, for a
> > specific filesystem, without any complex parsing.
> 
> The usual way to expose stats in xfs is through the stats sysfs file.
> Which requires some parsing, but the usual monitoring tools already
> have this.

So we have the following options:
1) /sys/fs/xfs/<dev>/zoned/
2) /sys/fs/xfs/<dev>/stats/stats
3) /sys/kernel/debug/xfs/<dev>/


You say that the usual way to expose stats is through 2)
but e.g. nr_open_zones is exposed via 1), introduced in commit
62c89988dc19 ("xfs: expose the number of open zones in sysfs")
(You are the author of that commit btw :))


In my mind, nr_open_zones and nr_free_zones is very similar,
so I though it was most logical to have them in the same place.


That said, if you prefer 2) or 3) over 1) for exposing nr_free_zones,
please tell me which you prefer, and I can send a V2 with that.


Kind regards,
Niklas
