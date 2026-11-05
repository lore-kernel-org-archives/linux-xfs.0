Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865130;
	b=wKrNSqjAcka4K8hzqMn86C+xUtJCIBhzSJ8AJzLTmEO+br3B7ZY2KzC7QvkBeKo5zWov
	 gylUJ6jfiLUFumGsMVXlzVsT1xhADR0Zu5sE1Cji9UXFf1BFoxLFpx8FdG9xjjWZwC6Xh
	 zKSuLTwNfUCvFCYymufu2tT8GpWiWBNqudMobdHoWoMLDD8GtxQmVq3mQybJ2jDC1VJOb
	 cTPkmGab6aGDG4Y8jblB1dwxtaUn5Q8FiwzkytPpg/7lxUj/65WRXa2SvEuKm1wRAaPCw
	 VKLQxjqfKIR1L5FKKJr+OF2UT9kWiQ5GmFMw7+N0DNXrtA1yMCqy8SshOKM1E/R6Z2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865130;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=QWVETi/gxseFc3bPK43pv+7C3lW063lO/0C03p7YpFjGEehsSEMpdRGJlnX7dEDSEYgN
	 R3L7ITq+zXeOBhD4w8wZSiuG+ftkvviqFM+n2sx3ZnKATRta0WvF1YsyTn8PxuidbeFFm
	 0zv5OqdkPtyScBJzYKPqwiglMjS4m7+ImP6RdWv5Jkl3JLayPY7lIE5+C+79UANsF7pz+
	 i4XEyA9T5kTHVuzpYizNLHOlh+RJE0EERPToeIcevIcenI5Px1KtE9ST1UnZFbjKIstSo
	 iXTMRQetrcQ35z1fq+vGIL5nEBOcYjP+STADH2oFicD36EN6DdcnEB2ev00IlRXMldQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53912606A326;
	Thu,  5 Nov 2026 07:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53912606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E07968B05; Thu,  5 Nov 2026 08:52:05 +0100 (CET)
Date: Thu, 5 Nov 2026 08:52:04 +0100
From: Christoph Hellwig <hch@lst.de>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, kernel-team@meta.com,
	Christian Andres Saide <csaide@meta.com>
Subject: Re: [PATCH] xfs: keep successful near rt allocations
Message-ID: <20261105075204.GA17923@lst.de>
References: <20261104100115.36bf7d28@fangorn>
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
In-Reply-To: <20261104100115.36bf7d28@fangorn>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

