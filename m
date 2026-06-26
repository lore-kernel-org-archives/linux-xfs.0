Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAAB30568D;
	Fri, 26 Jun 2026 04:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448406; cv=none; b=G7E15O+8dL/XWADRZxkBqBQqiceZLhRWPCFq3PmqRmPtMFL2SULweTz8xyCbbqlJDDn/phXSfimOu3jGz+6MB/Ersx1APfi2MAnHisQHstwyDnQOIASkkPIlT7MRdsLzRxZ/GT3/9MJgr4bkA0BNngcMMZ8Ca+fa8OGyIwWytE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448406; c=relaxed/simple;
	bh=fjHVMSVZUyXFyjOhAP2+pCdwrD+9eUL55c+u3rAHLTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a6bcrPMuJriySEoS4mowoBr/jCygJ7qCxJyhvy6gVEAsxM03Z3fsoLyjTm/tX0zVlvtT/Kfs8cai5P7hz45UHbQcpIjFQUyAUk+bcSlgdp4wYw1saQtq7J0JejLWiCnNPeLc5u1qC1N9FDJ9ODrvH59Dl/PexcT66Slt5+j2/Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 398A168B05; Fri, 26 Jun 2026 06:33:20 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:33:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260626043319.GC8078@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de> <20260625174758.GE6078@frogsfrogsfrogs> <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 11:32:40AM -0700, Joanne Koong wrote:
> Yes, that works. I think that's a good idea. fuse only needs
> submit_read logic for readahead. The change would just be:

A nice, I'll fold that in.

> If this fix needs to go into 7.2 though, maybe it makes sense to land
> the v1 implementation [1] + the xfs integrity fix now and do the fuse
> change later?

In a way this is actually simpler as it doesn't require the prototype
change.  And it'll avoid both a temporary fuse performance regression
and a bit of churn.

