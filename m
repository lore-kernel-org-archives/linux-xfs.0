Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0KYe+x6B"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A42FD7;
	Sun,  3 Dec 2023 23:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yY6ML3ph7CQ+D94sQfedEXVjNv2KO8ygBz1V+AY3K4k=; b=0KYe+x6B7veqLYYz68p/bY95tN
	Z+UY65Qpab9ylmVas2NJaOQtXEMU0SP7Nk+RLOMPWwFGZF89ElT2dmyVPv6SqeZWGv/aV+YxcLAYh
	OHu/swwu3rav0aMjJ578nuMf75bdhdn3XmNA4Zo2z6uHqlUVj5KhL/cn4zovathMshVQT6LEw2q8l
	TBkLH/0VjWrIK8bd24FNYWtU6ZGzblFOk+uqFvxxD2INRzdoDhz+pucuR7Ir84LPE0mUoac8pJoEz
	kWeysFtPr0krxUy1hT1rorvM2Ykm/hmgvY0wOrjW6VLV0M9a4btKBDRyBOKu82U0YRupMWW6yVm1M
	G/P7ItSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA3Dz-0038qQ-2O;
	Mon, 04 Dec 2023 07:18:39 +0000
Date: Sun, 3 Dec 2023 23:18:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, xieyongji@bytedance.com, me@jcix.top,
	Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/3] xfs: update dir3 leaf block metadata after swap
Message-ID: <ZW19T8PHLDx8o7ho@infradead.org>
References: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
 <20231130040516.35677-3-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130040516.35677-3-zhangjiachen.jaycee@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 12:05:15PM +0800, Jiachen Zhang wrote:
>  		return error;
>  	/*
>  	 * Copy the last block into the dead buffer and log it.
> +	 * If xfs enable crc, the node/leaf block records its blkno, we
> +	 * must update it.

I'd rewrod this sentence as:

	 * On CRC-enabled file systems, also update the stamped in blkno.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
