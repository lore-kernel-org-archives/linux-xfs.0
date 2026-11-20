Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199031;
	b=eyPVQllAXCErPCdrSrMeSyLLGVm7iOkd3PYvRn+FGZc9cD/LhWUTBOVjWPKIY/Bg+Jms
	 beNG7M1BL3dFWVz69qiA3Wb/0CYxF7/73kdX13Y+NcrZCgvwObhSaU1t2nNUicteWqr3n
	 j+Q0PJPLGph4yjkUM+yeTkhZxI2B9zbgowSYkfnkwg+ps4OEPNAeh/ptDswunDRxLJ2cK
	 BrTewKKepKLY8WlEJIEIbGAusgJBCLqUz6NovJFUaPoTYl/Zt1LHh/857+K6B5H27LwtJ
	 VreYC3qVbl8DJZRftzNBTaWFH0IJJtGfQOCXaPYnC4eVCOc7l1reEtM6r5SPK3SeREA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199031;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=BSgEiYozvlrweuLDCtv3KC06n9tjyfQLyMVDgOM/bqDaj3P24qiakfLoltXEfFb4Au6P
	 tcPPhC2j6CED7FLzQkwvLA1jjeENJuzDrewM2V/W7ViZU0wgkPM/Yrjt1U4S3QtQ4UYok
	 CW3wPOts5syb80x8VYXcgZdulLvToCn7uiuu5taPM6cy+q9DwnOztq3HiIhaOYNRuYAbR
	 KOpKGsk5RWKVdqo+SsW1CJ+PTdUN9x/dTaPZVdJyT+CZIkDnr+XB+16x1BkfR1NzDzlCS
	 ZAksh8nprnCopVjz2WlTEfG95yGDwn0GMqwuLBWvDRCuR29KwdiewIQ/1mTzwpkr+cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C77606A32C;
	Fri, 20 Nov 2026 18:23:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35C77606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CF9D068AFE; Fri, 20 Nov 2026 19:23:47 +0100 (CET)
Date: Fri, 20 Nov 2026 19:23:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com, brauner@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 4/5] hfsplus: return -EIO from hfsplus_map_extent()
 if no extent covers the block
Message-ID: <20261120182347.GD2183@lst.de>
References: <20261118004844.3849979-1-slava@dubeyko.com> <20261118004844.3849979-5-slava@dubeyko.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118004844.3849979-5-slava@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

