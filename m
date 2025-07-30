Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D772AE84;
	Wed, 30 Jul 2025 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885178; cv=none; b=IqInmEkB2Hz1Jup6Q7YiAIGV+NtScx+AAjpbYuiKP/Bn/T96yCRTU8Oa+ID+ZB8/AEIb12zx5uMxfCRjH0riJibuLCE+5CO/3YRqgQ0Dd/L/UcoW6QA5NmbUOozcYii+NALLhBaViczoUImUvvgw8vSCZxskBgxs/D51hwzDKoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885178; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gi9dhnGB/rvR+VZGSmHjSfRJWyO7IywU1qYgpcSG+9ElnLGSEbSlijQsKwf2eKFriyAWNSzqYr927ZNcCUp/NUbFjoWNrRzEDKAQPTFp7IJzGUdBqoG5Dk3NSfE8Yzc3UcJU3CRwokP8inW1eL7NbcXsQBnWRMJcQc4dr/SvRRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NJHAz5Pt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NJHAz5Pt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NJHAz5Pt6pNlx3hXMMc0PYwMZa
	5kzwogMFV2KruvGUso1IclXnXVuctnqe2tVL1INJh11n/M0NL9/g/7O77gKutga6reDfPB+gNj9HO
	ORldDKTIzKKKNquOgo+d+KMl2Ww+YtuA1AlMcnLkP0bNcMjPQU1pHmHC/dyrDLuSnt/WwazNcb+aO
	O4Mu5rWNtZVnRH470QT73angXDXJYLFP7D83HJVnQbjn2n0vfvPrLbO8kCAO3Jm9pJB8NGdEo/pJJ
	X22Yey8aZlU7YhtgEc+COzV3a54Vv7K+XFR2MeCLHlJDljUh+nm8GAmfxKQT7U5D2Jh4wZ7tzwmTA
	0pOzfv/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7ea-00000001ijB-442k;
	Wed, 30 Jul 2025 14:19:36 +0000
Date: Wed, 30 Jul 2025 07:19:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] generic/767: only test the hardware atomic write unit
Message-ID: <aIop-HQJJNCq8phY@infradead.org>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957973.3020742.7280346741094447176.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381957973.3020742.7280346741094447176.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

