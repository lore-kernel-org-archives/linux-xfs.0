Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AAC346E51;
	Thu, 18 Jun 2026 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773262; cv=none; b=Fz9fqMqIRG83qm+Fp5Mg0n+AIVWLVAiqYko1258JKpUJY9sYDWTsuLrrjh69KvIihv4BksSYXlkhomL+RD4D61aqHDH1TH0AC7v0i5/2BXl1hQ/vhYn4uGJrYnd9ArXWegTecg5B5LmaST0mLvjMHxoJyIw+9LeC/TnRt+1PpdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773262; c=relaxed/simple;
	bh=V7EWHCdfOLJBW3LIg7HN3oribf9s6I/Pfh4LQzI7QKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j62aEdwLskgO2WCV0VDrr5RFuFjZ8ec7FlxSocnKnuOd3hvLr+iXM+a6xRfTJNzrSM2iiP0OIhfvHKQOZN5g/EUSBcgxZ83b8yCRhEYDBjGHDGwGV+o6h5Rpz6KvFO2GrXTAquQlOWFF5giGo/D/5lERxMTItVd2TX66l/fWsb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p4iXdViK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p4iXdViK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M9EeFcKrsMF7BhoQjCI346X+ZOMEwg/R7gAke80GfVI=; b=p4iXdViKvbqf6kRpw/cqG3Blwa
	6C1K9QAX6RilcSbbtwmuX/qVu/9ZC9qD2CbGR4GsoseTTprHtyPVWYUdF+WPaqcRq5No3aOVj4snF
	KgeBky4jqCsXBD7v5nK98j+u8QXMs0Lez/NEW46AB9BlZv3yxgLXldXr7403y3TEbMHfu+fk4wrP8
	oNE7wt85e0cz6qBBc0PJErX39MXQf5zHOibI1B73aiixUJYiknhsaDSLiL3IlMJlaOygj8cqZQr+q
	MWNvdmn9CVpEGytH/VmlAj16AgLGAvl2huoX9KpHS3adF+lzg6Lz+2ELB899KUxAivCV6cF1zjcG1
	NdUtNW7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wa8cN-00000000t9z-0HKT;
	Thu, 18 Jun 2026 09:00:59 +0000
Date: Thu, 18 Jun 2026 02:00:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "zhaoyifan (H)" <zhaoyifan28@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	yekelu1@huawei.com, jingrui@huawei.com, zhukeqian1@huawei.com,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
Message-ID: <ajOzy2NPD2GlXcNt@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 18, 2026 at 03:16:03PM +0800, zhaoyifan (H) wrote:
> Hi Christoph,
> 
> 
> This patch works well under my workload (at least correctness-wise). Thanks.

Thanks.

Gao, do we need any erofs updates to go along with this to not regress
behavior where it would have merged before?

