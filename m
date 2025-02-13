Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7E335949
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420886; cv=none; b=D9E26uzoDwquMYsfpLGOYAER0jW6lz9j3LxHXGJcEQvUQfWRv6J6NNDM73txrFlIIlti49DLn+aWSolgXeQGLXnlNZAqY78jCJK7TI/2l0kXPIKl7HpAgqrvwuJxT+kcXrjpqPAHCoGCfuUE0uj4COc3D+jXMYjeKZ99qevsyeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420886; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ob2qMUPUNMxSxVmCIvnFDM8ut7wPetQrpP2uBeTzo47PIyyWph8feZVOQe5cA4it4KfCho8WbkPOTwGRmGWtyqgKxTof2IDtDNpX/y2RWOss3cDxLMJMLsOWb8G5pXyOSXB81zG6QtNbw63JsdTB6w+Ywo8qr/ZwuuAQQvK53JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d1psW0WM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d1psW0WM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=d1psW0WMIzv4PMcJZ+ANXL+2l+
	xwR0kZlVzz3OpzWhymfL4netOBQePkyPaa/RW59vFFV0ecS101I27uw8tu4kkPsbqgcCHKRAhKsC0
	Rpgvzp5ZSn3RbegRTexAT8qMCcu8JQ7rGaSmNn927k/COBg+YLulm96bMR5VojT7HTsLoly4lNsuc
	DJaHusAaFwknv7fWtrlxBEF02NIQ68S0MPZT/feyw/QuezXhs/0Qw+SJMfxMxjf8Jho0GxncTSe00
	l4aJiJck4jppLFt51Yo9j8Exn1dx/FwiSaO76I/XZZM2tRCgYHcNZBPJeZeUtZOW8Z7hLJOamYq1m
	Bh1joVkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQpY-00000009iSs-2W6D;
	Thu, 13 Feb 2025 04:28:04 +0000
Date: Wed, 12 Feb 2025 20:28:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs_logprint: report realtime CUIs
Message-ID: <Z6101JIO8RFffQse@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089238.2741962.6117855127240783512.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089238.2741962.6117855127240783512.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

