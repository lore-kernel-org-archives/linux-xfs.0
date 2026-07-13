Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4509D63B9
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 06:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783925488; cv=none; b=GZQeTlICIN8WKn2unk2OQqdyhXANsbNM6wzasJ7D8kMDrywjb6TnTJSOnETQlRhxrb0R3GsT28TirHSngJxiS2Q1AJEFi+fNseNU7O7CFDzWB0S7cLa13aCHUumnoYhT7JloPvi/5954BCo6Z/zZDiSeWdut4/2PYy/viyu5Sm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783925488; c=relaxed/simple;
	bh=WNv2evpFfib0oRVM4b7iBb/HsOFVlE9W8q7WMWznDKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rre8xIAFaWsjJfmxaUTVOSR/x2ABWt4g79TCheFSqekvSKBRHBoeLr20+xXIBVdDRrZJ0kCG1Nb+boJsuGKs9BIRA46mYtEv1+J6td4bhYLYavDiqCw5C8i2FhdVVq1hTqc7+VnvQju/nFWfLbTaQO/dYbyUq2bBnh7C0WrmauY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C1F8168B05; Mon, 13 Jul 2026 08:51:24 +0200 (CEST)
Date: Mon, 13 Jul 2026 08:51:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 1/3] xfs: add xfs_metadir_create_file helper
Message-ID: <20260713065124.GH29416@lst.de>
References: <20260712093317.782831-1-johannes.thumshirn@wdc.com> <20260712093317.782831-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712093317.782831-2-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 12, 2026 at 11:33:15AM +0200, Johannes Thumshirn wrote:
> Factor the metadata inode create/commit/cleanup lifecycle out of
> xfs_metadir_mkdir into a reusable helper that takes an optional callback
> to initialize the new inode, and convert xfs_metadir_mkdir to it.

This needs to be rebased on top of commit 45de375b2506 ("xfs: fix memory
leak in xfs_dqinode_metadir_create()"), which is already in mainline.
Without that revert the patch currently fails to apply.

Otherwise this looks good.

