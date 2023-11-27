Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BADvIn5t"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA919B6
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 08:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t7YBjbGqLcKvKJ2WRoF/xCWIhPFamT1RN3nbWjyN2xY=; b=BADvIn5tUWe9G4Jl0RXRnBzpv5
	BZPqqkTYov7yY+RCPqPzl+mjlq2PFh/tEZYSdO1skSr94q/tb1OBG9zpnVjWYmD8DkxoxmJzQYTUI
	PAhFd1V5dLeuPKpbstAp4d5b+wfjKsLF7PT4xSE9Pdt2qco7xMW4PUEDThY7V2rscIkJ3NXldg/R4
	MKsm1yq9W9BRL9gAHqgOdQ3Gslc0utLdazSacjAdHCnCcNLH0JdBX20R3RuoW62II+7iMj0u7gJes
	9rWIabOTlk6J3D3PnlR7Ia3DwZqvwXCsyLPNe9Wnw/q+BAV/v9jAUQFdQvR3aofEHH2o2Ni6HK7FS
	yU7KApVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7eee-0031zG-0H;
	Mon, 27 Nov 2023 16:40:16 +0000
Date: Mon, 27 Nov 2023 08:40:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: clean up the XFS_IOC_FSCOUNTS handler
Message-ID: <ZWTGcENXNIrYuDYo@infradead.org>
References: <20231126130124.1251467-1-hch@lst.de>
 <20231126130124.1251467-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126130124.1251467-3-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static int
> +xfs_ioctl_fs_counts(
> +	struct xfs_mount	*mp,
> +	struct xfs_fsop_counts	*uarg)

FYI, the buildbot (rightly) complained about a missing __user
annotation for sparse here.

