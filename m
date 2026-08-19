Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5621399354;
	Wed, 19 Aug 2026 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787149836; cv=none; b=opRxkzukE9C6PuHftZgrQSNR3g67vxyCgeDNeE3MBivgpJnIiroeaXWidHQjZX4mpxaJcafB8Ce+Rn5W85poT4hBafRMw2D4CBHTnzFKrbDh9bxEXLwPRO7F+wA8uqfjF4pd7ll6H84n88EPd98SU80kF+XpAvXeKRCCKjjRqeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787149836; c=relaxed/simple;
	bh=wOJXHBFkx/uosLmeewfdwEHJxj0bDo+AZy35Vlw6zNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A34uFeo0JFeNdpbBx5CuOBFtIATGyuOV14lJCucDgnljeJu27sWWptq1+jPclwoz65yDwXpVmmszrhWj0BdjsQIVGMih9I6eQOH7CWbY5g2tsft7z3kA8C98OyTVGMrjH/KtGUWLdhrnG8vYlxW/l3tmDmPC2a6d7NJTf48YJrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9FE4868C7B; Wed, 19 Aug 2026 16:30:25 +0200 (CEST)
Date: Wed, 19 Aug 2026 16:30:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, Alejandro Colomar <alx@kernel.org>,
	linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-ext4@vger.kernel.org, gost.dev@samsung.com, hch@lst.de,
	Zhang Yi <yi.zhang@huaweicloud.com>, pankaj.raghav@linux.dev
Subject: Re: [PATCH] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
Message-ID: <20260819143024.GA1010@lst.de>
References: <20260819114022.818734-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819114022.818734-1-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 19, 2026 at 01:40:22PM +0200, Pankaj Raghav wrote:
> This flag was added to the kernel in v6.17. As of now, only ext4
> supports this flag.

block device nodes also support it.
