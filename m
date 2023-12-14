Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KAV1qPay"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6D510F
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 07:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8z+9cX511wavWYiM3xQhSi0PHOucZkNHVOmgky1CKlg=; b=KAV1qPaybktZfk4vlU2671kIyM
	Fr8Qz/kt6SF2UFVI5uRmt1wSwZkSEGiRx3d7oeIW+UL2Ca7EP6v7RHAuI50Q4TsemkPb7ZBqFDl2t
	qUsSex+mT0JI6KIBY2SET1Gnp04mqhYiiHuR9WUIlpHSa9WPM7FGSIuaeBWSD73lpIpuxv0JbrIfk
	NaVrWB96Av1r/ba87ZG4KXAa8Gyw96/hzWb3IiCPYsLjSFM/5Fy7raqdhiJTaJwh2azaXs5BaMOUW
	wBDTjpQh8mR0+ondjY4UvNSstTUZ/t1So3iHOsN7/qpwK9I2L+ysU4ls6AFxHK6ItBu9w08abMMQ0
	39lw2sDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDneL-000g8R-2B;
	Thu, 14 Dec 2023 15:29:21 +0000
Date: Thu, 14 Dec 2023 07:29:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org,
	Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH] xfs: improve handling of prjquot ENOSPC
Message-ID: <ZXsfUeovFG7VQjIr@infradead.org>
References: <20231214150708.77586-1-wenjianhn@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214150708.77586-1-wenjianhn@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 14, 2023 at 11:07:08PM +0800, Jian Wen wrote:
>  	} else if (ret == -ENOSPC && !cleared_space) {
>  		struct xfs_icwalk	icw = {0};
> +		struct xfs_dquot	*pdqp = ip->i_pdquot;
>  
>  		cleared_space = true;
> +		if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount) &&
> +			pdqp && xfs_dquot_lowsp(pdqp)) {

wrong identation here, broken up control statements must not be
indented at the same level as the following block.

Otherwise this looks reaonable to me, but I'm a little worried
about the amount of ENOSPC/EDQUOT handling we're growing in
xfs_file_buffered_write.  Can we split all this into a helper?
