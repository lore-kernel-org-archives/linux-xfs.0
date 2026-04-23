Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F49A3CC9F4
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 05:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776921108; cv=none; b=awUWAtbbGFUrvvBjgrAfwedjcviaRljbiYOs0w5NVr7CNZ8Xlh3pkvrGKAPbaMD8b23J1WSO/plh1o+DmRagxqW8Wg+UtgVCI/19tZ/hV6d5/adQdIWRTDfBkCeGtSPWrNfRstfQkQiu6RXY0tdX6ABWBfQpR/wEs9Mt+U7GdAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776921108; c=relaxed/simple;
	bh=Z7BGwOZMdCgtgN1lj8bjOB4GgTd8Bx1/AryXH5dboxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thrGGRhtesnZZUxOoS96NAI4AvpWDTQxj6+PBaeufSNCSzjGoC8/0R0KdiPvjO7st1fpJrlVexX8EUjnhqpJopKpy8nE2UFR17QT1CIrq15RFAaF3+/9sTqvMULG5q1cu5yltrInitis/hoTeHv3Mtl8uqkRpExkaGG0Rxjl4GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B05568D05; Thu, 23 Apr 2026 07:11:43 +0200 (CEST)
Date: Thu, 23 Apr 2026 07:11:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: expose the number of free zones in sysfs
Message-ID: <20260423051142.GA27929@lst.de>
References: <20260420135011.624587-4-cassel@kernel.org> <20260420135011.624587-5-cassel@kernel.org> <20260422060322.GC5391@lst.de> <aeii-qIyPawexQci@ryzen>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeii-qIyPawexQci@ryzen>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 22, 2026 at 12:29:14PM +0200, Niklas Cassel wrote:
> You say that the usual way to expose stats is through 2)
> but e.g. nr_open_zones is exposed via 1), introduced in commit
> 62c89988dc19 ("xfs: expose the number of open zones in sysfs")
> (You are the author of that commit btw :))

nr_open_zones is important for applications as it tells them how many
different placement points we can have.  nr_free is really just
an implementation detail.

