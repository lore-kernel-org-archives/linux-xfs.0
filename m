Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A62AE84;
	Wed, 30 Jul 2025 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885258; cv=none; b=ppA/dtbwfle/PWE/U7jutuPLKIhsnJpyNo0f7tb6GkSLloN4k3NiTvUJwD9RAzsLvBIlvwDd2FbnOMauX25no1qO0UKeaeu5XBXouf5UVFoTsDFEp4mDrKSD38mgDr4oqYcmz6dhlFIjb2Dok/MLkupiQn0j6DORM1aiYxk2S0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885258; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NazzQZ1FczdMb+FtpCPUQTcqFiDvijXJJg6+RmGhAZVtEG5iTRPyDT/7uawA3k0KhkqMnxxnG+XjB3D051i76dz0FEF6KjRZLwR1fIqXnBolS4T/mgRvA8E1Y0Sw6Wo5Lqqs6vMccMabgfRY/SRMQLh3xq/qGorIMh6jggCCxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MD6U0ZKC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MD6U0ZKC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MD6U0ZKCqswCh97jdvJPupOenO
	8IqgnsM+BQ35X1Rlj5AY7PfeRPySNFZqcCuNpFTr4LerD5o7o4twMYw6wNVXmWNKl2EBzj4Z3c7v8
	jTtGracTNmChQ+Flt+GEnmhkH8EBAV9fwY+uwc0TUwM5sEhCty3M6A8Z9dpZ6lLpes3pTNMRIyKYo
	AOcUMgWNvRtL7XqF2vuDgn0c5EwsIK+LXKgowsQMoQ53hACbiiE33SthLtyAuyPwrHYpAgZuQwrVC
	hB96HgCJd4Rq0NHQo04mc3eVX43V001dzR0REQCVfXbhXwYaVy0EP0FNyWChfLFcYPfFcGph1BHhi
	53oxcLoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7fs-00000001iuT-2Xfq;
	Wed, 30 Jul 2025 14:20:56 +0000
Date: Wed, 30 Jul 2025 07:20:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/259: try to force loop device block size
Message-ID: <aIoqSHzaMgLDsauO@infradead.org>
References: <175381958191.3021057.13973475638062852804.stgit@frogsfrogsfrogs>
 <175381958216.3021057.6861906785798079394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381958216.3021057.6861906785798079394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

