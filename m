Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2804A16F857;
	Thu, 20 Jun 2024 08:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718870951; cv=none; b=avcdM2gO9EX7ogCheqf7/lyLxtd5m9CmnLBiUTEXCntFUCF3PoCgkWoWpNnThxi9zc4WhJkg1JgmUb42t1gwUMnxAmJfOMpVLF9C0Ip23w9y4XsMlPB2dcdFlLaW+09IhAuYM3jcTq4fIpoaOiTxlTaWpzJIaOxm90fMlN6Be74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718870951; c=relaxed/simple;
	bh=tNd5kAQQ6BHYFQdW/Qq5UxZejqIDHg2m3FuyRDnq+8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdUG5GXk7W20kwYTqtyAheBplHW2hGbNGtD9Ya3HqE+OFzaqibrJiHQrOobV2oeFVSPg8ntaDsrGuBLm0OcFVD+ZzboqQsjaRSyIM8F327XXTiw/gfbLLp0q9aJ2Z4HlwAA0ujqk6ZIPSfg6D4tnXetItZR4G5Pa8cBEXM32tjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wax9kbsb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wax9kbsb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XE6kznpYga8rkUPgu+YFYh3IX4ghmGe4Vm92oGUX9UE=; b=wax9kbsbeXsL81bO/yk37aFllh
	uPE7tBs/akLfAlj9FZUA8usbjNZnOyTsLEgIlVWoUCIhs7TJqZb5zaIdDHNg7c2oo/GFh5sSnPWFi
	3ng/YV0AR7pfFoh7ttxboYCx77c+Gdv+wVRQqiYVZrNMP8PcEUL9LSUx70A9s32iEtmDr+Et6OhoP
	S180LT1jXF0SaTFaKTQdqdjagqxIVpd1neMjeCS9ukUSCQoN73JTStWO55HfD3bko37UfgXGnqzVN
	GNM3XJ1Vz4pnWY41Oh08TSuIG43DYbJCay1nh2uKvsBXSwLHPIyPSb74TwUo58MjGbJImuPZyAxge
	BMzh6VXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKCqy-000000045te-42G2;
	Thu, 20 Jun 2024 08:09:08 +0000
Date: Thu, 20 Jun 2024 01:09:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: shaozongfan <shaozongfan@kylinos.cn>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a NULL pointer problem
Message-ID: <ZnPjpCovlQq7_ptP@infradead.org>
References: <20240620074312.646085-1-shaozongfan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620074312.646085-1-shaozongfan@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 20, 2024 at 03:43:13PM +0800, shaozongfan wrote:
> when a process using getdents64() api to get a Folder inside
> the file directory,meantime other process delete the file
> directory.it would cause an error like this:

Can you share your reproducer?

>  	if (ctx->pos <= dotdot_offset) {
> -		ino = xfs_dir2_sf_get_parent_ino(sfp);
> +		sfp1 = sfp;
> +		if (sfp1 == NULL)
> +			return 0;
> +		ino = xfs_dir2_sf_get_parent_ino(sfp1);

This looks ... odd.  Assigning one pointer variable to another
doesn't revalidate anything.  And xfs_dir2_sf_getdents is called
with the iolock held, which should prevent xfs_idestroy_fork
from racing with it.  And if for some reason it doesn't we need
to fix the synchronization.

