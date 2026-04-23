Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4262F25F5
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 09:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776935668; cv=none; b=l9hgrQ/9QGaQoA1Q+tsLW9GVxwciL2EVM1ed0+0tYR7M++HNQVv6uTZ0rtwyfzfMe9upp35jSUInce8w0HY+sAv6TaBGrSFxb6cOxp2PC/iMMjBl2sMO7i3A0QSd83OknWHin9wQwnqh2/egEOK/JGV7tGTAB96eQlOwGHZH0xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776935668; c=relaxed/simple;
	bh=pG405HgpTHn8xSoGQOSjF0HV1vp1rsuTL+xmgci9u/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ull0pFnXdHhD30brdk1UiS9MSlqaSfoeQNjbVvIXO73M3MGs4gXxZX0fdQZ8SxCKNPP95ySitnNX+5nOaIY5jeXcwDMesogM5nel7MbX62gfLX8hkH2vNVxLNnMR8AT2wOqlqrw4k9pbMJNgc/lDESjULjBc1cqsUwcVnSYwgdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGpKRJ05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGpKRJ05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8FFC2BCAF;
	Thu, 23 Apr 2026 09:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776935668;
	bh=pG405HgpTHn8xSoGQOSjF0HV1vp1rsuTL+xmgci9u/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OGpKRJ05uESfRZBJ7R3OXLjCl3NSeUJJ5KM9SzajOQhx9b9bNjoOHkLf6jfxChBK2
	 PdRQdML88VcVBisJbBhAh3hOfuJCRYzMDR/urC0Q+oEiwW5eKgvsGto1Ubc0D3M0QA
	 Yh31LJYZZU0QpKmVUv79AKhNyhrUAelSmk+AC1KUozwyRYPkD+yqHhzrhuuTdG2Sp3
	 /zgoaeVeoROORNZulILBYhWZ90ZuZkF6rxA7Kqi6Y9kD0QZwjHIeVGN4usx+OUBrjb
	 rcyY0BqyBrQI2QUXQFLjH+iNAYN1z5WDvBFPkDkDLhWfqAO1Rp6fbtLjpFICFgm3uY
	 3FioLjOzbj1TA==
Date: Thu, 23 Apr 2026 11:14:24 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: expose the number of free zones in sysfs
Message-ID: <aeni8LnZNjpF1VxC@ryzen>
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260420135011.624587-5-cassel@kernel.org>
 <20260422060322.GC5391@lst.de>
 <aeii-qIyPawexQci@ryzen>
 <20260423051142.GA27929@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423051142.GA27929@lst.de>

On Thu, Apr 23, 2026 at 07:11:42AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 22, 2026 at 12:29:14PM +0200, Niklas Cassel wrote:
> > You say that the usual way to expose stats is through 2)
> > but e.g. nr_open_zones is exposed via 1), introduced in commit
> > 62c89988dc19 ("xfs: expose the number of open zones in sysfs")
> > (You are the author of that commit btw :))
> 
> nr_open_zones is important for applications as it tells them how many
> different placement points we can have.  nr_free is really just
> an implementation detail.

The commit message for 62c89988dc19 ("xfs: expose the number of open zones
in sysfs") motivated the change by saying that nr_open_zones could be used
in monitoring or testing software.

Which seemed like the same reason/purpose why I wanted to add nr_free_zones.

Your commit message did not mention that user space software could also use
nr_open_zones to calculate the number of different placement points.

Anyway, I can continue with the current (somewhat fragile) way of parsing
/proc/<pid>/mountstats. It is just a bit unfortunate that you can't get it
for a specific mountpoint only.

The "mountstats" command:
https://man7.org/linux/man-pages/man8/mountstats.8.html
seems to be able to display the mountstats for a specific mountpoint only,
but it seems to be for NFS only.

Carlos,
please disregard this series.


Kind regards,
Niklas
