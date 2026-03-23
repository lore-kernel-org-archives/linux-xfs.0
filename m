Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3A62D5432
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 06:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246504; cv=none; b=Q+toIoVU2X0I5zL7iHOQy1eOKx34SqI/FruhHQ798bMMg3p36XT3ucKPQpK7H+xHoRfctw58k7WcfCaaT3wIlkmvHlMkMApJWm4ofYf8Dt/CLZUFHDTcQjbRMc7cz8rnkAqnLf1dsVfypfYgw+RVIjGl8/SCNpIQzpNvietJJz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246504; c=relaxed/simple;
	bh=mcWWeb/Tz3YG9BO54fiLT5EP+jiW7rFZczWvNulYkbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktMbdwkZ+AU0o+OilsFMUbpiZHCes3Y9oP0W5oljTCQ7yk68t0IoVQIu0f7dQbGUIasgN5LT68uJtcWX6wy0wkCQeP3m5MVNX3DGjdmkwVXtO3hHVddVNF54f/Tkq7OQL9sXfSbfd9aw82A5THr0ED3pe7kdhXA79JRUKM4sIbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n5uTurcg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n5uTurcg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mcWWeb/Tz3YG9BO54fiLT5EP+jiW7rFZczWvNulYkbk=; b=n5uTurcgRUCQmfhN9IoRZwfS6V
	lEZjuM1MzBAb5YF8wDb3KNmzovcNGF0M4//nyW6UpZVXqJUBEcvwFktHLKyB7pYzAntlRE+UCledX
	oCKgzTQh1W+DVKV0hTfsWQo1lwOha6Q9ZD3LK1MdrArFGLB0N3wABgis/scOyMwq9uAqGJltT2GZI
	Prok/znSevvzcTnzOVKn9HWfNKkkdqdpzfX4BGhLxSEMopUKpA9ewDCWWD1sAaXsl1as+5sh1txHt
	Hzep78Uw8N6sgwp/8de7WIO7HL/+7zk7rAtXi/bIYPMANnV2hnHS2c/SHQ9lXmVR3fPeD5FrvylSd
	YWCDoK+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4YZ4-0000000G7MW-2DYq;
	Mon, 23 Mar 2026 06:15:02 +0000
Date: Sun, 22 Mar 2026 23:15:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH v3 1/2] xfs: fix ri_total validation in
 xlog_recover_attri_commit_pass2
Message-ID: <acDaZj40D3-j2Y50@infradead.org>
References: <20260320021130.2936657-1-leo.lilong@huawei.com>
 <20260320021130.2936657-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320021130.2936657-2-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 10:11:29AM +0800, Long Li wrote:
> This problem may cause log recovery failures. The following script can be
> used to reproduce the problem:

Can you add this to xfstests, please?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
