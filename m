Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE911BBBCC;
	Wed, 19 Feb 2025 06:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944956; cv=none; b=LsLuRdQPerWD8uKPM31F6cfQOaGLpXM2Sy0WCq0oLpCysddpZAi95FL9l/EoEcVQSRTcqw1gc2jjKynBBJsTncR21SgmxlRZuK9/f4n9QAZpGtmJuo8A+PtB/oYEFL9w0es+EJBgt+47sUgZCReh2X6ZINBOZNPDxROQA5/d/QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944956; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzPS8oQOJluNv36q8T8HU+GlooqREY53aPieTvc4C+Swr88R2o4a5KuGpfdBrT+lMHUTOrbJKc2c/PmFnwAMdAaw8mc3+JmVo3rNTCnmQ0RV+h3aib9f1L6cdo/5B0OYKI6O952BbDcGrR8CT45iWV5KdZGas33JgntMd1lu3IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tIj7Yqed; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tIj7Yqed"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tIj7Yqeddhj9fynNE9K+VKFr+A
	qKWLmOKgTIuKJAQFNa5hEDn6RrXCqPHFqEhICw8xBk6lad4VNFdfYN8BmBs3/aODPu9VSID0HTDN/
	1D33vm3GR1ob4yNTfZfT9BzpidEuWD1IgXoEr/ftlUUy7gTgpzAcjxUFgCMZ14x7z+RH8LYV9cjEx
	q8AeLeM0wa/wfvT4xg6W/zAIQFtIFuEIgWG02Ron3LFNnZqlhpSTlq1Fy09M6sTdvu3SAg+SQ9lSR
	+mq6o2S2p9YJysj07+Y43WcnTWfJy9qS8k6q8qMFPYkD5GljGlLb/Xavb80lV21m6mAZmTJLQSJo8
	0jmu2fZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdAI-0000000Az2B-17Ww;
	Wed, 19 Feb 2025 06:02:34 +0000
Date: Tue, 18 Feb 2025 22:02:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] various: fix finding metadata inode numbers when
 metadir is enabled
Message-ID: <Z7Vz-t-8E2rvBcMd@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588079.4078751.10255522611762331320.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588079.4078751.10255522611762331320.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

