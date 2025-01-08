Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA40E198E92
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 06:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736319484; cv=none; b=WUnmxpOfxgPnzSZFuUlbVPe48joQpbwOEGO6d+gy21Eo9BaZUvfGOuc0PShYFhXpXLK9+nim0HAZtWEdRbQVBN4diAgQ5D5TkDXRKPWbw89Cl/tA2jlEhvFeAmk6ps9txM15BJVQTpttN39zuKZzJOw/+39iIMBO8dPPpEO+rLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736319484; c=relaxed/simple;
	bh=FvNjkyKmCHROYXeNd9Nvt8qy5ge/ev6k8frSrs646s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8AGzDFy4BDsXFnk8zCjsjE4SKDCFQiIO9g+CnTcJaD4VbUqcdfnCz3xfsRWqB5XXJXIb7Deb5j1SO3bhJnJpHyymQ+FvSCwoR51kFIBIJlRIe2YWuHv3SACwjMqJu9lQ1ATx9N4jLqyCWQ5UDCyBQ3H/UOoSEy4U93zKbEsNnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SrcbPzDo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SrcbPzDo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UXogUgNuQd/zofuUnasw+8DiLd+NnpP/DBT+vkYJYWA=; b=SrcbPzDoJrTbvoe+HfKlY1aGFA
	Z4O4OrbXZIWMXX3GM1iaazrx34A6G7XlmEOxSqnc2cJMFSWWRLungmN2IDv1SHS/Wzt2xyLIpWFqe
	4eM19zKBJ2YLG8FaEj+Ov5RqlFCzU+v7sEciTTAkmx9Hy+fWMI//Uv6u2o4EKmID1NE9RE3sZ31Ly
	aF1NMCQSDb9/6daWq6pEEHjflSZqna0Y+GRyQZDgGBEQRGMM+76IKjqRljrfSDPR7ct3TgMLVP2/9
	hO57WlAwMMzNwu7qpoNXPkL980X7qShYrHxJIQ+eTSEXe8bdQtaugzzMHOBI5Kl4ADqtY4u6p00td
	1lJFnWew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVQ0w-00000007JvX-1Gyv;
	Wed, 08 Jan 2025 06:58:02 +0000
Date: Tue, 7 Jan 2025 22:58:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <Z34h-hdI8VC_32g4@infradead.org>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
 <20250106195220.GK6174@frogsfrogsfrogs>
 <Z30n-9IusvggTuwP@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z30n-9IusvggTuwP@localhost.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

sb_rgcount for file system without a RT subvolume and without the
metadir/rtgroup feature should be 1.  That is because we have an implicit
default rtgroup that points to the global bitmap and summary inodes,
which exist even with zero rtblocks.  Now for a kernel without
CONFIG_XFS_RT that probably does not matter, but I'd prefer to keep the
value consistent for CONFIG_XFS_RT vs !CONFIG_XFS_RT.

