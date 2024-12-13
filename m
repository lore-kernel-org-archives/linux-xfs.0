Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B611017BEC5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081374; cv=none; b=VdkYZvo5DTrD0qOBV2r3DR59AOETGmL9CtemzVnVogEg9LvV3HqLtadgZFGswM/mhCM8GCMVv3o11bSXU8qy3/FaQ6ZqD+TODYYRHyNUvHTDsvmD5Xbr8nsZT+RUF4aUxB7ew1agyyCi0B9kiRqvQEvUeP5bpUO7Uk5rca0+aF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081374; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMUaG1mFdz+bQaJ/HaXTyUebeyfj+Kd1vErPJL3CqsFFfUkBtuXprjDRBet2KsOt9R0NMcgPB7rOrnubVsua0MJ1Oc97COZzz4ak2n7CS6YJiKHsmXw5nZ9Sda4JQ9ywlCv3oLn8ssTJnWtll4Xs3kNJIhY+YWneyvtoo9mqpCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dyEOocF6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dyEOocF6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dyEOocF6Z4aYyZgkDK2pswMR1o
	ulsHjjRttmxRlwlDXckTmc+u+NqitOZBJjV2hp3zHTOrI/RUCgT1wjKpTUxCiSshW32X7dc1ZJS4G
	Myp3Y6OWXbaUtRFvaqQ6RoCAwDz5ayq4rOQAWbbf6/YHrugo988hdpNT7Y8mRceuZQK6xKSNcHHd4
	fwx49TTbCxdenyO+vWe5BoKDmUKL+ofxAnyDpBndWule2983pMVcxuhVw0v5cIJJzp2uiSv+Ce8eu
	dB6RhYDcu9ueLvb6mQHTzPu9dxha/0znb7Bab+dC3EHWdNSgVQBbtxFWVHR+VEUKJYb81ITYbPQco
	giWKL2qA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1mP-00000003DGx-1ckq;
	Fri, 13 Dec 2024 09:16:13 +0000
Date: Fri, 13 Dec 2024 01:16:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/43] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
Message-ID: <Z1v7Xfs8R1kVd8_W@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124961.1182620.16706223069367374184.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124961.1182620.16706223069367374184.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

