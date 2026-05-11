Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5279137C0E7;
	Mon, 11 May 2026 12:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501455; cv=none; b=k86zwOI5Edtu4/2rsSHiFTg5li2w8p3XD9hBGoEVJBSzZARoraYLgxo6ZznVOtCkmLp2em/k6+T0uNWBe48PwhbAq+4IPawAzr37xoRNHdnOsNCNkDZo52NjVc5J1yv2/BdWOKw0qRoh65iYwPl74QxFwAr0L9QgORTAR7NR8gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501455; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3NYtF2WBsCny23y6airs09Hni/StHgfCPUCi165/g1iqtATGTd9Gk7tkDag9FWJpjzV7FK7s3GlzS+q76sn+m4G+cUduIfgSDSD4Q+motZsPMk9SifXm/A2MRoxBvtBOyu/AvVAATSCefRcKxqlqlkq0O3Aa5J5CYxpn5vOuig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D5C8C6732A; Mon, 11 May 2026 14:10:51 +0200 (CEST)
Date: Mon, 11 May 2026 14:10:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	chizhiling@kylinos.cn, djwong@kernel.org, hch@lst.de,
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com
Subject: Re: [PATCH v2] iomap: add dirty page control to iomap_zero_iter
Message-ID: <20260511121051.GB16027@lst.de>
References: <20260511094007.728011-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511094007.728011-1-chizhiling@163.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

